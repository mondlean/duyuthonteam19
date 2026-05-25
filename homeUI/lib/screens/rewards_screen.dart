import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/globals.dart';
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
  String _selectedRegion = '서울특별시 강남구'; 
  bool _isNotificationOn = true;
  String _viewMode = 'home'; // 'home' 또는 'tier'
  String _subViewMode = 'national'; // 'national' 또는 'regional'

  String _userName = '사용자'; 
  String _userTier = '새싹 티어';
  int _userPoint = 0;
  String _userPlant = '새싹';
  List<dynamic> _activitiesData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (Globals.loginId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${Globals.springBaseUrl}/users/${Globals.loginId}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userName = data['name'] ?? Globals.loginId;
          _userPoint = data['point'] ?? 0;
          _userPlant = data['plant'] ?? '새싹';
          _selectedRegion = '${data['city']} ${data['area']}'.trim();
          if (_selectedRegion.isEmpty) _selectedRegion = '지역 정보 없음';
          
          if (_userPoint >= 1000) _userTier = '그린 마스터';
          else if (_userPoint >= 500) _userTier = '에코 가디언';
          else _userTier = '초보 에코';

          _isLoading = false;
        });
        
        _fetchActivities();
      }
    } catch (e) {
      debugPrint('유저 정보 조회 에러: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchActivities() async {
    try {
      final response = await http.get(
        Uri.parse('${Globals.springBaseUrl}/point/history/${Globals.loginId}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _activitiesData = jsonDecode(response.body);
        });
      }
    } catch (e) {
      debugPrint('활동 내역 조회 에러: $e');
    }
  }

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

  void _showRegionPickerSheet(BuildContext context) {
    // ... (Existing regionData Map remains the same, omitted for brevity but I will keep it in the final write)
    final Map<String, List<String>> regionData = {
      "서울특별시": ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"],
      "경기도": ["수원시", "성남시", "안양시", "안산시", "용인시", "부천시", "광명시", "평택시", "과천시", "오산시", "시흥시", "군포시", "의왕시", "하남시", "이천시", "안성시", "김포시", "화성시", "광주시", "양주시", "포천시", "여주시", "연천군", "가평군", "양평군"],
      // ... Add other regions if needed
    };

    final List<String> sidos = regionData.keys.toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, 
      builder: (context) {
        String tempSelectedSido = sidos.first;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setBottomSheetState) {
            final List<String> guguns = regionData[tempSelectedSido] ?? [];
            return GlassPanel(
              opacity: 0.95, blur: 25, borderRadius: 32,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 24), decoration: BoxDecoration(color: AppColors.onSurface.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
                  Text('관심 지역 설정', style: AppTextStyles.koBody(18, weight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                    child: Row(
                      children: [
                        Expanded(child: Container(decoration: BoxDecoration(color: AppColors.onSurface.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(16)), child: Material(color: Colors.transparent, child: ListView.builder(itemCount: sidos.length, itemBuilder: (context, index) {
                          final sido = sidos[index]; final isCurrentSido = (tempSelectedSido == sido);
                          return ListTile(dense: true, title: Text(sido, style: AppTextStyles.koBody(14, weight: isCurrentSido ? FontWeight.w700 : FontWeight.w500, color: isCurrentSido ? AppColors.primary : AppColors.onSurface.withValues(alpha: 0.7))), tileColor: isCurrentSido ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent, onTap: () => setBottomSheetState(() => tempSelectedSido = sido));
                        })))),
                        const SizedBox(width: 12),
                        Expanded(child: Container(decoration: BoxDecoration(color: AppColors.onSurface.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(16)), child: Material(color: Colors.transparent, child: ListView.builder(itemCount: guguns.length, itemBuilder: (context, index) {
                          final gugun = guguns[index]; final fullPathName = "$tempSelectedSido $gugun"; final isCurrentGugun = (_selectedRegion == fullPathName);
                          return ListTile(dense: true, title: Text(gugun, style: AppTextStyles.koBody(14, weight: isCurrentGugun ? FontWeight.w700 : FontWeight.w500, color: isCurrentGugun ? AppColors.primary : AppColors.onSurface)), trailing: isCurrentGugun ? const Icon(Symbols.check, color: AppColors.primary, size: 18) : null, onTap: () { setState(() => _selectedRegion = fullPathName); Navigator.pop(context); });
                        }))))
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showProfileEditSheet(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: _userName);
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(builder: (context, setModalState) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: GlassPanel(opacity: 0.9, blur: 25, borderRadius: 32, padding: const EdgeInsets.fromLTRB(24, 12, 24, 40), child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 24), decoration: BoxDecoration(color: AppColors.onSurface.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
          Text('내 정보 및 설정', style: AppTextStyles.koBody(18, weight: FontWeight.w700)),
          const SizedBox(height: 24),
          Stack(children: [
            Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryContainer.withValues(alpha: 0.3), border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 2)), alignment: Alignment.center, child: const Icon(Symbols.person, color: AppColors.primary, size: 40)),
            Positioned(right: 0, bottom: 0, child: Container(width: 26, height: 26, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle), child: const Icon(Symbols.photo_camera, color: Colors.white, size: 14))),
          ]),
          const SizedBox(height: 24),
          Align(alignment: Alignment.centerLeft, child: Text('닉네임 / 이름', style: AppTextStyles.koBody(13, weight: FontWeight.w600, color: AppColors.onSurfaceVariant))),
          const SizedBox(height: 8),
          TextField(controller: nameController, decoration: InputDecoration(filled: true, fillColor: AppColors.onSurface.withValues(alpha: 0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          const SizedBox(height: 20),
          Container(decoration: BoxDecoration(color: AppColors.onSurface.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(16)), child: Column(children: [
            ListTile(leading: const Icon(Symbols.location_on, color: AppColors.primary), title: Text('나의 지역 설정', style: AppTextStyles.koBody(14, weight: FontWeight.w600)), trailing: Text(_selectedRegion), onTap: () { _showRegionPickerSheet(context); Future.delayed(const Duration(milliseconds: 500), () => setModalState(() {})); }),
            SwitchListTile(secondary: const Icon(Symbols.notifications_active, color: AppColors.primary), title: Text('실시간 푸시 알림', style: AppTextStyles.koBody(14, weight: FontWeight.w600)), value: _isNotificationOn, activeColor: AppColors.primary, onChanged: (v) => setModalState(() { _isNotificationOn = v; setState(() => _isNotificationOn = v); })),
          ])),
          const SizedBox(height: 28),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(50)), onPressed: () { setState(() => _userName = nameController.text); Navigator.pop(context); }, child: const Text('변경사항 저장')),
        ])),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: LuminaAppBar(
        leading: GestureDetector(onTap: () => _showProfileEditSheet(context), child: const _AvatarLeading()),
        trailing: IconButton(icon: const Icon(Symbols.notifications, color: AppColors.primary), onPressed: () {}),
      ),
      body: BirchBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 48),
            children: [
              _BalanceCard(viewMode: _viewMode, onViewModeChanged: _changeViewMode, points: _userPoint),
              const SizedBox(height: 16),
              if (_viewMode == 'home') ...[
                const _WeeklyImpactCard(),
                const SizedBox(height: 16),
                Text('최근 활동', style: AppTextStyles.titleMd.copyWith(color: AppColors.onSurface)),
                const SizedBox(height: 12),
                if (_activitiesData.isEmpty) const Center(child: Text('최근 활동이 없습니다.'))
                else for (final entry in _activitiesData) ...[
                  _ActivityRow(data: entry),
                  const SizedBox(height: 12),
                ],
              ] else ...[
                _MyRankingCard(name: _userName, tier: _userTier, points: _userPoint),
                const SizedBox(height: 16),
                _SubTabBar(subViewMode: _subViewMode, onSubViewModeChanged: _changeSubViewMode),
                const SizedBox(height: 16),
                _LeaderboardCard(isNational: _subViewMode == 'national', myName: _userName, myTier: _userTier, myPoints: _userPoint),
              ],
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: GlassPanel(onTap: () => context.go('/home'), padding: const EdgeInsets.all(16), borderRadius: 999, child: const Icon(Symbols.arrow_back, color: AppColors.primary, size: 24)),
    );
  }
}

