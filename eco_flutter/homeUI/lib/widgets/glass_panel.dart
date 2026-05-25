import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// 글래스모피즘 컨테이너.
/// 흰색 40% 반투명 + backdrop blur 24px + 1px 화이트 외곽선.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 24,
    this.opacity = 0.4,
    this.blur = 24,
    this.borderOpacity = 0.2,
    this.shadow = true,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double opacity;
  final double blur;
  final double borderOpacity;
  final bool shadow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final panel = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            borderRadius: radius,
            border: Border.all(
              color: Colors.white.withValues(alpha: borderOpacity),
              width: 1,
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );

    final withShadow = shadow
        ? DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              boxShadow: const [
                BoxShadow(
                  color: AppColors.glassShadow,
                  blurRadius: 32,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: panel,
          )
        : panel;

    if (onTap == null) return withShadow;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: withShadow,
      ),
    );
  }
}

/// 다크 글래스 (액션 풋터의 메인 CTA).
class DarkGlassButton extends StatelessWidget {
  const DarkGlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 64,
    this.borderRadius = 24,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.darkGlass,
              borderRadius: radius,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: radius,
                onTap: onPressed,
                child: Center(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
