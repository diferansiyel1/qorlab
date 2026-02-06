import 'package:flutter/material.dart';

/// QorLab Lab System Colors
/// Static getters that switch based on active brightness.
abstract class LabColors {
  static Brightness _brightness = Brightness.light;

  static void setBrightness(Brightness brightness) {
    _brightness = brightness;
  }

  static Brightness get brightness => _brightness;

  static bool get _isDark => _brightness == Brightness.dark;

  static Color backgroundFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF000000)
        : const Color(0xFFF2F2F7);
  }

  static Color surfaceFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF1C1C1E)
        : const Color(0xFFFFFFFF);
  }

  static Color textPrimaryFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF000000);
  }

  static Color textSecondaryFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF9A9AA1)
        : const Color(0xFF8E8E93);
  }

  static Color dividerFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF38383A)
        : const Color(0xFFC6C6C8);
  }

  static const Color accent = Color(0xFF0A84FF);
  static const Color error = Color(0xFFFF453A);

  static Color get background => backgroundFor(_brightness);
  static Color get surface => surfaceFor(_brightness);
  static Color get textPrimary => textPrimaryFor(_brightness);
  static Color get textSecondary => textSecondaryFor(_brightness);
  static Color get divider => dividerFor(_brightness);
}
