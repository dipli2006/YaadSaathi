import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class NorthIndiaMotif extends StatelessWidget {
  const NorthIndiaMotif({super.key, required this.child});

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
      ..color = AppColors.marigold.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final dot = Paint()..color = AppColors.rose.withValues(alpha: 0.55);

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

    for (var x = 16.0; x < size.width; x += 34) {
      canvas.drawCircle(Offset(x, size.height - 16), 3, dot);
    }
  }

  @override
  bool shouldRepaint(_MotifPainter oldDelegate) => false;
}