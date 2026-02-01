import 'package:flutter/material.dart';

/// QorLab Design System Color Palette
/// Based on stich design reference files
abstract class AppColors {
  // Base Backgrounds (from stich)
  static const Color background = Color(0xFF121212); // Deep Matte Black
  static const Color surface = Color(0xFF1E1E1E); // Surface Dark
  static const Color surfaceHighlight = Color(0xFF23263A); // Hover/highlight state
  static const Color inputSurface = Color(0xFF2A2A2A); // Input field background

  // Glassmorphism
  static const Color glassBackground = Color(0x1AFFFFFF); // 10% White
  static const Color glassBorder = Color(0x33FFFFFF); // 20% White
  static const Color glassSelection = Color(0x66FFFFFF); // 40% White (Selection)

  // Primary & Accents (Neon Cyan from stich)
  static const Color primary = Color(0xFF0DDFF2); // Neon Cyan - main actions
  static const Color primaryDark = Color(0xFF0AC8D8); // Darker variant
  static const Color accent = Color(0xFFF18F01); // Amber attention
  static const Color success = Color(0xFF30D158); // Teal Science (success/active)
  static const Color alert = Color(0xFFFF453A); // Biohazard Red (danger/stop)
  static const Color warning = Color(0xFFEAB308); // Yellow for observations

  // Text Colors
  static const Color textMain = Color(0xFFEAEAEA); // Off-white text
  static const Color textMuted = Color(0xFFA0A0A0); // Secondary text
  static const Color textDark = Color(0xFF888888); // Very muted text

  // Status Badge Colors (from stich)
  static const Color statusInProgress = Color(0xFF0DDFF2); // Cyan
  static const Color statusReview = Color(0xFFF97316); // Orange
  static const Color statusCompleted = Color(0xFF30D158); // Green
  static const Color statusRecording = Color(0xFFEF4444); // Red

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0DDFF2), Color(0xFF0AC8D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Neon Glow Shadows
  static List<BoxShadow> get neonGlow => [
        BoxShadow(
          color: primary.withOpacity(0.2),
          blurRadius: 10,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: primary.withOpacity(0.1),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: primary.withOpacity(0.3),
          blurRadius: 15,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get alertGlow => [
        BoxShadow(
          color: alert.withOpacity(0.6),
          blurRadius: 12,
          spreadRadius: 0,
        ),
      ];
}
