import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// QorLab Typography System
/// Display: Inter
abstract class AppTypography {
  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  static TextStyle _style({
    required double size,
    required FontWeight weight,
    required Color color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      fontFeatures: _tabular,
    );
  }

  // Headlines
  static TextStyle get headlineLarge => _style(
        size: 28,
        weight: FontWeight.w700,
        color: AppColors.textMain,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get headlineMedium => _style(
        size: 20,
        weight: FontWeight.w700,
        color: AppColors.textMain,
        letterSpacing: -0.3,
        height: 1.25,
      );

  static TextStyle get headlineSmall => _style(
        size: 18,
        weight: FontWeight.w600,
        color: AppColors.textMain,
        letterSpacing: -0.2,
        height: 1.3,
      );

  // Labels
  static TextStyle get labelLarge => _style(
        size: 16,
        weight: FontWeight.w600,
        color: AppColors.textMain,
        height: 1.4,
      );

  static TextStyle get labelMedium => _style(
        size: 14,
        weight: FontWeight.w500,
        color: AppColors.textMuted,
        height: 1.4,
      );

  static TextStyle get labelSmall => _style(
        size: 12,
        weight: FontWeight.w500,
        color: AppColors.textMuted,
        height: 1.4,
      );

  // Uppercase Labels
  static TextStyle get labelUppercase => _style(
        size: 12,
        weight: FontWeight.w700,
        color: AppColors.textMuted,
        letterSpacing: 1.2,
        height: 1.2,
      );

  static TextStyle get labelUppercasePrimary => _style(
        size: 12,
        weight: FontWeight.w700,
        color: AppColors.primary,
        letterSpacing: 1.2,
        height: 1.2,
      );

  // Experiment Code Style
  static TextStyle get experimentCode => _style(
        size: 12,
        weight: FontWeight.w500,
        color: AppColors.primary,
        letterSpacing: 0.4,
        height: 1.2,
      );

  static TextStyle get experimentCodeMuted => _style(
        size: 12,
        weight: FontWeight.w500,
        color: AppColors.textMuted,
        letterSpacing: 0.4,
        height: 1.2,
      );

  // Data / Numbers
  static TextStyle get dataXLarge => _style(
        size: 46,
        weight: FontWeight.w700,
        color: AppColors.primary,
        height: 1.1,
      );

  static TextStyle get dataLarge => _style(
        size: 26,
        weight: FontWeight.w600,
        color: AppColors.accent,
        height: 1.2,
      );

  static TextStyle get dataMedium => _style(
        size: 18,
        weight: FontWeight.w500,
        color: AppColors.textMain,
        height: 1.3,
      );

  static TextStyle get dataSmall => _style(
        size: 14,
        weight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.4,
      );

  // Timestamp Style
  static TextStyle get timestamp => _style(
        size: 12,
        weight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.2,
      );

  // Status Badge Style
  static TextStyle get statusBadge => _style(
        size: 10,
        weight: FontWeight.w700,
        color: AppColors.textMain,
        letterSpacing: 0.8,
        height: 1.2,
      );

  // Body Text
  static TextStyle get bodyMedium => _style(
        size: 14,
        weight: FontWeight.w400,
        color: AppColors.textMain,
        height: 1.6,
      );

  static TextStyle get bodySmall => _style(
        size: 12,
        weight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.6,
      );

  // Unit Labels
  static TextStyle get unitLabel => _style(
        size: 16,
        weight: FontWeight.w700,
        color: AppColors.textMuted,
        height: 1.2,
      );
}
