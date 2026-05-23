# 두유톤 19팀 - Lumina Nature

친환경 소비 앱의 Flutter 구현. Stitch 디자인 시스템 **Lumina Nature**(Glassmorphism + 자작나무 배경)를 기반으로 6개 핵심 화면을 구현했습니다.

## 구현된 화면

| 라우트 | 화면 | 설명 |
| --- | --- | --- |
| `/` | Onboarding | 로우폴리 꽃 + "성장을 시작하세요" |
| `/login` | Login | Lumina Nature 로그인 |
| `/signup` | Signup | 이름, 지역, ID, 비밀번호 (한글) |
| `/home` | Home | 친환경 소비 점수, 성장 로드맵, 두유 화분, 75% 성장도 |
| `/scan` | Receipt Scan | 영수증 카메라 스캔 (애니메이션 스캔 라인) |
| `/rewards` | Rewards | 총 포인트, 주간 임팩트 차트, 최근 활동 내역 |

## 디자인 시스템

- **컬러**: Primary `#006C4F`, Primary Container `#00C896` (Mint Green)
- **타이포**: Plus Jakarta Sans (라틴) + Noto Sans KR (한글) — `google_fonts`
- **글래스**: 흰색 40% + `BackdropFilter` blur 24px + 1px 화이트 보더
- **배경**: `CustomPaint`로 그린 자작나무 패턴 + 컬러 글로우 블롭
- **꽃 일러스트**: 원본 자산이 없어 `CustomPainter`로 로우폴리 꽃 + 글래스 화분 직접 묘사

## 실행

```bash
cd homeUI
flutter pub get
flutter run            # 디바이스/에뮬레이터로 실행
flutter run -d chrome  # 웹 브라우저로 실행
```

## 검증

```bash
flutter analyze    # → No issues found!
flutter test       # → All tests passed!
flutter build web  # → √ Built build\web
```

## 폴더 구조

```
lib/
├── main.dart                  # DuyuApp + MaterialApp.router
├── router/app_router.dart     # go_router (6 routes)
├── theme/
│   ├── app_colors.dart        # Lumina Nature 팔레트
│   ├── app_text_styles.dart   # Plus Jakarta Sans + Noto Sans KR
│   └── app_theme.dart         # Material 3 ThemeData
├── widgets/
│   ├── birch_background.dart  # 자작나무 배경 + 글로우 블롭
│   ├── glass_panel.dart       # GlassPanel + DarkGlassButton
│   ├── lumina_app_bar.dart    # 상단 글래스 앱바
│   └── duyu_flower.dart       # 로우폴리 꽃 (CustomPainter)
└── screens/
    ├── onboarding_screen.dart
    ├── login_screen.dart
    ├── signup_screen.dart
    ├── home_screen.dart
    ├── receipt_scan_screen.dart
    └── rewards_screen.dart
```

## 출처

- Stitch 프로젝트: `duyuthon` (`projects/15295183140283495300`)
- 디자인 시스템: Lumina Nature (`assets/56af8f4bc5f04051a2bbc70beb6db722`)
- 메인 화면 변형: **로우폴리 꽃 버전** (`screens/91eb275642ae41d898ea58bb657346cb`)

## TODO

- [ ] Stitch 원본 자작나무 배경 이미지 / 로우폴리 꽃 PNG를 `assets/images/`에 추가하면 `BirchBackground`와 `DuyuFlower`를 이미지 기반으로 교체 가능
- [ ] iOS 빌드: `flutter create --platforms=ios .` 로 플랫폼 추가
- [ ] 상태 관리: 현재 라우터는 stateless 네비게이션 — 실제 영수증 인증/포인트 적립 로직 연결 필요
