import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/globals.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/birch_background.dart';
import '../widgets/duyu_flower.dart';
import '../widgets/glass_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = '사용자';
  int _userPoint = 0;
  String _userPlant = '새싹';
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
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Home 유저 정보 조회 에러: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showSettingsSheet(BuildContext context) {
    bool pushNotification = true;
    bool marketingNotification = false;
    bool eventNotification = true;
    bool soundVibration = true;
    bool doNotDisturb = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return GlassPanel(
              opacity: 0.85,
              blur: 20,
              borderRadius: 32,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.onSurface.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Text(
                      '설정',
                      style: AppTextStyles.koBody(18, weight: FontWeight.w700, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildSheetSectionTitle('화면 및 스타일 설정'),
                            _buildSheetTile(Symbols.palette, '테마 변경 (다크 / 라이트 모드)', () {}),
                            _buildSheetTile(Symbols.format_size, '글자 크기 조절', () {}),
                            _buildSheetTile(Symbols.wallpaper, '배경화면 변경', () {}),
                            _buildSheetTile(Symbols.language, '언어 설정 (Language)', () {}),
                            _buildSheetTile(Symbols.accessibility, '접근성 설정', () {}),
                            const SizedBox(height: 24),
                            _buildSheetSectionTitle('알림 및 소리 설정'),
                            _buildSheetSwitchTile(Symbols.notifications_active, '푸시 알림 허용', pushNotification, (val) => setModalState(() => pushNotification = val)),
                            _buildSheetSwitchTile(Symbols.volume_up, '소리 알림', soundVibration, (val) => setModalState(() => soundVibration = val)),
                            _buildSheetSwitchTile(Symbols.do_not_disturb_on, '방해 금지 모드', doNotDisturb, (val) => setModalState(() => doNotDisturb = val)),
                            _buildSheetSwitchTile(Symbols.mail, 'SMS 마케팅 수신 동의', marketingNotification, (val) => setModalState(() => marketingNotification = val)),
                            _buildSheetSwitchTile(Symbols.celebration, '혜택 및 이벤트 앱 알림', eventNotification, (val) => setModalState(() => eventNotification = val)),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Globals.loginId = null;
                                    context.go('/login');
                                  },
                                  child: Text('로그아웃', style: AppTextStyles.koBody(14, weight: FontWeight.w600, color: Colors.red.shade400)),
                                ),
                                Container(width: 1, height: 14, color: AppColors.outline.withValues(alpha: 0.3)),
                                TextButton(onPressed: () {}, child: Text('회원 탈퇴', style: AppTextStyles.koBody(14, color: AppColors.onSurfaceVariant))),
                              ],
                            ),
                          ],
                        ),
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

  Widget _buildSheetSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 4),
      child: Text(title, style: AppTextStyles.koBody(13, weight: FontWeight.w700, color: AppColors.primary)),
    );
  }

  Widget _buildSheetTile(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: AppTextStyles.koBody(15, weight: FontWeight.w500, color: AppColors.onSurface))),
            const Icon(Symbols.arrow_forward_ios, size: 14, color: AppColors.outline),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetSwitchTile(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: AppTextStyles.koBody(15, weight: FontWeight.w500, color: AppColors.onSurface))),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primaryContainer.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _fetchUserData,
        color: AppColors.primary,
        child: BirchBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ScoreSummary(points: _userPoint, isLoading: _isLoading),
                  const SizedBox(height: 20),
                  _GrowthRoadmap(plant: _userPlant),
                  const SizedBox(height: 24),
                  const _PlantDisplay(), 
                  const SizedBox(height: 20),
                  _GrowthProgress(points: _userPoint),
                  const SizedBox(height: 24),
                  _ActionFooter(
                    onScanReceipt: () => context.push('/scan'),
                    onHistory: () => context.push('/rewards'),
                    onSettings: () => _showSettingsSheet(context),
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

class _ScoreSummary extends StatelessWidget {
  final int points;
  final bool isLoading;
  const _ScoreSummary({required this.points, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    String tier = '초보 에코';
    if (points >= 1000) tier = '그린 마스터';
    else if (points >= 500) tier = '에코 가디언';

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
                Text('친환경 소비 점수', style: AppTextStyles.koBody(12, weight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 8),
                if (isLoading && points == 0)
                  const SizedBox(height: 40, child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
                else
                  FittedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'),
                            style: AppTextStyles.displayLg.copyWith(fontSize: 34, color: AppColors.onSurface)),
                        const SizedBox(width: 4),
                        Padding(padding: const EdgeInsets.only(bottom: 6), child: Text('P', style: AppTextStyles.titleMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              _RankCard(icon: Symbols.star, iconColor: const Color(0xFFF59E0B), title: '나의 티어', value: tier),
              const SizedBox(height: 12),
              const _RankCard(icon: Symbols.location_on, iconColor: AppColors.primary, title: '전국 순위', value: '1위'),
            ],
          ),
        ),
      ],
    );
  }
}

