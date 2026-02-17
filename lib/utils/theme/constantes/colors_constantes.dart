import 'package:flutter/material.dart';

class ColorConstantes {
  ColorConstantes._();

  // Primary Blue Palette (like reference banking app)
  static const Color primaryColor = Color(0xFF1A237E);  // Deep Indigo Blue
  static const Color primaryLight = Color(0xFF3949AB);  // Medium Indigo
  static const Color primaryDark = Color(0xFF0D1642);   // Very Dark Blue
  
  // Accent Colors
  static const Color accentGold = Color(0xFFF4C542);    // Golden Yellow (like reference)
  static const Color accentGoldLight = Color(0xFFFFD966);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FE);  // Very light blue-grey
  static const Color backgroundGarden = Color(0xFFE8EAF6);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  
  // Neutral Colors
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF1A1A2E);
  static const Color greyColor = Color(0xFF6B7280);
  static const Color greyLight = Color(0xFFE5E7EB);
  static const Color textSecondary = Color(0xFF9CA3AF);
  
  // Status Colors
  static const Color errorRed = Color(0xFFDC2626);
  static const Color successGreen = Color(0xFF10B981);

  // User Type Colors - Harmonious Professional Palette
  static const Color teacherColor = Color(0xFFE67E22);      // Warm Orange
  static const Color teacherColorLight = Color(0xFFF39C12);
  static const Color teacherColorBg = Color(0xFFFEF3E2);    // Light orange bg
  
  static const Color parentColor = Color(0xFF00897B);       // Teal
  static const Color parentColorLight = Color(0xFF26A69A);
  static const Color parentColorBg = Color(0xFFE0F2F1);     // Light teal bg
  
  static const Color studentColor = Color(0xFF3498DB);      // Sky Blue
  static const Color studentColorLight = Color(0xFF5DADE2);
  static const Color studentColorBg = Color(0xFFEBF5FB);    // Light blue bg
  
  static const Color administrativeColor = Color(0xFF8E44AD); // Rich Purple
  static const Color administrativeColorLight = Color(0xFFA569BD);
  static const Color administrativeColorBg = Color(0xFFF5EEF8); // Light purple bg

  // Compatibility Aliases
  static const Color accentColor = accentGold;
  static const Color accentSage = Color(0xFF90CAF9);
  static const Color primaryColorDark = primaryDark;
  static const Color accentColorDark = primaryDark;
  static const Color redColor = errorRed;
  static const Color redColorDark = Color(0xFF840505);

  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryLight],
  );

  static const Gradient deepBlueGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF3949AB)],
  );
  
  static const Gradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A237E), Color(0xFF303F9F)],
  );

  static const Gradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Color(0xFFF8F9FE)],
  );

  // User Type Gradients
  static Gradient getGradientForUserType(String userType) {
    switch (userType) {
      case 'Teacher':
        return const LinearGradient(
          colors: [teacherColor, teacherColorLight],
        );
      case 'Parent':
        return const LinearGradient(
          colors: [parentColor, parentColorLight],
        );
      case 'Student':
        return const LinearGradient(
          colors: [studentColor, studentColorLight],
        );
      case 'Administrative':
        return const LinearGradient(
          colors: [administrativeColor, administrativeColorLight],
        );
      default:
        return primaryGradient;
    }
  }

  static Color getColorForUserType(String userType) {
    switch (userType) {
      case 'Teacher':
        return teacherColor;
      case 'Parent':
        return parentColor;
      case 'Student':
        return studentColor;
      case 'Administrative':
        return administrativeColor;
      default:
        return primaryColor;
    }
  }
  
  static Color getBgColorForUserType(String userType) {
    switch (userType) {
      case 'Teacher':
        return teacherColorBg;
      case 'Parent':
        return parentColorBg;
      case 'Student':
        return studentColorBg;
      case 'Administrative':
        return administrativeColorBg;
      default:
        return backgroundLight;
    }
  }
}

