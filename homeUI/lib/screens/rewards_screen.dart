import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/birch_background.dart';
import '../widgets/glass_panel.dart';
import '../widgets/lumina_app_bar.dart';

// 1. 상태 관리를 위해 RewardsScreen을 StatefulWidget으로 전환합니다.
class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  // 'home' 또는 'tier' 상태를 관리합니다.
  String _viewMode = 'home';

  void _changeViewMode(String mode) {
    setState(() {
      _viewMode = mode;
    });
  }

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
              // 포인트 카드에 현재 모드 정보와 상태 변경 이벤트를 콜백으로 넘겨줍니다.
              _BalanceCard(
                viewMode: _viewMode,
                onViewModeChanged: _changeViewMode,
              ),
              const SizedBox(height: 16),
              
              // _viewMode 상태값에 따라 하단 레이아웃을 조건부 스위칭(토글)합니다.
              if (_viewMode == 'home') ...[
                const _WeeklyImpactCard(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '최근 활동',
                        style: AppTextStyles.titleMd.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        '전체 보기',
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
              ] else ...[
                // 'tier' 모드일 때 나타날 커스텀 순위표 위젯 배치
                const _MyRankingCard(),
                const SizedBox(height: 16),
                const _LeaderboardCard(),
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

// 2. 현재 상태(viewMode)에 따라 버튼의 형태(FilledButton <-> GlassPanel)가 교차 대칭되도록 수정합니다.
class _BalanceCard extends StatelessWidget {
  final String viewMode;
  final ValueChanged<String> onViewModeChanged;

  const _BalanceCard({
    required this.viewMode,
    required this.onViewModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isHome = viewMode == 'home';

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
                '현재 보유 포인트',
                style: AppTextStyles.labelMd.copyWith(  
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '총 포인트: 20,250 P',
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
                  // REDEEM NOW 버튼
                  Expanded(
                    child: isHome
                        ? FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => onViewModeChanged('home'),
                            child: Text(
                              '포인트 사용',
                              style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.onPrimary,
                                letterSpacing: 1.2,
                              ),
                            ),
                          )
                        : GlassPanel(
                            onTap: () => onViewModeChanged('home'),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            borderRadius: 12,
                            opacity: 0.4,
                            shadow: false,
                            child: Center(
                              child: Text(
                                '포인트 사용',
                                style: AppTextStyles.labelMd.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  // TIER DETAILS 버튼
                  Expanded(
                    child: !isHome
                        ? FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => onViewModeChanged('tier'),
                            child: Text(
                              '티어 상세',
                              style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.onPrimary,
                                letterSpacing: 1.2,
                              ),
                            ),
                          )
                        : GlassPanel(
                            onTap: () => onViewModeChanged('tier'),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            borderRadius: 12,
                            opacity: 0.4,
                            shadow: false,
                            child: Center(
                              child: Text(
                                '티어 상세',
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

// 3. 신규 위젯: 포인트 기반 개인 순위표 카드 (My Ranking)
class _MyRankingCard extends StatelessWidget {
  const _MyRankingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // 프로젝트 고유의 테마 프라이머리 컬러와 어두운 톤을 조합한 그라데이션 배치
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF003D24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '내 순위',
                style: AppTextStyles.labelMd.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '331',
                      style: AppTextStyles.displayLg.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '/ 34,334명',
                      style: AppTextStyles.bodySm.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '상위 1% 이내 기록 중',
                style: AppTextStyles.bodySm.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Symbols.workspace_premium, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '그린 마스터 티어',
                      style: AppTextStyles.labelMd.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '20,250 P',
                style: AppTextStyles.titleMd.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// 4. 신규 위젯: 전국 순위표 카드 (Leaderboard)
class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard();

  @override
  Widget build(BuildContext context) {
    // 가상의 전국 스코어보드 고정 데이터셋
    final rankings = [
      const _LeaderboardEntry(rank: 1, name: '김지우', tier: '그랜드 마스터', points: '50,420 P'),
      const _LeaderboardEntry(rank: 2, name: '이민재', tier: '그랜드 마스터', points: '50,400 P'),
      const _LeaderboardEntry(rank: 3, name: '박서연', tier: '그린 마스터', points: '50,280 P'),
      const _LeaderboardEntry(rank: 331, name: '나', tier: '그린 마스터', points: '20,250 P', isMe: true),
      const _LeaderboardEntry(rank: 332, name: '최윤서', tier: '그린 마스터', points: '20,240 P'),
    ];

    return GlassPanel(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '전국 랭킹',
            style: AppTextStyles.titleMd.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rankings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = rankings[index];
              
              // 1, 2, 3등 메달의 메탈릭 컬러 분기 처리
              Color rankBg = Colors.transparent;
              Color rankText = AppColors.onSurfaceVariant;
              if (item.rank == 1) { rankBg = const Color(0xFFFFD700); rankText = Colors.white; }
              else if (item.rank == 2) { rankBg = const Color(0xFFC0C0C0); rankText = Colors.grey.shade800; }
              else if (item.rank == 3) { rankBg = const Color(0xCDCD7F32); rankText = Colors.white; }

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // '나'의 정보 로우(Row)는 앱 기본 테마색의 옅은 틴트를 주어 한눈에 강조합니다.
                  color: item.isMe 
                      ? AppColors.primary.withValues(alpha: 0.1) 
                      : AppColors.surfaceContainerHighest.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: item.isMe ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(color: rankBg, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text(
                        '${item.rank}',
                        style: AppTextStyles.labelMd.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: rankText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item.name,
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: item.isMe ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.tier,
                        style: AppTextStyles.labelMd.copyWith(
                          fontSize: 9,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.points,
                      style: AppTextStyles.titleMd.copyWith(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LeaderboardEntry {
  const _LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.tier,
    required this.points,
    this.isMe = false,
  });

  final int rank;
  final String name;
  final String tier;
  final String points;
  final bool isMe;
}

// ==========================================
// 아래 컴포넌트들은 수정 사항이 없는 기존 코드 영역입니다.
// ==========================================

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
                '주간 친환경 활동',
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
                                    color: AppColors.primary.withValues(alpha: 0.12),
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
                const TextSpan(text: '이번 주 탄소 발자국을 '),
                TextSpan(
                  text: '12kg',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' 줄였어요.'),
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
    title: '카페 영수증',
    subtitle: '오늘 오전 10:24',
    points: '+10P',
  ),
  _ActivityEntry(
    icon: Symbols.shopping_bag,
    iconColor: AppColors.onPrimaryContainer,
    tint: AppColors.primaryContainer,
    title: '에코백 사용',
    subtitle: '어제 오후 4:15',
    points: '+5P',
  ),
  _ActivityEntry(
    icon: Symbols.recycling,
    iconColor: AppColors.onTertiaryContainer,
    tint: AppColors.tertiaryContainer,
    title: '재활용 수거함 배출',
    subtitle: '5월 12일 오전 11:30',
    points: '+25P',
  ),
  _ActivityEntry(
    icon: Symbols.electric_bolt,
    iconColor: AppColors.onSurfaceVariant,
    tint: AppColors.surfaceContainerHighest,
    title: '스마트 미터 연동',
    subtitle: '5월 11일 오전 8:00',
    points: '+15P',
  ),
];