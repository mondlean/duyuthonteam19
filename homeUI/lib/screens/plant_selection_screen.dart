import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/globals.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/birch_background.dart';

class PlantSelectionScreen extends StatefulWidget {
  const PlantSelectionScreen({super.key});

  @override
  State<PlantSelectionScreen> createState() => _PlantSelectionScreenState();
}

class _PlantSelectionScreenState extends State<PlantSelectionScreen>
    with TickerProviderStateMixin {
  int? _selected;
  final TextEditingController _nameController = TextEditingController();

  late final List<AnimationController> _cardControllers;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  static const _plants = [
    _Plant(
      '민들레',
      'https://lh3.googleusercontent.com/aida/ADBb0uiW1OFLIs-q365BkoKYw0uh8vh6e2Ei0vzOQaH5er7wkjpwZOe2BrDij_f9tGa5MIJLwI17Wtz1jZS7LxOcdqYjNjkoI5VNgW8doUTeL75Uz9ORZ89opEY5ZQKR0_K7ke2i1yowc6OYTfIoIrxo1I1WODG5pLU9hu_iermxkSUBiyDwboXsUcEz2rvE3ObQMq2Qy_TJfCtCQfj5fKwoBDT04xqNiEySksYP0EvWx3jyukWRjuoElbP9kSBN',
    ),
    _Plant(
      '장미',
      '',
      assetPath: 'assets/images/rose.png',
    ),
    _Plant(
      '해바라기',
      'https://lh3.googleusercontent.com/aida/ADBb0uj7bKQLlMJ52NWkOUCiQruDYDeawuUu8Wg10xfpvLHX_0cEDIFKtKnrWi94K0ORTcHQsdjxMob77scq2Lxuh1Kk3vGFTk24FUqkNLWpWZTsb6ib4ETm9QKTbUnZ3w387MZEklYYIoZ1OKACgQ5A1ACRxJaWhzJ_rtqtys_jlrMq3oyrVfk5KR4IXR5UA7zI6-S8EYempRh5HMrVutQU8G-aLZRH4SKCt5t0Gel2vacLWVePOiBRI29RWAg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _cardControllers = List.generate(
      _plants.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    _fadeAnims = _cardControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();
    _slideAnims = _cardControllers
        .map(
          (c) => Tween<Offset>(
            begin: const Offset(0, 0.25),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOutCubic)),
        )
        .toList();

    for (int i = 0; i < _cardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 180 + i * 140), () {
        if (mounted) _cardControllers[i].forward();
      });
    }
  }

  List<Widget> _buildCards() {
    final result = <Widget>[];
    for (int i = 0; i < _plants.length; i++) {
      if (i > 0) result.add(const SizedBox(width: 12));
      result.add(
        Expanded(
          child: FadeTransition(
            opacity: _fadeAnims[i],
            child: SlideTransition(
              position: _slideAnims[i],
              child: _PlantCard(
                plant: _plants[i],
                isSelected: _selected == i,
                onTap: () => setState(() => _selected = i),
              ),
            ),
          ),
        ),
      );
    }
    return result;
  }

  @override
  void dispose() {
    for (final c in _cardControllers) {
      c.dispose();
    }
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BirchBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '환영해요',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.koBody(
                    14,
                    weight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '좋아하는 식물이 있나요?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.koBody(
                    26,
                    weight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '가장 마음에 드는 반려 식물을 선택해주세요',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.koBody(14, color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 52),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildCards(),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child: _selected != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primaryContainer.withValues(alpha: 0.35),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Symbols.local_florist,
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: _nameController,
                                        style: AppTextStyles.koBody(
                                          15,
                                          color: AppColors.onSurface,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: '식물의 이름을 정해주세요',
                                          hintStyle: AppTextStyles.koBody(
                                            15,
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const Spacer(),
                Text(
                  '나만의 작은 숲을 시작해보세요',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.koBody(13, color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                AnimatedOpacity(
                  opacity: _selected != null ? 1.0 : 0.4,
                  duration: const Duration(milliseconds: 200),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: AppColors.onPrimaryContainer,
                      minimumSize: const Size.fromHeight(56),
                      shape: const StadiumBorder(),
                      elevation: 6,
                      shadowColor: AppColors.primaryContainer.withValues(alpha: 0.4),
                    ),
                    onPressed: _selected != null
                        ? () async {
                            try {
                              // 식물 선택 정보 저장
                              final plantName = _plants[_selected!].name;
                              final response = await http.post(
                                Uri.parse('${Globals.springBaseUrl}/users/update-plant'),
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode({
                                  'loginId': Globals.loginId ?? 'testUser',
                                  'plant': plantName,
                                }),
                              );

                              if (response.statusCode == 200) {
                                if (context.mounted) context.go('/home');
                              } else {
                                throw Exception('저장 실패: ${response.statusCode}');
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('오류 발생: $e')),
                                );
                              }
                            }
                          }
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '시작하기',
                          style: AppTextStyles.koBody(
                            17,
                            weight: FontWeight.w700,
                            color: AppColors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Symbols.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Plant {
  const _Plant(this.name, this.imageUrl, {this.assetPath});
  final String name;
  final String imageUrl;
  final String? assetPath;
}

class _PlantCard extends StatelessWidget {
  const _PlantCard({
    required this.plant,
    required this.isSelected,
    required this.onTap,
  });

  final _Plant plant;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryContainer.withValues(alpha: 0.22)
                    : Colors.white.withValues(alpha: 0.40),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryContainer
                      : Colors.white.withValues(alpha: 0.2),
                  width: isSelected ? 2.0 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryContainer.withValues(alpha: 0.35),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ]
                    : [
                        const BoxShadow(
                          color: AppColors.glassShadow,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
              ),
              padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: plant.assetPath != null
                        ? Image.asset(
                            plant.assetPath!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Symbols.local_florist,
                              size: 48,
                              color: AppColors.primary,
                            ),
                          )
                        : Image.network(
                            plant.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Symbols.local_florist,
                              size: 48,
                              color: AppColors.primary,
                            ),
                          ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plant.name,
                    style: AppTextStyles.koBody(
                      14,
                      weight: FontWeight.w700,
                      color: isSelected ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    child: isSelected
                        ? const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(
                              Symbols.check_circle,
                              size: 18,
                              color: AppColors.primaryContainer,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