class _RankCard extends StatelessWidget {
  final IconData icon; final Color iconColor; final String title; final String value;
  const _RankCard({required this.icon, required this.iconColor, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(12),
      borderRadius: 18,
      child: Row(
        children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.4)), alignment: Alignment.center, child: Icon(icon, size: 18, color: iconColor)),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.koBody(10, weight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
            Text(value, style: AppTextStyles.koBody(13, weight: FontWeight.w700, color: AppColors.onSurface), overflow: TextOverflow.ellipsis),
          ])),
        ],
      ),
    );
  }
}

class _GrowthRoadmap extends StatelessWidget {
  final String plant;
  const _GrowthRoadmap({required this.plant});

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
              Text('성장 로드맵', style: AppTextStyles.koBody(18, weight: FontWeight.w700, color: AppColors.onSurface)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: AppColors.onSurface.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(999)), child: Text(plant, style: AppTextStyles.labelMd.copyWith(color: Colors.white))),
            ],
          ),
          const SizedBox(height: 20),
          _RoadmapSteps(currentPlant: plant),
        ],
      ),
    );
  }
}

class _RoadmapSteps extends StatelessWidget {
  final String currentPlant;
  const _RoadmapSteps({required this.currentPlant});

  static const _labels = ['씨앗', '새싹', '풀', '꽃봉오리', '꽃'];
  static const _icons = [Symbols.eco, Symbols.grass, Symbols.park, Symbols.local_florist, Symbols.filter_vintage];

  @override
  Widget build(BuildContext context) {
    int activeIndex = _labels.indexOf(currentPlant);
    if (activeIndex == -1) activeIndex = 0;

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 19, left: 20, right: 20,
            child: Container(height: 2, decoration: BoxDecoration(color: AppColors.outline.withValues(alpha: 0.2))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_labels.length, (i) {
              final active = i <= activeIndex;
              return Column(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: active ? const Color(0xFF059669) : Colors.white70),
                    child: Icon(_icons[i], size: 18, color: active ? Colors.white : Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(_labels[i], style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.bold : FontWeight.normal, color: active ? const Color(0xFF047857) : Colors.grey)),
                ],
              );
            }),
          ),
        ],
      );
    });
  }
}

class _PlantDisplay extends StatefulWidget {
  const _PlantDisplay();
  @override
  State<_PlantDisplay> createState() => _PlantDisplayState();
}

class _PlantDisplayState extends State<_PlantDisplay> {
  final GlobalKey _boundaryKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, alignment: Alignment.center,
      children: [
        RepaintBoundary(key: _boundaryKey, child: Container(color: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 16), child: const DuyuFlower(size: 240))),
        Positioned(top: 4, child: GlassPanel(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), borderRadius: 999, opacity: 0.6, blur: 12, shadow: false, child: Text('두유', style: AppTextStyles.koBody(14, weight: FontWeight.w700, color: AppColors.primary)))),
      ],
    );
  }
}

class _GrowthProgress extends StatelessWidget {
  final int points;
  const _GrowthProgress({required this.points});
  @override
  Widget build(BuildContext context) {
    double progress = (points % 200) / 200.0;
    return GlassPanel(
      borderRadius: 32, padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('현재 성장도', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${(progress * 100).toInt()}%', style: const TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.white30, color: const Color(0xFF059669), minHeight: 8),
        ],
      ),
    );
  }
}

class _ActionFooter extends StatelessWidget {
  final VoidCallback onScanReceipt; final VoidCallback onHistory; final VoidCallback onSettings;
  const _ActionFooter({required this.onScanReceipt, required this.onHistory, required this.onSettings});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: onScanReceipt,
          style: FilledButton.styleFrom(backgroundColor: Colors.black87, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Symbols.photo_camera), SizedBox(width: 12), Text('영수증 인증하고 물주기', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))]),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: GlassPanel(onTap: onHistory, padding: const EdgeInsets.symmetric(vertical: 18), borderRadius: 24, child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Symbols.description, color: AppColors.primary), SizedBox(width: 8), Text('인증 내역')]))),
          const SizedBox(width: 16),
          GlassPanel(onTap: onSettings, padding: const EdgeInsets.all(20), borderRadius: 24, child: const Icon(Symbols.settings)),
        ]),
      ],
    );
  }
}
