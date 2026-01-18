import 'package:flutter/material.dart';
import 'colors.dart';

/// Banking Design System Tokens
/// Spacing, border radius, shadows, and other design tokens
/// Consistent values used throughout the banking application

class BankingTokens {
  // Private constructor to prevent instantiation
  BankingTokens._();

  // ===========================================================================
  // SPACING SCALE (4px base unit, 8 levels)
  // ===========================================================================

  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;
  static const double space80 = 80.0;
  static const double space96 = 96.0;

  // ===========================================================================
  // BORDER RADIUS SCALE (4 levels)
  // ===========================================================================

  static const double borderRadiusSmall = 4.0;   // Small elements, chips
  static const double borderRadiusMedium = 8.0;  // Cards, buttons
  static const double borderRadiusLarge = 12.0;  // Large cards, dialogs
  static const double borderRadiusFull = 9999.0; // Pills, circular elements

  // Additional radius values for specific use cases
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;

  // ===========================================================================
  // BORDER WIDTH SCALE
  // ===========================================================================

  static const double borderWidthThin = 0.5;
  static const double borderWidthNormal = 1.0;
  static const double borderWidthThick = 2.0;

  // ===========================================================================
  // SHADOWS SCALE (4 elevation levels)
  // ===========================================================================

  // Level 1 - Subtle shadow for cards
  static List<BoxShadow> get shadowLevel1 => [
    BoxShadow(
      color: BankingColors.neutral900.withOpacity(0.08),
      blurRadius: 4.0,
      offset: const Offset(0, 1),
    ),
  ];

  // Level 2 - Medium shadow for elevated elements
  static List<BoxShadow> get shadowLevel2 => [
    BoxShadow(
      color: BankingColors.neutral900.withOpacity(0.12),
      blurRadius: 8.0,
      offset: const Offset(0, 2),
    ),
  ];

  // Level 3 - Strong shadow for floating elements
  static List<BoxShadow> get shadowLevel3 => [
    BoxShadow(
      color: BankingColors.neutral900.withOpacity(0.16),
      blurRadius: 16.0,
      offset: const Offset(0, 4),
    ),
  ];

  // Level 4 - Heavy shadow for modals and overlays
  static List<BoxShadow> get shadowLevel4 => [
    BoxShadow(
      color: BankingColors.neutral900.withOpacity(0.20),
      blurRadius: 24.0,
      offset: const Offset(0, 8),
    ),
  ];

  // ===========================================================================
  // COMPONENT SIZES
  // ===========================================================================

  // Button sizes
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 44.0;
  static const double buttonHeightLarge = 52.0;

  // Input field sizes
  static const double inputHeightSmall = 40.0;
  static const double inputHeightMedium = 48.0;
  static const double inputHeightLarge = 56.0;

  // Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXLarge = 32.0;

  // Avatar sizes
  static const double avatarSizeSmall = 24.0;
  static const double avatarSizeMedium = 32.0;
  static const double avatarSizeLarge = 40.0;
  static const double avatarSizeXLarge = 56.0;

  // ===========================================================================
  // ANIMATION DURATIONS
  // ===========================================================================

