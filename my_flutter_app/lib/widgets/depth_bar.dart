import 'package:flutter/material.dart';

class DepthBar extends StatelessWidget {
  final double currentDepth;
  final double targetMin;
  final double targetMax;

  const DepthBar({
    super.key,
    required this.currentDepth,
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
            'Compression Depth',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 60,
            height: 200,
            child: CustomPaint(
              painter: DepthBarPainter(
                currentDepth: currentDepth,
                targetMin: targetMin,
                targetMax: targetMax,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${currentDepth.toStringAsFixed(1)} cm',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            _getDepthStatus(),
            style: TextStyle(
              fontSize: 14,
              color: _getDepthColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getDepthStatus() {
    if (currentDepth < targetMin) return 'Too Shallow';
    if (currentDepth > targetMax) return 'Too Deep';
    return 'Good Depth';
  }

  Color _getDepthColor() {
    if (currentDepth >= targetMin && currentDepth <= targetMax) {
      return Colors.green.shade600;
    }
    return Colors.orange.shade600;
  }
}

class DepthBarPainter extends CustomPainter {
  final double currentDepth;
  final double targetMin;
  final double targetMax;

  DepthBarPainter({
    required this.currentDepth,
    required this.targetMin,
    required this.targetMax,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxDepth = 10.0; // Maximum depth scale (10 cm)
    
    // Draw background bar
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(15, 0, 30, size.height),
        const Radius.circular(15),
      ),
      backgroundPaint,
    );

    // Draw target range
    final targetStartY = size.height - (targetMin / maxDepth) * size.height;
    final targetEndY = size.height - (targetMax / maxDepth) * size.height;
    
    final targetPaint = Paint()
      ..color = Colors.green.shade300
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(15, targetEndY, 30, targetStartY - targetEndY),
        const Radius.circular(15),
      ),
      targetPaint,
    );

    // Draw current depth
    if (currentDepth > 0) {
      final currentY = size.height - (currentDepth / maxDepth) * size.height;
      final currentPaint = Paint()
        ..color = currentDepth >= targetMin && currentDepth <= targetMax
            ? Colors.green.shade600
            : Colors.orange.shade600
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(15, currentY, 30, size.height - currentY),
          const Radius.circular(15),
        ),
        currentPaint,
      );
    }

    // Draw depth markers
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= 10; i += 2) {
      final y = size.height - (i / maxDepth) * size.height;
      
      // Draw tick mark
      final tickPaint = Paint()
        ..color = Colors.black54
        ..strokeWidth = 1;
      
      canvas.drawLine(
        Offset(10, y),
        Offset(50, y),
        tickPaint,
      );

      // Draw label
      textPainter.text = TextSpan(
        text: '${i}cm',
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(52, y - 6));
    }
  }

  @override
  bool shouldRepaint(DepthBarPainter oldDelegate) {
    return currentDepth != oldDelegate.currentDepth;
  }
} 