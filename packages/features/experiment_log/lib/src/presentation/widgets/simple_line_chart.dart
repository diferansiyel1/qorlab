import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class ChartPoint {
  final double x;
  final double y;

  const ChartPoint(this.x, this.y);
}

class SimpleLineChart extends StatelessWidget {
  final List<ChartPoint> points;
  final Color? lineColor;
  final Color? dotColor;

  const SimpleLineChart({
    super.key,
    required this.points,
    this.lineColor,
    this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLineColor = lineColor ?? AppColors.primary;
    final effectiveDotColor = dotColor ?? effectiveLineColor;
    return CustomPaint(
      painter: _LineChartPainter(
        points: points,
        lineColor: effectiveLineColor,
        dotColor: effectiveDotColor,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<ChartPoint> points;
  final Color lineColor;
  final Color dotColor;

  _LineChartPainter({
    required this.points,
    required this.lineColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const padding = EdgeInsets.fromLTRB(12, 12, 12, 18);
    final plotRect = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.left - padding.right,
      size.height - padding.top - padding.bottom,
    );
    if (plotRect.width <= 0 || plotRect.height <= 0) return;

    final xs = points.map((p) => p.x);
    final ys = points.map((p) => p.y);

    double minX = xs.reduce(math.min);
    double maxX = xs.reduce(math.max);
    double minY = ys.reduce(math.min);
    double maxY = ys.reduce(math.max);

    if (minX == maxX) {
      minX -= 1;
      maxX += 1;
    }
    if (minY == maxY) {
      minY -= 1;
      maxY += 1;
    }

    final gridPaint = Paint()
      ..color = AppColors.glassBorder.withAlpha(120)
      ..strokeWidth = 1;

    const gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final t = i / gridLines;
      final y = plotRect.top + plotRect.height * t;
      canvas.drawLine(
        Offset(plotRect.left, y),
        Offset(plotRect.right, y),
        gridPaint,
      );
    }

    Offset mapPoint(ChartPoint p) {
      final xN = (p.x - minX) / (maxX - minX);
      final yN = (p.y - minY) / (maxY - minY);
      return Offset(
        plotRect.left + plotRect.width * xN,
        plotRect.bottom - plotRect.height * yN,
      );
    }

    final sorted = [...points]..sort((a, b) => a.x.compareTo(b.x));
    final path = Path();
    for (int i = 0; i < sorted.length; i++) {
      final o = mapPoint(sorted[i]);
      if (i == 0) {
        path.moveTo(o.dx, o.dy);
      } else {
        path.lineTo(o.dx, o.dy);
      }
    }

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;
    final dotOutline = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final p in sorted) {
      final o = mapPoint(p);
      canvas.drawCircle(o, 4.5, dotPaint);
      canvas.drawCircle(o, 4.5, dotOutline);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.dotColor != dotColor;
  }
}
