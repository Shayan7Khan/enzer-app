import 'package:flutter/material.dart';

class RankMarkClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 6.0;
    final path = Path();
    path.moveTo(radius, 0);
    path.quadraticBezierTo(0, 0, 0, radius);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height - size.width * 0.20);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, radius);
    path.quadraticBezierTo(size.width, 0, size.width - radius, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
