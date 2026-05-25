import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/birch_background.dart';
import '../widgets/glass_panel.dart';
import '../widgets/lumina_app_bar.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: LuminaAppBar(
        leading: const _AvatarLeading(),
        trailing: IconButton(
          icon: const Icon(Symbols.notifications, color: AppColors.primary),
          onPressed: () {},
        ),
      ),
      body: BirchBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 48),
            children: [
              const _BalanceCard(),
              const SizedBox(height: 16),
              const _WeeklyImpactCard(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Recent Activity',
                      style: AppTextStyles.titleMd.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'VIEW ALL',
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final entry in _activities) ...[
                _ActivityRow(entry: entry),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: GlassPanel(
        onTap: () => context.canPop() ? context.pop() : context.go('/home'),
        padding: const EdgeInsets.all(16),
        borderRadius: 999,
        child: const Icon(
          Symbols.arrow_back,
          color: AppColors.primary,
          size: 24,
        ),
      ),
    );
  }
}

class _AvatarLeading extends StatelessWidget {
  const _AvatarLeading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryContainer.withValues(alpha: 0.3),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Symbols.person,
          color: AppColors.primary,
          size: 24,
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            bottom: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withValues(alpha: 0.12),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CURRENT BALANCE',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Total Points: 1,250 P',
                  style: AppTextStyles.displayLg.copyWith(
                    color: AppColors.primary,
                    fontSize: 28,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        minimumSize: const Size.fromHeight(44),
                      ),
                      onPressed: () {},
                      child: Text(
                        'REDEEM NOW',
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.onPrimary,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassPanel(
                      onTap: () {},
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      borderRadius: 12,
                      opacity: 0.4,
                      shadow: false,
                      child: Center(
                        child: Text(
                          'TIER DETAILS',
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyImpactCard extends StatelessWidget {
  const _WeeklyImpactCard();

  static const _bars = <_BarData>[
    _BarData(label: 'M', height: 0.40),
    _BarData(label: 'T', height: 0.65),
    _BarData(label: 'W', height: 0.90, highlight: true),
    _BarData(label: 'T', height: 0.30),
    _BarData(label: 'F', height: 0.55),
    _BarData(label: 'S', height: 0.20),
    _BarData(label: 'S', height: 0.45),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Eco-Impact',
                style: AppTextStyles.titleMd.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              const Icon(Symbols.analytics, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 128,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final b in _bars) ...[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: LayoutBuilder(builder: (_, c) {
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                Container(
                                  height: c.maxHeight * b.height,
                                  decoration: BoxDecoration(
                                    color: b.highlight
                                        ? AppColors.primary
                                        : AppColors.primaryContainer,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          b.label,
                          style: AppTextStyles.labelMd.copyWith(
                            color: b.highlight
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                            fontWeight: b.highlight
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (b != _bars.last) const SizedBox(width: 6),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              children: [
                const TextSpan(text: "You've reduced your carbon footprint by "),
                TextSpan(
                  text: '12kg',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' this week.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  const _BarData({
    required this.label,
    required this.height,
    this.highlight = false,
  });

  final String label;
  final double height;
  final bool highlight;
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.entry});

  final _ActivityEntry entry;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.tint,
            ),
            alignment: Alignment.center,
            child: Icon(entry.icon, color: entry.iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.subtitle,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            entry.points,
            style: AppTextStyles.titleMd.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _ActivityEntry {
  const _ActivityEntry({
    required this.icon,
    required this.iconColor,
    required this.tint,
    required this.title,
    required this.subtitle,
    required this.points,
  });

  final IconData icon;
  final Color iconColor;
  final Color tint;
  final String title;
  final String subtitle;
  final String points;
}

const _activities = <_ActivityEntry>[
  _ActivityEntry(
    icon: Symbols.coffee,
    iconColor: AppColors.onSecondaryContainer,
    tint: AppColors.secondaryContainer,
    title: 'Cafe Receipt',
    subtitle: 'Today, 10:24 AM',
    points: '+10P',
  ),
  _ActivityEntry(
    icon: Symbols.shopping_bag,
    iconColor: AppColors.onPrimaryContainer,
    tint: AppColors.primaryContainer,
    title: 'Eco-bag usage',
    subtitle: 'Yesterday, 4:15 PM',
    points: '+5P',
  ),
  _ActivityEntry(
    icon: Symbols.recycling,
    iconColor: AppColors.onTertiaryContainer,
    tint: AppColors.tertiaryContainer,
    title: 'Recycling Bin Drop-off',
    subtitle: 'May 12, 11:30 AM',
    points: '+25P',
  ),
  _ActivityEntry(
    icon: Symbols.electric_bolt,
    iconColor: AppColors.onSurfaceVariant,
    tint: AppColors.surfaceContainerHighest,
    title: 'Smart Meter Sync',
    subtitle: 'May 11, 8:00 AM',
    points: '+15P',
  ),
];
