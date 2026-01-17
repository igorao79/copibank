import 'package:flutter/material.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';

/// Banking Design System Theme
/// Complete Material theme implementation with light and dark variants
/// Optimized for banking applications with proper contrast and accessibility

class BankingTheme {
  // Private constructor to prevent instantiation
  BankingTheme._();

  // ===========================================================================
  // LIGHT THEME
  // ===========================================================================

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color Scheme - Light theme with light blue accents
    colorScheme: const ColorScheme.light(
      primary: BankingColors.primary600,
      onPrimary: BankingColors.neutral0,
      primaryContainer: BankingColors.primary100,
      onPrimaryContainer: BankingColors.primary800,

      secondary: BankingColors.primary400,
      onSecondary: BankingColors.neutral0,
      secondaryContainer: BankingColors.primary50,
      onSecondaryContainer: BankingColors.primary700,

      tertiary: BankingColors.neutral600,
      onTertiary: BankingColors.neutral0,
      tertiaryContainer: BankingColors.neutral100,
      onTertiaryContainer: BankingColors.neutral900,

      error: BankingColors.error500,
      onError: BankingColors.neutral0,
      errorContainer: BankingColors.error100,
      onErrorContainer: BankingColors.error900,

      surface: BankingColors.neutral0,          // White background
      onSurface: BankingColors.neutral900,
      surfaceVariant: BankingColors.primary50,   // Light blue surface tint
      onSurfaceVariant: BankingColors.primary700,

      outline: BankingColors.primary200,
      outlineVariant: BankingColors.primary100,

      shadow: BankingColors.neutral900,
      scrim: BankingColors.neutral900,

      inverseSurface: BankingColors.neutral900,
      onInverseSurface: BankingColors.neutral0,
      inversePrimary: BankingColors.primary300,

      surfaceTint: BankingColors.primary400,
    ),

    // Typography - Light Theme TextTheme
    textTheme: TextTheme(
      // Display styles
      displayLarge: BankingTypography.displayLarge.copyWith(color: BankingColors.neutral900),
      displayMedium: BankingTypography.displayMedium.copyWith(color: BankingColors.neutral900),
      displaySmall: BankingTypography.displaySmall.copyWith(color: BankingColors.neutral900),

      // Headings
      headlineLarge: BankingTypography.heading1.copyWith(color: BankingColors.neutral900),
      headlineMedium: BankingTypography.heading2.copyWith(color: BankingColors.neutral900),
      headlineSmall: BankingTypography.heading3.copyWith(color: BankingColors.neutral900),
      titleLarge: BankingTypography.heading4.copyWith(color: BankingColors.neutral900),

      // Body text
      titleMedium: BankingTypography.bodyLarge.copyWith(color: BankingColors.neutral700),
      titleSmall: BankingTypography.bodyRegular.copyWith(color: BankingColors.neutral700),
      bodyLarge: BankingTypography.bodyLarge.copyWith(color: BankingColors.neutral700),
      bodyMedium: BankingTypography.bodyRegular.copyWith(color: BankingColors.neutral700),
      bodySmall: BankingTypography.bodySmall.copyWith(color: BankingColors.neutral600),

      // Utility
      labelSmall: BankingTypography.caption.copyWith(color: BankingColors.neutral500),
      labelMedium: BankingTypography.label.copyWith(color: BankingColors.neutral600),
      labelLarge: BankingTypography.button.copyWith(color: BankingColors.neutral0),
    ),

