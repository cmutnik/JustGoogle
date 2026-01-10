import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  AppColors._();

  // Primary Colors - Classic Google-inspired blue
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryLight = Color(0xFF4285F4);
  static const Color primaryDark = Color(0xFF174EA6);

  // Secondary Colors - Subtle accent
  static const Color secondary = Color(0xFF5F6368);
  static const Color secondaryLight = Color(0xFF9AA0A6);
  static const Color secondaryDark = Color(0xFF3C4043);

  // Success Color - For positive actions
  static const Color success = Color(0xFF1E8E3E);

  // Error Color - For errors and warnings
  static const Color error = Color(0xFFD93025);

  // Warning Color
  static const Color warning = Color(0xFFF9AB00);

  // Info Color
  static const Color info = Color(0xFF1A73E8);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8F9FA);
  static const Color lightSurfaceVariant = Color(0xFFE8EAED);
  static const Color lightOnBackground = Color(0xFF202124);
  static const Color lightOnSurface = Color(0xFF202124);
  static const Color lightOnSurfaceVariant = Color(0xFF5F6368);
  static const Color lightDivider = Color(0xFFDADCE0);
  static const Color lightBorder = Color(0xFFDADCE0);
  static const Color lightShadow = Color(0x1A000000);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF202124);
  static const Color darkSurface = Color(0xFF292A2D);
  static const Color darkSurfaceVariant = Color(0xFF3C4043);
  static const Color darkOnBackground = Color(0xFFE8EAED);
  static const Color darkOnSurface = Color(0xFFE8EAED);
  static const Color darkOnSurfaceVariant = Color(0xFF9AA0A6);
  static const Color darkDivider = Color(0xFF5F6368);
  static const Color darkBorder = Color(0xFF5F6368);
  static const Color darkShadow = Color(0x33000000);

  // Link Colors (Google-style)
  static const Color linkBlue = Color(0xFF1A73E8);
  static const Color linkGreen = Color(0xFF188038);
  static const Color visitedPurple = Color(0xFF681DA8);

  // Result Card Colors
  static const Color resultTitleBlue = Color(0xFF1A0DAB);
  static const Color resultUrlGreen = Color(0xFF006621);
  static const Color resultSnippetGray = Color(0xFF4D5156);

  // Shimmer Colors (for loading states)
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF3C4043);
  static const Color shimmerHighlightDark = Color(0xFF5F6368);
}
