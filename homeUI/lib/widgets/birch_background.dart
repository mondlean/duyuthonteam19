import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// 배경 이미지 + 컬러 글로우.
class BirchBackground extends StatelessWidget {
  const BirchBackground({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/test_backgroundimg.png',
          fit: BoxFit.cover,
        ),
        // 부드러운 컬러 글로우.
        Positioned(
          top: -120,
          right: -100,
          child: _Blob(
            color: AppColors.primaryContainer.withValues(alpha: 0.18),
            size: 360,
          ),
        ),
        Positioned(
          bottom: -160,
          left: -120,
          child: _Blob(
            color: AppColors.secondaryContainer.withValues(alpha: 0.22),
            size: 420,
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 120, spreadRadius: 40),
          ],
        ),
      ),
    );
  }
}
