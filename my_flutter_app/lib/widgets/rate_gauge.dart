import 'package:flutter/material.dart';
import 'dart:math' as math;

class RateGauge extends StatelessWidget {
  final double currentRate;
  final double targetMin;
  final double targetMax;

  const RateGauge({
    super.key,
    required this.currentRate,
    required this.targetMin,
    required this.targetMax,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Compression Rate',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: RateGaugePainter(
                currentRate: currentRate,
                targetMin: targetMin,
                targetMax: targetMax,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${currentRate.toInt()} BPM',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            _getRateStatus(),
            style: TextStyle(
              fontSize: 14,
              color: _getRateColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getRateStatus() {
    if (currentRate < targetMin) return 'Too Slow';
    if (currentRate > targetMax) return 'Too Fast';
    return 'Good Pace';
  }

  Color _getRateColor() {
    if (currentRate >= targetMin && currentRate <= targetMax) {
      return Colors.green.shade600;
    }
    return Colors.orange.shade600;
  }
}

class RateGaugePainter extends CustomPainter {
  final double currentRate;
  final double targetMin;
  final double targetMax;

  RateGaugePainter({
    required this.currentRate,
    required this.targetMin,
    required this.targetMax,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5,
      false,
      backgroundPaint,
    );

    // Draw target range arc
    final targetPaint = Paint()
      ..color = Colors.green.shade300
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final targetStartAngle = -math.pi * 0.75 + (targetMin / 200) * math.pi * 1.5;
    final targetSweepAngle = ((targetMax - targetMin) / 200) * math.pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      targetStartAngle,
      targetSweepAngle,
      false,
      targetPaint,
    );

    // Draw current rate indicator
    if (currentRate > 0) {
      final currentAngle = -math.pi * 0.75 + (currentRate / 200) * math.pi * 1.5;
      final indicatorPaint = Paint()
        ..color = currentRate >= targetMin && currentRate <= targetMax
            ? Colors.green.shade600
            : Colors.orange.shade600
        ..strokeWidth = 4;

      final startPoint = Offset(
        center.dx + (radius - 15) * math.cos(currentAngle),
        center.dy + (radius - 15) * math.sin(currentAngle),
      );
      final endPoint = Offset(
        center.dx + radius * math.cos(currentAngle),
        center.dy + radius * math.sin(currentAngle),
      );

      canvas.drawLine(startPoint, endPoint, indicatorPaint);
    }
  }

  @override
  bool shouldRepaint(RateGaugePainter oldDelegate) {
    return currentRate != oldDelegate.currentRate;
  }
} 