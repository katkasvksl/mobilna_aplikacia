import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class RiskIndicatorCircle extends StatelessWidget {
  final String label;
  final String value;
  final String level; // 'low' | 'medium' | 'high'
  final double size;

  const RiskIndicatorCircle({
    super.key,
    required this.label,
    required this.value,
    required this.level,
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.riskColor(level);
    final progress = level == 'low'
        ? 0.3
        : level == 'medium'
            ? 0.6
            : 0.9;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CircleProgressPainter(
              progress: progress,
              color: color,
              backgroundColor: color.withValues(alpha: 0.15),
            ),
            child: Center(
              child: Icon(
                level == 'low'
                    ? Icons.check_circle_outline
                    : level == 'medium'
                        ? Icons.warning_amber_rounded
                        : Icons.error_outline,
                color: color,
                size: size * 0.4,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _CircleProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 5.0;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