    // Component Themes
    appBarTheme: _buildAppBarTheme(Brightness.light),
    bottomNavigationBarTheme: _buildBottomNavigationBarTheme(Brightness.light),
    cardTheme: _buildCardTheme(Brightness.light),
    elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.light),
    outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.light),
    textButtonTheme: _buildTextButtonTheme(Brightness.light),
    inputDecorationTheme: _buildInputDecorationTheme(Brightness.light),
    tabBarTheme: _buildTabBarTheme(Brightness.light),
    dialogTheme: _buildDialogTheme(Brightness.light),
    bottomSheetTheme: _buildBottomSheetTheme(Brightness.light),

    // Other properties
    scaffoldBackgroundColor: BankingColors.primary50, // Light blue background for light theme
    dividerColor: BankingColors.primary200,
    dividerTheme: const DividerThemeData(
      thickness: BankingTokens.borderWidthThin,
      space: BankingTokens.space16,
    ),

    // Custom extensions
    extensions: [
      BankingThemeExtension.light,
    ],
  );

  // ===========================================================================
  // DARK THEME
  // ===========================================================================

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme - Dark theme with dark blue accents
    colorScheme: const ColorScheme.dark(
      primary: BankingColors.primary400,
      onPrimary: BankingColors.neutral0,
      primaryContainer: BankingColors.primary800,
      onPrimaryContainer: BankingColors.primary100,

      secondary: BankingColors.primary600,
      onSecondary: BankingColors.neutral0,
      secondaryContainer: BankingColors.primary900,
      onSecondaryContainer: BankingColors.primary100,

      tertiary: BankingColors.neutral300,
      onTertiary: BankingColors.neutral900,
      tertiaryContainer: BankingColors.neutral700,
      onTertiaryContainer: BankingColors.neutral100,

      error: BankingColors.error400,
      onError: BankingColors.neutral0,
      errorContainer: BankingColors.error800,
      onErrorContainer: BankingColors.error100,

      surface: BankingColors.primary900,        // Dark blue background
      onSurface: BankingColors.neutral0,
      surfaceVariant: BankingColors.primary800,  // Darker blue surface
      onSurfaceVariant: BankingColors.primary200,

      outline: BankingColors.primary600,
      outlineVariant: BankingColors.primary700,

      shadow: BankingColors.neutral900,
      scrim: BankingColors.neutral900,

      inverseSurface: BankingColors.neutral0,
      onInverseSurface: BankingColors.primary900,
      inversePrimary: BankingColors.primary300,

      surfaceTint: BankingColors.primary500,
    ),

    // Typography - Dark Theme TextTheme
    textTheme: TextTheme(
      // Display styles
      displayLarge: BankingTypography.displayLarge.copyWith(color: BankingColors.neutral0),
      displayMedium: BankingTypography.displayMedium.copyWith(color: BankingColors.neutral0),
      displaySmall: BankingTypography.displaySmall.copyWith(color: BankingColors.neutral0),

      // Headings
      headlineLarge: BankingTypography.heading1.copyWith(color: BankingColors.neutral0),
      headlineMedium: BankingTypography.heading2.copyWith(color: BankingColors.neutral0),
      headlineSmall: BankingTypography.heading3.copyWith(color: BankingColors.neutral0),
      titleLarge: BankingTypography.heading4.copyWith(color: BankingColors.neutral0),

      // Body text
      titleMedium: BankingTypography.bodyLarge.copyWith(color: BankingColors.neutral100),
      titleSmall: BankingTypography.bodyRegular.copyWith(color: BankingColors.neutral100),
      bodyLarge: BankingTypography.bodyLarge.copyWith(color: BankingColors.neutral100),
      bodyMedium: BankingTypography.bodyRegular.copyWith(color: BankingColors.neutral100),
      bodySmall: BankingTypography.bodySmall.copyWith(color: BankingColors.neutral200),

      // Utility
      labelSmall: BankingTypography.caption.copyWith(color: BankingColors.neutral200),
      labelMedium: BankingTypography.label.copyWith(color: BankingColors.neutral200),
      labelLarge: BankingTypography.button.copyWith(color: BankingColors.neutral0),
    ),

    // Component Themes
    appBarTheme: _buildAppBarTheme(Brightness.dark),
    bottomNavigationBarTheme: _buildBottomNavigationBarTheme(Brightness.dark),
    cardTheme: _buildCardTheme(Brightness.dark),
    elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.dark),
    outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.dark),
    textButtonTheme: _buildTextButtonTheme(Brightness.dark),
    inputDecorationTheme: _buildInputDecorationTheme(Brightness.dark),
    tabBarTheme: _buildTabBarTheme(Brightness.dark),
    dialogTheme: _buildDialogTheme(Brightness.dark),
    bottomSheetTheme: _buildBottomSheetTheme(Brightness.dark),

    // Other properties
    scaffoldBackgroundColor: BankingColors.primary900, // Dark blue background for dark theme
    dividerColor: BankingColors.primary700,
    dividerTheme: const DividerThemeData(
      thickness: BankingTokens.borderWidthThin,
      space: BankingTokens.space16,
    ),

    // Custom extensions
    extensions: [
      BankingThemeExtension.dark,
    ],
  );

  // ===========================================================================
  // THEME BUILDING HELPERS
  // ===========================================================================


  static AppBarTheme _buildAppBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return AppBarTheme(
      backgroundColor: isDark ? BankingColors.neutral900 : BankingColors.neutral0,
      foregroundColor: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: BankingTypography.heading3.copyWith(
        color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
      ),
      toolbarHeight: BankingTokens.appBarHeight,
      iconTheme: IconThemeData(
        color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
        size: BankingTokens.iconSizeMedium,
      ),
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? BankingColors.neutral900 : BankingColors.neutral0,
      selectedItemColor: BankingColors.primary500,
      unselectedItemColor: isDark ? BankingColors.neutral400 : BankingColors.neutral500,
      selectedIconTheme: const IconThemeData(size: BankingTokens.iconSizeMedium),
      unselectedIconTheme: const IconThemeData(size: BankingTokens.iconSizeMedium),
      selectedLabelStyle: BankingTypography.caption,
      unselectedLabelStyle: BankingTypography.caption,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }

  static CardThemeData _buildCardTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return CardThemeData(
      color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
      shadowColor: isDark ? BankingColors.neutral900 : BankingColors.neutral900,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
      ),
      margin: EdgeInsets.zero,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(Brightness brightness) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: BankingColors.primary500,
        foregroundColor: BankingColors.neutral0,
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: const Size(double.infinity, BankingTokens.buttonHeightMedium),
        padding: const EdgeInsets.symmetric(
          horizontal: BankingTokens.space16,
          vertical: BankingTokens.space12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        ),
        textStyle: BankingTypography.button,
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(Brightness brightness) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: BankingColors.primary500,
        side: const BorderSide(color: BankingColors.primary500),
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: const Size(double.infinity, BankingTokens.buttonHeightMedium),
        padding: const EdgeInsets.symmetric(
          horizontal: BankingTokens.space16,
          vertical: BankingTokens.space12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        ),
        textStyle: BankingTypography.button,
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(Brightness brightness) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: BankingColors.primary500,
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: const Size(0, BankingTokens.buttonHeightMedium),
        padding: const EdgeInsets.symmetric(
          horizontal: BankingTokens.space16,
          vertical: BankingTokens.space12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        ),
        textStyle: BankingTypography.button,
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? BankingColors.neutral800 : BankingColors.neutral50,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: BankingTokens.space16,
        vertical: BankingTokens.space12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        borderSide: BorderSide(
          color: isDark ? BankingColors.neutral600 : BankingColors.neutral300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        borderSide: BorderSide(
          color: isDark ? BankingColors.neutral600 : BankingColors.neutral300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        borderSide: const BorderSide(
          color: BankingColors.primary500,
          width: BankingTokens.borderWidthThick,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        borderSide: const BorderSide(
          color: BankingColors.error500,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        borderSide: const BorderSide(
          color: BankingColors.error500,
          width: BankingTokens.borderWidthThick,
        ),
      ),
      labelStyle: BankingTypography.label.copyWith(
        color: isDark ? BankingColors.neutral300 : BankingColors.neutral600,
      ),
      hintStyle: BankingTypography.bodySmall.copyWith(
        color: isDark ? BankingColors.neutral500 : BankingColors.neutral400,
      ),
      errorStyle: BankingTypography.caption.error,
      floatingLabelStyle: BankingTypography.label.copyWith(
        color: BankingColors.primary500,
      ),
    );
  }

  static TabBarThemeData _buildTabBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return TabBarThemeData(
      labelColor: BankingColors.primary500,
      unselectedLabelColor: isDark ? BankingColors.neutral400 : BankingColors.neutral600,
      labelStyle: BankingTypography.bodyRegular.semiBold,
      unselectedLabelStyle: BankingTypography.bodyRegular,
      indicatorColor: BankingColors.primary500,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: isDark ? BankingColors.neutral700 : BankingColors.neutral200,
    );
  }

  static DialogThemeData _buildDialogTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return DialogThemeData(
      backgroundColor: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
      elevation: 8,
      shadowColor: BankingColors.neutral900.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
      ),
    );
  }

  static BottomSheetThemeData _buildBottomSheetTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return BottomSheetThemeData(
      backgroundColor: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
      elevation: 8,
      shadowColor: BankingColors.neutral900.withOpacity(0.2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(BankingTokens.borderRadiusLarge),
          topRight: Radius.circular(BankingTokens.borderRadiusLarge),
        ),
      ),
    );
  }
}

