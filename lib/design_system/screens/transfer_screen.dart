import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../components/buttons.dart';
import '../components/svg_background.dart';
import '../utils/app_state.dart';
import '../../l10n/app_localizations.dart';

class TransferScreen extends StatefulWidget {
  final Account? selectedAccount;

  const TransferScreen({super.key, this.selectedAccount});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  TransferUser? _selectedUser;
  Account? _selectedAccount;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool _isProcessing = false;
  String? _amountError;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: BankingTokens.durationNormal,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();

    // Pre-select account if provided
    if (widget.selectedAccount != null) {
      _selectedAccount = widget.selectedAccount;
    }

    // Add listener for amount validation
    _amountController.addListener(_validateAmount);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _validateAmount() {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (_selectedAccount != null && amount != null && amount > _selectedAccount!.balance) {
      setState(() {
        _amountError = 'Сумма превышает доступный баланс';
      });
    } else {
      setState(() {
        _amountError = null;
      });
    }
  }

  void _onUserSelected(TransferUser user) {
    setState(() {
      _selectedUser = user;
    });
  }

  void _onAccountSelected(Account account) {
    setState(() {
      _selectedAccount = account;
    });
  }

  bool _validateTransfer() {
    if (_selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.selectRecipient ?? 'Выберите получателя')),
      );
      return false;
    }

    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.selectCard ?? 'Выберите карту для перевода')),
      );
      return false;
    }

    if (_selectedAccount!.type != 'debit_card') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.debitOnly ?? 'Переводы возможны только с дебетовых карт')),
      );
      return false;
    }

    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.enterValidAmount ?? 'Введите корректную сумму')),
      );
      return false;
    }

    if (amount > _selectedAccount!.balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.insufficientCardFunds ?? 'Недостаточно средств на карте')),
      );
      return false;
    }

    return true;
  }

  Future<void> _processTransfer() async {
    if (!_validateTransfer()) return;

    final amount = double.parse(_amountController.text.replaceAll(',', '.'));

    setState(() {
      _isProcessing = true;
    });

    try {
      final appState = context.read<AppState>();
      final success = await appState.transferMoney(
        fromAccount: _selectedAccount!,
        toUser: _selectedUser!,
        amount: amount,
        comment: _commentController.text.isNotEmpty ? _commentController.text : null,
      );

      if (success && mounted) {
        print('DEBUG: Showing success dialog');
        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            // Auto-close dialog after 2 seconds
            Future.delayed(const Duration(seconds: 2), () {
              print('DEBUG: Closing success dialog');
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BankingTokens.radius16),
              ),
              child: Container(
                padding: const EdgeInsets.all(BankingTokens.space24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: BankingColors.success500,
                      size: 64,
                    ),
                    const SizedBox(height: BankingTokens.space16),
                    Text(
                      'Перевод успешно совершен',
                      style: BankingTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: BankingColors.neutral900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );

        // Go back to dashboard
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.transferError ?? 'Ошибка при выполнении перевода')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showSlidingNotification(double amount, String senderName) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: BankingTokens.space16,
        right: BankingTokens.space16,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: AnimationController(
                duration: const Duration(milliseconds: 500),
                vsync: Navigator.of(context),
              )..forward(),
              curve: Curves.easeOut,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(BankingTokens.space16),
              decoration: BoxDecoration(
                color: BankingColors.success500,
                borderRadius: BorderRadius.circular(BankingTokens.radius12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: BankingTokens.space12),
                  Expanded(
                    child: Text(
                      'Зачислено ${amount.toStringAsFixed(2)}\$ от $senderName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove after 4 seconds with fade out animation
    Timer(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  Future<void> _receiveRandomTransfer() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final appState = context.read<AppState>();
      await appState.receiveRandomTransfer();

      // Show smooth sliding notification with last transaction info
      if (mounted && appState.transactions.isNotEmpty) {
        final lastTransaction = appState.transactions.first;
        final amount = lastTransaction.amount.abs();
        final senderName = lastTransaction.title.replaceAll('Получен перевод от ', '');

        _showSlidingNotification(amount, senderName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.receiveError ?? 'Ошибка при получении перевода')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      body: SvgBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(BankingTokens.space16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      style: IconButton.styleFrom(
                        backgroundColor: BankingColors.neutral50,
                        foregroundColor: BankingColors.neutral900,
                      ),
                    ),
                    const SizedBox(width: BankingTokens.space16),
                    Expanded(
                      child: Text(
                        'Перевод денег',
                        style: BankingTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: BankingColors.neutral900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(BankingTokens.space16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Selection
                        Text(
                          'Выберите получателя',
                          style: BankingTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: BankingColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: BankingTokens.space16),

                        // Users List
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: appState.transferUsers.length,
                            itemBuilder: (context, index) {
                              final user = appState.transferUsers[index];
                              final isSelected = _selectedUser?.id == user.id;

                              return GestureDetector(
                                onTap: () => _onUserSelected(user),
                                child: Container(
                                  width: 80,
                                  margin: const EdgeInsets.only(right: BankingTokens.space12),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected ? BankingColors.primary500 : BankingColors.neutral300,
                                            width: isSelected ? 3 : 1,
                                          ),
                                        ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: BankingColors.primary100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: BankingColors.primary600,
                                          size: 30,
                                        ),
                                      ),
                                      ),
                                      const SizedBox(height: BankingTokens.space8),
                                      Text(
                                        user.name.split(' ').first,
                                        style: BankingTypography.bodySmall.copyWith(
                                          color: BankingColors.neutral700,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: BankingTokens.space32),

                        // Account Selection
                        Text(
                          'Выберите карту',
                          style: BankingTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: BankingColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: BankingTokens.space16),

                        // Debit Cards Only
                        ...appState.accounts.where((account) => account.type == 'debit_card').map((account) {
                          final isSelected = _selectedAccount?.id == account.id;

                          return GestureDetector(
                            onTap: () => _onAccountSelected(account),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: BankingTokens.space12),
                              padding: const EdgeInsets.all(BankingTokens.space16),
                              decoration: BoxDecoration(
                                color: isSelected ? BankingColors.primary50 : BankingColors.neutral50,
                                border: Border.all(
                                  color: isSelected ? BankingColors.primary500 : BankingColors.neutral300,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(BankingTokens.radius8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: account.color,
                                      borderRadius: BorderRadius.circular(BankingTokens.radius8),
                                    ),
                                    child: Icon(
                                      Icons.credit_card,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: BankingTokens.space12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          account.name,
                                          style: BankingTypography.bodyRegular.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: BankingColors.neutral900,
                                          ),
                                        ),
                                        Text(
                                          account.formattedBalance,
                                          style: BankingTypography.bodySmall.copyWith(
                                            color: BankingColors.neutral600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: BankingColors.primary500,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),

                        if (appState.accounts.where((account) => account.type == 'debit_card').isEmpty)
                          Container(
                            padding: const EdgeInsets.all(BankingTokens.space24),
                            decoration: BoxDecoration(
                              color: BankingColors.neutral50,
                              borderRadius: BorderRadius.circular(BankingTokens.radius8),
                            ),
                            child: Center(
                              child: Text(
                                'У вас нет дебетовых карт для переводов',
                                style: BankingTypography.bodyRegular.copyWith(
                                  color: BankingColors.neutral600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                        const SizedBox(height: BankingTokens.space32),

                        // Amount Input
                        Text(
                          'Сумма перевода',
                          style: BankingTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: BankingColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: BankingTokens.space16),

                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            prefixText: '\$ ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(BankingTokens.radius8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(BankingTokens.radius8),
                              borderSide: BorderSide(
                                color: _amountError != null ? BankingColors.error500 : BankingColors.primary500,
                                width: 2,
                              ),
                            ),
                            errorText: _amountError,
                            errorStyle: BankingTypography.bodySmall.copyWith(
                              color: BankingColors.error500,
                            ),
                          ),
                          style: BankingTypography.bodyLarge,
                        ),

                        if (_selectedAccount != null && _amountError == null)
                          Padding(
                            padding: const EdgeInsets.only(top: BankingTokens.space8),
                            child: Text(
                              'Максимальная сумма: ${_selectedAccount!.balance.toStringAsFixed(2)}\$',
                              style: BankingTypography.bodySmall.copyWith(
                                color: BankingColors.neutral600,
                              ),
                            ),
                          ),

                        const SizedBox(height: BankingTokens.space32),

                        // Comment Input
                        Text(
                          'Комментарий (необязательно)',
                          style: BankingTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: BankingColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: BankingTokens.space16),

                        TextField(
                          controller: _commentController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Добавьте комментарий к переводу...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(BankingTokens.radius8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(BankingTokens.radius8),
                              borderSide: BorderSide(color: BankingColors.primary500, width: 2),
                            ),
                          ),
                          style: BankingTypography.bodyRegular,
                        ),

                        const SizedBox(height: BankingTokens.space32),

                        // Buttons Row
                        Row(
                          children: [
                            Expanded(
                              child: BankingButtons.primary(
                                text: _isProcessing ? 'Выполняется...' : 'Перевести',
                                onPressed: _isProcessing ? null : _processTransfer,
                              ),
                            ),
                            const SizedBox(width: BankingTokens.space16),
                            Expanded(
                              child: BankingButtons.secondary(
                                text: 'Получить перевод',
                                onPressed: _isProcessing ? null : _receiveRandomTransfer,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: BankingTokens.space32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
