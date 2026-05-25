import 'dart:convert';
import 'package:http/http.dart' as http;
import '../globals.dart';
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

  static const _cities = ['서울특별시', '부산광역시', '대구광역시', '인천광역시', '광주광역시', '대전광역시'];
  static const _districts = ['중구', '동구', '서구', '남구', '북구'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
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
                    Text(
                      '회원가입',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.koBody(
                        26,
                        weight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '친환경 커뮤니티에 가입하고 함께 변화를 만들어가요.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.koBody(
                        14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _Field(
                      label: '이름',
                      child: TextField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(hintText: '이름을 입력하세요'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _Field(
                      label: '지역 정보',
                      child: Row(
                        children: [
                          Expanded(
                            child: _GlassDropdown(
                              value: _city,
                              hint: '시/도 선택',
                              items: _cities,
                              onChanged: (v) => setState(() => _city = v),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _GlassDropdown(
                              value: _district,
                              hint: '시/군/구 선택',
                              items: _districts,
                              onChanged: (v) => setState(() => _district = v),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _Field(
                      label: '루미나 ID',
                      child: TextField(
                        controller: _idCtrl,
                        decoration: const InputDecoration(hintText: '아이디 입력'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _Field(
                      label: '비밀번호',
                      child: TextField(
                        controller: _pwCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: '비밀번호 입력',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Symbols.visibility
                                  : Symbols.visibility_off,
                              color: AppColors.outline,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: () async {
                        try {
                          final response = await http.post(
                            Uri.parse('${Globals.loginBaseUrl}/users'),
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({
                              'loginId': _idCtrl.text,
                              'password': _pwCtrl.text,
                              'name': _nameCtrl.text,
                              'area': _district ?? '',
                              'city': _city ?? '',
                            }),
                          );
                          if (response.statusCode == 200) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('회원가입이 완료되었습니다!')),
                              );
                              context.go('/login');
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('회원가입 실패: ${response.body}')),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('오류 발생: $e')),
                            );
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('가입하기',
                              style: AppTextStyles.koBody(
                                18,
                                weight: FontWeight.w700,
                                color: AppColors.onPrimaryContainer,
                              )),
                          const SizedBox(width: 6),
                          const Icon(Symbols.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.koBody(
                            13,
                            color: AppColors.onSurfaceVariant,
                          ),
                          children: [
                            const TextSpan(text: '이미 계정이 있으신가요? '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => context.canPop() ? context.pop() : context.push('/login'),
                                child: Text(
                                  '로그인',
                                  style: AppTextStyles.koBody(
                                    13,
                                    weight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: AppTextStyles.koBody(
              12,
              weight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _GlassDropdown extends StatelessWidget {
  const _GlassDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: AppTextStyles.koBody(14, color: AppColors.outline),
          ),
          icon: const Icon(Symbols.expand_more, color: AppColors.onSurfaceVariant),
          items: items
              .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      c,
                      style: AppTextStyles.koBody(14, color: AppColors.onSurface),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