class _AvatarLeading extends StatelessWidget {
  const _AvatarLeading();
  @override
  Widget build(BuildContext context) {
    return Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryContainer.withValues(alpha: 0.3)), alignment: Alignment.center, child: const Icon(Symbols.person, color: AppColors.primary, size: 24));
  }
}

class _BalanceCard extends StatelessWidget {
  final String viewMode; final ValueChanged<String> onViewModeChanged; final int points;
  const _BalanceCard({required this.viewMode, required this.onViewModeChanged, required this.points});

  @override
  Widget build(BuildContext context) {
    final isHome = viewMode == 'home';
    return GlassPanel(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('현재 보유 포인트', style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.5)),
        const SizedBox(height: 6),
        Text('${points.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]},")} P', style: AppTextStyles.displayLg.copyWith(color: AppColors.primary, fontSize: 28)),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: isHome ? FilledButton(style: FilledButton.styleFrom(backgroundColor: AppColors.primary), onPressed: () {}, child: const Text('포인트 사용')) : OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary), onPressed: () => onViewModeChanged('home'), child: const Text('포인트 사용'))),
          const SizedBox(width: 12),
          Expanded(child: !isHome ? FilledButton(style: FilledButton.styleFrom(backgroundColor: AppColors.primary), onPressed: () {}, child: const Text('티어 상세')) : OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary), onPressed: () => onViewModeChanged('tier'), child: const Text('티어 상세'))),
        ]),
      ]),
    );
  }
}