/// Custom theme extension for banking-specific properties
class BankingThemeExtension extends ThemeExtension<BankingThemeExtension> {
  final Color positiveAmountColor;
  final Color negativeAmountColor;
  final Color cardGradientStart;
  final Color cardGradientEnd;

  const BankingThemeExtension({
    required this.positiveAmountColor,
    required this.negativeAmountColor,
    required this.cardGradientStart,
    required this.cardGradientEnd,
  });

  static const light = BankingThemeExtension(
    positiveAmountColor: BankingColors.positiveAmount,
    negativeAmountColor: BankingColors.negativeAmount,
    cardGradientStart: BankingColors.cardGradientStart,
    cardGradientEnd: BankingColors.cardGradientEnd,
  );

  static const dark = BankingThemeExtension(
    positiveAmountColor: BankingColors.positiveAmount,
    negativeAmountColor: BankingColors.negativeAmount,
    cardGradientStart: BankingColors.cardGradientStart,
    cardGradientEnd: BankingColors.cardGradientEnd,
  );

  @override
  BankingThemeExtension copyWith({
    Color? positiveAmountColor,
    Color? negativeAmountColor,
    Color? cardGradientStart,
    Color? cardGradientEnd,
  }) {
    return BankingThemeExtension(
      positiveAmountColor: positiveAmountColor ?? this.positiveAmountColor,
      negativeAmountColor: negativeAmountColor ?? this.negativeAmountColor,
      cardGradientStart: cardGradientStart ?? this.cardGradientStart,
      cardGradientEnd: cardGradientEnd ?? this.cardGradientEnd,
    );
  }

  @override
  BankingThemeExtension lerp(ThemeExtension<BankingThemeExtension>? other, double t) {
    if (other is! BankingThemeExtension) return this;
    return BankingThemeExtension(
      positiveAmountColor: Color.lerp(positiveAmountColor, other.positiveAmountColor, t)!,
      negativeAmountColor: Color.lerp(negativeAmountColor, other.negativeAmountColor, t)!,
      cardGradientStart: Color.lerp(cardGradientStart, other.cardGradientStart, t)!,
      cardGradientEnd: Color.lerp(cardGradientEnd, other.cardGradientEnd, t)!,
    );
  }
}

/// Extension to easily access banking theme properties
extension BankingThemeExtensionAccess on BuildContext {
  BankingThemeExtension get bankingTheme =>
      Theme.of(this).extension<BankingThemeExtension>() ??
      BankingThemeExtension.light;
}
