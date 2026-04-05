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
  static const darkShellColor = Color(0xFF08111F);
  static const darkPanelColor = Color(0xFF0F1A2B);
  static const darkSurfaceColor = Color(0xFF101C30);
  static const darkBorderColor = Color(0xFF22314C);
  static const darkInkColor = Color(0xFFF3F7FF);
  static const darkMutedTextColor = Color(0xFFA8B6CC);
  static const darkSoftShadow = Color(0x66000000);

  static ThemeData get dashboardTheme => _buildTheme(Brightness.light);

  static ThemeData get dashboardDarkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: frozenBlue,
      primary: frozenBlue,
      secondary: safeGreen,
      error: dangerRed,
      brightness: brightness,
      surface: isDark ? darkSurfaceColor : Colors.white,
    );

    final scaffoldColor = isDark ? darkShellColor : shellColor;
    final surfaceColor = isDark ? darkSurfaceColor : Colors.white;
    final textColor = isDark ? darkInkColor : inkColor;
    final mutedColor = isDark ? darkMutedTextColor : mutedTextColor;
    final outlineColor = isDark ? darkBorderColor : borderColor;
    final shadowColor = isDark ? darkSoftShadow : softShadow;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -0.3,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 46,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: -1.4,
        ),
        headlineMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -0.8,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: mutedColor,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: outlineColor),
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkPanelColor : const Color(0xFFFDFEFF),
        labelStyle: TextStyle(color: mutedColor),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: outlineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: outlineColor),
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
        side: BorderSide(color: outlineColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        backgroundColor: surfaceColor,
        selectedColor: isDark
            ? frozenBlue.withValues(alpha: 0.18)
            : chartBlueTint,
      ),
      dividerColor: outlineColor,
      shadowColor: shadowColor,
      canvasColor: surfaceColor,
    );
  }
}