class _MyRankingCard extends StatelessWidget {
  final String name; final String tier; final int points;
  const _MyRankingCard({required this.name, required this.tier, required this.points});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF003D24)]), borderRadius: BorderRadius.circular(16)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$name 님의 순위', style: AppTextStyles.labelMd.copyWith(color: Colors.white70)),
        const SizedBox(height: 8),
        Text('1위', style: AppTextStyles.displayLg.copyWith(color: Colors.white, fontSize: 28)),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)), child: Text(tier, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        const SizedBox(height: 16),
        Text('$points P', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ])
    ]));
  }
}

class _SubTabBar extends StatelessWidget {
  final String subViewMode; final ValueChanged<String> onSubViewModeChanged;
  const _SubTabBar({required this.subViewMode, required this.onSubViewModeChanged});
  @override
  Widget build(BuildContext context) {
    final isNational = subViewMode == 'national';
    return Row(children: [
      Expanded(child: isNational ? FilledButton(style: FilledButton.styleFrom(backgroundColor: AppColors.primary), onPressed: () {}, child: const Text('전국 랭킹')) : OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary), onPressed: () => onSubViewModeChanged('national'), child: const Text('전국 랭킹'))),
      const SizedBox(width: 12),
      Expanded(child: !isNational ? FilledButton(style: FilledButton.styleFrom(backgroundColor: AppColors.primary), onPressed: () {}, child: const Text('지역별 랭킹')) : OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary), onPressed: () => onSubViewModeChanged('regional'), child: const Text('지역별 랭킹'))),
    ]);
  }
}

class _LeaderboardCard extends StatelessWidget {
  final bool isNational; final String myName; final String myTier; final int myPoints;
  const _LeaderboardCard({required this.isNational, required this.myName, required this.myTier, required this.myPoints});
  @override
  Widget build(BuildContext context) {
    return GlassPanel(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(isNational ? '전국 랭킹 (Top 5)' : '지역별 랭킹', style: AppTextStyles.titleMd),
      const SizedBox(height: 16),
      _LeaderboardRow(rank: 1, name: myName, tier: myTier, points: '$myPoints P', isMe: true),
    ]));
  }
}

class _LeaderboardRow extends StatelessWidget {
  final int rank; final String name; final String tier; final String points; final bool isMe;
  const _LeaderboardRow({required this.rank, required this.name, required this.tier, required this.points, this.isMe = false});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: isMe ? AppColors.primary.withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(12)), child: Row(children: [
      CircleAvatar(radius: 12, backgroundColor: AppColors.primary, child: Text('$rank', style: const TextStyle(color: Colors.white, fontSize: 12))),
      const SizedBox(width: 12), Text(name, style: const TextStyle(fontWeight: FontWeight.bold)), const Spacer(),
      Text(points, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
    ]));
  }
}

class _WeeklyImpactCard extends StatelessWidget {
  const _WeeklyImpactCard();
  @override
  Widget build(BuildContext context) {
    const bars = [_BarData('M', 0.40), _BarData('T', 0.65), _BarData('W', 0.90, true), _BarData('T', 0.30), _BarData('F', 0.55), _BarData('S', 0.20), _BarData('S', 0.45)];
    return GlassPanel(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('주간 친환경 활동', style: AppTextStyles.titleMd), const Icon(Symbols.analytics, color: AppColors.primary)]),
      const SizedBox(height: 20),
      SizedBox(height: 100, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        for (final b in bars) Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(child: Container(width: 12, decoration: BoxDecoration(color: b.highlight ? AppColors.primary : AppColors.primaryContainer.withOpacity(0.3), borderRadius: BorderRadius.circular(4)), child: FractionallySizedBox(heightFactor: b.height, alignment: Alignment.bottomCenter, child: Container(decoration: BoxDecoration(color: b.highlight ? AppColors.primary : AppColors.primaryContainer, borderRadius: BorderRadius.circular(4)))))),
          const SizedBox(height: 4), Text(b.label, style: const TextStyle(fontSize: 10)),
        ]))
      ])),
      const SizedBox(height: 16),
      const Center(child: Text('이번 주 탄소 발자국을 12kg 줄였어요.', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold))),
    ]));
  }
}

class _BarData {
  const _BarData(this.label, this.height, [this.highlight = false]);
  final String label; final double height; final bool highlight;
}

class _ActivityRow extends StatelessWidget {
  final dynamic data;
  const _ActivityRow({required this.data});
  @override
  Widget build(BuildContext context) {
    return GlassPanel(padding: const EdgeInsets.all(16), borderRadius: 16, child: Row(children: [
      const Icon(Symbols.eco, color: AppColors.primary),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(data['item'] ?? '친환경 활동', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(data['time']?.toString().split('T')[0] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ])),
      Text('+${data['point']}P', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
    ]));
  }
}
