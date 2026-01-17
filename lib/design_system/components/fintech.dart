import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import 'buttons.dart';

/// Banking Chart Data Point
class ChartDataPoint {
  final String label;
  final double value;
  final Color color;

  const ChartDataPoint({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Banking Line Chart
/// Financial line chart for trends and analytics
class BankingLineChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  final String? title;
  final double height;
  final bool showGrid;
  final bool showDots;
  final Duration animationDuration;

  const BankingLineChart({
    super.key,
    required this.data,
    this.title,
    this.height = 200,
    this.showGrid = true,
    this.showDots = true,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: height,
      padding: const EdgeInsets.all(BankingTokens.space16),
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
            const SizedBox(height: BankingTokens.space16),
          ],
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: showGrid,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: (isDark ? BankingColors.neutral700 : BankingColors.neutral200)
                          .withOpacity(0.5),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: (isDark ? BankingColors.neutral700 : BankingColors.neutral200)
                          .withOpacity(0.5),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < data.length) {
                          return Text(
                            data[value.toInt()].label,
                            style: BankingTypography.caption.copyWith(
                              color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: BankingTypography.caption.copyWith(
                            color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: isDark ? BankingColors.neutral700 : BankingColors.neutral200,
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: data.length.toDouble() - 1,
                minY: 0,
                maxY: data.isNotEmpty ? data.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2 : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.value);
                    }).toList(),
                    isCurved: true,
                    color: BankingColors.primary500,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: showDots,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: BankingColors.primary500,
                          strokeWidth: 2,
                          strokeColor: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: BankingColors.primary500.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Banking Donut Chart
/// Circular chart for portfolio allocation and category breakdowns
class BankingDonutChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  final String? centerText;
  final String? centerSubtitle;
  final double radius;
  final double strokeWidth;
  final Duration animationDuration;

  const BankingDonutChart({
    super.key,
    required this.data,
    this.centerText,
    this.centerSubtitle,
    this.radius = 80,
    this.strokeWidth = 20,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: radius * 2 + BankingTokens.space48,
      width: radius * 2 + BankingTokens.space48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: data.map((point) {
                return PieChartSectionData(
                  value: point.value,
                  title: '${(point.value / data.map((e) => e.value).reduce((a, b) => a + b) * 100).toStringAsFixed(1)}%',
                  color: point.color,
                  radius: radius,
                  titleStyle: BankingTypography.caption.copyWith(
                    color: BankingColors.neutral0,
                    fontWeight: FontWeight.bold,
                  ),
                  borderSide: BorderSide(
                    color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
                    width: 2,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: radius * 0.6,
            ),
          ),
          if (centerText != null) ...[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  centerText!,
                  style: BankingTypography.amountMedium.copyWith(
                    color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                  ),
                ),
                if (centerSubtitle != null) ...[
                  const SizedBox(height: BankingTokens.space4),
                  Text(
                    centerSubtitle!,
                    style: BankingTypography.caption.copyWith(
                      color: isDark ? BankingColors.neutral400 : BankingColors.neutral500,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Banking Amount Input
/// Specialized input for monetary amounts with large display
class BankingAmountInput extends StatefulWidget {
  final String? label;
  final String? currency;
  final double? initialValue;
  final ValueChanged<double?>? onChanged;
  final FormFieldValidator<double?>? validator;
  final bool enabled;
  final double? maxAmount;

  const BankingAmountInput({
    super.key,
    this.label,
    this.currency = '\$',
    this.initialValue,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.maxAmount,
  });

  @override
  State<BankingAmountInput> createState() => _BankingAmountInputState();
}

class _BankingAmountInputState extends State<BankingAmountInput> {
  late TextEditingController _controller;
  double? _value;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _controller = TextEditingController(
      text: _value != null ? _value!.toStringAsFixed(2) : '',
    );
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    final value = double.tryParse(text);
    setState(() => _value = value);
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: BankingTypography.bodyRegular.semiBold.copyWith(
              color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
            ),
          ),
          const SizedBox(height: BankingTokens.space16),
        ],
        Container(
          padding: const EdgeInsets.all(BankingTokens.space24),
          decoration: BoxDecoration(
            color: isDark ? BankingColors.neutral800 : BankingColors.neutral50,
            borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
            border: Border.all(
              color: _errorText != null
                  ? BankingColors.error500
                  : isDark
                      ? BankingColors.neutral700
                      : BankingColors.neutral200,
              width: BankingTokens.borderWidthNormal,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    widget.currency!,
                    style: BankingTypography.heading2.copyWith(
                      color: isDark ? BankingColors.neutral300 : BankingColors.neutral600,
                    ),
                  ),
                  const SizedBox(width: BankingTokens.space8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: widget.enabled,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                      style: BankingTypography.amountLarge.copyWith(
                        color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              if (_errorText != null) ...[
                const SizedBox(height: BankingTokens.space8),
                Text(
                  _errorText!,
                  style: BankingTypography.caption.error,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Banking Numpad
/// Numeric keypad for amount input and PIN entry
class BankingNumpad extends StatelessWidget {
  final ValueChanged<String>? onKeyPressed;
  final VoidCallback? onDelete;
  final VoidCallback? onSubmit;
  final bool showDecimal;
  final bool showBiometric;
  final String? submitLabel;

  const BankingNumpad({
    super.key,
    this.onKeyPressed,
    this.onDelete,
    this.onSubmit,
    this.showDecimal = true,
    this.showBiometric = false,
    this.submitLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BankingTokens.space16),
      child: Column(
        children: [
          // Number rows
          for (int row = 0; row < 4; row++) ...[
            Row(
              children: [
                for (int col = 0; col < 3; col++) ...[
                  if (row == 3 && col == 0) ...[
                    // Bottom left: biometric or empty
                    if (showBiometric) ...[
                      _NumpadButton.biometric(onPressed: onSubmit),
                    ] else ...[
                      const SizedBox(width: 80, height: 80),
                    ],
                  ] else if (row == 3 && col == 1) ...[
                    // Bottom center: 0
                    _NumpadButton(
                      label: '0',
                      onPressed: () => onKeyPressed?.call('0'),
                    ),
                  ] else if (row == 3 && col == 2) ...[
                    // Bottom right: delete
                    _NumpadButton.delete(onPressed: onDelete),
                  ] else ...[
                    // Numbers 1-9
                    _NumpadButton(
                      label: '${row * 3 + col + 1}',
                      onPressed: () => onKeyPressed?.call('${row * 3 + col + 1}'),
                    ),
                  ],
                ],
              ],
            ),
            if (row < 3) const SizedBox(height: BankingTokens.space8),
          ],
          if (submitLabel != null) ...[
            const SizedBox(height: BankingTokens.space16),
            BankingButtons.primary(
              text: submitLabel!,
              onPressed: onSubmit,
              size: BankingButtonSize.large,
            ),
          ],
        ],
      ),
    );
  }
}

/// Individual numpad button
class _NumpadButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isSpecial;

  const _NumpadButton({
    this.label,
    this.icon,
    this.onPressed,
    this.isSpecial = false,
  });

  factory _NumpadButton.delete({VoidCallback? onPressed}) {
    return _NumpadButton(
      icon: Icons.backspace_outlined,
      onPressed: onPressed,
      isSpecial: true,
    );
  }

  factory _NumpadButton.biometric({VoidCallback? onPressed}) {
    return _NumpadButton(
      icon: Icons.fingerprint,
      onPressed: onPressed,
      isSpecial: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.all(BankingTokens.space4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSpecial
              ? (isDark ? BankingColors.neutral700 : BankingColors.neutral100)
              : (isDark ? BankingColors.neutral800 : BankingColors.neutral50),
          foregroundColor: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
          ),
          padding: EdgeInsets.zero,
        ),
        child: icon != null
            ? Icon(
                icon,
                size: BankingTokens.iconSizeLarge,
                color: isSpecial
                    ? BankingColors.primary500
                    : (isDark ? BankingColors.neutral100 : BankingColors.neutral600),
              )
            : Text(
                label!,
                style: BankingTypography.amountMedium.copyWith(
                  color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                ),
              ),
      ),
    );
  }
}

/// Banking PIN Input
/// Secure PIN entry with dots display
class BankingPinInput extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final bool showNumpad;

  const BankingPinInput({
    super.key,
    this.length = 4,
    this.onCompleted,
    this.onChanged,
    this.obscureText = true,
    this.showNumpad = true,
  });

  @override
  State<BankingPinInput> createState() => _BankingPinInputState();
}

class _BankingPinInputState extends State<BankingPinInput> {
  late List<String> _pin;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pin = List.filled(widget.length, '');
  }

  void _onKeyPressed(String key) {
    if (_currentIndex < widget.length) {
      setState(() {
        _pin[_currentIndex] = key;
        _currentIndex++;
      });

      final pinString = _pin.join();
      widget.onChanged?.call(pinString);

      if (_currentIndex == widget.length) {
        widget.onCompleted?.call(pinString);
      }
    }
  }

  void _onDelete() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _pin[_currentIndex] = '';
      });

      widget.onChanged?.call(_pin.join());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PIN dots display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Container(
              width: BankingTokens.space16,
              height: BankingTokens.space16,
              margin: const EdgeInsets.symmetric(horizontal: BankingTokens.space8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < _currentIndex
                        ? BankingColors.primary500
                        : (Theme.of(context).brightness == Brightness.dark
                            ? BankingColors.neutral200
                            : BankingColors.neutral300),
              ),
            );
          }),
        ),
        if (widget.showNumpad) ...[
          const SizedBox(height: BankingTokens.space32),
          BankingNumpad(
            onKeyPressed: _onKeyPressed,
            onDelete: _onDelete,
          ),
        ],
      ],
    );
  }
}

/// Convenience constructors for common fintech components
class BankingFintech {
  /// Balance trend chart
  static BankingLineChart balanceChart({
    required List<ChartDataPoint> data,
    String? title = 'Balance Trend',
    double height = 200,
  }) {
    return BankingLineChart(
      data: data,
      title: title,
      height: height,
      showGrid: true,
      showDots: true,
    );
  }

  /// Portfolio allocation donut chart
  static BankingDonutChart portfolioChart({
    required List<ChartDataPoint> data,
    String? centerText,
    String? centerSubtitle,
  }) {
    return BankingDonutChart(
      data: data,
      centerText: centerText,
      centerSubtitle: centerSubtitle,
    );
  }

  /// Amount input for transfers
  static BankingAmountInput transferAmount({
    String? label = 'Transfer Amount',
    String? currency = '\$',
    ValueChanged<double?>? onChanged,
    FormFieldValidator<double?>? validator,
    double? maxAmount,
  }) {
    return BankingAmountInput(
      label: label,
      currency: currency,
      onChanged: onChanged,
      validator: validator,
      maxAmount: maxAmount,
    );
  }

  /// PIN entry for security
  static BankingPinInput pinEntry({
    int length = 4,
    ValueChanged<String>? onCompleted,
    bool showNumpad = true,
  }) {
    return BankingPinInput(
      length: length,
      onCompleted: onCompleted,
      showNumpad: showNumpad,
    );
  }
}
