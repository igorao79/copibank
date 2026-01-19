import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../components/cards.dart';
import '../components/buttons.dart';
import '../components/fintech.dart';
import '../components/svg_background.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';
import '../utils/app_state.dart';
import '../utils/assets_constants.dart';
import '../../l10n/app_localizations.dart';
import 'profile_screen.dart';
import 'card_details_screen.dart';
import 'cashback_selection_screen.dart';
import 'transfer_screen.dart';
import 'qr_scanner_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _themeButtonController;
  late Animation<double> _themeButtonAnimation;
  late AnimationController _contentController;
  late Animation<double> _contentAnimation;

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

    _themeButtonController = AnimationController(
      duration: BankingTokens.durationFast,
      vsync: this,
    );
    _themeButtonAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _themeButtonController, curve: Curves.easeInOut),
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    // Анимируем появление контента после небольшой задержки (имитация после ввода пинкода)
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _contentController.forward();
      }
    });

    // Ensure user data is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      if (appState.userName.isEmpty) {
        appState.init(); // Reload data if needed
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _themeButtonController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    return SvgBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _navigateToProfile(),
          child: Row(
            children: [
              Icon(
                Icons.account_circle,
                color: BankingColors.primary500,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                appState.userName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: BankingColors.primary500,
                ),
              ),
            ],
          ),
        ),
        actions: [
          AnimatedBuilder(
            animation: _themeButtonAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _themeButtonAnimation.value,
                child: IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: BankingColors.primary500,
                  ),
                  onPressed: () => _toggleTheme(context),
                  tooltip: _getThemeTooltip(appState.themeMode, localizations),
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                _buildNotificationsMenu(),
                if (appState.unreadNotificationsCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: BankingColors.error500,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        appState.unreadNotificationsCount > 99
                            ? '99+'
                            : appState.unreadNotificationsCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: FadeTransition(
          opacity: _contentAnimation,
          child: appState.accounts.isEmpty
            ? // Для пользователей без карт - центрируем по всему экрану
              Center(
                child: _buildWelcomeSection(localizations),
              )
            : SingleChildScrollView(
              padding: EdgeInsets.only(
                left: BankingTokens.screenHorizontalPadding,
                right: BankingTokens.screenHorizontalPadding,
                top: BankingTokens.screenVerticalPadding,
                bottom: BankingTokens.screenVerticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: BankingTokens.durationNormal,
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    // Balance Section
                    _buildBalanceSection(appState, localizations),

                    const SizedBox(height: BankingTokens.space32),

                    // Accounts/Cards Section
                    _buildAccountsSection(appState, localizations),

                    const SizedBox(height: BankingTokens.space24),

                    // Savings Account Section
                    if (appState.savingsAccount != null)
                      _buildSavingsSection(appState),

                    const SizedBox(height: BankingTokens.space32),

                    // Cashback Section
                    if (appState.accounts.isNotEmpty)
                      _buildCashbackSection(appState, localizations),

                    const SizedBox(height: BankingTokens.space32),

                    // Quick Actions
                    _buildQuickActions(appState, localizations),

                    const SizedBox(height: BankingTokens.space32),

                    // Chart Section
                    _buildChartSection(localizations),

                    const SizedBox(height: BankingTokens.space32),

                    // Recent Transactions
                    _buildRecentTransactions(appState, localizations),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigation(appState, localizations),
      ),
    );
  }

  Widget _buildBalanceSection(AppState appState, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.totalBalance,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: BankingTokens.space8),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: appState.balance, end: appState.balance),
          duration: BankingTokens.durationNormal,
          builder: (context, value, child) {
            return AnimatedScale(
              scale: 1.0,
              duration: BankingTokens.durationFast,
              child: Text(
                '\$${value.toStringAsFixed(2)}',
                style: BankingTypography.amountLarge.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? BankingColors.neutral0
                      : BankingColors.neutral900,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSavingsSection(AppState appState) {
    final savings = appState.savingsAccount!;
    final monthlyIncome = savings.getMonthlyIncome(1);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(BankingTokens.space16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            BankingColors.primary100,
            BankingColors.primary50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(BankingTokens.radius12),
        border: Border.all(
          color: BankingColors.primary200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: BankingColors.primary500,
              borderRadius: BorderRadius.circular(BankingTokens.radius12),
            ),
            child: const Icon(
              Icons.savings,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: BankingTokens.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.savingsAccount,
                  style: BankingTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: BankingColors.neutral900,
                  ),
                ),
                const SizedBox(height: BankingTokens.space4),
                Text(
                  '\$${savings.balance.toStringAsFixed(2)}',
                  style: BankingTypography.amountMedium.copyWith(
                    color: BankingColors.neutral700,
                  ),
                ),
                const SizedBox(height: BankingTokens.space4),
                Text(
                  'Через месяц: +\$${monthlyIncome.toStringAsFixed(2)}',
                  style: BankingTypography.caption.copyWith(
                    color: BankingColors.success600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showSavingsDepositDialog(appState),
            icon: Icon(
              Icons.add_circle,
              color: BankingColors.success600,
              size: 28,
            ),
            tooltip: localizations.depositAccount,
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(BankingTokens.space24),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? BankingColors.neutral800
                  : BankingColors.neutral0,
              borderRadius: BorderRadius.circular(BankingTokens.radius16),
              boxShadow: BankingTokens.getShadow(2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Lottie.asset(
                    'assets/lottie/success.json',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: BankingTokens.space16),
                Text(
                  '${AppLocalizations.of(context)?.accountDeposited ?? 'Счет пополнен на'} \$${amount.toStringAsFixed(2)}',
                  style: BankingTypography.bodyLarge.copyWith(
                    color: BankingColors.success600,
                    fontWeight: FontWeight.w600,
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

  void _showSavingsDepositDialog(AppState appState) {
    final localizations = AppLocalizations.of(context)!;
    final TextEditingController amountController = TextEditingController();
    Account? selectedAccount;

    // Фильтруем карты - только дебетовые с положительным балансом
    final availableAccounts = appState.accounts
        .where((account) => account.type == 'debit_card' && account.balance > 0)
        .toList();

    // Если нет доступных дебетовых карт, показываем сообщение об ошибке
    if (availableAccounts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.noDebitCardsAvailable),
          backgroundColor: BankingColors.error500,
        ),
      );
      return;
    }

    // По умолчанию выбираем первую доступную карту
    selectedAccount = availableAccounts.first;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(AppLocalizations.of(context)?.depositSavingsTitle ?? 'Пополнение накопительного счета'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Выбор карты (если несколько доступных)
                if (availableAccounts.length > 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.chooseCard,
                        style: BankingTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: BankingTokens.space8),
                      DropdownButtonFormField<Account>(
                        value: selectedAccount,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: availableAccounts.map((account) {
                          return DropdownMenuItem<Account>(
                            value: account,
                            child: Text(
                              '**** ${account.cardNumber?.substring(account.cardNumber!.length - 4) ?? '****'} - ${account.formattedBalance}',
                              style: BankingTypography.bodySmall,
                            ),
                          );
                        }).toList(),
                        onChanged: (account) {
                          setState(() {
                            selectedAccount = account;
                          });
                        },
                      ),
                      const SizedBox(height: BankingTokens.space16),
                    ],
                  ),

                // Поле ввода суммы
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Сумма',
                    prefixText: '\$ ',
                    hintText: '0.00',
                  ),
                ),
                const SizedBox(height: BankingTokens.space16),
                Text(
                  'Доступно: \$${selectedAccount?.balance.toStringAsFixed(2) ?? '0.00'}',
                  style: BankingTypography.caption.copyWith(
                    color: BankingColors.neutral600,
                  ),
                ),
              ],
            ),
            actions: [
              // Центрируем кнопку отмены
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)?.cancel ?? 'Отмена'),
                ),
              ),
              const SizedBox(height: BankingTokens.space16), // Отступ между кнопками
              ElevatedButton(
                onPressed: () async {
                  final validation = _validateAmount(amountController.text, selectedAccount);
                  if (validation != null) {
                    // Показываем ошибку валидации
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(validation),
                        backgroundColor: BankingColors.error500,
                      ),
                    );
                    return;
                  }

                  final amount = double.tryParse(amountController.text.replaceAll(',', '.'));
                  if (amount != null && amount > 0 && selectedAccount != null) {
                    final success = await appState.depositToSavingsFromAccount(amount, selectedAccount!);
                    if (success) {
                      Navigator.of(context).pop();
                      _showSuccessDialog(amount);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)?.insufficientFundsGeneral ?? 'Недостаточно средств'),
                          backgroundColor: BankingColors.error500,
                        ),
                      );
                    }
                  }
                },
                child: Text(AppLocalizations.of(context)?.deposit ?? 'Пополнить'),
              ),
              const SizedBox(height: BankingTokens.space16), // Отступ перед кнопкой удаления
              Center(
                child: TextButton(
                  onPressed: () async {
                    // Показываем диалог подтверждения
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(localizations.deleteSavingsAccount),
                          content: const Text('Вы уверены, что хотите удалить накопительный счет? Все средства будут потеряны.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(localizations.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: TextButton.styleFrom(
                                foregroundColor: BankingColors.error500,
                              ),
                              child: Text(localizations.deleteSavingsAccount),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed == true) {
                      final localizations = AppLocalizations.of(context);
                      final success = await appState.deleteSavingsAccount(localizations);
                      if (success) {
                        Navigator.of(context).pop(); // Закрываем диалог пополнения
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Накопительный счет удален'),
                            backgroundColor: BankingColors.error500,
                          ),
                        );
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: BankingColors.error500,
                  ),
                  child: Text(localizations.deleteSavingsAccount),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Валидация суммы
  String? _validateAmount(String value, Account? selectedAccount) {
    if (value.isEmpty) return null;

    final amount = double.tryParse(value.replaceAll(',', '.'));
    if (amount == null) return 'Введите корректную сумму';

    if (amount <= 0) return 'Сумма должна быть больше 0';

    if (selectedAccount != null && amount > selectedAccount.balance) {
      return 'Недостаточно средств на выбранной карте';
    }

    return null;
  }

  Widget _buildQuickActions(AppState appState, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.quickActions,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: BankingTokens.space16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: appState.quickActions.map((action) {
          return BankingCards.quickAction(
            title: _getLocalizedActionTitle(action.id, localizations),
            icon: action.icon,
            iconColor: action.color,
            onTap: () => _onQuickActionTap(action.id),
          );
        }).toList(),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(AppLocalizations localizations) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Bank Logo
        SizedBox(
          height: 80,
          width: 80,
          child: Image.asset(
            WebpAssets.logoBank,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: BankingTokens.space16),

        // Success Text
        Text(
          localizations.loginSuccess,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: BankingColors.primary500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: BankingTokens.space16),

        // Welcome Text
        Text(
          localizations.welcomeMessage,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? BankingColors.neutral200
                : BankingColors.neutral700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: BankingTokens.space32),

        // Apply Button
        Center(
          child: SizedBox(
            width: 200, // Fixed width for the button
            child: BankingButtons.primary(
              text: 'Оформить карту',
              onPressed: () => _navigateToApply(),
              fullWidth: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection(AppLocalizations localizations) {
    // Sample chart data with more realistic spending pattern
    final chartData = [
      ChartDataPoint(label: 'Пн', value: 850, color: BankingColors.primary500),
      ChartDataPoint(label: 'Вт', value: 1250, color: BankingColors.primary500),
      ChartDataPoint(label: 'Ср', value: 680, color: BankingColors.primary500),
      ChartDataPoint(label: 'Чт', value: 1450, color: BankingColors.primary500),
      ChartDataPoint(label: 'Пт', value: 2100, color: BankingColors.primary500),
      ChartDataPoint(label: 'Сб', value: 3200, color: BankingColors.primary500),
      ChartDataPoint(label: 'Вс', value: 1800, color: BankingColors.primary500),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.weeklySpending,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => _onViewAllCharts(),
              child: Text(
                localizations.viewAll,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: BankingColors.primary500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: BankingTokens.space16),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? BankingColors.neutral800
                : BankingColors.neutral0,
            borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
            boxShadow: BankingTokens.getShadow(1),
          ),
          child: BankingFintech.balanceChart(
            data: chartData,
            title: null,
            height: 180,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(AppState appState, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.recentTransactions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => _onViewAllTransactions(),
              child: Text(
                localizations.viewAll,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: BankingColors.primary500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: BankingTokens.space16),
        ...appState.transactions.take(5).map((transaction) {
          return Padding(
            padding: const EdgeInsets.only(bottom: BankingTokens.space12),
                  child: BankingCards.transaction(
                    title: _getLocalizedTransactionTitle(transaction.title, localizations),
                    amount: transaction.formattedAmount,
                    subtitle: _formatTransactionDate(transaction.date),
                    icon: transaction.icon,
                    iconColor: transaction.isPositive
                        ? BankingColors.success500
                        : BankingColors.primary500,
                    onTap: () => _onTransactionTap(transaction),
                  ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomNavigation(AppState appState, AppLocalizations localizations) {
    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance),
        label: localizations.myBank,
      ),
    ];

    // Добавляем историю только если есть карты
    if (appState.accounts.isNotEmpty) {
      items.add(BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: localizations.history,
      ));
    }

    items.addAll([
      BottomNavigationBarItem(
        icon: Icon(Icons.chat),
        label: localizations.chats,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle),
        label: localizations.apply,
      ),
    ]);

    // Вычисляем currentIndex для BottomNavigationBar
    int currentNavIndex;
    final hasHistory = appState.accounts.isNotEmpty;
    if (hasHistory) {
      currentNavIndex = appState.selectedTabIndex;
    } else {
      switch (appState.selectedTabIndex) {
        case 0:
          currentNavIndex = 0; // Мой банк
          break;
        case 2:
          currentNavIndex = 1; // Чаты
          break;
        case 3:
          currentNavIndex = 2; // Оформить
          break;
        default:
          currentNavIndex = 0;
      }
    }

    return BottomNavigationBar(
      currentIndex: currentNavIndex,
      onTap: (index) => _onBottomNavigationTap(index, appState, hasHistory: hasHistory),
      items: items,
    );
  }

  void _onQuickActionTap(String actionId) {
    switch (actionId) {
      case 'transfer':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const TransferScreen(),
          ),
        );
        break;
      case 'pay':
        // TODO: Navigate to bill payment
        print('Открыть экран оплаты счетов');
        break;
      case 'topup':
        // TODO: Navigate to top up
        print('Открыть экран пополнения');
        break;
      case 'scan':
        // Open QR scanner
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const QrScannerScreen(),
          ),
        ).then((scannedCode) {
          if (scannedCode != null && scannedCode is String) {
            // Обработка отсканированного QR кода
            print('Отсканирован QR код: $scannedCode');
            // Здесь можно добавить логику обработки QR кода
          }
        });
        break;
    }
  }

  void _toggleTheme(BuildContext context) {
    _themeButtonController.forward().then((_) {
      _themeButtonController.reverse();
    });
    context.read<AppState>().toggleTheme();
  }

  String _getThemeTooltip(ThemeMode themeMode, AppLocalizations localizations) {
    switch (themeMode) {
      case ThemeMode.system:
        return localizations.systemTheme;
      case ThemeMode.light:
        return localizations.lightTheme;
      case ThemeMode.dark:
        return localizations.darkTheme;
    }
  }

  Widget _buildNotificationsMenu() {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      icon: Icon(
        isDark ? BankingIcons.notification : BankingIcons.notificationFilled,
        color: BankingColors.primary500,
      ),
      onSelected: (value) {
        if (value == 'view_all') {
          _onViewAllNotifications();
        }
      },
      onOpened: () {
        appState.markAllNotificationsAsRead();
      },
      itemBuilder: (BuildContext context) {
        final notifications = appState.notifications;
        final unreadCount = notifications.where((n) => !n.isRead).length;

        return [
          PopupMenuItem<String>(
            enabled: false,
            child: Text(
              unreadCount > 0
                  ? '${localizations.notificationsHeader} (${unreadCount} ${localizations.unreadNotifications})'
                  : localizations.notificationsHeader,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const PopupMenuDivider(),
          ...notifications.take(3).map((notification) {
            return PopupMenuItem<String>(
              enabled: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.getLocalizedTitle(localizations),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: BankingColors.primary500,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  if (notification.getLocalizedMessage(localizations).isNotEmpty)
                    Text(
                      notification.getLocalizedMessage(localizations),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? BankingColors.neutral400
                            : BankingColors.neutral600,
                      ),
                    ),
                  Text(
                    notification.getTimeAgo(AppLocalizations.of(context)),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? BankingColors.neutral500
                          : BankingColors.neutral500,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }),
          if (notifications.length > 3)
            const PopupMenuDivider(),
          if (notifications.length > 3)
            PopupMenuItem<String>(
              value: 'view_all',
              child: Row(
                children: [
                  Icon(Icons.expand_more, size: 16),
                  const SizedBox(width: 8),
                  Text(localizations.viewAllNotifications),
                ],
              ),
            ),
        ];
      },
    );
  }

  void _onViewAllNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)?.openAllNotifications ?? 'Открыть экран всех уведомлений'),
        duration: const Duration(seconds: 1),
      ),
    );
    // TODO: Navigate to full notifications screen
    print('Открыть экран всех уведомлений');
  }


  void _navigateToApply() {
    final appState = context.read<AppState>();
    // "Оформить" всегда имеет индекс 3 в main.dart
    appState.setSelectedTabIndex(3);
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  void _onBottomNavigationTap(int index, AppState appState, {bool hasHistory = true}) {
    // Корректируем индекс для соответствия main.dart логике
    int correctedIndex;
    if (hasHistory) {
      // С историей: [0:Мой банк, 1:История, 2:Чаты, 3:Оформить]
      correctedIndex = index;
    } else {
      // Без истории: [0:Мой банк, 1:Чаты->2, 2:Оформить->3]
      switch (index) {
        case 0:
          correctedIndex = 0; // Мой банк
          break;
        case 1:
          correctedIndex = 2; // Чаты
          break;
        case 2:
          correctedIndex = 3; // Оформить
          break;
        default:
          correctedIndex = 0;
      }
    }
    appState.setSelectedTabIndex(correctedIndex);
  }


  void _onTransactionTap(Transaction transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)?.transactionOpened ?? 'Открыта транзакция'} "${transaction.title}"'),
        duration: const Duration(seconds: 1),
      ),
    );
    // TODO: Navigate to transaction details screen
    print('Открыть детали транзакции: ${transaction.title}');
  }

  void _onViewAllCharts() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)?.openFullChart ?? 'Открыть полный график расходов'),
        duration: Duration(seconds: 1),
      ),
    );
    // TODO: Navigate to detailed charts screen
    print('Открыть экран с подробными графиками');
  }

  void _onViewAllTransactions() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)?.openAllTransactions ?? 'Открыть все транзакции'),
        duration: Duration(seconds: 1),
      ),
    );
    // TODO: Navigate to transactions list screen
    print('Открыть экран со всеми транзакциями');
  }

  String _getLocalizedTransactionTitle(String titleKey, AppLocalizations localizations) {
    // For now, use the existing localized keys. Later we can expand this
    switch (titleKey) {
      case 'Amazon Purchase':
        return localizations.amazonPurchase;
      case 'Salary Deposit':
        return localizations.salaryDeposit;
      case 'Coffee Shop':
        return localizations.coffeeShop;
      case 'Electricity Bill':
        return localizations.electricityBill;
      case 'Freelance Payment':
        return localizations.freelancePayment;
      default:
        return titleKey;
    }
  }

  String _getLocalizedActionTitle(String actionId, AppLocalizations localizations) {
    switch (actionId) {
      case 'transfer':
        return localizations.transfer;
      case 'pay':
        return localizations.payBills;
      case 'topup':
        return localizations.topUp;
      case 'scan':
        return localizations.scanQR;
      default:
        return actionId;
    }
  }

  String _formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final localizations = AppLocalizations.of(context)!;

    if (difference.inDays == 0) {
      return localizations.today;
    } else if (difference.inDays == 1) {
      return localizations.yesterday;
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${localizations.daysAgo}';
    } else {
      return '${date.month}/${date.day}';
    }
  }

  Widget _buildAccountsSection(AppState appState, AppLocalizations localizations) {
    if (appState.accounts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.myCards,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: BankingTokens.space16),
        ...appState.accounts.map((account) => Padding(
          padding: const EdgeInsets.only(bottom: BankingTokens.space12),
          child: GestureDetector(
            onTap: () => _onAccountTap(account),
            child: Container(
              padding: const EdgeInsets.all(BankingTokens.space16),
              decoration: BoxDecoration(
                color: account.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(BankingTokens.radius12),
                border: Border.all(
                  color: account.color.withOpacity(0.3),
                  width: 1,
                ),
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
                    child: const Icon(
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
                          account.type == 'credit_card' ? localizations.creditCard : localizations.debitCard,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            print('DEBUG: Dashboard displaying card ${account.id}:');
                            print('  cardNumber: ${account.cardNumber}');
                            print('  formattedBalance: ${account.formattedBalance}');
                            return Text(
                              account.cardNumber ?? '**** **** **** ****',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Text(
                    account.formattedBalance,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: account.isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }

  void _onAccountTap(Account account) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardDetailsScreen(account: account),
      ),
    );
  }

  Widget _buildCashbackSection(AppState appState, AppLocalizations localizations) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.myCashback,
          style: BankingTypography.heading3,
        ),
        const SizedBox(height: BankingTokens.space16),
        Container(
          padding: const EdgeInsets.all(BankingTokens.space24),
          decoration: BoxDecoration(
            color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
            borderRadius: BorderRadius.circular(BankingTokens.radius16),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: appState.hasSelectedCashbackCategories
              ? _buildSelectedCashbackCategories(appState, localizations)
              : _buildCashbackSetup(appState, localizations),
        ),
      ],
    );
  }

  Widget _buildCashbackSetup(AppState appState, AppLocalizations localizations) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(BankingTokens.space12),
              decoration: BoxDecoration(
                color: BankingColors.primary100,
                borderRadius: BorderRadius.circular(BankingTokens.radius12),
              ),
              child: Icon(
                Icons.local_offer,
                color: BankingColors.primary500,
                size: 24,
              ),
            ),
            const SizedBox(width: BankingTokens.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.setupCashback,
                  style: BankingTypography.bodyRegular.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                  ),
                  ),
                  const SizedBox(height: BankingTokens.space4),
                  Text(
                    localizations.cashbackDescription,
                    style: BankingTypography.caption.copyWith(
                      color: isDark ? BankingColors.neutral400 : BankingColors.neutral600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? BankingColors.neutral500 : BankingColors.neutral400,
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: BankingTokens.space16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CashbackSelectionScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: BankingColors.primary500,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: BankingTokens.space12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BankingTokens.radius12),
              ),
            ),
            child: Text(
              localizations.selectCategories,
              style: BankingTypography.button,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCashbackCategories(AppState appState, AppLocalizations localizations) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Активные категории кэшбэка',
          style: BankingTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
          ),
        ),
        const SizedBox(height: BankingTokens.space16),
        Wrap(
          spacing: BankingTokens.space12,
          runSpacing: BankingTokens.space12,
          children: appState.selectedCashbackCategories.map((category) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: BankingTokens.space12,
                vertical: BankingTokens.space8,
              ),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.1),
                border: Border.all(
                  color: category.color.withOpacity(0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(BankingTokens.radius16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    size: 16,
                    color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
                  ),
                  const SizedBox(width: BankingTokens.space8),
                  Text(
                    category.name,
                    style: BankingTypography.caption.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
                    ),
                  ),
                  const SizedBox(width: BankingTokens.space8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: BankingTokens.space8,
                      vertical: BankingTokens.space4,
                    ),
                    decoration: BoxDecoration(
                      color: category.color,
                      borderRadius: BorderRadius.circular(BankingTokens.radius8),
                    ),
                    child: Text(
                      '${category.percentage}%',
                      style: BankingTypography.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
