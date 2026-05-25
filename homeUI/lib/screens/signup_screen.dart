import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/birch_background.dart';
import '../widgets/glass_panel.dart';
import '../widgets/lumina_app_bar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  String? _city;
  String? _district;
  bool _obscure = true;

  static const Map<String, List<String>> _regionData = {
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  void _showRegionPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final availableDistricts = _city != null ? (_regionData[_city] ?? []) : <String>[];
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('지역 선택', style: AppTextStyles.koBody(18, weight: FontWeight.w700)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView(
                          children: _regionData.keys.map((c) => ListTile(
                            title: Text(c, style: AppTextStyles.koBody(14)),
                            selected: _city == c,
                            onTap: () => setModalState(() { setState(() => _city = c); _district = null; }),
                          )).toList(),
                        ),
                      ),
                      const VerticalDivider(),
                      Expanded(
                        child: ListView(
                          children: availableDistricts.map((d) => ListTile(
                            title: Text(d, style: AppTextStyles.koBody(14)),
                            selected: _district == d,
                            onTap: () { setState(() => _district = d); Navigator.pop(context); },
                          )).toList(),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: LuminaAppBar(
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop() ? context.pop() : context.go('/login'),
        ),
      ),
      body: BirchBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 96, 20, 48),
            children: [
              GlassPanel(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('회원가입', textAlign: TextAlign.center, style: AppTextStyles.koBody(26, weight: FontWeight.w700, color: AppColors.onSurface)),
                    const SizedBox(height: 6),
                    Text('친환경 커뮤니티에 가입하고 함께 변화를 만들어가요.', textAlign: TextAlign.center, style: AppTextStyles.koBody(14, color: AppColors.onSurfaceVariant)),
                    const SizedBox(height: 28),
                    _Field(label: '이름', child: TextField(controller: _nameCtrl, decoration: const InputDecoration(hintText: '이름을 입력하세요'))),
                    const SizedBox(height: 16),
                    _Field(
                      label: '지역 정보',
                      child: _RegionSelectionField(
                        city: _city,
                        district: _district,
                        onTap: () => _showRegionPickerSheet(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _Field(label: '초록수증 ID', child: TextField(controller: _idCtrl, decoration: const InputDecoration(hintText: '아이디 입력'))),
                    const SizedBox(height: 16),
                    _Field(
                      label: '비밀번호',
                      child: TextField(
                        controller: _pwCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: '비밀번호 입력',
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Symbols.visibility : Symbols.visibility_off, color: AppColors.outline),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
 featnew
                      onPressed: () => context.go('/home'),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('가입하기', style: AppTextStyles.koBody(18, weight: FontWeight.w700, color: AppColors.onPrimaryContainer)),
                        const SizedBox(width: 6),
                        const Icon(Symbols.arrow_forward, size: 20),
                      ]),

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(padding: const EdgeInsets.only(left: 4, bottom: 6), child: Text(label, style: AppTextStyles.koBody(12, weight: FontWeight.w600, color: AppColors.onSurfaceVariant))),
      child,
    ]);
  }
}

class _RegionSelectionField extends StatelessWidget {
  final String? city;
  final String? district;
  final VoidCallback onTap;
  const _RegionSelectionField({this.city, this.district, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          border: Border.all(color: AppColors.glassBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(Symbols.place, size: 20, color: city == null ? AppColors.outline : AppColors.primary),
          const SizedBox(width: 10),
          Text((city == null) ? '시/도 및 시/군/구 선택' : '$city $district', style: AppTextStyles.koBody(14, color: city == null ? AppColors.outline : AppColors.onSurface)),
        ]),
      ),
    );
  }
}