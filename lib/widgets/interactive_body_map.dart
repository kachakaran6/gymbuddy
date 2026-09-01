import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import '../data/catalog/body_svg.dart';

final Map<String, Path> _svgPathCache = {};
Path _svgPath(String d) => _svgPathCache.putIfAbsent(d, () => parseSvgPathData(d));

const double _bodyAspect = bodyViewH / bodyViewW;

String? muscleAt(Offset p) {
  for (final id in muscleFills.keys) {
    final hits = muscleHits[id];
    final probes = (hits != null && hits.isNotEmpty) ? hits : muscleFills[id]!;
    for (final d in probes) {
      if (_svgPath(d).contains(p)) return id;
    }
  }
  return null;
}

Color idleMuscle(ThemeData theme) {
  final isDark = theme.brightness == Brightness.dark;
  return isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0);
}

const List<Color> _heatDark = [
  Color(0xFF78350F), // amber 900
  Color(0xFFD97706), // amber 600
  Color(0xFFF97316), // orange 500
  Color(0xFF10B981), // emerald neon
];

const List<Color> _heatLight = [
  Color(0xFFFDE68A), // amber 200
  Color(0xFFFBBF24), // amber 400
  Color(0xFFF97316), // orange 500
  Color(0xFF059669), // emerald 600
];

Color getMuscleHeatColor(ThemeData theme, double intensity0to1) {
  if (intensity0to1 <= 0) return idleMuscle(theme);
  final isDark = theme.brightness == Brightness.dark;
  final ramp = isDark ? _heatDark : _heatLight;
  int lvl = 0;
  if (intensity0to1 >= 0.75) {
    lvl = 3;
  } else if (intensity0to1 >= 0.50) {
    lvl = 2;
  } else if (intensity0to1 >= 0.25) {
    lvl = 1;
  }
  return ramp[lvl];
}

class BodyHeatMap extends StatelessWidget {
  final Map<String, double> intensity; // muscle name -> 0.0 to 1.0
  final String? focusMuscle;
  final ValueChanged<String>? onMuscleTap;

  const BodyHeatMap({
    super.key,
    required this.intensity,
    this.focusMuscle,
    this.onMuscleTap,
  });

  String get _token {
    final keys = intensity.keys.toList()..sort();
    return keys.map((k) => '$k${(intensity[k]! * 100).round()}').join(',');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _BodyCanvas(
      onTap: onMuscleTap,
      painter: _BodyPainter(
        theme: theme,
        token: _token,
        color: (id) => getMuscleHeatColor(theme, intensity[id] ?? 0.0),
        outline: focusMuscle,
      ),
    );
  }
}

class _BodyCanvas extends StatelessWidget {
  const _BodyCanvas({required this.painter, this.onTap});

  final _BodyPainter painter;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final scale = w / bodyViewW;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: onTap == null
            ? null
            : (d) {
                final p = Offset(d.localPosition.dx / scale, d.localPosition.dy / scale);
                final id = muscleAt(p);
                if (id != null) onTap!(id);
              },
        child: CustomPaint(
          size: Size(w, w * _bodyAspect),
          painter: painter,
        ),
      );
    });
  }
}

class _BodyPainter extends CustomPainter {
  _BodyPainter({
    required this.theme,
    required this.color,
    required this.token,
    this.outline,
  });

  final ThemeData theme;
  final Color Function(String id) color;
  final String token;
  final String? outline;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / bodyViewW);

    final isDark = theme.brightness == Brightness.dark;
    final bodyMain = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF1F5F9);
    final bodyLite = isDark ? const Color(0xFF282828) : const Color(0xFFE2E8F0);

    void fill(String d, Color c) =>
        canvas.drawPath(_svgPath(d), Paint()..color = c..style = PaintingStyle.fill..isAntiAlias = true);

    for (final d in bodyBaseMain) {
      fill(d, bodyMain);
    }
    for (final d in bodyBaseLite) {
      fill(d, bodyLite);
    }
    for (final entry in muscleFills.entries) {
      final c = color(entry.key);
      for (final d in entry.value) {
        fill(d, c);
      }
    }

    final id = outline;
    if (id != null) {
      final stroke = Paint()
        ..color = theme.colorScheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..isAntiAlias = true;
      for (final d in muscleFills[id] ?? const <String>[]) {
        canvas.drawPath(_svgPath(d), stroke);
      }
    }
  }

  @override
  bool shouldRepaint(_BodyPainter old) =>
      old.theme != theme || old.token != token || old.outline != outline;
}
