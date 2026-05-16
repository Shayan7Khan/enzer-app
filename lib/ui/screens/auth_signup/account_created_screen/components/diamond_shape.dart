import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/components/diamond_painter.dart';
import 'package:flutter/material.dart';

class DiamondShape extends StatelessWidget {
  final double size;
  final Color color;
  final bool filled;

  const DiamondShape({
    super.key,
    required this.size,
    required this.color,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: DiamondPainter(color: color, filled: filled),
    );
  }
}