  static const Duration durationInstant = Duration(milliseconds: 0);
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 350);

  // ===========================================================================
  // CARD DIMENSIONS
  // ===========================================================================

  // Account card
  static const double accountCardHeight = 160.0;
  static const double accountCardWidth = double.infinity;

  // Transaction card
  static const double transactionCardHeight = 72.0;

  // Quick action card
  static const double quickActionCardSize = 80.0;

  // ===========================================================================
  // CHART DIMENSIONS
  // ===========================================================================

  static const double chartHeightSmall = 120.0;
  static const double chartHeightMedium = 200.0;
  static const double chartHeightLarge = 300.0;

  // ===========================================================================
  // LAYOUT CONSTANTS
  // ===========================================================================

  // Screen padding
  static const double screenHorizontalPadding = space16;
  static const double screenVerticalPadding = space16;

  // Content max width for large screens
  static const double contentMaxWidth = 1200.0;

  // Bottom navigation height
  static const double bottomNavigationHeight = 80.0;

  // App bar height
  static const double appBarHeight = 56.0;

  // ===========================================================================
  // Z-INDEX LAYERS (Elevation values)
  // ===========================================================================

  static const double zIndexBase = 0.0;
  static const double zIndexCard = 1.0;
  static const double zIndexAppBar = 2.0;
  static const double zIndexModal = 3.0;
  static const double zIndexTooltip = 4.0;
  static const double zIndexDropdown = 5.0;

  // ===========================================================================
  // BORDER STYLES
  // ===========================================================================

  static Border get thinBorder => Border.all(
    color: BankingColors.neutral200,
    width: borderWidthThin,
  );

  static Border get normalBorder => Border.all(
    color: BankingColors.neutral200,
    width: borderWidthNormal,
  );

  static Border get thickBorder => Border.all(
    color: BankingColors.neutral200,
    width: borderWidthThick,
  );

  static Border get focusBorder => Border.all(
    color: BankingColors.primary500,
    width: borderWidthNormal,
  );

  static Border get errorBorder => Border.all(
    color: BankingColors.error500,
    width: borderWidthNormal,
  );

  // ===========================================================================
  // UTILITY METHODS
  // ===========================================================================

  /// Get spacing value by scale name
  static double getSpacing(String scale) {
    switch (scale) {
      case '4': return space4;
      case '8': return space8;
      case '12': return space12;
      case '16': return space16;
      case '24': return space24;
      case '32': return space32;
      case '48': return space48;
      case '64': return space64;
      case '80': return space80;
      case '96': return space96;
      default: return space16;
    }
  }

  /// Get border radius by size name
  static double getBorderRadius(String size) {
    switch (size) {
      case 'small': return borderRadiusSmall;
      case 'medium': return borderRadiusMedium;
      case 'large': return borderRadiusLarge;
      case 'full': return borderRadiusFull;
      default: return borderRadiusMedium;
    }
  }

  /// Get shadow by elevation level
  static List<BoxShadow> getShadow(int level) {
    switch (level) {
      case 1: return shadowLevel1;
      case 2: return shadowLevel2;
      case 3: return shadowLevel3;
      case 4: return shadowLevel4;
      default: return shadowLevel1;
    }
  }

  /// Get button height by size name
  static double getButtonHeight(String size) {
    switch (size) {
      case 'small': return buttonHeightSmall;
      case 'medium': return buttonHeightMedium;
      case 'large': return buttonHeightLarge;
      default: return buttonHeightMedium;
    }
  }

  /// Get input height by size name
  static double getInputHeight(String size) {
    switch (size) {
      case 'small': return inputHeightSmall;
      case 'medium': return inputHeightMedium;
      case 'large': return inputHeightLarge;
      default: return inputHeightMedium;
    }
  }

  /// Get icon size by scale name
  static double getIconSize(String scale) {
    switch (scale) {
      case 'small': return iconSizeSmall;
      case 'medium': return iconSizeMedium;
      case 'large': return iconSizeLarge;
      case 'xlarge': return iconSizeXLarge;
      default: return iconSizeMedium;
    }
  }

  /// Get avatar size by scale name
  static double getAvatarSize(String scale) {
    switch (scale) {
      case 'small': return avatarSizeSmall;
      case 'medium': return avatarSizeMedium;
      case 'large': return avatarSizeLarge;
      case 'xlarge': return avatarSizeXLarge;
      default: return avatarSizeMedium;
    }
  }
}

/// Extension methods for easier token usage
extension BankingTokenExtension on num {
  /// Convert number to spacing token
  double get spacing => BankingTokens.getSpacing(toString());

  /// Convert number to border radius
  double get radius => BankingTokens.getBorderRadius(toString());
}

