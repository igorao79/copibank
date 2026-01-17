import 'package:flutter/material.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';

/// Banking Card Variants
enum BankingCardVariant {
  account,      // Account/Card balance display
  transaction,  // Transaction item
  quickAction,  // Quick action button
  balance,      // Balance summary
  info,         // Information display
}

/// Banking Card Sizes
enum BankingCardSize {
  small,
  medium,
  large,
}

/// Banking Design System Card
/// Comprehensive card component for various banking use cases
class BankingCard extends StatelessWidget {
  final BankingCardVariant variant;
  final BankingCardSize size;
  final Widget? child;
  final String? title;
  final String? subtitle;
  final String? amount;
  final String? description;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? gradientStart;
  final Color? gradientEnd;
  final VoidCallback? onTap;
  final bool showShadow;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const BankingCard({
    super.key,
    this.variant = BankingCardVariant.info,
    this.size = BankingCardSize.medium,
    this.child,
    this.title,
    this.subtitle,
    this.amount,
    this.description,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.gradientStart,
    this.gradientEnd,
    this.onTap,
    this.showShadow = true,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: BankingTokens.durationNormal,
      curve: Curves.easeInOut,
      decoration: _buildDecoration(isDark),
      padding: padding ?? _getPadding(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        child: child ?? _buildDefaultContent(context),
      ),
    );
  }

