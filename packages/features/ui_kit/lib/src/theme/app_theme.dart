import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// QorLab App Theme
/// Light-first with optional dark mode.
class AppTheme {
  static ThemeData get lightTheme => _buildTheme(AppPalettes.light);
  static ThemeData get darkTheme => _buildTheme(AppPalettes.dark);

  static ThemeData _buildTheme(AppPalette palette) {
    AppColors.setPalette(palette);
    final isDark = palette.brightness == Brightness.dark;
    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: palette.primary,
            secondary: palette.accent,
            surface: palette.surface,
            error: palette.alert,
            onPrimary: Colors.white,
            onSecondary: palette.textMain,
            onSurface: palette.textMain,
            onError: palette.textMain,
            outline: palette.glassBorder,
          )
        : ColorScheme.light(
            primary: palette.primary,
            secondary: palette.accent,
            surface: palette.surface,
            error: palette.alert,
            onPrimary: Colors.white,
            onSecondary: palette.textMain,
            onSurface: palette.textMain,
            onError: Colors.white,
            outline: palette.glassBorder,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: palette.brightness,
      scaffoldBackgroundColor: palette.background,
      primaryColor: palette.primary,
      colorScheme: colorScheme,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: TextTheme(
        displayLarge: AppTypography.headlineLarge,
        displayMedium: AppTypography.headlineMedium,
        displaySmall: AppTypography.headlineSmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.labelLarge,
        titleMedium: AppTypography.labelMedium,
        bodyLarge: AppTypography.bodyMedium,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineMedium,
        iconTheme: IconThemeData(color: palette.textMain),
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: palette.glassBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.inputSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.glassBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.alert, width: 2),
        ),
        labelStyle: AppTypography.labelMedium,
        hintStyle: AppTypography.labelMedium.copyWith(
          color: palette.textDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: isDark ? palette.background : Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        foregroundColor: isDark ? palette.background : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.surface.withOpacity(0.95),
        selectedItemColor: palette.primary,
        unselectedItemColor: palette.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: palette.glassBorder,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.surface,
        contentTextStyle: AppTypography.labelMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
