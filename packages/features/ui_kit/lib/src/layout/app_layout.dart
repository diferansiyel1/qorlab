import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Main app layout with bottom navigation matching stich design
class AppLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Function(int) onTabTapped;
  final VoidCallback onFabPressed;
  final VoidCallback? onFabLongPressed;

  const AppLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTabTapped,
    required this.onFabPressed,
    this.onFabLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Main Content
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: body,
            ),

            // Bottom Navigation Bar with backdrop blur
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 8,
                      top: 12,
                      left: 24,
                      right: 24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.95),
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
                          label: 'Home',
                          isActive: currentIndex == 0,
                          onTap: () => onTabTapped(0),
                        ),

                        // Files tab
                        _BottomBarItem(
                          icon: Icons.folder_open_rounded,
                          label: 'Files',
                          isActive: currentIndex == 1,
                          onTap: () => onTabTapped(1),
                        ),

                        // Spacer for FAB
                        const SizedBox(width: 56),

                        // Lab tab
                        _BottomBarItem(
                          icon: Icons.science_rounded,
                          label: 'Lab',
                          isActive: currentIndex == 2,
                          onTap: () => onTabTapped(2),
                        ),

                        // Settings tab
                        _BottomBarItem(
                          icon: Icons.settings_rounded,
                          label: 'Settings',
                          isActive: currentIndex == 3,
                          onTap: () => onTabTapped(3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // FAB with neon glow
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              left: 0,
              right: 0,
              child: Center(
                child: _AnimatedFab(
                  onTap: onFabPressed,
                  onLongPress: onFabLongPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textMuted,
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

  const _AnimatedFab({
    required this.onTap,
    this.onLongPress,
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
                      color: Colors.black.withOpacity(0.3),
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
                      'Tap: Quick Calc',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMain,
                      ),
                    ),
                    Text(
                      'HOLD: NEW EXPERIMENT',
                      style: AppTypography.labelUppercase.copyWith(
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // FAB Button
          GestureDetector(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: AnimatedScale(
              scale: _isPressed ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 100),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.neonGlow,
                ),
                child: AnimatedRotation(
                  turns: _isPressed ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppColors.background,
                    size: 28,
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
