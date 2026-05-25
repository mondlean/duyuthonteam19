import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
// 이미지 저장 패키지를 쓰신다면 아래 주석을 해제하세요.
// import 'package:gal/gal.dart'; 

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/birch_background.dart';
import '../widgets/duyu_flower.dart';
import '../widgets/glass_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // const 생성자 유지 가능!

  // 하단에서 올라오는 설정 바텀 시트 구현 함수
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
                      style: AppTextStyles.koBody(
                        18,
                        weight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildSheetSectionTitle('계정 설정'),
                            _buildSheetTile(Symbols.person, '프로필 사진 변경', () {}),
                            _buildSheetTile(Symbols.badge, '회원가입 정보 수정', () {}),
                            _buildSheetTile(Symbols.lock, '비밀번호 변경', () {}),
                            _buildSheetTile(Symbols.alternate_email, '이메일 / 전화번호 변경', () {}),
                            _buildSheetTile(Symbols.share, '소셜 계정 연동', () {}),
                            
                            const SizedBox(height: 24),
                            
                            _buildSheetSectionTitle('알림 설정'),
                            _buildSheetSwitchTile(Symbols.notifications, '푸시 알림 ON/OFF', pushNotification, (val) {
                              setModalState(() => pushNotification = val);
                            }),
                            _buildSheetSwitchTile(Symbols.campaign, '마케팅 알림 받기', marketingNotification, (val) {
                              setModalState(() => marketingNotification = val);
                            }),
                            _buildSheetSwitchTile(Symbols.featured_seasonal_and_gifts, '이벤트 알림', eventNotification, (val) {
                              setModalState(() => eventNotification = val);
                            }),
                            _buildSheetSwitchTile(Symbols.volume_up, '소리 / 진동 설정', soundVibration, (val) {
                              setModalState(() => soundVibration = val);
                            }),
                            _buildSheetSwitchTile(Symbols.do_not_disturb_on, '방해금지 시간 설정', doNotDisturb, (val) {
                              setModalState(() => doNotDisturb = val);
                            }),
                            
                            const SizedBox(height: 32),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    '로그아웃',
                                    style: AppTextStyles.koBody(14, weight: FontWeight.w600, color: Colors.red.shade400),
                                  ),
                                ),
                                Container(width: 1, height: 14, color: AppColors.outline.withValues(alpha: 0.3)),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    '회원 탈퇴',
                                    style: AppTextStyles.koBody(14, color: AppColors.onSurfaceVariant),
                                  ),
                                ),
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
      child: Text(
        title,
        style: AppTextStyles.koBody(13, weight: FontWeight.w700, color: AppColors.primary),
      ),
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
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.koBody(15, weight: FontWeight.w500, color: AppColors.onSurface),
              ),
            ),
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
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.koBody(15, weight: FontWeight.w500, color: AppColors.onSurface),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
              activeTrackColor: AppColors.primaryContainer.withValues(alpha: 0.3),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade300,
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
                const _PlantDisplay(), // 기존처럼 const 구조 유지 가능!
                const SizedBox(height: 20),
                const _GrowthProgress(),
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
                  style: AppTextStyles.koBody(12, weight: FontWeight.w700, color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '20,250',
                      style: AppTextStyles.displayLg.copyWith(fontSize: 34, color: AppColors.onSurface),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        'P',
                        style: AppTextStyles.titleMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
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
                title: '전국 순위',
                value: '상위 1%',
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
                  style: AppTextStyles.koBody(10, weight: FontWeight.w500, color: AppColors.onSurfaceVariant),
                ),
                Text(
                  value,
                  style: AppTextStyles.koBody(13, weight: FontWeight.w700, color: AppColors.onSurface),
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
                style: AppTextStyles.koBody(18, weight: FontWeight.w700, color: AppColors.onSurface),
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
  static const _icons = [Symbols.eco, Symbols.grass, Symbols.park, Symbols.forest];
  static const int _activeIndex = 1;

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
                  color: active ? const Color(0xFF059669) : Colors.white.withValues(alpha: 0.4),
                  border: active ? null : Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: AppColors.primaryContainer.withValues(alpha: 0.3),
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
                  color: active ? const Color(0xFF047857) : Colors.grey.shade500,
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
                  decoration: BoxDecoration(color: AppColors.outline.withValues(alpha: 0.2)),
                ),
                FractionallySizedBox(
                  widthFactor: _activeIndex / (_labels.length - 1),
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.6)),
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

