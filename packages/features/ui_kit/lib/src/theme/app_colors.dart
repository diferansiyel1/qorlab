import 'package:flutter/material.dart';

/// QorLab Design System Color Palette
/// Supports light + dark modes with shared semantic tokens.
class AppPalette {
  final Brightness brightness;
  final Color background;
  final Color surface;
  final Color surfaceHighlight;
  final Color inputSurface;
  final Color glassBackground;
  final Color glassBorder;
  final Color glassSelection;
  final Color primary;
  final Color primaryDark;
  final Color accent;
  final Color success;
  final Color alert;
  final Color warning;
  final Color textMain;
  final Color textMuted;
  final Color textDark;
  final Color statusInProgress;
  final Color statusReview;
  final Color statusCompleted;
  final Color statusRecording;
  final LinearGradient primaryGradient;
  final List<BoxShadow> neonGlow;
  final List<BoxShadow> primaryGlow;
  final List<BoxShadow> alertGlow;

  AppPalette({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceHighlight,
    required this.inputSurface,
    required this.glassBackground,
    required this.glassBorder,
    required this.glassSelection,
    required this.primary,
    required this.primaryDark,
    required this.accent,
    required this.success,
    required this.alert,
    required this.warning,
    required this.textMain,
    required this.textMuted,
    required this.textDark,
    required this.statusInProgress,
    required this.statusReview,
    required this.statusCompleted,
    required this.statusRecording,
  })  : primaryGradient = LinearGradient(
          colors: [primary, primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        neonGlow = [
          BoxShadow(
            color: primary.withOpacity(brightness == Brightness.dark ? 0.22 : 0.14),
            blurRadius: 12,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: primary.withOpacity(brightness == Brightness.dark ? 0.12 : 0.08),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
        primaryGlow = [
          BoxShadow(
            color: primary.withOpacity(brightness == Brightness.dark ? 0.28 : 0.18),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
        alertGlow = [
          BoxShadow(
            color: alert.withOpacity(brightness == Brightness.dark ? 0.5 : 0.25),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ];
}

class AppPalettes {
  static final AppPalette light = AppPalette(
    brightness: Brightness.light,
    background: const Color(0xFFF2F2F7),
    surface: const Color(0xFFFFFFFF),
    surfaceHighlight: const Color(0xFFF5F5FA),
    inputSurface: const Color(0xFFF7F7FA),
    glassBackground: const Color(0x0D000000),
    glassBorder: const Color(0xFFC6C6C8),
    glassSelection: const Color(0x33000000),
    primary: const Color(0xFF0A84FF),
    primaryDark: const Color(0xFF0060DF),
    accent: const Color(0xFF0A84FF),
    success: const Color(0xFF34C759),
    alert: const Color(0xFFFF453A),
    warning: const Color(0xFFFF9F0A),
    textMain: const Color(0xFF000000),
    textMuted: const Color(0xFF8E8E93),
    textDark: const Color(0xFF636366),
    statusInProgress: const Color(0xFF0A84FF),
    statusReview: const Color(0xFFFF9F0A),
    statusCompleted: const Color(0xFF34C759),
    statusRecording: const Color(0xFFFF453A),
  );

  static final AppPalette dark = AppPalette(
    brightness: Brightness.dark,
    background: const Color(0xFF000000),
    surface: const Color(0xFF1C1C1E),
    surfaceHighlight: const Color(0xFF2C2C2E),
    inputSurface: const Color(0xFF2C2C2E),
    glassBackground: const Color(0x0FFFFFFF),
    glassBorder: const Color(0xFF38383A),
    glassSelection: const Color(0x66FFFFFF),
    primary: const Color(0xFF0A84FF),
    primaryDark: const Color(0xFF0060DF),
    accent: const Color(0xFF0A84FF),
    success: const Color(0xFF30D158),
    alert: const Color(0xFFFF453A),
    warning: const Color(0xFFFF9F0A),
    textMain: const Color(0xFFFFFFFF),
    textMuted: const Color(0xFF8E8E93),
    textDark: const Color(0xFF636366),
    statusInProgress: const Color(0xFF0A84FF),
    statusReview: const Color(0xFFFF9F0A),
    statusCompleted: const Color(0xFF30D158),
    statusRecording: const Color(0xFFFF453A),
  );
}

/// Active palette used by legacy widgets without context access.
abstract class AppColors {
  static AppPalette _palette = AppPalettes.light;

  static AppPalette get palette => _palette;

  static void setPalette(AppPalette palette) {
    _palette = palette;
  }

  static void setBrightness(Brightness brightness) {
    _palette = brightness == Brightness.dark ? AppPalettes.dark : AppPalettes.light;
  }

  static Color get background => _palette.background;
  static Color get surface => _palette.surface;
  static Color get surfaceHighlight => _palette.surfaceHighlight;
  static Color get inputSurface => _palette.inputSurface;
  static Color get glassBackground => _palette.glassBackground;
  static Color get glassBorder => _palette.glassBorder;
  static Color get glassSelection => _palette.glassSelection;
  static Color get primary => _palette.primary;
  static Color get primaryDark => _palette.primaryDark;
  static Color get accent => _palette.accent;
  static Color get success => _palette.success;
  static Color get alert => _palette.alert;
  static Color get warning => _palette.warning;
  static Color get textMain => _palette.textMain;
  static Color get textMuted => _palette.textMuted;
  static Color get textDark => _palette.textDark;
  static Color get statusInProgress => _palette.statusInProgress;
  static Color get statusReview => _palette.statusReview;
  static Color get statusCompleted => _palette.statusCompleted;
  static Color get statusRecording => _palette.statusRecording;
  static LinearGradient get primaryGradient => _palette.primaryGradient;
  static List<BoxShadow> get neonGlow => _palette.neonGlow;
  static List<BoxShadow> get primaryGlow => _palette.primaryGlow;
  static List<BoxShadow> get alertGlow => _palette.alertGlow;
}
