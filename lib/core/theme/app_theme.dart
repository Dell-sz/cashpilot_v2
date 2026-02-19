// Placeholder for theme
import 'package:flutter/material.dart';

class Imons {
  static const total_balance = Icons.account_balance_wallet;
}

class AppColors {
  static const primary = Color(0xFF667EEA);
  static const primaryLight = Color(0xFF8198F0);
  static const primaryDark = Color(0xFF4C63B6);

  static const secondary = Color(0xFF764BA2);
  static const secondaryLight = Color(0xFF9B6BC2);
  static const secondaryDark = Color(0xFF5A3A7A);

  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  static const background = Color(0xFF0F172A);
  static const surface = Color(0xFF1E293B);
  static const surfaceLight = Color(0xFF334155);
  static const text = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF94A3B8);
  static const border = Color(0x1AFFFFFF);
}

class AppTheme {
  static ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.text,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.text,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
    ),
  );
}
