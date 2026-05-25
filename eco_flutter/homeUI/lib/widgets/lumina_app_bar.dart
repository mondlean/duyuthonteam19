import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// 글래스 상단 앱바. Lumina Nature 로고 + 우측 액션 슬롯.
class LuminaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LuminaAppBar({
    super.key,
    this.leading,
    this.trailing,
    this.title = 'Lumina Nature',
    this.showLogo = true,
  });

  final Widget? leading;
  final Widget? trailing;
  final String title;
  final bool showLogo;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            border: const Border(
              bottom: BorderSide(color: AppColors.glassBorder, width: 1),
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.glassShadow,
                blurRadius: 32,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                if (leading != null) leading!,
                if (showLogo) ...[
                  const Icon(
                    Symbols.energy_savings_leaf,
                    color: AppColors.primary,
                    size: 28,
                    weight: 500,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      title,
                      style: AppTextStyles.headlineLgMobile.copyWith(
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
