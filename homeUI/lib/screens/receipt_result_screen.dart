import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/birch_background.dart';
import '../widgets/glass_panel.dart';

class ReceiptResultScreen extends StatelessWidget {
  const ReceiptResultScreen({super.key});

  static const _items = [
    _ReceiptItem('유기농 사과 주스', '에코 인증 음료', 3500, 15),
    _ReceiptItem('무라벨 생수 6입', '플라스틱 절감 제품', 2900, 12),
    _ReceiptItem('대나무 칫솔 2입', '생분해 가능 제품', 4800, 15),
    _ReceiptItem('에코백 사용', '일회용 봉투 대체', 3300, 8),
  ];

  @override
  Widget build(BuildContext context) {
    final totalPoints = _items.fold(0, (sum, i) => sum + i.points);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BirchBackground(
        child: SafeArea(
          child: Column(
            children: [
              // 앱바 영역
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    GlassPanel(
                      onTap: () => context.canPop() ? context.pop() : context.go('/home'),
                      padding: const EdgeInsets.all(10),
                      borderRadius: 999,
                      shadow: false,
                      child: const Icon(
                        Symbols.close,
                        color: AppColors.onSurfaceVariant,
                        size: 22,
                      ),
                    ),
                    const Spacer(),
                    GlassPanel(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      borderRadius: 999,
                      shadow: false,
                      child: Row(
                        children: [
                          const Icon(
                            Symbols.check_circle,
                            color: AppColors.primaryContainer,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '분석 완료',
                            style: AppTextStyles.koBody(
                              12,
                              weight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 스크롤 영역
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 헤더 카드
                      GlassPanel(
                        borderRadius: 28,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryContainer.withValues(alpha: 0.2),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Symbols.receipt_long,
                                color: AppColors.primaryContainer,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              '영수증 분석 완료',
                              style: AppTextStyles.koBody(
                                22,
                                weight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '자연을 생각하는 당신의 소비 내역입니다',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.koBody(
                                13,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 에코 임팩트 배지
                      GlassPanel(
                        borderRadius: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primaryContainer,
                                    AppColors.primary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryContainer.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Symbols.eco, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '에코 임팩트',
                                    style: AppTextStyles.koBody(
                                      11,
                                      weight: FontWeight.w600,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    '친환경 소비로 $totalPoints포인트 획득!',
                                    style: AppTextStyles.koBody(
                                      15,
                                      weight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '+${totalPoints}P',
                              style: AppTextStyles.koBody(
                                20,
                                weight: FontWeight.w800,
                                color: AppColors.primaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 항목 목록
                      GlassPanel(
                        borderRadius: 28,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '구매 내역',
                              style: AppTextStyles.koBody(
                                15,
                                weight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...List.generate(_items.length, (i) {
                              final item = _items[i];
                              return Column(
                                children: [
                                  if (i > 0)
                                    Divider(
                                      height: 24,
                                      thickness: 1,
                                      color: AppColors.outline.withValues(alpha: 0.1),
                                    ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryContainer
                                              .withValues(alpha: 0.12),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Symbols.eco,
                                          size: 18,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: AppTextStyles.koBody(
                                                14,
                                                weight: FontWeight.w600,
                                                color: AppColors.onSurface,
                                              ),
                                            ),
                                            Text(
                                              item.tag,
                                              style: AppTextStyles.koBody(
                                                11,
                                                color: AppColors.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '₩${item.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                            style: AppTextStyles.koBody(
                                              13,
                                              weight: FontWeight.w600,
                                              color: AppColors.onSurface,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryContainer
                                                  .withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '+${item.points}P',
                                              style: AppTextStyles.koBody(
                                                10,
                                                weight: FontWeight.w700,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                            const SizedBox(height: 16),
                            Container(
                              height: 1,
                              color: AppColors.outline.withValues(alpha: 0.15),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '총 결제액',
                                  style: AppTextStyles.koBody(
                                    14,
                                    weight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                Text(
                                  '₩${_items.fold(0, (s, i) => s + i.price).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                  style: AppTextStyles.koBody(
                                    16,
                                    weight: FontWeight.w800,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 홈으로 버튼
                      GlassPanel(
                        onTap: () => context.go('/home'),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        borderRadius: 24,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Symbols.home,
                              color: AppColors.primary,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '홈으로 돌아가기',
                              style: AppTextStyles.koBody(
                                16,
                                weight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptItem {
  const _ReceiptItem(this.name, this.tag, this.price, this.points);
  final String name;
  final String tag;
  final int price;
  final int points;
}
