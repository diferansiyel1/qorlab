import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Generates the QorLab ThemeData.
ThemeData createAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.deepLabBlue,
    brightness: brightness,
    primary: AppColors.deepLabBlue,
    secondary: AppColors.tealScience,
    error: AppColors.biohazardRed,
    surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: isDark ? AppColors.oledBlack : AppColors.sterileWhite,
    
    // Typography
    textTheme: GoogleFonts.interTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).copyWith(
      // Monospace for data
      bodyMedium: GoogleFonts.robotoMono(),
    ),

    // Card Theme (High Contrast)
    cardTheme: CardThemeData(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
    ),

  );
}
