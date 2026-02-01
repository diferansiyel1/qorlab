import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// QorLab Typography System
/// Based on stich design reference files
/// Display: Space Grotesk, Mono: JetBrains Mono
abstract class AppTypography {
  // Headlines - Space Grotesk (from stich)
  static TextStyle get headlineLarge => GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textMain,
        letterSpacing: -0.5,
        height: 1.15,
      );

  static TextStyle get headlineMedium => GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textMain,
        letterSpacing: -0.3,
        height: 1.2,
      );

  static TextStyle get headlineSmall => GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain,
        letterSpacing: -0.2,
        height: 1.25,
      );

  // Labels - Space Grotesk
  static TextStyle get labelLarge => GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain,
        height: 1.4,
      );

  static TextStyle get labelMedium => GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
        height: 1.4,
      );

  static TextStyle get labelSmall => GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
        height: 1.4,
      );

  // Uppercase Labels (from stich - category headers)
  static TextStyle get labelUppercase => GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        letterSpacing: 1.5,
        height: 1.2,
      );

  static TextStyle get labelUppercasePrimary => GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        letterSpacing: 1.5,
        height: 1.2,
      );

  // Experiment Code Style (from stich - "EXP-001" labels)
  static TextStyle get experimentCode => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
        letterSpacing: 0.5,
        height: 1.2,
      );

  static TextStyle get experimentCodeMuted => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
        letterSpacing: 0.5,
        height: 1.2,
      );

  // Data / Numbers - JetBrains Mono (Scientific data display)
  static TextStyle get dataXLarge => GoogleFonts.jetBrainsMono(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        height: 1.1,
      );

  static TextStyle get dataLarge => GoogleFonts.jetBrainsMono(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: AppColors.accent,
        height: 1.2,
      );

  static TextStyle get dataMedium => GoogleFonts.jetBrainsMono(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.textMain,
        height: 1.3,
      );

  static TextStyle get dataSmall => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.4,
      );

  // Timestamp Style (from stich timeline)
  static TextStyle get timestamp => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.2,
      );

  // Status Badge Style (from stich)
  static TextStyle get statusBadge => GoogleFonts.spaceGrotesk(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        height: 1.2,
      );

  // Body Text
  static TextStyle get bodyMedium => GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textMain,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.5,
      );

  // Unit Labels (from stich input fields - "mg/kg", "mL")
  static TextStyle get unitLabel => GoogleFonts.jetBrainsMono(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        height: 1.2,
      );
}
