import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lab_colors.dart';

/// Lab theme system for QorLab.
class LabTheme {
  static ThemeData getLight() => _buildTheme(Brightness.light);

  static ThemeData getDark() => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    LabColors.setBrightness(brightness);
    final isDark = brightness == Brightness.dark;

    final baseScheme =
        isDark ? const ColorScheme.dark() : const ColorScheme.light();
    final colorScheme = baseScheme.copyWith(
      primary: LabColors.accent,
      onPrimary: Colors.white,
      secondary: LabColors.accent,
      onSecondary: Colors.white,
      surface: LabColors.surfaceFor(brightness),
      onSurface: LabColors.textPrimaryFor(brightness),
      background: LabColors.backgroundFor(brightness),
      onBackground: LabColors.textPrimaryFor(brightness),
      error: LabColors.error,
      onError: Colors.white,
      outline: LabColors.dividerFor(brightness),
    );

    final textTheme = _buildTextTheme(
      primary: LabColors.textPrimaryFor(brightness),
      secondary: LabColors.textSecondaryFor(brightness),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: LabColors.backgroundFor(brightness),
      primaryColor: LabColors.accent,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: LabColors.backgroundFor(brightness),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: LabColors.textPrimaryFor(brightness)),
      ),
      cardTheme: CardThemeData(
        color: LabColors.surfaceFor(brightness),
        elevation: isDark ? 0 : 1,
        shadowColor: const Color(0x0D000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isDark
              ? BorderSide(color: LabColors.dividerFor(brightness), width: 1)
              : BorderSide.none,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: LabColors.dividerFor(brightness),
        thickness: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LabColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(56, 56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: LabColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: LabColors.accent,
      ),
    );
  }

  static TextTheme _buildTextTheme({
    required Color primary,
    required Color secondary,
  }) {
    final base = GoogleFonts.interTextTheme();

    TextStyle? withTabular(TextStyle? style) {
      if (style == null) return null;
      return style.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      );
    }

    final themed = base.copyWith(
      displayLarge: withTabular(base.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.1,
      )),
      displayMedium: withTabular(base.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        height: 1.15,
      )),
      displaySmall: withTabular(base.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        height: 1.2,
      )),
      headlineLarge: withTabular(base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        height: 1.2,
      )),
      headlineMedium: withTabular(base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.25,
      )),
      headlineSmall: withTabular(base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
      )),
      titleLarge: withTabular(base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.35,
      )),
      titleMedium: withTabular(base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.35,
      )),
      titleSmall: withTabular(base.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.35,
      )),
      bodyLarge: withTabular(base.bodyLarge?.copyWith(
        fontWeight: FontWeight.w400,
        height: 1.6,
      )),
      bodyMedium: withTabular(base.bodyMedium?.copyWith(
        fontWeight: FontWeight.w400,
        height: 1.6,
      )),
      bodySmall: withTabular(base.bodySmall?.copyWith(
        fontWeight: FontWeight.w400,
        height: 1.6,
      )),
      labelLarge: withTabular(base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      )),
      labelMedium: withTabular(base.labelMedium?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      )),
      labelSmall: withTabular(base.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      )),
    );

    return themed.apply(
      bodyColor: primary,
      displayColor: primary,
    ).copyWith(
      bodySmall: themed.bodySmall?.copyWith(color: secondary),
      labelMedium: themed.labelMedium?.copyWith(color: secondary),
      labelSmall: themed.labelSmall?.copyWith(color: secondary),
    );
  }
}
