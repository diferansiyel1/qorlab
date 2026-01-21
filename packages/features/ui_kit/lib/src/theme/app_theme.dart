import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../ui_kit.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
      primaryColor: const Color(0xFF2DD4BF), // Teal 400
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF2DD4BF),
        secondary: Color(0xFF38BDF8), // Sky 400
        surface: Color(0xFF1E293B), // Slate 800
        background: Color(0xFF0F172A),
        error: Color(0xFFF43F5E), // Rose 500
        onPrimary: Colors.black,
      ),
      fontFamily: GoogleFonts.outfit().fontFamily,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: const Color(0xFFE2E8F0), // Slate 200
        displayColor: const Color(0xFFF1F5F9), // Slate 100
      ),
      // cardTheme: CardTheme(
      //   color: const Color(0xFF1E293B).withOpacity(0.7),
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(16),
      //     side: BorderSide(color: Colors.white.withOpacity(0.1)),
      //   ),
      // ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2DD4BF)),
        ),
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)), // Slate 400
      ),
    );
  }
}
