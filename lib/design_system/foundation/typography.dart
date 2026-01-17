import 'package:flutter/material.dart';
import 'colors.dart';

/// Banking Design System Typography
/// Modular scale typography system with comprehensive text styles
/// Optimized for banking applications with clear hierarchy and readability

class BankingTypography {
  // Private constructor to prevent instantiation
  BankingTypography._();

  // ===========================================================================
  // TYPOGRAPHY SCALE (Modular scale based on 1.25 ratio)
  // Base size: 16px (1rem)
  // ===========================================================================

  // Font sizes following modular scale
  static const double fontSizeXs = 12.0;      // 0.75rem
  static const double fontSizeSm = 14.0;      // 0.875rem
  static const double fontSizeBase = 16.0;    // 1rem
  static const double fontSizeLg = 18.0;      // 1.125rem
  static const double fontSizeXl = 20.0;      // 1.25rem
  static const double fontSize2xl = 24.0;     // 1.5rem
  static const double fontSize3xl = 30.0;     // 1.875rem
  static const double fontSize4xl = 36.0;     // 2.25rem
  static const double fontSize5xl = 48.0;     // 3rem
  static const double fontSize6xl = 60.0;     // 3.75rem
  static const double fontSize7xl = 72.0;     // 4.5rem

  // Line heights (following Material Design principles)
  static const double lineHeightTight = 1.25;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.625;

  // Letter spacing
  static const double letterSpacingTight = -0.025;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.025;
  static const double letterSpacingWider = 0.05;

  // Font weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;

  // ===========================================================================
  // DISPLAY STYLES (Hero text, large headings)
  // ===========================================================================

  static TextStyle get displayLarge => const TextStyle(
    fontSize: fontSize6xl,
    fontWeight: fontWeightBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: BankingColors.neutral900,
  );

  static TextStyle get displayMedium => const TextStyle(
    fontSize: fontSize5xl,
    fontWeight: fontWeightBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: BankingColors.neutral900,
  );

  static TextStyle get displaySmall => const TextStyle(
    fontSize: fontSize4xl,
    fontWeight: fontWeightBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: BankingColors.neutral900,
  );

  // ===========================================================================
  // HEADING STYLES (Section headers, card titles)
  // ===========================================================================

  static TextStyle get heading1 => const TextStyle(
    fontSize: fontSize3xl,
    fontWeight: fontWeightSemiBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: BankingColors.neutral900,
  );

  static TextStyle get heading2 => const TextStyle(
    fontSize: fontSize2xl,
    fontWeight: fontWeightSemiBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: BankingColors.neutral900,
  );

  static TextStyle get heading3 => const TextStyle(
    fontSize: fontSizeXl,
    fontWeight: fontWeightSemiBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
    color: BankingColors.neutral900,
  );

  static TextStyle get heading4 => const TextStyle(
    fontSize: fontSizeLg,
    fontWeight: fontWeightSemiBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
    color: BankingColors.neutral900,
  );

  // ===========================================================================
  // BODY STYLES (Main content, descriptions)
  // ===========================================================================

  static TextStyle get bodyLarge => const TextStyle(
    fontSize: fontSizeLg,
    fontWeight: fontWeightRegular,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
    color: BankingColors.neutral700,
  );

  static TextStyle get bodyRegular => const TextStyle(
    fontSize: fontSizeBase,
    fontWeight: fontWeightRegular,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
    color: BankingColors.neutral700,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontSize: fontSizeSm,
    fontWeight: fontWeightRegular,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
    color: BankingColors.neutral600,
  );

  // ===========================================================================
  // UTILITY STYLES (Labels, captions, metadata)
  // ===========================================================================

  static TextStyle get caption => const TextStyle(
    fontSize: fontSizeSm,
    fontWeight: fontWeightRegular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: BankingColors.neutral500,
  );

  static TextStyle get overline => const TextStyle(
    fontSize: fontSizeXs,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWider,
    color: BankingColors.neutral500,
    textBaseline: TextBaseline.alphabetic,
  );

  // ===========================================================================
  // SPECIALIZED STYLES (For specific banking use cases)
  // ===========================================================================

  static TextStyle get amountLarge => const TextStyle(
    fontSize: fontSize4xl,
    fontWeight: fontWeightBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: BankingColors.neutral900,
  );

  static TextStyle get amountMedium => const TextStyle(
    fontSize: fontSize2xl,
    fontWeight: fontWeightSemiBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: BankingColors.neutral900,
  );

  static TextStyle get amountSmall => const TextStyle(
    fontSize: fontSizeXl,
    fontWeight: fontWeightMedium,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: BankingColors.neutral700,
  );

  static TextStyle get label => const TextStyle(
    fontSize: fontSizeSm,
    fontWeight: fontWeightMedium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: BankingColors.neutral600,
  );

