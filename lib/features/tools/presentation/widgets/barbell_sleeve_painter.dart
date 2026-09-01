import 'package:flutter/material.dart';
import '../../domain/models/tool_models.dart';

class BarbellSleevePainter extends CustomPainter {
  final List<PlateCount> plates;
  final double barWeight;
  final bool isDark;

  const BarbellSleevePainter({
    required this.plates,
    required this.barWeight,
    required this.isDark,
  });

  Color _getPlateColor(double weight) {
    // Standard Olympic plate colors
    if (weight >= 25) return const Color(0xFFDC2626); // Red
    if (weight >= 20) return const Color(0xFF2563EB); // Blue
    if (weight >= 15) return const Color(0xFFEAB308); // Yellow
    if (weight >= 10) return const Color(0xFF16A34A); // Green
    if (weight >= 5) return const Color(0xFFF1F5F9); // White
    if (weight >= 2.5) return const Color(0xFF1E293B); // Black
    if (weight >= 1.25) return const Color(0xFF94A3B8); // Silver
    return const Color(0xFF64748B);
  }

  double _getPlateHeight(double weight, double maxHeight) {
    if (weight >= 25) return maxHeight * 0.95;
    if (weight >= 20) return maxHeight * 0.92;
    if (weight >= 15) return maxHeight * 0.80;
    if (weight >= 10) return maxHeight * 0.70;
    if (weight >= 5) return maxHeight * 0.55;
    if (weight >= 2.5) return maxHeight * 0.45;
    return maxHeight * 0.35;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final shaftPaint = Paint()
      ..color = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)
      ..style = PaintingStyle.fill;

    final collarPaint = Paint()
      ..color = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)
      ..style = PaintingStyle.fill;

    // 1. Draw Barbell Shaft (left side leading to sleeve)
    const shaftHeight = 12.0;
    final shaftRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, centerY - (shaftHeight / 2), size.width * 0.20, shaftHeight),
      const Radius.circular(2),
    );
    canvas.drawRRect(shaftRect, shaftPaint);

    // 2. Draw Inside Collar / Flange
    const collarHeight = 54.0;
    const collarWidth = 14.0;
    final collarX = size.width * 0.20;
    final collarRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(collarX, centerY - (collarHeight / 2), collarWidth, collarHeight),
      const Radius.circular(3),
    );
    canvas.drawRRect(collarRect, collarPaint);

    // 3. Draw Sleeve (the horizontal rod where plates slide on)
    const sleeveHeight = 22.0;
    final sleeveX = collarX + collarWidth;
    final sleeveWidth = size.width - sleeveX - 10;
    final sleeveRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(sleeveX, centerY - (sleeveHeight / 2), sleeveWidth, sleeveHeight),
      const Radius.circular(3),
    );
    final sleevePaint = Paint()
      ..color = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(sleeveRect, sleevePaint);

    // 4. Draw Plates stacked from collar outwards to the right
    double currentX = sleeveX + 2.0;
    const plateWidth = 16.0;

    for (final plateItem in plates) {
      final color = _getPlateColor(plateItem.weight);
      final pHeight = _getPlateHeight(plateItem.weight, size.height);

      for (int i = 0; i < plateItem.countPerSide; i++) {
        if (currentX + plateWidth > size.width - 15) break; // Don't overflow sleeve

        final plateRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(currentX, centerY - (pHeight / 2), plateWidth, pHeight),
          const Radius.circular(3),
        );

        // Plate body
        final platePaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawRRect(plateRect, platePaint);

        // Plate 3D rim border
        final borderPaint = Paint()
          ..color = Colors.black.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;
        canvas.drawRRect(plateRect, borderPaint);

        // Inner groove highlight
        final groovePaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        final innerGroove = RRect.fromRectAndRadius(
          Rect.fromLTWH(currentX + 3, centerY - (pHeight / 2) + 6, plateWidth - 6, pHeight - 12),
          const Radius.circular(2),
        );
        canvas.drawRRect(innerGroove, groovePaint);

        currentX += plateWidth + 2.5;
      }
    }

    // 5. Draw Spring Collar / Lock if plates are loaded
    if (plates.isNotEmpty) {
      final lockPaint = Paint()
        ..color = const Color(0xFFE2E8F0)
        ..style = PaintingStyle.fill;
      final lockRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(currentX, centerY - 18, 8, 36),
        const Radius.circular(2),
      );
      canvas.drawRRect(lockRect, lockPaint);
    }
  }

  @override
  bool shouldRepaint(BarbellSleevePainter oldDelegate) {
    return oldDelegate.plates != plates ||
        oldDelegate.barWeight != barWeight ||
        oldDelegate.isDark != isDark;
  }
}
