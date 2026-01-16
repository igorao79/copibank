import 'package:flutter/material.dart';

/// Banking Design System Colors
/// Complete color palette with primary, secondary, neutral, and semantic colors
/// All colors work in both light and dark themes

class BankingColors {
  // Private constructor to prevent instantiation
  BankingColors._();

  // ===========================================================================
  // PRIMARY COLORS (Light blue palette for light theme, Dark blue for dark theme)
  // ===========================================================================

  static const Color primary50 = Color(0xFFE3F2FD);   // Very light blue
  static const Color primary100 = Color(0xFFBBDEFB);  // Light blue
  static const Color primary200 = Color(0xFF90CAF9);  // Lighter blue
  static const Color primary300 = Color(0xFF64B5F6);  // Light medium blue
  static const Color primary400 = Color(0xFF42A5F5);  // Medium light blue
  static const Color primary500 = Color(0xFF2196F3);  // Main light blue
  static const Color primary600 = Color(0xFF1E88E5);  // Medium blue
  static const Color primary700 = Color(0xFF1976D2);  // Darker blue
  static const Color primary800 = Color(0xFF1565C0);  // Dark blue
  static const Color primary900 = Color(0xFF0D47A1);  // Very dark blue

  // ===========================================================================
  // SECONDARY COLORS (Teal accent)
  // ===========================================================================

  static const Color secondary50 = Color(0xFFE8F8F5);
  static const Color secondary100 = Color(0xFFCCF0EB);
  static const Color secondary200 = Color(0xFF99E0D7);
  static const Color secondary300 = Color(0xFF66D1C3);
  static const Color secondary400 = Color(0xFF33C1AF);
  static const Color secondary500 = Color(0xFF00B29B); // Main secondary
  static const Color secondary600 = Color(0xFF008F7C);
  static const Color secondary700 = Color(0xFF006C5D);
  static const Color secondary800 = Color(0xFF00493E);
  static const Color secondary900 = Color(0xFF00261F);

  // ===========================================================================
  // NEUTRAL COLORS (12 shades for comprehensive coverage)
  // ===========================================================================

  static const Color neutral0 = Color(0xFFFFFFFF);   // Pure white
  static const Color neutral25 = Color(0xFFFCFCFD);  // Off white
  static const Color neutral50 = Color(0xFFF9FAFB);  // Very light gray
  static const Color neutral100 = Color(0xFFF3F4F6); // Light gray
  static const Color neutral200 = Color(0xFFE5E7EB); // Light medium gray
  static const Color neutral300 = Color(0xFFD1D5DB); // Medium light gray
  static const Color neutral400 = Color(0xFF9CA3AF); // Medium gray
  static const Color neutral500 = Color(0xFF6B7280); // Base gray
  static const Color neutral600 = Color(0xFF4B5563); // Medium dark gray
  static const Color neutral700 = Color(0xFF374151); // Dark gray
  static const Color neutral800 = Color(0xFF1F2937); // Very dark gray
  static const Color neutral900 = Color(0xFF111827); // Almost black
  static const Color neutral950 = Color(0xFF030712); // Pure black for text

  // ===========================================================================
  // SEMANTIC COLORS (Success, Warning, Error, Info - 5 shades each)
  // ===========================================================================

  // Success (Green)
  static const Color success50 = Color(0xFFE8F5E8);
  static const Color success100 = Color(0xFFD1E7DD);
  static const Color success200 = Color(0xFFA3CFBB);
  static const Color success300 = Color(0xFF75B798);
  static const Color success400 = Color(0xFF479F76);
  static const Color success500 = Color(0xFF198754); // Main success

  // Warning (Orange/Amber)
  static const Color warning50 = Color(0xFFFFF8E1);
  static const Color warning100 = Color(0xFFFFECB3);
  static const Color warning200 = Color(0xFFFFE082);
  static const Color warning300 = Color(0xFFFFD54F);
  static const Color warning400 = Color(0xFFFFCA28);
  static const Color warning500 = Color(0xFFFFC107); // Main warning

  // Error (Red)
  static const Color error50 = Color(0xFFFFEBEE);
  static const Color error100 = Color(0xFFFFCDD2);
  static const Color error200 = Color(0xFFEF9A9A);
  static const Color error300 = Color(0xFFE57373);
  static const Color error400 = Color(0xFFEF5350);
  static const Color error500 = Color(0xFFF44336); // Main error
  static const Color error600 = Color(0xFFE53935);
  static const Color error700 = Color(0xFFD32F2F);
  static const Color error800 = Color(0xFFC62828);
  static const Color error900 = Color(0xFFB71C1C);

  // Info (Blue)
  static const Color info50 = Color(0xFFE3F2FD);
  static const Color info100 = Color(0xFFBBDEFB);
  static const Color info200 = Color(0xFF90CAF9);
  static const Color info300 = Color(0xFF64B5F6);
  static const Color info400 = Color(0xFF42A5F5);
  static const Color info500 = Color(0xFF2196F3); // Main info

  // ===========================================================================
  // SPECIAL BANKING COLORS
  // ===========================================================================

  // Money/Positive amounts
  static const Color positiveAmount = Color(0xFF198754);
  static const Color positiveAmountLight = Color(0xFFE8F5E8);

  // Money/Negative amounts
  static const Color negativeAmount = Color(0xFFF44336);
  static const Color negativeAmountLight = Color(0xFFFFEBEE);

  // Card backgrounds
  static const Color cardGradientStart = Color(0xFF667EEA);
  static const Color cardGradientEnd = Color(0xFF764BA2);

  // ===========================================================================
  // UTILITY METHODS
  // ===========================================================================

  /// Get primary color by shade (50-900)
  static Color getPrimaryShade(int shade) {
    switch (shade) {
      case 50: return primary50;
      case 100: return primary100;
      case 200: return primary200;
      case 300: return primary300;
      case 400: return primary400;
      case 500: return primary500;
      case 600: return primary600;
      case 700: return primary700;
      case 800: return primary800;
      case 900: return primary900;
      default: return primary500;
    }
  }

  /// Get secondary color by shade (50-900)
  static Color getSecondaryShade(int shade) {
    switch (shade) {
      case 50: return secondary50;
      case 100: return secondary100;
      case 200: return secondary200;
      case 300: return secondary300;
      case 400: return secondary400;
      case 500: return secondary500;
      case 600: return secondary600;
      case 700: return secondary700;
      case 800: return secondary800;
      case 900: return secondary900;
      default: return secondary500;
    }
  }

  /// Get neutral color by shade (0, 25, 50, 100-900, 950)
  static Color getNeutralShade(int shade) {
    switch (shade) {
      case 0: return neutral0;
      case 25: return neutral25;
      case 50: return neutral50;
      case 100: return neutral100;
      case 200: return neutral200;
      case 300: return neutral300;
      case 400: return neutral400;
      case 500: return neutral500;
      case 600: return neutral600;
      case 700: return neutral700;
      case 800: return neutral800;
      case 900: return neutral900;
      case 950: return neutral950;
      default: return neutral500;
    }
  }
}

/// Extension methods for easier color usage
extension BankingColorExtension on Color {
  /// Check if color is light (for determining text color contrast)
  bool get isLight => computeLuminance() > 0.5;

  /// Get appropriate text color for this background
  Color get onColor => isLight ? BankingColors.neutral900 : BankingColors.neutral0;
}
