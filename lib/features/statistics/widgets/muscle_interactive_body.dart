import 'package:flutter/material.dart';
import '../../../domain/models/models.dart';
import 'muscle_body_painter.dart';
import 'muscle_path_cache.dart';

class MuscleInteractiveBody extends StatefulWidget {
  final Map<MuscleGroup, double> normalizedScores;
  final MuscleGroup? selectedMuscle;
  final ValueChanged<MuscleGroup?> onMuscleSelected;

  const MuscleInteractiveBody({
    super.key,
    required this.normalizedScores,
    this.selectedMuscle,
    required this.onMuscleSelected,
  });

  @override
  State<MuscleInteractiveBody> createState() => _MuscleInteractiveBodyState();
}

class _MuscleInteractiveBodyState extends State<MuscleInteractiveBody> with SingleTickerProviderStateMixin {
  bool _isFront = true;
  late AnimationController _animController;
  late Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();
    MusclePathCache.ensureInitialized();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _rotationAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleSide(bool toFront) {
    if (_isFront == toFront) return;
    setState(() {
      _isFront = toFront;
    });
    if (_isFront) {
      _animController.reverse();
    } else {
      _animController.forward();
    }
    widget.onMuscleSelected(null);
  }

  void _handleTap(TapUpDetails details, BoxConstraints constraints) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final bounds = _isFront ? MusclePathCache.frontBounds : MusclePathCache.backBounds;
    final pathsMap = _isFront ? MusclePathCache.frontPaths : MusclePathCache.backPaths;

    if (bounds.isEmpty) return;

    final scale = (w / bounds.width).clamp(0.0, h / bounds.height);
    final scaledWidth = bounds.width * scale;
    final scaledHeight = bounds.height * scale;
    final offsetX = (w - scaledWidth) / 2;
    final offsetY = (h - scaledHeight) / 2;

    // Convert local tap coordinate to SVG coordinate space
    final sx = (details.localPosition.dx - offsetX) / scale + bounds.left;
    final sy = (details.localPosition.dy - offsetY) / scale + bounds.top;
    final tapPoint = Offset(sx, sy);

    String? hitSlug;
    // Iterate in reverse to catch top-most first, though paths shouldn't heavily overlap
    for (final entry in pathsMap.entries) {
      for (final p in entry.value) {
        if (p.contains(tapPoint)) {
          hitSlug = entry.key;
          break;
        }
      }
      if (hitSlug != null) break;
    }

    if (hitSlug != null) {
      widget.onMuscleSelected(_mapSlugToMuscleGroup(hitSlug, _isFront));
    } else {
      widget.onMuscleSelected(null);
    }
  }

  MuscleGroup? _mapSlugToMuscleGroup(String slug, bool isFront) {
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
        case 'upper-back': return MuscleGroup.upperBack;
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Premium Segmented Control
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _toggleSide(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _isFront ? theme.colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: _isFront ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ] : null,
                    ),
                    child: Center(
                      child: Text(
                        'FRONT',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: _isFront ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                          fontWeight: _isFront ? FontWeight.bold : FontWeight.normal,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _toggleSide(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: !_isFront ? theme.colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: !_isFront ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ] : null,
                    ),
                    child: Center(
                      child: Text(
                        'BACK',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: !_isFront ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                          fontWeight: !_isFront ? FontWeight.bold : FontWeight.normal,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Invisible radial stage background for premium feel
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.05),
                            Colors.transparent,
                          ],
                          radius: 0.6,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTapUp: (details) => _handleTap(details, constraints),
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity != null) {
                        if (details.primaryVelocity! > 300 && !_isFront) {
                          _toggleSide(true);
                        } else if (details.primaryVelocity! < -300 && _isFront) {
                          _toggleSide(false);
                        }
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _rotationAnim,
                      builder: (context, child) {
                        final value = _rotationAnim.value;
                        final rotation = value * 3.14159; 
                        
                        // Add a slight scale effect during rotation for 3D feel
                        final scale = 1.0 - (0.1 * (0.5 - (value - 0.5).abs()));
                        
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.002) // subtle perspective
                            ..scale(scale, scale)
                            ..rotateY(rotation),
                          alignment: Alignment.center,
                          child: value > 0.5 
                            ? Transform(
                                transform: Matrix4.identity()..rotateY(3.14159),
                                alignment: Alignment.center,
                                child: _buildPainter(theme, false)
                              )
                            : _buildPainter(theme, true),
                        );
                      }
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ],
    );
  }

  Widget _buildPainter(ThemeData theme, bool isFrontSide) {
    return AnimatedScale(
      scale: widget.selectedMuscle != null ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CustomPaint(
          painter: MuscleBodyPainter(
            isFront: isFrontSide,
            normalizedScores: widget.normalizedScores,
            selectedMuscle: widget.selectedMuscle,
            accentColor: theme.colorScheme.primary,
            baseColor: theme.colorScheme.surfaceContainerHighest,
            outlineColor: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
