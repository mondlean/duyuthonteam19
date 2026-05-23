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
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headlineLgMobile.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Reconnecting with nature begins here.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _LabeledField(
                      label: 'ID',
                      controller: _idCtrl,
                      hint: 'Enter your ID',
                      suffix: const Icon(
                        Symbols.person,
                        color: AppColors.outline,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _LabeledField(
                      label: 'PASSWORD',
                      controller: _pwCtrl,
                      hint: '••••••••',
                      obscure: _obscure,
                      trailingLabel: 'Forgot Password?',
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
                      onPressed: () => context.go('/home'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Log In', style: AppTextStyles.titleMd),
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
                            const TextSpan(text: "Don't have an account? "),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => context.push('/signup'),
                                child: Text(
                                  'Sign up',
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
