import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/cards.dart';
import '../components/buttons.dart';
import '../components/fintech.dart';
import '../components/svg_background.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';
import '../utils/app_state.dart';
import '../../l10n/app_localizations.dart';

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
        title: Text(
          localizations.dashboard,
          style: Theme.of(context).textTheme.headlineSmall,
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
                    color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
                  ),
                  onPressed: () => _toggleTheme(context),
                  tooltip: _getThemeTooltip(appState.themeMode, localizations),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              isDark ? BankingIcons.notification : BankingIcons.notificationFilled,
              color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
            ),
            onPressed: () => _onNotificationsTap(),
          ),
          IconButton(
            icon: Icon(
              BankingIcons.settings,
              color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
            ),
            onPressed: () => _onSettingsTap(),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
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
                children: appState.accounts.isEmpty
                  ? [
                      // Для пользователей без карт
                      _buildWelcomeSection(localizations),
                    ]
                  : [
                      // Balance Section
                      _buildBalanceSection(appState, localizations),

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
        // App Bank SVG
        SizedBox(
          height: 200,
          width: 200,
          child: SvgPicture.asset(
            'svg/app-bank.svg',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: BankingTokens.space32),

        // Welcome Text
        Text(
          'Станьте нашим клиентом',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: BankingTokens.space16),

        Text(
          'Откройте для себя все возможности современного банкинга',
          style: Theme.of(context).textTheme.bodyLarge,
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
    // Sample chart data
    final chartData = [
      ChartDataPoint(label: 'Mon', value: 1200, color: BankingColors.primary500),
      ChartDataPoint(label: 'Tue', value: 1800, color: BankingColors.primary500),
      ChartDataPoint(label: 'Wed', value: 1400, color: BankingColors.primary500),
      ChartDataPoint(label: 'Thu', value: 2200, color: BankingColors.primary500),
      ChartDataPoint(label: 'Fri', value: 1600, color: BankingColors.primary500),
      ChartDataPoint(label: 'Sat', value: 1900, color: BankingColors.primary500),
      ChartDataPoint(label: 'Sun', value: 2100, color: BankingColors.primary500),
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
        content: Text('Действие "${_getLocalizedActionTitle(actionId, AppLocalizations.of(context)!)}" выбрано'),
        duration: const Duration(seconds: 1),
      ),
    );

    switch (actionId) {
      case 'transfer':
        // TODO: Navigate to transfer screen
        print('Открыть экран перевода');
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

  void _onNotificationsTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Уведомления открыты'),
        duration: const Duration(seconds: 1),
      ),
    );
    // TODO: Navigate to notifications screen
    print('Открыть экран уведомлений');
  }

  void _onSettingsTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Настройки открыты'),
        duration: const Duration(seconds: 1),
      ),
    );
    // TODO: Navigate to settings screen
    print('Открыть экран настроек');
  }

  void _navigateToApply() {
    final appState = context.read<AppState>();
    final hasHistory = appState.accounts.isNotEmpty;
    // Индекс вкладки "Оформить" зависит от наличия вкладки "История"
    final applyIndex = hasHistory ? 3 : 2;
    appState.setSelectedTabIndex(applyIndex);
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
        content: Text('Открыта транзакция "${transaction.title}"'),
        duration: const Duration(seconds: 1),
      ),
    );
    // TODO: Navigate to transaction details screen
    print('Открыть детали транзакции: ${transaction.title}');
  }

  void _onViewAllCharts() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Открыть полный график расходов'),
        duration: Duration(seconds: 1),
      ),
    );
    // TODO: Navigate to detailed charts screen
    print('Открыть экран с подробными графиками');
  }

  void _onViewAllTransactions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Открыть все транзакции'),
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
}
