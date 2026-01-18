import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../components/cards.dart';
import 'package:flutter/material.dart' show Badge;
import '../components/buttons.dart';
import '../components/fintech.dart';
import '../components/svg_background.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';
import '../utils/app_state.dart';
import '../../l10n/app_localizations.dart';
import 'profile_screen.dart';
import 'card_details_screen.dart';
import 'cashback_selection_screen.dart';
import 'transfer_screen.dart';

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
            child: Badge(
            label: appState.unreadNotificationsCount > 0
                ? Text(
                    appState.unreadNotificationsCount.toString(),
                    style: const TextStyle(fontSize: 9),
                  )
                : null,
            smallSize: 14,
              child: PopupMenuButton<String>(
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
                // Header with unread count
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
                // Notifications list
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
                                notification.title,
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
                        Text(
                          notification.message,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? BankingColors.neutral400
                                : BankingColors.neutral600,
                          ),
                        ),
                        Text(
                          notification.timeAgo,
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
            ),
          ),
        ),
        ],
        ),
        body: FadeTransition(
        opacity: _fadeAnimation,
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
                  'Накопительный счет',
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
            tooltip: 'Пополнить счет',
          ),
        ],
      ),
    );
  }

  void _showSavingsDepositDialog(AppState appState) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(AppLocalizations.of(context)?.depositSavingsTitle ?? 'Пополнение накопительного счета'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Сумма',
                    prefixText: '\$ ',
                    hintText: '0.00',
                  ),
                ),
                const SizedBox(height: BankingTokens.space16),
                Text(
                  'Доступно: \$${appState.balance.toStringAsFixed(2)}',
                  style: BankingTypography.caption.copyWith(
                    color: BankingColors.neutral600,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)?.cancel ?? 'Отмена'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final amount = double.tryParse(amountController.text.replaceAll(',', '.'));
                  if (amount != null && amount > 0) {
                    final success = await appState.depositToSavings(amount);
                    if (success) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${AppLocalizations.of(context)?.accountDeposited ?? 'Счет пополнен на'} \$${amount.toStringAsFixed(2)}'),
                          backgroundColor: BankingColors.success500,
                        ),
                      );
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
            ],
          ),
        );
      },
    );
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
        // Success Text
        Text(
          localizations.loginSuccess,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: BankingColors.success500,
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
    // Show feedback when action is tapped
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)?.actionSelected ?? 'Действие'} "${_getLocalizedActionTitle(actionId, AppLocalizations.of(context)!)}" ${AppLocalizations.of(context)?.actionSelected == 'Action selected' ? 'selected' : 'выбрано'}'),
        duration: const Duration(seconds: 1),
      ),
    );

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
        // TODO: Open QR scanner
        print('Открыть сканер QR');
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
          'Мои карты',
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
                          account.name,
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
          'Мой кэшбэк',
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
              ? _buildSelectedCashbackCategories(appState)
              : _buildCashbackSetup(appState),
        ),
      ],
    );
  }

  Widget _buildCashbackSetup(AppState appState) {
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
                    'Настройте кэшбэк',
                  style: BankingTypography.bodyRegular.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                  ),
                  ),
                  const SizedBox(height: BankingTokens.space4),
                  Text(
                    'Выберите до 3 категорий и получайте кэшбэк до 5%',
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
              'Выбрать категории',
              style: BankingTypography.button,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCashbackCategories(AppState appState) {
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
