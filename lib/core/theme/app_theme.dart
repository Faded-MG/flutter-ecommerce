import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const stallGreen = Color(0xFF2E4B3F);
  static const background = Color(0xFFF5F7F5);
  static const cardWhite = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1A1A1A);
  static const muted = Color(0xFF6B7280);
  static const starGold = Color(0xFFFBBF24);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.stallGreen,
        primary: AppColors.stallGreen,
        secondary: AppColors.starGold,
        surface: AppColors.cardWhite,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.stallGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          color: AppColors.ink,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13,
          color: AppColors.ink,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.muted,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.stallGreen,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.stallGreen, width: 2),
        ),
      ),
    );
  }
}