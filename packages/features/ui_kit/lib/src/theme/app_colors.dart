import 'package:flutter/material.dart';

abstract class AppColors {
  // Base
  static const Color background = Color(0xFF050505); // Deep almost black
  static const Color surface = Color(0xFF141414);    // Slightly lighter for cards (fallback)
  
  // Glassmorphism
  static const Color glassBackground = Color(0x1AFFFFFF); // 10% White
  static const Color glassBorder = Color(0x33FFFFFF);     // 20% White
  static const Color glassSelection = Color(0x66FFFFFF);  // 40% White (Selection)

  // Status & Accents (High Contrast Neon)
  static const Color primary = Color(0xFF2E86AB);       // Clinical Blue
  static const Color accent = Color(0xFFF18F01);        // Amber attention
  static const Color success = Color(0xFF06D6A0);       // Neon Green
  static const Color alert = Color(0xFFEF476F);         // Neon Red
  static const Color textMain = Color(0xFFEAEAEA);      // Off-white text
  static const Color textMuted = Color(0xFF888888);     // Muted text

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2E86AB), Color(0xFF1B4F72)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