  BoxDecoration _buildDecoration(bool isDark) {
    final hasGradient = gradientStart != null && gradientEnd != null;

    return BoxDecoration(
      color: hasGradient
          ? null
          : backgroundColor ?? (isDark ? BankingColors.neutral800 : BankingColors.neutral0),
      gradient: hasGradient
          ? LinearGradient(
              colors: [gradientStart!, gradientEnd!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      borderRadius: borderRadius ?? BorderRadius.circular(_getBorderRadius()),
      boxShadow: showShadow ? BankingTokens.getShadow(1) : null,
    );
  }

  double _getBorderRadius() {
    switch (variant) {
      case BankingCardVariant.account:
        return BankingTokens.borderRadiusLarge;
      case BankingCardVariant.transaction:
        return BankingTokens.borderRadiusMedium;
      case BankingCardVariant.quickAction:
        return BankingTokens.borderRadiusLarge;
      case BankingCardVariant.balance:
        return BankingTokens.borderRadiusLarge;
      case BankingCardVariant.info:
        return BankingTokens.borderRadiusMedium;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case BankingCardSize.small:
        return const EdgeInsets.all(BankingTokens.space12);
      case BankingCardSize.medium:
        return const EdgeInsets.all(BankingTokens.space16);
      case BankingCardSize.large:
        return const EdgeInsets.all(BankingTokens.space24);
    }
  }

  Widget _buildDefaultContent(BuildContext context) {
    switch (variant) {
      case BankingCardVariant.account:
        return _buildAccountCard(context);
      case BankingCardVariant.transaction:
        return _buildTransactionCard(context);
      case BankingCardVariant.quickAction:
        return _buildQuickActionCard(context);
      case BankingCardVariant.balance:
        return _buildBalanceCard(context);
      case BankingCardVariant.info:
        return _buildInfoCard(context);
    }
  }

  Widget _buildAccountCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 130, // Увеличенная высота для предотвращения overflow с длинными суммами
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(BankingTokens.space8),
                decoration: BoxDecoration(
                  color: (iconColor ?? BankingColors.primary500).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? BankingColors.primary500,
                  size: BankingTokens.iconSizeLarge,
                ),
              ),
            ],
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: BankingTypography.caption.copyWith(
                  color: isDark ? BankingColors.neutral100 : BankingColors.neutral600,
                ),
              ),
            ],
          ],
        ),
        if (title != null) ...[
          const SizedBox(height: BankingTokens.space12),
          Text(
            title!,
            style: BankingTypography.heading3.copyWith(
              color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
            ),
          ),
        ],
        if (amount != null) ...[
          const SizedBox(height: BankingTokens.space8),
          Text(
            amount!,
            style: BankingTypography.amountLarge.copyWith(
              color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
            ),
          ),
        ],
      ],
    ),
  );
}

  Widget _buildTransactionCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        if (icon != null) ...[
          Container(
            width: BankingTokens.space48,
            height: BankingTokens.space48,
            decoration: BoxDecoration(
              color: (iconColor ?? BankingColors.primary100).withOpacity(0.1),
              borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
            ),
            child: Icon(
              icon,
              color: iconColor ?? BankingColors.primary500,
              size: BankingTokens.iconSizeMedium,
            ),
          ),
          const SizedBox(width: BankingTokens.space12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: BankingTypography.bodyRegular.semiBold.copyWith(
                    color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                  ),
                ),
              ],
              if (subtitle != null) ...[
                const SizedBox(height: BankingTokens.space4),
                Text(
                  subtitle!,
                  style: BankingTypography.caption.copyWith(
                    color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (amount != null) ...[
          Text(
            amount!,
            style: BankingTypography.amountMedium.copyWith(
              color: amount!.startsWith('-')
                  ? BankingColors.error500
                  : BankingColors.success500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActionCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedScale(
      scale: onTap != null ? 1.0 : 0.95,
      duration: BankingTokens.durationFast,
      curve: Curves.easeInOut,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            AnimatedContainer(
              duration: BankingTokens.durationFast,
              width: BankingTokens.quickActionCardSize,
              height: BankingTokens.quickActionCardSize,
              decoration: BoxDecoration(
                color: (iconColor ?? BankingColors.primary500).withOpacity(0.1),
                borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
              ),
              child: Icon(
                icon,
                color: iconColor ?? BankingColors.primary500,
                size: BankingTokens.iconSizeLarge,
              ),
            ),
            const SizedBox(height: BankingTokens.space8),
          ],
          if (title != null) ...[
            AnimatedDefaultTextStyle(
              duration: BankingTokens.durationFast,
              style: BankingTypography.bodySmall.semiBold.copyWith(
                color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
              ),
              child: Text(
                title!,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: BankingTypography.bodySmall.copyWith(
              color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
            ),
          ),
          const SizedBox(height: BankingTokens.space4),
        ],
        if (amount != null) ...[
          Text(
            amount!,
            style: BankingTypography.amountLarge.copyWith(
              color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
            ),
          ),
        ],
        if (subtitle != null) ...[
          const SizedBox(height: BankingTokens.space8),
          Text(
            subtitle!,
            style: BankingTypography.caption.copyWith(
              color: isDark ? BankingColors.neutral400 : BankingColors.neutral500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: iconColor ?? BankingColors.primary500,
            size: BankingTokens.iconSizeMedium,
          ),
          const SizedBox(height: BankingTokens.space8),
        ],
        if (title != null) ...[
          Text(
            title!,
            style: BankingTypography.heading4.copyWith(
              color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
            ),
          ),
        ],
        if (description != null) ...[
          const SizedBox(height: BankingTokens.space4),
          Text(
            description!,
            style: BankingTypography.bodySmall.copyWith(
              color: isDark ? BankingColors.neutral300 : BankingColors.neutral600,
            ),
          ),
        ],
      ],
    );
  }
}

/// Convenience constructors for common card types
class BankingCards {
  /// Account balance card
  static BankingCard account({
    required String title,
    required String amount,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    VoidCallback? onTap,
    bool showShadow = true,
  }) {
    return BankingCard(
      variant: BankingCardVariant.account,
      size: BankingCardSize.large,
      title: title,
      amount: amount,
      subtitle: subtitle,
      icon: icon ?? BankingIcons.card,
      iconColor: iconColor,
      onTap: onTap,
      showShadow: showShadow,
    );
  }

  /// Transaction item card
  static BankingCard transaction({
    required String title,
    required String amount,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return BankingCard(
      variant: BankingCardVariant.transaction,
      size: BankingCardSize.medium,
      title: title,
      amount: amount,
      subtitle: subtitle,
      icon: icon ?? BankingIcons.transaction,
      iconColor: iconColor,
      onTap: onTap,
      showShadow: false,
    );
  }

  /// Quick action card
  static BankingCard quickAction({
    required String title,
    required IconData icon,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return BankingCard(
      variant: BankingCardVariant.quickAction,
      size: BankingCardSize.small,
      title: title,
      icon: icon,
      iconColor: iconColor,
      onTap: onTap,
      showShadow: true,
    );
  }

  /// Balance summary card
  static BankingCard balance({
    required String amount,
    String? title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return BankingCard(
      variant: BankingCardVariant.balance,
      size: BankingCardSize.medium,
      title: title,
      amount: amount,
      subtitle: subtitle,
      onTap: onTap,
      showShadow: true,
    );
  }

  /// Information card
  static BankingCard info({
    String? title,
    String? description,
    IconData? icon,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return BankingCard(
      variant: BankingCardVariant.info,
      size: BankingCardSize.medium,
      title: title,
      description: description,
      icon: icon,
      iconColor: iconColor,
      onTap: onTap,
      showShadow: false,
    );
  }

  /// Gradient account card (for featured accounts)
  static BankingCard gradientAccount({
    required String title,
    required String amount,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    Color? gradientStart,
    Color? gradientEnd,
    VoidCallback? onTap,
  }) {
    return BankingCard(
      variant: BankingCardVariant.account,
      size: BankingCardSize.large,
      title: title,
      amount: amount,
      subtitle: subtitle,
      icon: icon ?? BankingIcons.card,
      iconColor: iconColor ?? BankingColors.neutral0,
      gradientStart: gradientStart ?? BankingColors.cardGradientStart,
      gradientEnd: gradientEnd ?? BankingColors.cardGradientEnd,
      onTap: onTap,
      showShadow: true,
    );
  }
}

/// Banking Bottom Sheet
/// Standardized bottom sheet for banking actions
class BankingBottomSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final List<Widget>? actions;
  final bool showDragHandle;
  final bool isDismissible;

  const BankingBottomSheet({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.actions,
    this.showDragHandle = true,
    this.isDismissible = true,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? subtitle,
    required Widget child,
    List<Widget>? actions,
    bool showDragHandle = true,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (context) => BankingBottomSheet(
        title: title,
        subtitle: subtitle,
        child: child,
        actions: actions,
        showDragHandle: showDragHandle,
        isDismissible: isDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(BankingTokens.space16),
      decoration: BoxDecoration(
        color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
        boxShadow: BankingTokens.getShadow(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) ...[
            const SizedBox(height: BankingTokens.space8),
            Container(
              width: BankingTokens.space32,
              height: BankingTokens.space4,
              decoration: BoxDecoration(
                color: isDark ? BankingColors.neutral600 : BankingColors.neutral300,
                borderRadius: BorderRadius.circular(BankingTokens.borderRadiusSmall),
              ),
            ),
            const SizedBox(height: BankingTokens.space16),
          ],
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: BankingTokens.space16),
              child: Column(
                children: [
                  Text(
                    title!,
                    style: BankingTypography.heading3,
                    textAlign: TextAlign.center,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: BankingTokens.space8),
                    Text(
                      subtitle!,
                      style: BankingTypography.bodySmall.copyWith(
                        color: isDark ? BankingColors.neutral400 : BankingColors.neutral500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: BankingTokens.space24),
          ],
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: BankingTokens.space16),
              child: child,
            ),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(height: BankingTokens.space24),
            Container(
              padding: const EdgeInsets.all(BankingTokens.space16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? BankingColors.neutral700 : BankingColors.neutral200,
                    width: BankingTokens.borderWidthThin,
                  ),
                ),
              ),
              child: Column(
                children: actions!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Banking Dialog
/// Standardized dialog for banking confirmations and alerts
class BankingDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final Widget? icon;
  final List<Widget>? actions;

  const BankingDialog({
    super.key,
    this.title,
    this.content,
    this.icon,
    this.actions,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? content,
    Widget? icon,
    List<Widget>? actions,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => BankingDialog(
        title: title,
        content: content,
        icon: icon,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(BankingTokens.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(height: BankingTokens.space16),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: BankingTypography.heading3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: BankingTokens.space8),
            ],
            if (content != null) ...[
              Text(
                content!,
                style: BankingTypography.bodyRegular.copyWith(
                  color: isDark ? BankingColors.neutral300 : BankingColors.neutral600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: BankingTokens.space24),
            ],
            if (actions != null && actions!.isNotEmpty) ...[
              Row(
                children: actions!.map((action) {
                  return Expanded(child: action);
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
