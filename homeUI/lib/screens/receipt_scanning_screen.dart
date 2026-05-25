import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/globals.dart';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ReceiptScanningScreen extends StatefulWidget {
  const ReceiptScanningScreen({super.key, required this.imageBytes});

  final Uint8List imageBytes;

  @override
  State<ReceiptScanningScreen> createState() => _ReceiptScanningScreenState();
}

class _ReceiptScanningScreenState extends State<ReceiptScanningScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinner = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  late final Animation<double> _pulse = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.06), weight: 50),
    TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0), weight: 50),
  ]).animate(CurvedAnimation(parent: _spinner, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    _performScan();
  }

  Future<void> _performScan() async {
    try {
      // FastAPI OCR 호출
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Globals.plantBaseUrl}/ocr'),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          widget.imageBytes,
          filename: 'receipt.jpg',
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // 분석 성공 -> 결과 화면으로 데이터 전달
          if (mounted) {
            context.pushReplacement('/scan-result', extra: data);
          }
        } else {
          throw Exception(data['message'] ?? '분석 실패');
        }
      } else {
        throw Exception('서버 응답 오류 (${response.statusCode})');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('에러 발생: $e'),
            backgroundColor: AppColors.error,
          ),
        );
        context.pushReplacement('/scan');
      }
    }
  }

  @override
  void dispose() {
    _spinner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 찍힌 사진을 배경으로
          Image.memory(
            widget.imageBytes,
            fit: BoxFit.cover,
          ),
          // 어두운 오버레이
          Container(color: Colors.black.withValues(alpha: 0.58)),
          // 뒤로가기 버튼
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _GlassIconButton(
                  icon: Symbols.arrow_back,
                  onTap: () => context.canPop() ? context.pop() : context.go('/scan'),
                ),
              ),
            ),
          ),
          // 중앙 스캔 카드
          Center(
            child: ScaleTransition(
              scale: _pulse,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 스피너
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: RotationTransition(
                            turns: _spinner,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    AppColors.primaryContainer.withValues(alpha: 0.0),
                                    AppColors.primaryContainer,
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withValues(alpha: 0.55),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Symbols.receipt_long,
                                    color: AppColors.primaryContainer,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '영수증을 읽는 중...',
                          style: AppTextStyles.koBody(
                            18,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '에코 스캐닝 기술 적용 중',
                          style: AppTextStyles.koBody(
                            12,
                            color: AppColors.primaryContainer,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _DotProgress(animation: _spinner),
                        const SizedBox(height: 20),
                        Text(
                          '자연을 생각하는\n당신의 기록',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.koBody(
                            11,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotProgress extends StatelessWidget {
  const _DotProgress({required this.animation});
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final phase = (animation.value * 3).floor() % 3;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final active = i == phase;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primaryContainer
                    : Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withValues(alpha: 0.2),
          shape: const CircleBorder(side: BorderSide(color: Color(0x33FFFFFF))),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}
