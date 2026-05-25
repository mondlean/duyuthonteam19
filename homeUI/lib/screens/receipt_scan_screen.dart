import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../utils/image_saver.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/birch_background.dart' show BirchBackground;
import '../widgets/lumina_app_bar.dart';

class ReceiptScanScreen extends StatefulWidget {
  const ReceiptScanScreen({super.key});

  @override
  State<ReceiptScanScreen> createState() => _ReceiptScanScreenState();
}

class _ReceiptScanScreenState extends State<ReceiptScanScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _scan = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  CameraController? _camera;
  Future<void>? _cameraReady;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cameraReady = _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _cameraError = '사용 가능한 카메라가 없습니다');
        return;
      }
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _camera = controller);
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() => _cameraError = e.description ?? e.code);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cam = _camera;
    if (cam == null || !cam.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      cam.dispose();
      _camera = null;
    } else if (state == AppLifecycleState.resumed) {
      _cameraReady = _setupCamera();
      if (mounted) setState(() {});
    }
  }

  Future<void> _captureImage() async {
    final cam = _camera;
    if (cam == null || !cam.value.isInitialized) return;

    try {
      final xFile = await cam.takePicture();
      final bytes = await xFile.readAsBytes();
      await saveReceiptImage(bytes);

      if (mounted) {
        context.push('/scan-loading', extra: bytes);
      }
    } on CameraException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('촬영 실패: ${e.description ?? e.code}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scan.dispose();
    _camera?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: LuminaAppBar(
        showLogo: false,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back, color: AppColors.onSurfaceVariant),
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
        trailing: IconButton(
          icon: const Icon(Symbols.help, color: AppColors.onSurfaceVariant),
          onPressed: () {},
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: _CameraLayer(camera: _camera, error: _cameraError, future: _cameraReady)),
          Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.35))),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '영수증 인증',
                style: AppTextStyles.koBody(
                  22,
                  weight: FontWeight.w700,
                  color: AppColors.primaryContainer,
                ),
              ),
            ),
          ),
          Center(
            child: _ScanFrame(animation: _scan),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 240,
            child: _CameraControls(onCapture: _captureImage),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _Instructions(),
          ),
        ],
      ),
    );
  }
}

class _CameraLayer extends StatelessWidget {
  const _CameraLayer({
    required this.camera,
    required this.error,
    required this.future,
  });

  final CameraController? camera;
  final String? error;
  final Future<void>? future;

  @override
  Widget build(BuildContext context) {
    final cam = camera;
    if (cam != null && cam.value.isInitialized) {
      // 카메라 프리뷰를 화면 전체에 채우기 위해 종횡비 보정.
      final size = MediaQuery.of(context).size;
      final preview = cam.value.previewSize;
      // previewSize는 가로 기준 — 세로 화면이므로 swap.
      final previewAspect = preview == null ? 3 / 4 : preview.height / preview.width;
      return ClipRect(
        child: OverflowBox(
          alignment: Alignment.center,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: size.width,
              height: size.width / previewAspect,
              child: CameraPreview(cam),
            ),
          ),
        ),
      );
    }

    // 카메라 미초기화 / 에러 / 권한 거부 → 자작나무 배경으로 폴백.
    return Stack(
      fit: StackFit.expand,
      children: [
        const BirchBackground(),
        if (error != null)
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                '카메라를 사용할 수 없습니다\n($error)',
                textAlign: TextAlign.center,
                style: AppTextStyles.koBody(
                  13,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ),
          )
        else
          FutureBuilder<void>(
            future: future,
            builder: (_, snap) {
              if (snap.connectionState == ConnectionState.done) {
                return const SizedBox.shrink();
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryContainer,
                  strokeWidth: 2,
                ),
              );
            },
          ),
      ],
    );
  }
}

class _ScanFrame extends StatelessWidget {
  const _ScanFrame({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final width = constraints.maxWidth * 0.78;
          return SizedBox(
            width: width,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryContainer,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                // 모서리 강조.
                ..._cornerWidgets(),
                // 움직이는 스캔 라인.
                AnimatedBuilder(
                  animation: animation,
                  builder: (_, __) {
                    return Positioned(
                      top: animation.value * (constraints.maxHeight - 4),
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.primaryContainer,
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryContainer
                                  .withValues(alpha: 0.8),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _cornerWidgets() {
    Widget corner({
      double? top,
      double? left,
      double? right,
      double? bottom,
      required BorderSide horizontal,
      required BorderSide vertical,
      BorderRadius? radius,
    }) {
      return Positioned(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            border: Border(
              top: top != null ? horizontal : BorderSide.none,
              bottom: bottom != null ? horizontal : BorderSide.none,
              left: left != null ? vertical : BorderSide.none,
              right: right != null ? vertical : BorderSide.none,
            ),
            borderRadius: radius,
          ),
        ),
      );
    }

    const side = BorderSide(color: AppColors.primary, width: 4);
    return [
      corner(
        top: -4,
        left: -4,
        horizontal: side,
        vertical: side,
        radius: const BorderRadius.only(topLeft: Radius.circular(8)),
      ),
      corner(
        top: -4,
        right: -4,
        horizontal: side,
        vertical: side,
        radius: const BorderRadius.only(topRight: Radius.circular(8)),
      ),
      corner(
        bottom: -4,
        left: -4,
        horizontal: side,
        vertical: side,
        radius: const BorderRadius.only(bottomLeft: Radius.circular(8)),
      ),
      corner(
        bottom: -4,
        right: -4,
        horizontal: side,
        vertical: side,
        radius: const BorderRadius.only(bottomRight: Radius.circular(8)),
      ),
    ];
  }
}

class _CameraControls extends StatelessWidget {
  const _CameraControls({required this.onCapture});

  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundIconButton(icon: Symbols.flash_off, onTap: () {}),
        const SizedBox(width: 36),
        GestureDetector(
          onTap: onCapture,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            padding: const EdgeInsets.all(4),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 36),
        _RoundIconButton(icon: Symbols.photo_library, onTap: () {}),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.white.withValues(alpha: 0.2),
          shape: const CircleBorder(
            side: BorderSide(color: Color(0x33FFFFFF)),
          ),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

class _Instructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.55),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Icon(Symbols.receipt_long, color: AppColors.primary, size: 36),
              const SizedBox(height: 8),
              Text(
                '영수증을 사각형 안에 맞춰주세요',
                style: AppTextStyles.koBody(
                  18,
                  weight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '가게 이름, 결제 일시, 금액이 선명하게 보이도록 영수증을 평평하게 펴주세요.',
                textAlign: TextAlign.center,
                style: AppTextStyles.koBody(
                  13,
                  color: AppColors.onSurfaceVariant,
                  height: 19,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 240,
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 1 / 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '스캔 준비 중',
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '1/3 단계',
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
