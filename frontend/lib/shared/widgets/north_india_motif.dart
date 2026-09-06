import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class NortheastMotif extends StatelessWidget {
  const NortheastMotif({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MotifPainter(),
      child: child,
    );
  }
}

class _MotifPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()
      ..color = AppColors.rose.withValues(alpha: 0.72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final dot = Paint()..color = AppColors.peacock.withValues(alpha: 0.55);

    final top = Path()
      ..moveTo(0, 18)
      ..lineTo(size.width, 18);
    canvas.drawPath(top, border);
    for (var x = 12.0; x < size.width; x += 28) {
      final diamond = Path()
        ..moveTo(x, 8)
        ..lineTo(x + 8, 18)
        ..lineTo(x, 28)
        ..lineTo(x - 8, 18)
        ..close();
      canvas.drawPath(diamond, border);
    }

    final hill = Paint()
      ..color = AppColors.peacock.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final hills = Path()
      ..moveTo(0, size.height - 28)
      ..quadraticBezierTo(size.width * 0.22, size.height - 66, size.width * 0.44, size.height - 30)
      ..quadraticBezierTo(size.width * 0.68, size.height - 74, size.width, size.height - 28)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hills, hill);

    for (var x = 16.0; x < size.width; x += 34) {
      canvas.drawCircle(Offset(x, size.height - 16), 3, dot);
    }
  }

  @override
  bool shouldRepaint(_MotifPainter oldDelegate) => false;
}