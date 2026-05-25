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

class ReceiptResultScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  const ReceiptResultScreen({super.key, this.data});

  @override
  State<ReceiptResultScreen> createState() => _ReceiptResultScreenState();
}

class _ReceiptResultScreenState extends State<ReceiptResultScreen> {
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 자동으로 친환경 품목 포인트 적립 시도
    _saveEcoPoints();
  }

  Future<void> _saveEcoPoints() async {
    if (widget.data == null) return;
    
    final List items = widget.data!['items'] ?? [];
    setState(() => _isSaving = true);

    try {
      for (var item in items) {
        if (item['eco'] == true) {
          await http.post(
            Uri.parse('${Globals.springBaseUrl}/point/earn'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'loginId': Globals.loginId ?? 'testUser',
              'item': item['name'],
              'count': 1,
            }),
          );
        }
      }
    } catch (e) {
      debugPrint('포인트 적립 중 오류: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List items = widget.data?['items'] ?? [];
    final int totalPoints = widget.data?['total_point'] ?? 0;
    final int totalPrice = widget.data?['total_price'] ?? 0;

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
                      onTap: () => context.go('/home'),
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
                    if (_isSaving)
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
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
                                    totalPoints > 0 
                                      ? '친환경 소비로 $totalPoints포인트 획득!'
                                      : '아쉽게도 친환경 품목이 없네요',
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
                            if (items.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 32),
                                child: Text(
                                  '품목을 찾을 수 없습니다.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.koBody(14, color: AppColors.onSurfaceVariant),
                                ),
                              )
                            else
                              ...List.generate(items.length, (i) {
                                final item = items[i];
                                final bool isEco = item['eco'] ?? false;
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
                                            color: (isEco ? AppColors.primaryContainer : AppColors.outline)
                                                .withValues(alpha: 0.12),
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            isEco ? Symbols.eco : Symbols.shopping_bag,
                                            size: 18,
                                            color: isEco ? AppColors.primary : AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['name'] ?? '알 수 없는 품목',
                                                style: AppTextStyles.koBody(
                                                  14,
                                                  weight: FontWeight.w600,
                                                  color: AppColors.onSurface,
                                                ),
                                              ),
                                              Text(
                                                item['category'] ?? '기타',
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
                                              '₩${(item['price'] ?? 0).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                              style: AppTextStyles.koBody(
                                                13,
                                                weight: FontWeight.w600,
                                                color: AppColors.onSurface,
                                              ),
                                            ),
                                            if (isEco)
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryContainer
                                                      .withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  '+${item['point'] ?? 0}P',
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
                                  '₩${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
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
