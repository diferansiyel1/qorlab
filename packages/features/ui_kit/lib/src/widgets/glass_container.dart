import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Glass morphism container widget matching stich design
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool active;
  final Color? accentColor;
  final bool showBottomAccent;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
    this.active = false,
    this.accentColor,
    this.showBottomAccent = false,
  });

  LinearGradient _sheenGradient(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    // "Liquid crystal" sheen: a very soft highlight that reads as glass rather
    // than a flat card. Keep it subtle so content stays clinical/legible.
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        (isDark ? Colors.white : Colors.white).withAlpha(isDark ? 22 : 38),
        Colors.transparent,
        (isDark ? Colors.black : Colors.black).withAlpha(isDark ? 26 : 14),
      ],
      stops: const [0.0, 0.45, 1.0],
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveAccent = accentColor ?? AppColors.primary;
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: AppColors.glassBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active ? effectiveAccent : AppColors.glassBorder,
                  width: active ? 1.6 : 1,
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withAlpha(18),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  if (active) ...AppColors.primaryGlow,
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: padding ?? const EdgeInsets.all(16),
                    child: child,
                  ),
                  // Glass sheen overlay.
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: _sheenGradient(brightness),
                        ),
                      ),
                    ),
                  ),
                  // Bottom accent gradient line (from stich metric cards)
                  if (showBottomAccent)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              effectiveAccent,
                              effectiveAccent.withAlpha(0),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
