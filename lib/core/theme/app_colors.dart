import 'package:flutter/material.dart';

/// Divvy Jones App Color Palette
/// Extracted from Figma design
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryPurple = Color(0xFF7938CA);
  static const Color primaryLight = Color(0xFFB7AEFF);
  static const Color primaryDark = Color(0xFF8C7DF4);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryLight, primaryDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF8F6FF),
      Color(0xFFFFFFFF),
      Color(0xFFFFF6F8),
    ],
  );

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textLink = Color(0xFF7938CA);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Border Colors
  static const Color border = Color(0xFFE5E5E5);
  static const Color borderLight = Color(0xFFF0F0F0);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Shadow
  static const Color shadowColor = Color(0x14000000); // rgba(0,0,0,0.08)

  // Social Button Colors
  static const Color googleButtonBorder = Color(0xFFE5E5E5);
  static const Color facebookButtonBorder = Color(0xFFE5E5E5);
}
