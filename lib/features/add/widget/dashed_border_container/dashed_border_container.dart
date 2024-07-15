import 'package:flutter/material.dart';

import 'dashed_border_painter.dart';

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double borderWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  const DashedBorderContainer({
    super.key,
    required this.child,
    this.borderColor = Colors.black,
    this.borderWidth = 2.0,
    this.dashWidth = 5.0,
    this.dashSpace = 5.0,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 3 - 20,
        height: (MediaQuery.of(context).size.width / 3 - 20) * 3 / 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: CustomPaint(
          painter: DashedBorderPainter(
            color: borderColor,
            strokeWidth: borderWidth,
            dashWidth: dashWidth,
            dashSpace: dashSpace,
            borderRadius: borderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
