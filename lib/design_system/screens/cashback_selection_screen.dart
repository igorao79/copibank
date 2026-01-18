import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../utils/app_state.dart';

class CashbackSelectionScreen extends StatefulWidget {
  const CashbackSelectionScreen({super.key});

  @override
  State<CashbackSelectionScreen> createState() => _CashbackSelectionScreenState();
}

class _CashbackSelectionScreenState extends State<CashbackSelectionScreen> {
  final Set<String> _selectedCategoryIds = {};

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? BankingColors.neutral900 : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? BankingColors.neutral900 : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Выберите категории кэшбэка',
          style: BankingTypography.heading3.copyWith(
            color: isDark ? BankingColors.neutral100 : BankingColors.neutral700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(BankingTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Выберите до 3 категорий, где хотите получать кэшбэк',
              style: BankingTypography.bodyRegular.copyWith(
                color: isDark ? BankingColors.neutral400 : BankingColors.neutral600,
              ),
            ),
            const SizedBox(height: BankingTokens.space8),
            Text(
              'Выбрано: ${_selectedCategoryIds.length}/3',
              style: BankingTypography.bodySmall.copyWith(
                color: BankingColors.primary500,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: BankingTokens.space32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: BankingTokens.space16,
                  mainAxisSpacing: BankingTokens.space16,
                  childAspectRatio: 1.2,
                ),
                itemCount: appState.allCashbackCategories.length,
                itemBuilder: (context, index) {
                  final category = appState.allCashbackCategories[index];
                  final isSelected = _selectedCategoryIds.contains(category.id);
                  final isDisabled = _selectedCategoryIds.length >= 3 && !isSelected;

                  return GestureDetector(
                    onTap: isDisabled ? null : () {
                      setState(() {
                        if (isSelected) {
                          _selectedCategoryIds.remove(category.id);
                        } else {
                          _selectedCategoryIds.add(category.id);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(BankingTokens.space16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? category.color.withOpacity(0.1)
                            : isDark ? BankingColors.neutral800 : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? category.color
                              : isDisabled
                                  ? BankingColors.neutral300
                                  : BankingColors.neutral400,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(BankingTokens.radius12),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: category.color.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            category.icon,
                            size: 32,
                            color: isDisabled
                                ? BankingColors.neutral400
                                : category.color,
                          ),
                          const SizedBox(height: BankingTokens.space8),
                          Text(
                            category.name,
                            style: BankingTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDisabled
                                  ? BankingColors.neutral400
                                  : isDark ? BankingColors.neutral100 : BankingColors.neutral700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: BankingTokens.space4),
                          Text(
                            '${category.percentage}%',
                            style: BankingTypography.caption.copyWith(
                              color: isDisabled
                                  ? BankingColors.neutral400
                                  : category.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: BankingTokens.space24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedCategoryIds.length != 3
                    ? null
                    : () async {
                        try {
                          await appState.selectCashbackCategories(_selectedCategoryIds.toList());
                          _showSuccessDialog();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ошибка: $e')),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BankingColors.primary500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: BankingTokens.space16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(BankingTokens.radius12),
                  ),
                  disabledBackgroundColor: BankingColors.neutral300,
                ),
                child: Text(
                  _selectedCategoryIds.length < 3
                      ? 'Выберите ${_selectedCategoryIds.length}/3 категории'
                      : 'Подтвердить выбор',
                  style: BankingTypography.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          // Close the success dialog first
          Navigator.of(context).pop();
          // Then close the cashback selection screen
          Navigator.of(context).pop();
        });

        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Dialog(
          backgroundColor: isDark ? BankingColors.neutral800 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BankingTokens.radius16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(BankingTokens.space32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: BankingColors.success100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: BankingColors.success500,
                    size: 48,
                  ),
                ),
                const SizedBox(height: BankingTokens.space24),
                Text(
                  'Кэшбэк настроен!',
                  style: BankingTypography.heading2.copyWith(
                    color: isDark ? BankingColors.neutral100 : BankingColors.neutral700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BankingTokens.space8),
                Text(
                  'Теперь вы будете получать кэшбэк\nв выбранных категориях',
                  style: BankingTypography.bodyRegular.copyWith(
                    color: isDark ? BankingColors.neutral400 : BankingColors.neutral600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
