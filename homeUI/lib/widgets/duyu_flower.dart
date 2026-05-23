import 'package:flutter/material.dart';

/// 두유톤 19팀 마스코트 꽃 이미지.
class DuyuFlower extends StatelessWidget {
  const DuyuFlower({
    super.key,
    this.size = 240,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/test.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
