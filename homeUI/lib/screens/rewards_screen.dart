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
  String _selectedRegion = '서울시 강남구'; 
  bool _isNotificationOn = true;
  String _viewMode = 'home'; // 'home' 또는 'tier'
  String _subViewMode = 'national'; // 'national' 또는 'regional'

  // 실시간 정보 수정 및 변경 사항 반영을 위한 유저 정보 상태 변수
  String _userName = '두유톤'; 
  final String _userTier = '그린 마스터 티어';

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

  // 🔴 [구조 변경] 관심 지역 선택 바텀 시트 (이제 프로필 시트 위로 겹쳐서 자연스럽게 띄웁니다)
  void _showRegionPickerSheet(BuildContext context) {
  // 1. 전국 시/도 및 시/군/구 데이터 정의
  final Map<String, List<String>> regionData = {
    "서울특별시": ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"],
    "부산광역시": ["강서구", "금정구", "기장군", "남구", "동구", "동래구", "부산진구", "북구", "사상구", "사하구", "서구", "수영구", "연제구", "영도구", "중구", "해운대구"],
    "대구광역시": ["군위군", "남구", "달서구", "달성군", "동구", "북구", "서구", "수성구", "중구"],
    "인천광역시": ["강화군", "계양구", "남동구", "동구", "미추홀구", "부평구", "서구", "연수구", "옹진군", "중구"],
    "광주광역시": ["광산구", "남구", "동구", "북구", "서구"],
    "대전광역시": ["대덕구", "동구", "서구", "유성구", "중구"],
    "울산광역시": ["남구", "동구", "북구", "울주군", "중구"],
    "세종특별자치시": ["세종시"],
    "경기도": ["가평군", "고양시 덕양구", "고양시 일산동구", "고양시 일산서구", "과천시", "광명시", "광주시", "구리시", "군포시", "김포시", "남양주시", "동두천시", "부천시 원미구", "부천시 소사구", "부천시 오정구", "성남시 분당구", "성남시 수정구", "성남시 중원구", "수원시 권선구", "수원시 영통구", "수원시 장안구", "수원시 팔달구", "시흥시", "안산시 단원구", "안산시 상록구", "안성시", "안양시 동안구", "안양시 만안구", "양주시", "양평군", "여주시", "연천군", "오산시", "용인시 기흥구", "용인시 수지구", "용인시 처인구", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시"],
    "강원특별자치도": ["강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "영월군", "원주시", "인제군", "정선군", "철원군", "춘천시", "태백시", "평창군", "홍천군", "화천군", "횡성군"],
    "충청북도": ["괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "제천시", "증평군", "진천군", "청주시 상당구", "청주시 서원구", "청주시 청원구", "청주시 흥덕구", "충주시"],
    "충청남도": ["계룡시", "공주시", "금산군", "논산시", "당진시", "보령시", "부여군", "서산시", "서천군", "아산시", "예산군", "천안시 동남구", "천안시 서북구", "청양군", "태안군", "홍성군"],
    "전북특별자치도": ["고창군", "군산시", "김제시", "남원시", "무주군", "부안군", "순창군", "완주군", "익산시", "임실군", "장수군", "전주시 덕진구", "전주시 완산구", "정읍시", "진안군"],
    "전라남도": ["강진군", "고흥군", "곡성군", "광양시", "구례군", "나주시", "담양군", "목포시", "무안군", "보성군", "순천시", "신안군", "여수시", "영광군", "영암군", "완도군", "장성군", "장흥군", "진도군", "함평군", "해남군", "화순군"],
    "경상북도": ["경산시", "경주시", "고령군", "구미시", "김천시", "문경시", "봉화군", "상주시", "성주군", "안동시", "영덕군", "영양군", "영주시", "영천시", "예천군", "울릉군", "울진군", "의성군", "청도군", "청송군", "칠곡군", "포항시 남구", "포항시 북구"],
    "경상남도": ["거제시", "거창군", "고성군", "김해시", "남해군", "밀양시", "사천시", "산청군", "양산시", "의령군", "진주시", "창녕군", "창원시 마산합포구", "창원시 마산회원구", "창원시 성산구", "창원시 의창구", "창원시 진해구", "통영시", "하동군", "함안군", "함양군", "합천군"],
    "제주특별자치도": ["서귀포시", "제주시"]
  };

  // 시/도 Key 배열 추출
  final List<String> sidos = regionData.keys.toList();

  // 바텀시트 내부에서 실시간으로 스크롤 상태를 바꾸기 위해 StatefulBuilder 사용
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true, // 내부 Expanded 레이아웃이 정상 작동하기 위해 필수
    builder: (context) {
      // 초기 내부 선택 상태 변수 (현재 메인 화면에서 고른 값이 있으면 파싱해서 초기값 매칭)
      String tempSelectedSido = sidos.first;
      if (_selectedRegion.isNotEmpty) {
        for (var sido in sidos) {
          if (_selectedRegion.startsWith(sido)) {
            tempSelectedSido = sido;
            break;
          }
        }
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setBottomSheetState) {
          final List<String> guguns = regionData[tempSelectedSido] ?? [];

          return GlassPanel(
            opacity: 0.95,
            blur: 25,
            borderRadius: 32,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 바텀시트 상단 핸들 바
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  '관심 지역 설정',
                  style: AppTextStyles.koBody(
                    18,
                    weight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
                
                // 좌우 독립 스크롤 구현을 위한 고정 높이 컨테이너 설정
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4, // 유연한 높이 제한 (최대 40%)
                  ),
                  child: Row(
                    children: [
                      // ➡️ 왼쪽: 시/도 리스트 스크롤 박스
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.onSurface.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: sidos.length,
                            itemBuilder: (context, index) {
                              final sido = sidos[index];
                              final isCurrentSido = (tempSelectedSido == sido);

                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                title: Text(
                                  sido,
                                  style: AppTextStyles.koBody(
                                    14,
                                    weight: isCurrentSido ? FontWeight.w700 : FontWeight.w500,
                                    color: isCurrentSido ? AppColors.primary : AppColors.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                                tileColor: isCurrentSido ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                onTap: () {
                                  // 바텀시트 내부의 상태만 업데이트하여 구 목록을 변경
                                  setBottomSheetState(() {
                                    tempSelectedSido = sido;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // ➡️ 오른쪽: 시/군/구 리스트 스크롤 박스
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.onSurface.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: guguns.length,
                            itemBuilder: (context, index) {
                              final gugun = guguns[index];
                              final fullPathName = "$tempSelectedSido $gugun";
                              final isCurrentGugun = (_selectedRegion == fullPathName);

                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                title: Text(
                                  gugun,
                                  style: AppTextStyles.koBody(
                                    14,
                                    weight: isCurrentGugun ? FontWeight.w700 : FontWeight.w500,
                                    color: isCurrentGugun ? AppColors.primary : AppColors.onSurface,
                                  ),
                                ),
                                trailing: isCurrentGugun 
                                    ? const Icon(Symbols.check, color: AppColors.primary, size: 18) 
                                    : null,
                                onTap: () {
                                  // 구까지 최종 선택 완료 시 부모 UI 상태(setState)를 업데이트하고 시트 이탈
                                  setState(() {
                                    _selectedRegion = fullPathName;
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

  // 🔄 [핵심 수정] 프로필 아바타 클릭 시 모든 설정(지역, 알림, 버전)이 포함되어 나오는 통합 바텀 시트
  void _showProfileEditSheet(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: _userName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // 내부 스위치 및 지역 텍스트 실시간 반영을 위해 StatefulBuilder 사용
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: GlassPanel(
                opacity: 0.9,
                blur: 25,
                borderRadius: 32,
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 상단 드래그 핸들러
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.onSurface.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Text(
                      '내 정보 및 설정',
                      style: AppTextStyles.koBody(
                        18,
                        weight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // 📸 프로필 이미지 영역
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryContainer.withValues(alpha: 0.3),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 2),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Symbols.person, color: AppColors.primary, size: 40),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('갤러리 접근 권한을 요청합니다. (더미)')),
                              );
                            },
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const Icon(Symbols.photo_camera, color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // 📝 닉네임 입력란
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '닉네임 / 이름',
                        style: AppTextStyles.koBody(13, weight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      style: AppTextStyles.koBody(15, color: AppColors.onSurface, weight: FontWeight.w500),
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        hintText: '이름을 입력해주세요',
                        hintStyle: AppTextStyles.koBody(15, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: AppColors.onSurface.withValues(alpha: 0.05),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.outline.withValues(alpha: 0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // 📍 관심 지역 설정 통합
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.onSurface.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            leading: const Icon(Symbols.location_on, color: AppColors.primary),
                            title: Text('나의 지역 설정', style: AppTextStyles.koBody(14, weight: FontWeight.w600, color: AppColors.onSurface)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_selectedRegion, style: AppTextStyles.koBody(13, color: AppColors.onSurfaceVariant)),
                                const SizedBox(width: 6),
                                const Icon(Symbols.arrow_forward_ios, size: 12, color: AppColors.onSurfaceVariant),
                              ],
                            ),
                            onTap: () {
                              // 지역 선택 창을 열고, 닫혔을 때 바텀시트 내부 텍스트와 부모 상태를 동시 갱신
                              _showRegionPickerSheet(context);
                              Future.delayed(const Duration(milliseconds: 300), () {
                                setModalState(() {});
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(height: 1, thickness: 1, color: AppColors.outline.withValues(alpha: 0.05)),
                          ),
                          // 🔔 알림 설정 통합
                          SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            secondary: const Icon(Symbols.notifications_active, color: AppColors.primary),
                            title: Text('실시간 푸시 알림', style: AppTextStyles.koBody(14, weight: FontWeight.w600, color: AppColors.onSurface)),
                            value: _isNotificationOn,
                            activeColor: AppColors.primary,
                            onChanged: (bool value) {
                              // 모달 내부 상태와 부모 위젯 상태를 동시에 동기화
                              setModalState(() {
                                _isNotificationOn = value;
                              });
                              setState(() {
                                _isNotificationOn = value;
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(height: 1, thickness: 1, color: AppColors.outline.withValues(alpha: 0.05)),
                          ),
                          // ℹ️ 앱 버전 정보 통합
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            leading: const Icon(Symbols.info, color: AppColors.onSurfaceVariant),
                            title: Text('현재 앱 버전', style: AppTextStyles.koBody(14, weight: FontWeight.w600, color: AppColors.onSurface)),
                            trailing: Text(
                              'v1.0.4',
                              style: AppTextStyles.koBody(13, weight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    
                    // 💾 변경사항 저장 버튼
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isNotEmpty) {
                          setState(() {
                            _userName = nameController.text.trim();
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        '변경사항 저장',
                        style: AppTextStyles.koBody(15, weight: FontWeight.w700, color: Colors.white),
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

  // 알림 바텀 시트 함수
  void _showNotificationsSheet(BuildContext context) {
    final List<_NotificationEntry> currentNotifications = List.from(_initialNotifications);

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
                height: MediaQuery.of(context).size.height * 0.75, 
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 56), 
                        Text(
                          '알림',
                          style: AppTextStyles.koBody(
                            18,
                            weight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
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
                                    : Colors.red.shade400, 
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
        leading: GestureDetector(
          onTap: () => _showProfileEditSheet(context),
          child: const _AvatarLeading(),
        ),
        trailing: IconButton(
          icon: const Icon(Symbols.notifications, color: AppColors.primary),
          onPressed: () => _showNotificationsSheet(context), 
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
                _MyRankingCard(name: _userName, tier: _userTier),
                const SizedBox(height: 16),
                
                _SubTabBar(
                  subViewMode: _subViewMode,
                  onSubViewModeChanged: _changeSubViewMode,
                ),
                const SizedBox(height: 16),
                
                _LeaderboardCard(
                  isNational: _subViewMode == 'national',
                  myName: _userName,
                  myTier: _userTier,
                ),
              ],
              // 🔴 불필요한 하단 설정 카드는 완벽히 제거되었습니다.
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
  const _MyRankingCard({
    required this.name,
    required this.tier,
  });

  final String name;
  final String tier;

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
                '$name 님의 순위',
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
                      tier,
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
  const _LeaderboardCard({
    required this.isNational,
    required this.myName,
    required this.myTier,
  });

  final bool isNational;
  final String myName;
  final String myTier;

  @override
  Widget build(BuildContext context) {
    final nationalRankings = [
      const _LeaderboardEntry(rank: 1, name: '김지우', tier: '그랜드 마스터', points: '50,420 P'),
      const _LeaderboardEntry(rank: 2, name: '이민재', tier: '그랜드 마스터', points: '50,400 P'),
      const _LeaderboardEntry(rank: 3, name: '박서연', tier: '그린 마스터', points: '50,280 P'),
      _LeaderboardEntry(rank: 331, name: myName, tier: myTier, points: '20,250 P', isMe: true),
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