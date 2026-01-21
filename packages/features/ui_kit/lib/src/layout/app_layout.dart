import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Function(int) onTabTapped;
  final VoidCallback onFabPressed;

  const AppLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTabTapped,
    required this.onFabPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Padding(
              padding: const EdgeInsets.only(bottom: 80), // Space for BottomBar
              child: body,
            ),

            // Contextual Bottom Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.background,
                      AppColors.background.withOpacity(0.0),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tab 1: Dashboard
                      _BottomBarItem(
                        icon: Icons.grid_view_rounded,
                        label: 'Dash',
                        isActive: currentIndex == 0,
                        onTap: () => onTabTapped(0),
                      ),
                      
                      // Tab 2: Lab Tools
                      _BottomBarItem(
                        icon: Icons.science_rounded,
                        label: 'Tools',
                        isActive: currentIndex == 1,
                        onTap: () => onTabTapped(1),
                      ),
                      
                      // Spacer for FAB
                      const SizedBox(width: 48),

                      // Tab 3: Settings
                      _BottomBarItem(
                        icon: Icons.settings_rounded,
                        label: 'Settings',
                        isActive: currentIndex == 2,
                        onTap: () => onTabTapped(2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // FAB - The "Big Bang" Button
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: onFabPressed,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.accent : AppColors.textMuted,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              fontSize: 10,
              color: isActive ? AppColors.accent : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
