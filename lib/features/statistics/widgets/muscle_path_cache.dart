import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'anatomy_paths.dart';

class MusclePathCache {
  static final Map<String, List<Path>> frontPaths = {};
  static final Map<String, List<Path>> backPaths = {};
  static Rect frontBounds = Rect.zero;
  static Rect backBounds = Rect.zero;

  static void ensureInitialized() {
    if (frontPaths.isEmpty) {
      _initFront();
    }
    if (backPaths.isEmpty) {
      _initBack();
    }
  }

  static void _initFront() {
    Path overallPath = Path();
    for (final entry in AnatomyPaths.front.entries) {
      final paths = <Path>[];
      for (final p in entry.value) {
        final path = parseSvgPathData(p);
        paths.add(path);
        overallPath.addPath(path, Offset.zero);
      }
      frontPaths[entry.key] = paths;
    }
    frontBounds = overallPath.getBounds();
  }

  static void _initBack() {
    Path overallPath = Path();
    for (final entry in AnatomyPaths.back.entries) {
      final paths = <Path>[];
      for (final p in entry.value) {
        final path = parseSvgPathData(p);
        paths.add(path);
        overallPath.addPath(path, Offset.zero);
      }
      backPaths[entry.key] = paths;
    }
    backBounds = overallPath.getBounds();
  }
}
