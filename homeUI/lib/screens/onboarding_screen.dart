import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/birch_background.dart';
import '../widgets/duyu_flower.dart';
import '../widgets/glass_panel.dart';
import '../widgets/lumina_app_bar.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: LuminaAppBar(
        trailing: IconButton(
          icon: const Icon(Symbols.eco, color: AppColors.primary),
          onPressed: () {},
        ),
      ),
      body: BirchBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 24),
            child: Column(
              children: [
                const Expanded(
                  child: Center(
                    child: DuyuFlower(size: 260),
                  ),
                ),
                GlassPanel(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '성장을 시작하세요',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.koBody(
                          28,
                          weight: FontWeight.w700,
                          color: AppColors.onSurface,
                          height: 36,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '친환경 소비로 당신만의 꽃을 피워보세요',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.koBody(
                          16,
                          color: AppColors.onSurfaceVariant,
                          height: 24,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _StepIndicator(active: 0),
                      const SizedBox(height: 24),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: AppColors.onPrimaryContainer,
                          minimumSize: const Size.fromHeight(56),
                          shape: const StadiumBorder(),
                          elevation: 6,
                          shadowColor:
                              AppColors.primaryContainer.withValues(alpha: 0.4),
                        ),
                        onPressed: () => context.push('/signup'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '시작하기',
                              style: AppTextStyles.koBody(
                                18,
                                weight: FontWeight.w700,
                                color: AppColors.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Symbols.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.push('/login'),
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.labelMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                            children: [
                              const TextSpan(text: '이미 계정이 있으신가요? '),
                              TextSpan(
                                text: '로그인',
                                style: AppTextStyles.labelMd.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.active});

  final int active;

  @override
  Widget build(BuildContext context) {
    Widget bar(bool isActive) => Container(
          width: isActive ? 32 : 8,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryContainer
                : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [bar(active == 0), bar(active == 1), bar(active == 2)],
    );
  }
}