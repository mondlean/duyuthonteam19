import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/birch_background.dart';
import '../widgets/duyu_flower.dart';
import '../widgets/glass_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BirchBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _ScoreSummary(),
                const SizedBox(height: 20),
                const _GrowthRoadmap(),
                const SizedBox(height: 24),
                const _PlantDisplay(),
                const SizedBox(height: 20),
                const _GrowthProgress(),
                const SizedBox(height: 24),
                _ActionFooter(
                  onScanReceipt: () => context.push('/scan'),
                  onHistory: () => context.push('/rewards'),
                  onSettings: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreSummary extends StatelessWidget {
  const _ScoreSummary();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GlassPanel(
            borderRadius: 24,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '친환경 소비 점수',
                  style: AppTextStyles.koBody(
                    12,
                    weight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '1,250',
                      style: AppTextStyles.displayLg.copyWith(
                        fontSize: 34,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        'P',
                        style: AppTextStyles.titleMd.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            children: [
              _RankCard(
                icon: Symbols.star,
                iconColor: Color(0xFFF59E0B),
                title: '나의 티어',
                value: '그린 마스터',
              ),
              SizedBox(height: 12),
              _RankCard(
                icon: Symbols.location_on,
                iconColor: AppColors.primary,
                title: '지역 순위',
                value: '상위 5%',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RankCard extends StatelessWidget {
  const _RankCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(12),
      borderRadius: 18,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.4),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.koBody(
                    10,
                    weight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: AppTextStyles.koBody(
                    13,
                    weight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthRoadmap extends StatelessWidget {
  const _GrowthRoadmap();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: 32,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '성장 로드맵',
                style: AppTextStyles.koBody(
                  18,
                  weight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.onSurface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Level 2',
                  style: AppTextStyles.labelMd.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _RoadmapSteps(),
        ],
      ),
    );
  }
}

class _RoadmapSteps extends StatelessWidget {
  const _RoadmapSteps();

  static const _labels = ['씨앗', '새싹', '작은 나무', '숲'];
  static const _icons = [
    Symbols.eco,
    Symbols.grass,
    Symbols.park,
    Symbols.forest,
  ];
  static const int _activeIndex = 1; // 0,1 완료, 2/3 잠금

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final dotRow = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_labels.length, (i) {
          final active = i <= _activeIndex;
          return Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? const Color(0xFF059669)
                      : Colors.white.withValues(alpha: 0.4),
                  border: active
                      ? null
                      : Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color:
                                AppColors.primaryContainer.withValues(alpha: 0.3),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  _icons[i],
                  size: 20,
                  color: active ? Colors.white : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _labels[i],
                style: AppTextStyles.koBody(
                  11,
                  weight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active
                      ? const Color(0xFF047857)
                      : Colors.grey.shade500,
                ),
              ),
            ],
          );
        }),
      );

      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 19,
            left: 20,
            right: 20,
            child: Stack(
              children: [
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.outline.withValues(alpha: 0.2),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: _activeIndex / (_labels.length - 1),
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          dotRow,
        ],
      );
    });
  }
}

class _PlantDisplay extends StatelessWidget {
  const _PlantDisplay();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        const DuyuFlower(size: 240),
        Positioned(
          top: 4,
          child: GlassPanel(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            borderRadius: 999,
            opacity: 0.6,
            blur: 12,
            shadow: false,
            child: Text(
              '두유',
              style: AppTextStyles.koBody(
                14,
                weight: FontWeight.w700,
                color: AppColors.primary,
              ).copyWith(letterSpacing: 1.5),
            ),
          ),
        ),
        const Positioned(
          bottom: 8,
          right: 24,
          child: GlassPanel(
            padding: EdgeInsets.all(12),
            borderRadius: 999,
            child: Icon(
              Symbols.save_alt,
              color: AppColors.onSurfaceVariant,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

class _GrowthProgress extends StatelessWidget {
  const _GrowthProgress();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: 32,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '현재 성장도',
                style: AppTextStyles.koBody(
                  13,
                  weight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '75%',
                style: AppTextStyles.koBody(
                  13,
                  weight: FontWeight.w700,
                  color: const Color(0xFF047857),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.75,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF34D399),
                          Color(0xFF059669),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Symbols.water_drop, size: 16, color: Color(0xFF3B82F6)),
              const SizedBox(width: 4),
              Text(
                '오늘 물을 ',
                style: AppTextStyles.koBody(12, color: AppColors.onSurfaceVariant),
              ),
              Text(
                '2번 더',
                style: AppTextStyles.koBody(
                  12,
                  weight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                ' 줄 수 있어요!',
                style: AppTextStyles.koBody(12, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionFooter extends StatelessWidget {
  const _ActionFooter({
    required this.onScanReceipt,
    required this.onHistory,
    required this.onSettings,
  });

  final VoidCallback onScanReceipt;
  final VoidCallback onHistory;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DarkGlassButton(
          onPressed: onScanReceipt,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryContainer.withValues(alpha: 0.4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(
                  Symbols.photo_camera,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '영수증 인증하고 물주기',
                style: AppTextStyles.koBody(
                  17,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GlassPanel(
                onTap: onHistory,
                padding: const EdgeInsets.symmetric(vertical: 18),
                borderRadius: 24,
                opacity: 0.5,
                blur: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Symbols.description,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '인증 내역',
                      style: AppTextStyles.koBody(
                        15,
                        weight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            GlassPanel(
              onTap: onSettings,
              padding: const EdgeInsets.all(20),
              borderRadius: 24,
              opacity: 0.5,
              blur: 15,
              child: const Icon(
                Symbols.settings,
                color: AppColors.onSurfaceVariant,
                size: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
