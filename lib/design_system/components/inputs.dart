import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';

/// Banking Input Variants
enum BankingInputVariant {
  text,
  password,
  number,
  search,
  amount, // Special variant for monetary amounts
}

/// Banking Input Sizes
enum BankingInputSize {
  medium,
  large,
}

/// Banking Design System Input Field
/// Comprehensive input component with all required variants and states
class BankingInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final BankingInputVariant variant;
  final BankingInputSize size;
  final TextEditingController? controller;
  final String? initialValue;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final bool showCounter;

  const BankingInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.variant = BankingInputVariant.text,
    this.size = BankingInputSize.medium,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.showCounter = false,
  });

  @override
  State<BankingInput> createState() => _BankingInputState();
}

class _BankingInputState extends State<BankingInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;

    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = widget.errorText != null || _errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: BankingTypography.label.copyWith(
              color: hasError
                  ? BankingColors.error500
                  : _focusNode.hasFocus
                      ? BankingColors.primary500
                      : isDark
                          ? BankingColors.neutral300
                          : BankingColors.neutral600,
            ),
          ),
          const SizedBox(height: BankingTokens.space8),
        ],
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: _obscureText,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          keyboardType: _getKeyboardType(),
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          autofocus: widget.autofocus,
          onTap: widget.onTap,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (_errorText != null) {
              setState(() => _errorText = null);
            }
          },
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          style: _getTextStyle(isDark),
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            errorText: widget.errorText ?? _errorText,
            counterText: widget.showCounter ? null : '',
            filled: true,
            fillColor: widget.enabled
                ? (isDark ? BankingColors.neutral800 : BankingColors.neutral50)
                : (isDark ? BankingColors.neutral700 : BankingColors.neutral100),
            contentPadding: _getContentPadding(),
            prefixIcon: _buildPrefixIcon(),
            suffixIcon: _buildSuffixIcon(),
            border: _buildBorder(isDark, false, false),
            enabledBorder: _buildBorder(isDark, false, false),
            focusedBorder: _buildBorder(isDark, true, false),
            errorBorder: _buildBorder(isDark, false, true),
            focusedErrorBorder: _buildBorder(isDark, true, true),
            disabledBorder: _buildBorder(isDark, false, false, disabled: true),
            hintStyle: BankingTypography.bodySmall.copyWith(
              color: isDark ? BankingColors.neutral500 : BankingColors.neutral400,
            ),
            helperStyle: BankingTypography.caption.copyWith(
              color: isDark ? BankingColors.neutral400 : BankingColors.neutral500,
            ),
            errorStyle: BankingTypography.caption.error,
            labelStyle: BankingTypography.label,
            floatingLabelStyle: BankingTypography.label.copyWith(
              color: BankingColors.primary500,
            ),
          ),
        ),
      ],
    );
  }

  TextInputType _getKeyboardType() {
    if (widget.keyboardType != null) return widget.keyboardType!;

    switch (widget.variant) {
      case BankingInputVariant.text:
        return TextInputType.text;
      case BankingInputVariant.password:
        return TextInputType.visiblePassword;
      case BankingInputVariant.number:
      case BankingInputVariant.amount:
        return TextInputType.numberWithOptions(decimal: true);
      case BankingInputVariant.search:
        return TextInputType.text;
    }
  }

  TextStyle _getTextStyle(bool isDark) {
    return BankingTypography.bodyRegular.copyWith(
      color: widget.enabled
          ? (isDark ? BankingColors.neutral100 : BankingColors.neutral900)
          : (isDark ? BankingColors.neutral500 : BankingColors.neutral400),
    );
  }

  EdgeInsets _getContentPadding() {
    final basePadding = widget.size == BankingInputSize.large
        ? BankingTokens.space16
        : BankingTokens.space12;

    return EdgeInsets.symmetric(
      horizontal: basePadding,
      vertical: basePadding,
    );
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon != null) return widget.prefixIcon;

    switch (widget.variant) {
      case BankingInputVariant.search:
        return Icon(
          BankingIcons.search,
          color: Theme.of(context).brightness == Brightness.dark
              ? BankingColors.neutral400
              : BankingColors.neutral500,
          size: BankingTokens.iconSizeMedium,
        );
      case BankingInputVariant.amount:
        return Icon(
          BankingIcons.dollar,
          color: Theme.of(context).brightness == Brightness.dark
              ? BankingColors.neutral400
              : BankingColors.neutral500,
          size: BankingTokens.iconSizeMedium,
        );
      default:
        return null;
    }
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon != null) return widget.suffixIcon;

    switch (widget.variant) {
      case BankingInputVariant.password:
        return IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).brightness == Brightness.dark
                ? BankingColors.neutral400
                : BankingColors.neutral500,
            size: BankingTokens.iconSizeMedium,
          ),
          onPressed: () {
            setState(() => _obscureText = !_obscureText);
          },
        );
      default:
        return null;
    }
  }

  InputBorder _buildBorder(bool isDark, bool focused, bool error, {bool disabled = false}) {
    Color borderColor;

    if (disabled) {
      borderColor = isDark ? BankingColors.neutral600 : BankingColors.neutral300;
    } else if (error) {
      borderColor = BankingColors.error500;
    } else if (focused) {
      borderColor = BankingColors.primary500;
    } else {
      borderColor = isDark ? BankingColors.neutral600 : BankingColors.neutral300;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
      borderSide: BorderSide(
        color: borderColor,
        width: focused || error ? BankingTokens.borderWidthThick : BankingTokens.borderWidthNormal,
      ),
    );
  }
}

