import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/birch_background.dart';
import '../widgets/glass_panel.dart';
import '../widgets/lumina_app_bar.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  String _viewMode = 'home'; // 'home' 또는 'tier'
  String _subViewMode = 'national'; // 'national' 또는 'regional' (티어 상세 내 서브 탭)

  void _changeViewMode(String mode) {
    setState(() {
      _viewMode = mode;
    });
  }

  void _changeSubViewMode(String subMode) {
    setState(() {
      _subViewMode = subMode;
    });
  }

  // 🆕 실시간 지우기 및 풍성한 알림 요소가 적용된 알림 바텀 시트 함수
  void _showNotificationsSheet(BuildContext context) {
    // 시트가 열릴 때 원본 불변 데이터를 변경 가능한 가변 리스트로 복사해옵니다.
    final List<_NotificationEntry> currentNotifications = List.from(_initialNotifications);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // 유리 효과 극대화를 위해 배경 투명 처리
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return GlassPanel(
              opacity: 0.85,
              blur: 20,
              borderRadius: 32,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75, // 화면 높이의 75% 차지
                child: Column(
                  children: [
                    // 상단 핸들 바 (쓸어내리기 유도 디자인)
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.onSurface.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // 타이틀 및 지우기 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 56), // 우측 지우기 버튼과의 대칭을 위한 여백
                        Text(
                          '알림',
                          style: AppTextStyles.koBody(
                            18,
                            weight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        // ⚡ 클릭 시 전체 지우기 기능 작동
                        GestureDetector(
                          onTap: () {
                            if (currentNotifications.isNotEmpty) {
                              setModalState(() {
                                currentNotifications.clear();
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              '전체 삭제',
                              style: AppTextStyles.koBody(
                                13,
                                weight: FontWeight.w700,
                                color: currentNotifications.isEmpty 
                                    ? AppColors.onSurfaceVariant.withValues(alpha: 0.3)
                                    : Colors.red.shade400, // 데이터가 있을 때만 붉은색 활성화
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // 알림 목록 리스트 영역
                    Expanded(
                      child: currentNotifications.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Symbols.notifications_off, 
                                    size: 48, 
                                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.3)
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '새로운 알림이 없습니다.',
                                    style: AppTextStyles.koBody(
                                      14, 
                                      weight: FontWeight.w500,
                                      color: AppColors.onSurfaceVariant
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: currentNotifications.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1,
                                thickness: 1,
                                color: AppColors.outline.withValues(alpha: 0.08),
                              ),
                              itemBuilder: (context, index) {
                                final item = currentNotifications[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 알림 성격별 아이콘 컨테이너
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: item.iconBg,
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(item.icon, color: item.iconColor, size: 20),
                                      ),
                                      const SizedBox(width: 14),
                                      // 알림 텍스트 세부 영역
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  item.type,
                                                  style: AppTextStyles.koBody(
                                                    11,
                                                    weight: FontWeight.w700,
                                                    color: item.typeColor,
                                                  ),
                                                ),
                                                Text(
                                                  item.time,
                                                  style: AppTextStyles.koBody(
                                                    11,
                                                    color: AppColors.onSurfaceVariant,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.title,
                                              style: AppTextStyles.koBody(
                                                14,
                                                weight: FontWeight.w600,
                                                color: AppColors.onSurface,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              item.message,
                                              style: AppTextStyles.koBody(
                                                13,
                                                color: AppColors.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
          onPressed: () => _showNotificationsSheet(context), // 알림 바텀 시트 트리거 연동
        ),
      ),
      body: BirchBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 48),
            children: [
              _BalanceCard(
                viewMode: _viewMode,
                onViewModeChanged: _changeViewMode,
              ),
              const SizedBox(height: 16),
              
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
                const _MyRankingCard(),
                const SizedBox(height: 16),
                
                _SubTabBar(
                  subViewMode: _subViewMode,
                  onSubViewModeChanged: _changeSubViewMode,
                ),
                const SizedBox(height: 16),
                
                _LeaderboardCard(isNational: _subViewMode == 'national'),
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

class _MyRankingCard extends StatelessWidget {
  const _MyRankingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
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

class _SubTabBar extends StatelessWidget {
  final String subViewMode;
  final ValueChanged<String> onSubViewModeChanged;

  const _SubTabBar({
    required this.subViewMode,
    required this.onSubViewModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isNational = subViewMode == 'national';

    return Row(
      children: [
        Expanded(
          child: isNational
              ? FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => onSubViewModeChanged('national'),
                  child: Text(
                    '전국 랭킹',
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : GlassPanel(
                  onTap: () => onSubViewModeChanged('national'),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  borderRadius: 12,
                  opacity: 0.4,
                  shadow: false,
                  child: Center(
                    child: Text(
                      '전국 랭킹',
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: !isNational
              ? FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => onSubViewModeChanged('regional'),
                  child: Text(
                    '지역별 랭킹',
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : GlassPanel(
                  onTap: () => onSubViewModeChanged('regional'),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  borderRadius: 12,
                  opacity: 0.4,
                  shadow: false,
                  child: Center(
                    child: Text(
                      '지역별 랭킹',
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final bool isNational;
  const _LeaderboardCard({required this.isNational});

  @override
  Widget build(BuildContext context) {
    final nationalRankings = [
      const _LeaderboardEntry(rank: 1, name: '김지우', tier: '그랜드 마스터', points: '50,420 P'),
      const _LeaderboardEntry(rank: 2, name: '이민재', tier: '그랜드 마스터', points: '50,400 P'),
      const _LeaderboardEntry(rank: 3, name: '박서연', tier: '그린 마스터', points: '50,280 P'),
      const _LeaderboardEntry(rank: 331, name: '나', tier: '그린 마스터', points: '20,250 P', isMe: true),
      const _LeaderboardEntry(rank: 332, name: '최윤서', tier: '그린 마스터', points: '20,240 P'),
    ];

    final regionalRankings = [
      const _LeaderboardEntry(rank: 1, name: '서대문구', tier: '서울시', points: '3,302,110 P'),
      const _LeaderboardEntry(rank: 2, name: '마포구', tier: '서울시', points: '3,228,450 P'),
      const _LeaderboardEntry(rank: 3, name: '연수구', tier: '인천시', points: '3,120,250 P', isMe: true),
      const _LeaderboardEntry(rank: 4, name: '성남시', tier: '경기도', points: '2,919,870 P'),
      const _LeaderboardEntry(rank: 5, name: '해운대구', tier: '부산시', points: '2,915,400 P'),
    ];

    final rankings = isNational ? nationalRankings : regionalRankings;

    return GlassPanel(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isNational ? '전국 랭킹' : '지역별 랭킹',
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
              
              Color rankBg = Colors.transparent;
              Color rankText = AppColors.onSurfaceVariant;
              if (item.rank == 1) { rankBg = const Color(0xFFFFD700); rankText = Colors.white; }
              else if (item.rank == 2) { rankBg = const Color(0xFFC0C0C0); rankText = Colors.grey.shade800; }
              else if (item.rank == 3) { rankBg = const Color(0xCDCD7F32); rankText = Colors.white; }

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
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


// ==========================================
// 🆕 확장 및 구조 개선된 가상의 알림 데이터 영역
// ==========================================

class _NotificationEntry {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String type;
  final Color typeColor;
  final String time;
  final String title;
  final String message;

  const _NotificationEntry({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.type,
    required this.typeColor,
    required this.time,
    required this.title,
    required this.message,
  });
}

// 총 7개의 다채로운 일상 알림 더미 데이터 세트
const _initialNotifications = <_NotificationEntry>[
  _NotificationEntry(
    icon: Symbols.water_drop,
    iconColor: Color(0xFF3B82F6),
    iconBg: Color(0xFFDBEAFE),
    type: '물주기 리마인더',
    typeColor: Color(0xFF2563EB),
    time: '방금 전',
    title: '💧 두유가 목이 말라요!',
    message: '오늘 아직 물을 주지 않았습니다. 영수증을 인증하고 두유를 함께 성장시켜 보세요.',
  ),
  _NotificationEntry(
    icon: Symbols.workspace_premium,
    iconColor: Color(0xFFF59E0B),
    iconBg: Color(0xFFFEF3C7),
    type: '티어 승급',
    typeColor: Color(0xFFD97706),
    time: '20분 전',
    title: '🎉 그린 마스터 티어 달성!',
    message: '친환경 소비 점수 20,250P를 넘겨 전국 상위 1% ‘그린 마스터’로 도약하셨습니다.',
  ),
  _NotificationEntry(
    icon: Symbols.park,
    iconColor: Color(0xFF10B981),
    iconBg: Color(0xFFD1FAE5),
    type: '식물 성장',
    typeColor: Color(0xFF059669),
    time: '2시간 전',
    title: '🌱 두유가 \'새싹\'으로 진화했습니다!',
    message: '꾸준한 지구 지킴이 활동 덕분에 반려 식물이 한 차례 더 멋지게 성장했습니다.',
  ),
  _NotificationEntry(
    icon: Symbols.eco,
    iconColor: Color(0xFF059669),
    iconBg: Color(0xFFD1FAE5),
    type: '포인트 적립',
    typeColor: Color(0xFF059669),
    time: '오전 10:24',
    title: '카페 다회용컵 인증 완료 (+10P)',
    message: '텀블러 이용 영수증이 시스템을 통해 정상 확인되어 포인트가 적립되었습니다.',
  ),
  _NotificationEntry(
    icon: Symbols.featured_seasonal_and_gifts,
    iconColor: Color(0xFFEC4899),
    iconBg: Color(0xFFFCE7F3),
    type: '이벤트',
    typeColor: Color(0xFFDB2777),
    time: '어제',
    title: '⚡ 주말 한정! 대중교통 2배 레이스',
    message: '다가오는 주말 동안 대중교통 이용 내역을 인증하면 포인트가 두 배로 쌓입니다.',
  ),
  _NotificationEntry(
    icon: Symbols.leaderboard,
    iconColor: Color(0xFF6366F1),
    iconBg: Color(0xFFEEF2FF),
    type: '순위 변동',
    typeColor: Color(0xFF4F46E5),
    time: '어제',
    title: '지역 랭킹 대폭 상승 📈',
    message: '전국 랭킹이 지난주 대비 무려 12위나 뛰어올라 현재 상위 1%입니다.',
  ),
  _NotificationEntry(
    icon: Symbols.error,
    iconColor: Color(0xFFEF4444),
    iconBg: Color(0xFFFEE2E2),
    type: '인증 반려',
    typeColor: Color(0xFFDC2626),
    time: '3일 전',
    title: '❌ 영수증 인증 실패 안내',
    message: '제출하신 이미지의 초점이 다소 흐려 영수증 확인이 어렵습니다. 다시 시도해 주세요.',
  ),
];