import 'package:flutter/material.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';

/// Banking Button Variants
enum BankingButtonVariant {
  primary,
  secondary,
  tertiary,
  destructive,
  iconOnly,
}

/// Banking Button Sizes
enum BankingButtonSize {
  small,
  medium,
  large,
}

/// Banking Design System Button
/// Comprehensive button component with all required variants and states
class BankingButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final BankingButtonVariant variant;
  final BankingButtonSize size;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool fullWidth;
  final EdgeInsetsGeometry? padding;

  const BankingButton({
    super.key,
    this.text,
    this.icon,
    this.variant = BankingButtonVariant.primary,
    this.size = BankingButtonSize.medium,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = true,
    this.padding,
  }) : assert(
          text != null || icon != null,
          'Either text or icon must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = !isDisabled && !isLoading && onPressed != null;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: BankingTokens.getButtonHeight(_getSizeString()),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: _getButtonStyle(context),
        child: _buildContent(context),
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (variant) {
      case BankingButtonVariant.primary:
        return _buildPrimaryStyle(isDark);
      case BankingButtonVariant.secondary:
        return _buildSecondaryStyle(isDark);
      case BankingButtonVariant.tertiary:
        return _buildTertiaryStyle(isDark);
      case BankingButtonVariant.destructive:
        return _buildDestructiveStyle(isDark);
      case BankingButtonVariant.iconOnly:
        return _buildIconOnlyStyle(isDark);
    }
  }

  ButtonStyle _buildPrimaryStyle(bool isDark) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDisabled
          ? (isDark ? BankingColors.neutral600 : BankingColors.neutral300)
          : BankingColors.primary500,
      foregroundColor: BankingColors.neutral0,
      elevation: 0,
      shadowColor: Colors.transparent,
      disabledBackgroundColor: isDark ? BankingColors.neutral600 : BankingColors.neutral300,
      disabledForegroundColor: BankingColors.neutral400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
      ),
      padding: padding ?? _getPadding(),
      textStyle: _getTextStyle(),
    );
  }

  ButtonStyle _buildSecondaryStyle(bool isDark) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDisabled
          ? (isDark ? BankingColors.neutral700 : BankingColors.neutral200)
          : BankingColors.secondary500,
      foregroundColor: BankingColors.neutral0,
      elevation: 0,
      shadowColor: Colors.transparent,
      disabledBackgroundColor: isDark ? BankingColors.neutral700 : BankingColors.neutral200,
      disabledForegroundColor: BankingColors.neutral400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
      ),
      padding: padding ?? _getPadding(),
      textStyle: _getTextStyle(),
    );
  }

  ButtonStyle _buildTertiaryStyle(bool isDark) {
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: isDisabled
          ? (isDark ? BankingColors.neutral500 : BankingColors.neutral400)
          : BankingColors.primary500,
      elevation: 0,
      shadowColor: Colors.transparent,
      side: BorderSide(
        color: isDisabled
            ? (isDark ? BankingColors.neutral600 : BankingColors.neutral300)
            : BankingColors.primary500,
        width: BankingTokens.borderWidthNormal,
      ),
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: isDark ? BankingColors.neutral500 : BankingColors.neutral400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
      ),
      padding: padding ?? _getPadding(),
      textStyle: _getTextStyle(),
    );
  }

  ButtonStyle _buildDestructiveStyle(bool isDark) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDisabled
          ? (isDark ? BankingColors.neutral600 : BankingColors.neutral300)
          : BankingColors.error500,
      foregroundColor: BankingColors.neutral0,
      elevation: 0,
      shadowColor: Colors.transparent,
      disabledBackgroundColor: isDark ? BankingColors.neutral600 : BankingColors.neutral300,
      disabledForegroundColor: BankingColors.neutral400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
      ),
      padding: padding ?? _getPadding(),
      textStyle: _getTextStyle(),
    );
  }

  ButtonStyle _buildIconOnlyStyle(bool isDark) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDisabled
          ? (isDark ? BankingColors.neutral600 : BankingColors.neutral300)
          : BankingColors.primary500,
      foregroundColor: BankingColors.neutral0,
      elevation: 0,
      shadowColor: Colors.transparent,
      disabledBackgroundColor: isDark ? BankingColors.neutral600 : BankingColors.neutral300,
      disabledForegroundColor: BankingColors.neutral400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
      ),
      padding: EdgeInsets.all(_getIconPadding()),
      minimumSize: Size.square(BankingTokens.getButtonHeight(_getSizeString())),
      maximumSize: Size.square(BankingTokens.getButtonHeight(_getSizeString())),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: BankingTokens.iconSizeMedium,
        height: BankingTokens.iconSizeMedium,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == BankingButtonVariant.primary ||
                variant == BankingButtonVariant.secondary ||
                variant == BankingButtonVariant.destructive ||
                variant == BankingButtonVariant.iconOnly
                ? BankingColors.neutral0
                : BankingColors.primary500,
          ),
        ),
      );
    }

    if (variant == BankingButtonVariant.iconOnly) {
      return Icon(
        icon,
        size: _getIconSize(),
        color: _getIconColor(context),
      );
    }

    if (icon != null && text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: _getIconSize(),
            color: _getIconColor(context),
          ),
          const SizedBox(width: BankingTokens.space8),
          Text(text!),
        ],
      );
    }

    if (icon != null) {
      return Icon(
        icon,
        size: _getIconSize(),
        color: _getIconColor(context),
      );
    }

    return Text(text!);
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case BankingButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: BankingTokens.space12,
          vertical: BankingTokens.space8,
        );
      case BankingButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: BankingTokens.space16,
          vertical: BankingTokens.space12,
        );
      case BankingButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: BankingTokens.space24,
          vertical: BankingTokens.space16,
        );
    }
  }

  double _getIconPadding() {
    switch (size) {
      case BankingButtonSize.small:
        return BankingTokens.space8;
      case BankingButtonSize.medium:
        return BankingTokens.space12;
      case BankingButtonSize.large:
        return BankingTokens.space16;
    }
  }

  double _getIconSize() {
    switch (size) {
      case BankingButtonSize.small:
        return BankingTokens.iconSizeSmall;
      case BankingButtonSize.medium:
        return BankingTokens.iconSizeMedium;
      case BankingButtonSize.large:
        return BankingTokens.iconSizeLarge;
    }
  }

  Color _getIconColor(BuildContext context) {
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    if (!isEnabled) {
      return BankingColors.neutral400;
    }

    switch (variant) {
      case BankingButtonVariant.primary:
      case BankingButtonVariant.secondary:
      case BankingButtonVariant.destructive:
      case BankingButtonVariant.iconOnly:
        return BankingColors.neutral0;
      case BankingButtonVariant.tertiary:
        return BankingColors.primary500;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case BankingButtonSize.small:
        return BankingTypography.buttonSmall;
      case BankingButtonSize.medium:
      case BankingButtonSize.large:
        return BankingTypography.button;
    }
  }

  String _getSizeString() {
    switch (size) {
      case BankingButtonSize.small:
        return 'small';
      case BankingButtonSize.medium:
        return 'medium';
      case BankingButtonSize.large:
        return 'large';
    }
  }
}

