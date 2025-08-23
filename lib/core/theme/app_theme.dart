import 'package:flutter/material.dart';

class FormaColors {
  // Light
  static const primary = Color(0xFF2563EB);
  static const secondary = Color(0xFF22C55E);
  static const tertiary = Color(0xFFF59E0B);
  static const background = Color(0xFFF9FAFB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFF000000);
  static const outline = Color(0xFF9CA3AF);
  static const error = Color(0xFFDC2626);
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF000000);

  
  static const primaryDark = Color(0xFF3B82F6); 
  static const secondaryDark = Color(0xFF4ADE80); 
  static const tertiaryDark = Color(0xFFFBBF24); 
  static const backgroundDark = Color(0xFF1F2937); 
  static const surfaceDark = Color(0xFF374151); 
  static const surfaceVariantDark = Color(0xFF4B5563); 
  static const outlineDark = Color(0xFF6B7280); 
  static const errorDark = Color(0xFFF87171); 
  static const textPrimaryDark = Color(0xFFFFFFFF); 
  static const textSecondaryDark = Color(0xFFE5E7EB); 
}

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: FormaColors.primary,
  scaffoldBackgroundColor: FormaColors.background,
  colorScheme: ColorScheme.light(
    primary: FormaColors.primary,
    secondary: FormaColors.secondary,
    tertiary: FormaColors.tertiary,
    surface: FormaColors.surface,
    surfaceContainerHighest: FormaColors.surfaceVariant,
    onSurface: FormaColors.textPrimary,
    onSurfaceVariant: FormaColors.textSecondary,
    error: FormaColors.error,
    outline: FormaColors.outline,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: FormaColors.textPrimary),
    bodyMedium: TextStyle(color: FormaColors.textSecondary),
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: FormaColors.primaryDark,
  scaffoldBackgroundColor: FormaColors.backgroundDark,
  colorScheme: ColorScheme.dark(
    primary: FormaColors.primaryDark,
    secondary: FormaColors.secondaryDark,
    tertiary: FormaColors.tertiaryDark,
    surface: FormaColors.surfaceDark,
    background: FormaColors.backgroundDark,
    surfaceContainerHighest: FormaColors.surfaceVariantDark,
    onSurface: FormaColors.textPrimaryDark,
    onSurfaceVariant: FormaColors.textSecondaryDark,
    onBackground: FormaColors.textPrimaryDark,
    error: FormaColors.errorDark,
    outline: FormaColors.outlineDark,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: FormaColors.textPrimaryDark),
    bodyMedium: TextStyle(color: FormaColors.textSecondaryDark),
  ),
);
