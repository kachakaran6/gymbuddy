import 'package:flutter/material.dart';
import '../../../domain/models/models.dart';
import 'muscle_path_cache.dart';

class MuscleBodyPainter extends CustomPainter {
  final bool isFront;
  final Map<MuscleGroup, double> normalizedScores;
  final MuscleGroup? selectedMuscle;
  final Color accentColor;
  final Color baseColor;
  final Color outlineColor;

  MuscleBodyPainter({
    required this.isFront,
    required this.normalizedScores,
    this.selectedMuscle,
    required this.accentColor,
    required this.baseColor,
    required this.outlineColor,
  }) {
    MusclePathCache.ensureInitialized();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bounds = isFront ? MusclePathCache.frontBounds : MusclePathCache.backBounds;
    final pathsMap = isFront ? MusclePathCache.frontPaths : MusclePathCache.backPaths;

    if (bounds.isEmpty) return;

    // Scale to fit the canvas, keeping aspect ratio
    final scale = (w / bounds.width).clamp(0.0, h / bounds.height);
    
    // Center it horizontally and vertically
    final scaledWidth = bounds.width * scale;
    final scaledHeight = bounds.height * scale;
    final offsetX = (w - scaledWidth) / 2;
    final offsetY = (h - scaledHeight) / 2;

    canvas.save();
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale, scale);
    canvas.translate(-bounds.left, -bounds.top);

    // Sort regions so selected muscle is drawn last (on top for glowing)
    final sortedKeys = pathsMap.keys.toList();
    sortedKeys.sort((a, b) {
      final mA = _mapSlugToMuscleGroup(a);
      final mB = _mapSlugToMuscleGroup(b);
      if (mA == selectedMuscle && mB != selectedMuscle) return 1;
      if (mB == selectedMuscle && mA != selectedMuscle) return -1;
      return 0;
    });

    for (final slug in sortedKeys) {
      final paths = pathsMap[slug]!;
      final muscle = _mapSlugToMuscleGroup(slug);
      
      double intensity = 0.0;
      if (muscle != null) {
        // Special case for upper-back slug which combines upperBack and lats visually
        if (slug == 'upper-back') {
          final lats = normalizedScores[MuscleGroup.lats] ?? 0.0;
          final ub = normalizedScores[MuscleGroup.upperBack] ?? 0.0;
          intensity = lats > ub ? lats : ub; 
        } else {
          intensity = normalizedScores[muscle] ?? 0.0;
        }
      }

      bool isSelected = (muscle != null && muscle == selectedMuscle);
      
      // Determine fill color
      Color fillColor = baseColor;
      if (intensity > 0 && muscle != null) {
        fillColor = Color.lerp(baseColor, accentColor, intensity * 0.8 + 0.2)!;
      }
      
      if (selectedMuscle != null && !isSelected) {
        fillColor = fillColor.withValues(alpha: 0.3); // Dim unselected
      } else if (isSelected) {
        fillColor = accentColor;
      }

      final fillPaint = Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill;

      // Draw shadow/glow if highly active or selected
      if ((intensity > 0.7 || isSelected) && (selectedMuscle == null || isSelected)) {
        final shadowPaint = Paint()
          ..color = accentColor.withValues(alpha: isSelected ? 0.6 : 0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.outer, isSelected ? 12.0 : 8.0)
          ..style = PaintingStyle.fill;
        for (final p in paths) {
          canvas.drawPath(p, shadowPaint);
        }
      }

      // Draw the paths
      for (final p in paths) {
        canvas.drawPath(p, fillPaint);
      }

      // Draw boundaries with subtle depth
      final strokeColor = isSelected ? outlineColor : outlineColor.withValues(alpha: 0.15);
      final strokePaint = Paint()
        ..color = strokeColor
        ..strokeWidth = isSelected ? 2.5 : 1.0
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round;
        
      for (final p in paths) {
        canvas.drawPath(p, strokePaint);
      }
    }

    canvas.restore();
  }

  MuscleGroup? _mapSlugToMuscleGroup(String slug) {
    if (isFront) {
      switch (slug) {
        case 'chest': return MuscleGroup.chest;
        case 'obliques': return MuscleGroup.obliques;
        case 'abs': return MuscleGroup.core;
        case 'biceps': return MuscleGroup.biceps;
        case 'triceps': return MuscleGroup.triceps;
        case 'deltoids': return MuscleGroup.frontShoulders;
        case 'quadriceps': return MuscleGroup.quadriceps;
        case 'tibialis':
        case 'calves': return MuscleGroup.calves;
        case 'trapezius': return MuscleGroup.traps;
        case 'forearm': return MuscleGroup.forearms;
      }
    } else {
      switch (slug) {
        case 'trapezius': return MuscleGroup.traps;
        case 'deltoids': return MuscleGroup.rearShoulders;
        case 'upper-back': return MuscleGroup.upperBack; // or lats combined
        case 'triceps': return MuscleGroup.triceps;
        case 'lower-back': return MuscleGroup.lowerBack;
        case 'forearm': return MuscleGroup.forearms;
        case 'gluteal': return MuscleGroup.glutes;
        case 'hamstring': return MuscleGroup.hamstrings;
        case 'calves': return MuscleGroup.calves;
      }
    }
    return null;
  }

  @override
  bool shouldRepaint(covariant MuscleBodyPainter oldDelegate) {
    return isFront != oldDelegate.isFront ||
        selectedMuscle != oldDelegate.selectedMuscle ||
        accentColor != oldDelegate.accentColor ||
        normalizedScores != oldDelegate.normalizedScores;
  }
}