/// Convenience constructors for common input types
class BankingInputs {
  /// Standard text input
  static BankingInput text({
    String? label,
    String? hint,
    String? helperText,
    String? errorText,
    BankingInputSize size = BankingInputSize.medium,
    TextEditingController? controller,
    String? initialValue,
    bool enabled = true,
    bool readOnly = false,
    int? maxLines = 1,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    Widget? prefixIcon,
    Widget? suffixIcon,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
    bool autofocus = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return BankingInput(
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      variant: BankingInputVariant.text,
      size: size,
      controller: controller,
      initialValue: initialValue,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      onTap: onTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      focusNode: focusNode,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
    );
  }

  /// Password input with show/hide functionality
  static BankingInput password({
    String? label,
    String? hint = 'Enter password',
    String? helperText,
    String? errorText,
    BankingInputSize size = BankingInputSize.medium,
    TextEditingController? controller,
    String? initialValue,
    bool enabled = true,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return BankingInput(
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      variant: BankingInputVariant.password,
      size: size,
      controller: controller,
      initialValue: initialValue,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: true,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// Number input
  static BankingInput number({
    String? label,
    String? hint,
    String? helperText,
    String? errorText,
    BankingInputSize size = BankingInputSize.medium,
    TextEditingController? controller,
    String? initialValue,
    bool enabled = true,
    bool readOnly = false,
    int? maxLength,
    Widget? prefixIcon,
    Widget? suffixIcon,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return BankingInput(
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      variant: BankingInputVariant.number,
      size: size,
      controller: controller,
      initialValue: initialValue,
      enabled: enabled,
      readOnly: readOnly,
      maxLength: maxLength,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// Search input
  static BankingInput search({
    String? label,
    String? hint = 'Search...',
    String? helperText,
    String? errorText,
    BankingInputSize size = BankingInputSize.medium,
    TextEditingController? controller,
    String? initialValue,
    bool enabled = true,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return BankingInput(
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      variant: BankingInputVariant.search,
      size: size,
      controller: controller,
      initialValue: initialValue,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// Amount input for monetary values
  static BankingInput amount({
    String? label,
    String? hint = '0.00',
    String? helperText,
    String? errorText,
    BankingInputSize size = BankingInputSize.large,
    TextEditingController? controller,
    String? initialValue,
    bool enabled = true,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return BankingInput(
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      variant: BankingInputVariant.amount,
      size: size,
      controller: controller,
      initialValue: initialValue,
      enabled: enabled,
      readOnly: readOnly,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }
}

/// Common input formatters for banking inputs
class BankingInputFormatters {
  /// Amount formatter that allows decimal numbers with up to 2 decimal places
  static final amount = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
  ];

  /// Phone number formatter (basic)
  static final phone = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];

  /// Card number formatter (spaces every 4 digits)
  static final cardNumber = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(16),
    _CardNumberFormatter(),
  ];

  /// Expiry date formatter (MM/YY)
  static final expiryDate = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(4),
    _ExpiryDateFormatter(),
  ];

  /// CVV formatter (3-4 digits)
  static final cvv = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(4),
  ];
}

/// Custom formatter for card numbers
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.length,
      ),
    );
  }
}

/// Custom formatter for expiry dates
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.length <= 5 ? buffer.toString() : oldValue.text,
      selection: TextSelection.collapsed(
        offset: buffer.length <= 5 ? buffer.length : oldValue.selection.end,
      ),
    );
  }
}