  static TextStyle get button => const TextStyle(
    fontSize: fontSizeBase,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: BankingColors.neutral0,
  );

  static TextStyle get buttonSmall => const TextStyle(
    fontSize: fontSizeSm,
    fontWeight: fontWeightSemiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: BankingColors.neutral0,
  );

  // ===========================================================================
  // SEMANTIC STYLES (For status indicators, alerts)
  // ===========================================================================

  static TextStyle get success => bodyRegular.copyWith(
    color: BankingColors.success500,
  );

  static TextStyle get warning => bodyRegular.copyWith(
    color: BankingColors.warning500,
  );

  static TextStyle get error => bodyRegular.copyWith(
    color: BankingColors.error500,
  );

  static TextStyle get info => bodyRegular.copyWith(
    color: BankingColors.info500,
  );

  // ===========================================================================
  // UTILITY METHODS
  // ===========================================================================

  /// Get text style by semantic name and optional brightness
  static TextStyle getStyle(String name, {Brightness? brightness}) {
    final isDark = brightness == Brightness.dark;

    switch (name) {
      case 'displayLarge':
        return displayLarge.copyWith(
          color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
        );
      case 'displayMedium':
        return displayMedium.copyWith(
          color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
        );
      case 'displaySmall':
        return displaySmall.copyWith(
          color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
        );
      case 'heading1':
        return heading1.copyWith(
          color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
        );
      case 'heading2':
        return heading2.copyWith(
          color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
        );
      case 'heading3':
        return heading3.copyWith(
          color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
        );
      case 'heading4':
        return heading4.copyWith(
          color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
        );
      case 'bodyLarge':
        return bodyLarge.copyWith(
          color: isDark ? BankingColors.neutral100 : BankingColors.neutral700,
        );
      case 'bodyRegular':
        return bodyRegular.copyWith(
          color: isDark ? BankingColors.neutral100 : BankingColors.neutral700,
        );
      case 'bodySmall':
        return bodySmall.copyWith(
          color: isDark ? BankingColors.neutral200 : BankingColors.neutral600,
        );
      case 'caption':
        return caption.copyWith(
          color: isDark ? BankingColors.neutral400 : BankingColors.neutral500,
        );
      case 'overline':
        return overline.copyWith(
          color: isDark ? BankingColors.neutral400 : BankingColors.neutral500,
        );
      case 'amountLarge':
        return amountLarge.copyWith(
          color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
        );
      case 'amountMedium':
        return amountMedium.copyWith(
          color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
        );
      case 'amountSmall':
        return amountSmall.copyWith(
          color: isDark ? BankingColors.neutral100 : BankingColors.neutral700,
        );
      case 'label':
        return label.copyWith(
          color: isDark ? BankingColors.neutral200 : BankingColors.neutral600,
        );
      case 'button':
        return button.copyWith(
          color: BankingColors.neutral0,
        );
      case 'buttonSmall':
        return buttonSmall.copyWith(
          color: BankingColors.neutral0,
        );
      default:
        return bodyRegular.copyWith(
          color: isDark ? BankingColors.neutral100 : BankingColors.neutral700,
        );
    }
  }

  /// Get font size by scale name
  static double getFontSize(String scale) {
    switch (scale) {
      case 'xs': return fontSizeXs;
      case 'sm': return fontSizeSm;
      case 'base': return fontSizeBase;
      case 'lg': return fontSizeLg;
      case 'xl': return fontSizeXl;
      case '2xl': return fontSize2xl;
      case '3xl': return fontSize3xl;
      case '4xl': return fontSize4xl;
      case '5xl': return fontSize5xl;
      case '6xl': return fontSize6xl;
      case '7xl': return fontSize7xl;
      default: return fontSizeBase;
    }
  }
}

/// Extension to easily apply banking typography to Text widgets
extension BankingTextStyle on TextStyle {
  /// Apply banking color theme based on brightness
  TextStyle withBankingColor(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return copyWith(
      color: color ?? (isDark ? BankingColors.neutral100 : BankingColors.neutral700),
    );
  }

  /// Make text bold
  TextStyle get bold => copyWith(fontWeight: BankingTypography.fontWeightBold);

  /// Make text semi-bold
  TextStyle get semiBold => copyWith(fontWeight: BankingTypography.fontWeightSemiBold);

  /// Make text medium weight
  TextStyle get medium => copyWith(fontWeight: BankingTypography.fontWeightMedium);

  /// Apply success color
  TextStyle get success => copyWith(color: BankingColors.success500);

  /// Apply error color
  TextStyle get error => copyWith(color: BankingColors.error500);

  /// Apply warning color
  TextStyle get warning => copyWith(color: BankingColors.warning500);

  /// Apply info color
  TextStyle get info => copyWith(color: BankingColors.info500);
}

