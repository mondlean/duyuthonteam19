import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Lumina Nature 타이포그래피.
/// Plus Jakarta Sans 라틴, 한글 노트는 Noto Sans KR로 fallback.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base(
    double size, {
    FontWeight weight = FontWeight.w400,
    double? height,
    double? letterSpacing,
    Color color = AppColors.onSurface,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      height: height == null ? null : height / size,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static TextStyle displayLg = _base(
    40,
    weight: FontWeight.w700,
    height: 48,
    letterSpacing: -0.8,
  );

  static TextStyle headlineLg = _base(
    32,
    weight: FontWeight.w700,
    height: 40,
    letterSpacing: -0.32,
  );

  static TextStyle headlineLgMobile = _base(
    28,
    weight: FontWeight.w700,
    height: 36,
  );

  static TextStyle titleMd = _base(
    20,
    weight: FontWeight.w600,
    height: 28,
  );

  static TextStyle bodyLg = _base(
    16,
    height: 24,
  );

  static TextStyle bodySm = _base(
    14,
    height: 20,
  );

  static TextStyle labelMd = _base(
    12,
    weight: FontWeight.w600,
    height: 16,
    letterSpacing: 0.6,
  );

  /// 한글 본문용 fallback - Noto Sans KR.
  static TextStyle koBody(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.onSurface,
    double? height,
  }) {
    return GoogleFonts.notoSansKr(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height == null ? null : height / size,
    );
  }
}
