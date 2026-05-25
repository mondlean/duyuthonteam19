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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _idCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: const LuminaAppBar(),
      body: BirchBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 96, 20, 48),
            children: [
              GlassPanel(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '돌아오신 걸 환영해요',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headlineLgMobile.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '자연과의 연결이 여기서 시작돼요.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _LabeledField(
                      label: '아이디',
                      controller: _idCtrl,
                      hint: '아이디를 입력하세요',
                      suffix: const Icon(
                        Symbols.person,
                        color: AppColors.outline,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _LabeledField(
                      label: '비밀번호',
                      controller: _pwCtrl,
                      hint: '••••••••',
                      obscure: _obscure,
                      trailingLabel: '비밀번호를 잊으셨나요?',
                      onTrailingTap: () {},
                      suffix: IconButton(
                        icon: Icon(
                          _obscure
                              ? Symbols.visibility
                              : Symbols.visibility_off,
                          color: AppColors.outline,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () async {
                        try {
                          final response = await http.post(
                            Uri.parse('${Globals.springBaseUrl}/users/login'),
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({
                              'loginId': _idCtrl.text,
                              'password': _pwCtrl.text,
                            }),
                          );
                          if (response.statusCode == 200) {
                            final body = response.body;
                            if (body.contains('성공')) {
                              Globals.loginId = _idCtrl.text;
                              
                              // 추가: 유저 정보를 조회하여 식물 선택 여부 확인
                              final userRes = await http.get(
                                Uri.parse('${Globals.springBaseUrl}/users/${Globals.loginId}'),
                              );
                              
                              if (userRes.statusCode == 200) {
                                final userData = jsonDecode(userRes.body);
                                final String plant = userData['plant'] ?? '새싹';
                                
                                if (context.mounted) {
                                  // 식물이 초기값 '새싹'이거나 비어있으면 선택 화면으로, 아니면 홈으로
                                  if (plant == '새싹' || plant.isEmpty) {
                                    context.go('/plant-selection');
                                  } else {
                                    context.go('/home');
                                  }
                                }
                              } else {
                                if (context.mounted) context.go('/home');
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(body)),
                                );
                              }
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('로그인 실패: ${response.statusCode}')),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('서버 연결 오류: $e')),
                            );
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('로그인', style: AppTextStyles.titleMd),
                          const SizedBox(width: 6),
                          const Icon(Symbols.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                          children: [
                            const TextSpan(text: '계정이 없으신가요? '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => context.push('/signup'),
                                child: Text(
                                  '회원가입',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
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

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.suffix,
    this.trailingLabel,
    this.onTrailingTap,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Widget? suffix;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                label,
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            if (trailingLabel != null)
              GestureDetector(
                onTap: onTrailingTap,
                child: Text(
                  trailingLabel!,
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