/// Convenience constructors for common button types
class BankingButtons {
  /// Primary action button
  static BankingButton primary({
    required String text,
    IconData? icon,
    BankingButtonSize size = BankingButtonSize.medium,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    bool fullWidth = true,
  }) {
    return BankingButton(
      text: text,
      icon: icon,
      variant: BankingButtonVariant.primary,
      size: size,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      fullWidth: fullWidth,
    );
  }

  /// Secondary action button
  static BankingButton secondary({
    required String text,
    IconData? icon,
    BankingButtonSize size = BankingButtonSize.medium,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    bool fullWidth = true,
  }) {
    return BankingButton(
      text: text,
      icon: icon,
      variant: BankingButtonVariant.secondary,
      size: size,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      fullWidth: fullWidth,
    );
  }

  /// Tertiary/outline button
  static BankingButton tertiary({
    required String text,
    IconData? icon,
    BankingButtonSize size = BankingButtonSize.medium,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    bool fullWidth = true,
  }) {
    return BankingButton(
      text: text,
      icon: icon,
      variant: BankingButtonVariant.tertiary,
      size: size,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      fullWidth: fullWidth,
    );
  }

  /// Destructive action button
  static BankingButton destructive({
    required String text,
    IconData? icon,
    BankingButtonSize size = BankingButtonSize.medium,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    bool fullWidth = true,
  }) {
    return BankingButton(
      text: text,
      icon: icon,
      variant: BankingButtonVariant.destructive,
      size: size,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      fullWidth: fullWidth,
    );
  }

  /// Icon-only button
  static BankingButton icon({
    required IconData icon,
    BankingButtonSize size = BankingButtonSize.medium,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return BankingButton(
      icon: icon,
      variant: BankingButtonVariant.iconOnly,
      size: size,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      fullWidth: false,
    );
  }
}

/// Extension methods for easier button usage
extension BankingButtonExtensions on BuildContext {
  /// Get the appropriate button size based on screen constraints
  BankingButtonSize get buttonSize {
    final width = MediaQuery.of(this).size.width;
    if (width < 360) return BankingButtonSize.small;
    if (width < 480) return BankingButtonSize.medium;
    return BankingButtonSize.large;
  }
}

