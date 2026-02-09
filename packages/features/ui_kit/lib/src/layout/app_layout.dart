import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Main app layout with bottom navigation matching stich design
class AppLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Function(int) onTabTapped;
  final VoidCallback onFabPressed;
  final VoidCallback? onFabLongPressed;
  final String homeTabLabel;
  final String filesTabLabel;
  final String labTabLabel;
  final String settingsTabLabel;
  final String fabTapHint;
  final String fabHoldHint;

  const AppLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTabTapped,
    required this.onFabPressed,
    this.onFabLongPressed,
    required this.homeTabLabel,
    required this.filesTabLabel,
    required this.labTabLabel,
    required this.settingsTabLabel,
    required this.fabTapHint,
    required this.fabHoldHint,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isDesktop = screenWidth >= 1000;
    final safeBottom = mediaQuery.padding.bottom;
    final navMaxWidth = isDesktop ? 980.0 : double.infinity;
    final contentMaxWidth = isDesktop ? 1180.0 : double.infinity;
    // Keep scrolling content fully above nav + protruding FAB.
    final contentBottomInset = safeBottom + (isDesktop ? 116 : 96);
    final navItemIconSize = isDesktop ? 26.0 : 24.0;
    final navItemFontSize = isDesktop ? 11.0 : 10.0;
    final fabSize = isDesktop ? 64.0 : 56.0;
    final fabIconSize = isDesktop ? 30.0 : 28.0;
    final textScale = mediaQuery.textScaler.scale(1) * (isDesktop ? 1.08 : 1.0);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final activeInk =
        Color.lerp(
          AppColors.textMuted,
          AppColors.primary,
          isDark ? 0.78 : 0.60,
        ) ??
        AppColors.primary;
    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.linear(textScale)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Ambient background: subtle iridescent blobs for a "liquid crystal" feel.
              Positioned.fill(
                child: CustomPaint(
                  painter: _AmbientPainter(
                    brightness: brightness,
                    primaryInk: activeInk,
                  ),
                ),
              ),

              // Main Content
              Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: contentBottomInset),
                    child: body,
                  ),
                ),
              ),

              // Bottom Navigation Bar with backdrop blur
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: navMaxWidth),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(isDesktop ? 18 : 0),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: safeBottom + (isDesktop ? 10 : 8),
                            top: isDesktop ? 14 : 12,
                            left: isDesktop ? 28 : 24,
                            right: isDesktop ? 28 : 24,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.glassBackground,
                            border: Border(
                              top: BorderSide(
                                color: AppColors.glassBorder,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Home tab
                              _BottomBarItem(
                                icon: Icons.home_rounded,
                                label: homeTabLabel,
                                isActive: currentIndex == 0,
                                activeColor: activeInk,
                                iconSize: navItemIconSize,
                                fontSize: navItemFontSize,
                                onTap: () => onTabTapped(0),
                              ),

                              // Files tab
                              _BottomBarItem(
                                icon: Icons.folder_open_rounded,
                                label: filesTabLabel,
                                isActive: currentIndex == 1,
                                activeColor: activeInk,
                                iconSize: navItemIconSize,
                                fontSize: navItemFontSize,
                                onTap: () => onTabTapped(1),
                              ),

                              // Spacer for FAB
                              SizedBox(width: fabSize),

                              // Lab tab
                              _BottomBarItem(
                                icon: Icons.science_rounded,
                                label: labTabLabel,
                                isActive: currentIndex == 2,
                                activeColor: activeInk,
                                iconSize: navItemIconSize,
                                fontSize: navItemFontSize,
                                onTap: () => onTabTapped(2),
                              ),

                              // Settings tab
                              _BottomBarItem(
                                icon: Icons.settings_rounded,
                                label: settingsTabLabel,
                                isActive: currentIndex == 3,
                                activeColor: activeInk,
                                iconSize: navItemIconSize,
                                fontSize: navItemFontSize,
                                onTap: () => onTabTapped(3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // FAB with neon glow
              Positioned(
                bottom: safeBottom + (isDesktop ? 28 : 24),
                left: 0,
                right: 0,
                child: Center(
                  child: _AnimatedFab(
                    onTap: onFabPressed,
                    onLongPress: onFabLongPressed,
                    tapHint: fabTapHint,
                    holdHint: fabHoldHint,
                    size: fabSize,
                    iconSize: fabIconSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmbientPainter extends CustomPainter {
  final Brightness brightness;
  final Color primaryInk;

  const _AmbientPainter({required this.brightness, required this.primaryInk});

  @override
  void paint(Canvas canvas, Size size) {
    final isDark = brightness == Brightness.dark;
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.background);

    // Very subtle iridescent blobs. They should be felt, not seen.
    final blobs = <_BlobSpec>[
      _BlobSpec(
        center: Offset(size.width * 0.15, size.height * 0.08),
        radius: math.min(size.width, size.height) * 0.55,
        color: primaryInk.withAlpha(isDark ? 26 : 18),
      ),
      _BlobSpec(
        center: Offset(size.width * 0.92, size.height * 0.22),
        radius: math.min(size.width, size.height) * 0.42,
        color: const Color(0xFF64D2FF).withAlpha(isDark ? 16 : 12),
      ),
      _BlobSpec(
        center: Offset(size.width * 0.55, size.height * 0.92),
        radius: math.min(size.width, size.height) * 0.65,
        color: const Color(0xFFFFD6A5).withAlpha(isDark ? 0 : 20),
      ),
    ];

    for (final blob in blobs) {
      if (blob.color.a == 0) continue;
      final paint = Paint()
        ..color = blob.color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);
      canvas.drawCircle(blob.center, blob.radius, paint);
    }

    // Gentle top-to-bottom fade for contrast under the nav bar.
    final fade = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          (isDark ? Colors.black : Colors.black).withAlpha(isDark ? 46 : 15),
        ],
        stops: const [0.65, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, fade);
  }

  @override
  bool shouldRepaint(covariant _AmbientPainter oldDelegate) {
    return oldDelegate.brightness != brightness ||
        oldDelegate.primaryInk != primaryInk;
  }
}

class _BlobSpec {
  final Offset center;
  final double radius;
  final Color color;

  const _BlobSpec({
    required this.center,
    required this.radius,
    required this.color,
  });
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final double iconSize;
  final double fontSize;
  final VoidCallback onTap;

  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.iconSize,
    required this.fontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : AppColors.textMuted,
              size: iconSize,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: isActive ? activeColor : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedFab extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String tapHint;
  final String holdHint;
  final double size;
  final double iconSize;

  const _AnimatedFab({
    required this.onTap,
    this.onLongPress,
    required this.tapHint,
    required this.holdHint,
    required this.size,
    required this.iconSize,
  });

  @override
  State<_AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<_AnimatedFab>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _showTooltip = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _showTooltip = true),
      onExit: (_) => setState(() => _showTooltip = false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Tooltip
          if (_showTooltip)
            Positioned(
              right: 72,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.glassBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(76),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.tapHint,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMain,
                      ),
                    ),
                    Text(
                      widget.holdHint,
                      style: AppTypography.labelUppercase.copyWith(fontSize: 9),
                    ),
                  ],
                ),
              ),
            ),

          // FAB Button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            onLongPress: widget.onLongPress == null
                ? null
                : () {
                    HapticFeedback.mediumImpact();
                    widget.onLongPress!();
                  },
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: AnimatedScale(
              scale: _isPressed ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 100),
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                            AppColors.textMuted,
                            AppColors.primary,
                            0.86,
                          ) ??
                          AppColors.primary,
                      Color.lerp(
                            AppColors.textMuted,
                            AppColors.primaryDark,
                            0.82,
                          ) ??
                          AppColors.primaryDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    widget.size >= 64 ? 18 : 16,
                  ),
                  border: Border.all(color: Colors.white.withAlpha(44)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(44),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withAlpha(24),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AnimatedRotation(
                  turns: _isPressed ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: widget.iconSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
