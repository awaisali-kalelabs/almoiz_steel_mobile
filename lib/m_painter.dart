import 'package:flutter/material.dart';

class MPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path();
    // Draw a thick rounded "M" shape
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.15, 0);
    path.quadraticBezierTo(size.width * 0.2, -10, size.width * 0.25, 0);
    path.lineTo(size.width * 0.5, size.height * 0.6);
    path.lineTo(size.width * 0.75, 0);
    path.quadraticBezierTo(size.width * 0.8, -10, size.width * 0.85, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
