import 'dart:math' as math;
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_drawing/path_drawing.dart';

class ExerciseArtData {
  const ExerciseArtData(this.frames, this.bounds);
  final List<Path> frames;
  final Rect bounds;
}

const _cacheLimit = 48;
final _cache = <String, ExerciseArtData>{};
final _pending = <String, Future<ExerciseArtData>>{};

Future<ExerciseArtData> loadExerciseArt(String slug) {
  final hit = _cache.remove(slug);
  if (hit != null) {
    _cache[slug] = hit;
    return SynchronousFuture(hit);
  }
  return _pending.putIfAbsent(slug, () async {
    try {
      final raw = await rootBundle.loadString('assets/art/$slug.txt');
      final frames = [
        for (final d in raw.split('\n'))
          if (d.trim().isNotEmpty) parseSvgPathData(d.trim())..fillType = PathFillType.evenOdd,
      ];
      if (frames.isEmpty) throw StateError('No frames found in $slug.txt');
      var bounds = frames.first.getBounds();
      for (final f in frames.skip(1)) {
        bounds = bounds.expandToInclude(f.getBounds());
      }
      final data = ExerciseArtData(frames, bounds);
      _cache[slug] = data;
      if (_cache.length > _cacheLimit) _cache.remove(_cache.keys.first);
      return data;
    } finally {
      _pending.remove(slug);
    }
  });
}

class ExerciseArt extends StatefulWidget {
  const ExerciseArt({
    super.key,
    required this.slug,
    this.height = 200,
    this.radius = 16,
    this.live = true,
  });

  final String slug;
  final double height;
  final double radius;
  final bool live;

  @override
  State<ExerciseArt> createState() => _ExerciseArtState();
}

class _ExerciseArtState extends State<ExerciseArt> with SingleTickerProviderStateMixin {
  static const _cycle = Duration(milliseconds: 1600);

  AnimationController? _c;
  ExerciseArtData? _art;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void didUpdateWidget(ExerciseArt old) {
    super.didUpdateWidget(old);
    if (old.slug != widget.slug) {
      _art = null;
      _failed = false;
      _fetch();
    }
    if (old.live != widget.live) _sync();
  }

  Future<void> _fetch() async {
    if (widget.slug.isEmpty) return;
    final slug = widget.slug;
    try {
      final data = await loadExerciseArt(slug);
      if (!mounted || slug != widget.slug) return;
      setState(() {
        _art = data;
        _sync();
      });
    } catch (_) {
      if (mounted && slug == widget.slug) setState(() => _failed = true);
    }
  }

  void _sync() {
    if (widget.live && (_art?.frames.length ?? 0) > 1) {
      final c = _c ??= AnimationController(vsync: this, duration: _cycle);
      if (!c.isAnimating) c.repeat();
    } else {
      _c?.stop();
    }
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : Colors.black87;
    final art = _art;

    Widget child;
    if (widget.slug.isEmpty || _failed) {
      child = _fallback(theme, widget.height);
    } else if (art == null) {
      child = const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else if (widget.live && art.frames.length > 1 && _c != null) {
      final c = _c!;
      child = AnimatedBuilder(
        animation: c,
        builder: (_, _) => CustomPaint(
          painter: _ArtPainter(art, primaryColor, c.value),
          size: Size.infinite,
        ),
      );
    } else {
      child = CustomPaint(
        painter: _ArtPainter(art, primaryColor, 0),
        size: Size.infinite,
      );
    }

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181818) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(
          color: isDark ? const Color(0xFF282828) : const Color(0xFFE2E8F0),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _fallback(ThemeData theme, double height) => Center(
        child: Icon(
          Icons.fitness_center_rounded,
          size: height * 0.32,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      );
}

class _ArtPainter extends CustomPainter {
  const _ArtPainter(this.art, this.color, this.t);

  final ExerciseArtData art;
  final Color color;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final b = art.bounds;
    if (b.isEmpty || size.isEmpty) return;
    final pad = size.shortestSide * 0.08;
    final scale = math.min((size.width - pad * 2) / b.width, (size.height - pad * 2) / b.height);
    if (scale <= 0) return;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale);
    canvas.translate(-b.center.dx, -b.center.dy);

    final n = art.frames.length;
    final steps = (n - 1) * 2;
    final pos = t * steps;
    final step = pos.floor() % steps;
    final f = pos - pos.floor();
    final ascending = step < n - 1;
    final from = ascending ? step : steps - step;
    final to = ascending ? from + 1 : from - 1;
    final blend = f < 0.72 ? 0.0 : Curves.easeInOut.transform((f - 0.72) / 0.28);

    _draw(canvas, art.frames[from], 1 - blend);
    if (blend > 0) _draw(canvas, art.frames[to], blend);
    canvas.restore();
  }

  void _draw(Canvas canvas, Path path, double opacity) {
    if (opacity <= 0.01) return;
    canvas.drawPath(path, Paint()..color = color.withValues(alpha: opacity));
  }

  @override
  bool shouldRepaint(_ArtPainter old) =>
      old.art != art || old.color != color || old.t != t;
}