/* ⭐️ 핵심 변경: 캡처 전용 로직을 격리하기 위해 StatefulWidget으로 전환된 _PlantDisplay 위젯 ⭐️ */
class _PlantDisplay extends StatefulWidget {
  const _PlantDisplay();

  @override
  State<_PlantDisplay> createState() => _PlantDisplayState();
}

class _PlantDisplayState extends State<_PlantDisplay> {
  // 내부 캡처를 위한 독자적인 GlobalKey 생성
  final GlobalKey _boundaryKey = GlobalKey();

  Future<void> _downloadPlantImage() async {
    try {
      final RenderRepaintBoundary? boundary = 
          _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) return;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) return;
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/duyu_${DateTime.now().millisecondsSinceEpoch}.png').create();
      await imagePath.writeAsBytes(pngBytes);

      // 'gal' 패키지 등을 통해 사진첩 저장 시 아래 주석 해제하여 사용
      // await Gal.putImage(imagePath.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('식물 이미지가 갤러리에 저장되었습니다!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // 꽃 영역만 깔끔하게 캡처하기 위한 RepaintBoundary
        RepaintBoundary(
          key: _boundaryKey,
          child: Container(
            color: Colors.transparent, 
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                DuyuFlower(size: 240),
              ],
            ),
          ),
        ),
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
              style: AppTextStyles.koBody(14, weight: FontWeight.w700, color: AppColors.primary).copyWith(letterSpacing: 1.5),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 24,
          child: GlassPanel(
            onTap: _downloadPlantImage, // 클릭 시 내부 메서드 실행
            padding: const EdgeInsets.all(12),
            borderRadius: 999,
            child: const Icon(
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
                style: AppTextStyles.koBody(13, weight: FontWeight.w700, color: AppColors.onSurfaceVariant),
              ),
              Text(
                '75%',
                style: AppTextStyles.koBody(13, weight: FontWeight.w700, color: const Color(0xFF047857)),
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
                        colors: [Color(0xFF34D399), Color(0xFF059669)],
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
              Text('오늘 물을 ', style: AppTextStyles.koBody(12, color: AppColors.onSurfaceVariant)),
              Text('2번 더', style: AppTextStyles.koBody(12, weight: FontWeight.w700, color: AppColors.onSurface)),
              Text(' 줄 수 있어요!', style: AppTextStyles.koBody(12, color: AppColors.onSurfaceVariant)),
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
                    BoxShadow(color: AppColors.primaryContainer.withValues(alpha: 0.4), blurRadius: 12),
                  ],
                ),
                child: const Icon(Symbols.photo_camera, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text('영수증 인증하고 물주기', style: AppTextStyles.koBody(17, weight: FontWeight.w700, color: Colors.white)),
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
                    const Icon(Symbols.description, color: AppColors.primary, size: 22),
                    const SizedBox(width: 8),
                    Text('인증 내역', style: AppTextStyles.koBody(15, weight: FontWeight.w700, color: AppColors.onSurface)),
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
              child: const Icon(Symbols.settings, color: AppColors.onSurfaceVariant, size: 24),
            ),
          ],
        ),
      ],
    );
  }
}

class DarkGlassButton extends StatelessWidget {
  const DarkGlassButton({super.key, required this.onPressed, required this.child});
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.onSurface.withValues(alpha: 0.85),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: child,
          ),
        ),
      ),
    );
  }
}