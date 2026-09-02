import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';

/// Clean, obsidian rounded card matching GymMane's aesthetic
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 20,
    this.borderColor,
    this.color,
    this.clip = false,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final Color? borderColor;
  final Color? color;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    return Container(
      padding: padding,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        color: color ?? gc.bgRaised,
        border: Border.all(color: borderColor ?? gc.border, width: 1),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}

/// Standout primary pill button
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.bg,
    this.fg,
    this.height = 54,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final Color? bg;
  final Color? fg;
  final double height;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    final buttonFg = fg ?? gc.onEmber;
    final buttonBg = bg ?? gc.ember;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            color: buttonBg,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: buttonBg.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: buttonFg),
                const SizedBox(width: 10),
              ],
              Text(
                label.toUpperCase(),
                style: AppTheme.d(
                  15,
                  weight: FontWeight.w700,
                  color: buttonFg,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Secondary outline pill button
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 50,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final double height;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: gc.bgRaised,
            border: Border.all(color: gc.border),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: gc.text),
                const SizedBox(width: 8),
              ],
              Text(
                label.toUpperCase(),
                style: AppTheme.d(
                  13,
                  weight: FontWeight.w600,
                  color: gc.text,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Upper-case tracked section subheader (like "TODAY'S FOCUS" or "ACTIVITY")
class Kicker extends StatelessWidget {
  const Kicker(
    this.text, {
    super.key,
    this.color,
    this.size = 11,
    this.spacing = 2.5,
  });

  final String text;
  final Color? color;
  final double size;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    return Text(
      text.toUpperCase(),
      style: AppTheme.d(
        size,
        weight: FontWeight.w600,
        color: color ?? gc.brass,
        letterSpacing: spacing,
      ),
    );
  }
}

/// Bold display screen title
class ScreenTitle extends StatelessWidget {
  const ScreenTitle(
    this.text, {
    super.key,
    this.size = 28,
    this.spacing = 1.0,
  });

  final String text;
  final double size;
  final double spacing;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTheme.d(
          size,
          weight: FontWeight.w700,
          color: context.gc.text,
          letterSpacing: spacing,
        ),
      );
}

/// Segmented option for SegToggle
class SegOption {
  const SegOption(this.label, this.selected, this.onTap, {this.icon});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
}

/// Segmented pill toggle (e.g. All | Gym Floor | Home Workout)
class SegToggle extends StatelessWidget {
  const SegToggle(
    this.options, {
    super.key,
    this.hPad = 14,
    this.vPad = 8,
    this.fontSize = 12,
  });

  final List<SegOption> options;
  final double hPad;
  final double vPad;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: gc.bgRaised,
        border: Border.all(color: gc.border),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final o in options)
            GestureDetector(
              onTap: o.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
                decoration: BoxDecoration(
                  color: o.selected ? gc.ember : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (o.icon != null) ...[
                      Icon(
                        o.icon,
                        size: 14,
                        color: o.selected ? gc.onEmber : gc.textSecondary,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      o.label,
                      style: AppTheme.s(
                        fontSize,
                        weight: FontWeight.w600,
                        color: o.selected ? gc.onEmber : gc.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Pill filter chip
class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.hPad = 14,
    this.vPad = 8,
    this.fontSize = 12,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final double hPad;
  final double vPad;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        decoration: BoxDecoration(
          color: selected ? gc.accentSoft : gc.bgRaised,
          border: Border.all(
            color: selected ? gc.accent : gc.border,
            width: selected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: selected ? gc.accent : gc.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTheme.s(
                fontSize,
                weight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? gc.text : gc.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stepper control for sets, reps, weight
class StepperControl extends StatelessWidget {
  const StepperControl({
    super.key,
    required this.value,
    required this.onDec,
    required this.onInc,
    this.onEdit,
    this.minWidth = 70,
    this.btnSize = 34,
    this.gap = 12,
    this.fontSize = 16,
    this.btnRadius = 10,
  });

  final String value;
  final VoidCallback onDec;
  final VoidCallback onInc;
  final VoidCallback? onEdit;
  final double minWidth;
  final double btnSize;
  final double gap;
  final double fontSize;
  final double btnRadius;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    Widget btn(String glyph, VoidCallback onTap) => GestureDetector(
          onTap: onTap,
          child: Container(
            width: btnSize,
            height: btnSize,
            decoration: BoxDecoration(
              color: gc.bgRaised2,
              borderRadius: BorderRadius.circular(btnRadius),
              border: Border.all(color: gc.border),
            ),
            alignment: Alignment.center,
            child: Text(
              glyph,
              style: TextStyle(
                color: gc.text,
                fontSize: fontSize + 2,
                height: 1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );

    Widget label = Container(
      constraints: BoxConstraints(minWidth: minWidth),
      alignment: Alignment.center,
      child: Text(
        value,
        style: AppTheme.d(fontSize, weight: FontWeight.w700, color: gc.text),
      ),
    );

    if (onEdit != null) {
      label = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onEdit,
        child: label,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        btn('–', onDec),
        SizedBox(width: gap),
        label,
        SizedBox(width: gap),
        btn('+', onInc),
      ],
    );
  }
}

/// Ambient glow background decoration
class AmbientGlow extends StatelessWidget {
  const AmbientGlow({super.key, this.color, this.radius = 180});

  final Color? color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                (color ?? gc.accent).withValues(alpha: 0.14),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
