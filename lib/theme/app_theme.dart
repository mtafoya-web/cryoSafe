import 'package:flutter/material.dart';

class AppTheme {
  static const frozenBlue = Color(0xFF1D4ED8);
  static const electricBlue = Color(0xFF4F7BFF);
  static const safeGreen = Color(0xFF16A34A);
  static const dangerRed = Color(0xFFDC2626);
  static const violetInk = Color(0xFF44337A);
  static const mintGlow = Color(0xFFDDFCF0);
  static const chartBlueTint = Color(0xFFEAF2FF);
  static const chartGreenTint = Color(0xFFECFDF3);
  static const chartRedTint = Color(0xFFFEF2F2);
  static const panelColor = Color(0xFFF8FAFC);
  static const shellColor = Color(0xFFF4F7FB);
  static const inkColor = Color(0xFF0F172A);
  static const mutedTextColor = Color(0xFF475569);
  static const borderColor = Color(0xFFDCE3EC);
  static const softShadow = Color(0x140F172A);

  static ThemeData get dashboardTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: frozenBlue,
      primary: frozenBlue,
      secondary: safeGreen,
      error: dangerRed,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: shellColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: inkColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: inkColor,
          letterSpacing: -0.3,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 46,
          fontWeight: FontWeight.w800,
          color: inkColor,
          letterSpacing: -1.4,
        ),
        headlineMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: inkColor,
          letterSpacing: -0.8,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: inkColor,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: inkColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: inkColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: mutedTextColor,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: inkColor,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFDFEFF),
        labelStyle: const TextStyle(color: mutedTextColor),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: frozenBlue, width: 1.4),
        ),
      ),
      sliderTheme: const SliderThemeData(
        showValueIndicator: ShowValueIndicator.onDrag,
        trackHeight: 5,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 9),
      ),
      chipTheme: ChipThemeData(
        side: const BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        backgroundColor: Colors.white,
        selectedColor: chartBlueTint,
      ),
      dividerColor: borderColor,
    );
  }
}
