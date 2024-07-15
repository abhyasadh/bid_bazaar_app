import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    Path path = Path()..addRRect(rRect);

    double dashPatternLength = dashWidth + dashSpace;
    double pathLength = path.computeMetrics().first.length;

    for (double i = 0; i < pathLength; i += dashPatternLength) {
      canvas.drawPath(
        extractPathSegment(path, i, dashWidth),
        paint,
      );
    }
  }

  Path extractPathSegment(Path path, double start, double length) {
    final pathMetrics = path.computeMetrics();
    final pathMetric = pathMetrics.first;

    return pathMetric.extractPath(start, start + length);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
