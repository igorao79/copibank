import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';
import '../components/cards.dart';
import '../components/svg_background.dart';
import '../utils/app_state.dart';
import '../../l10n/app_localizations.dart';
import 'profile_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Search and filter state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _transactionTypeFilter = 'all'; // 'all', 'income', 'expense'
  String? _selectedAccountId; // null means all accounts
  DateTimeRange? _dateRange;

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

    // Listen to search changes
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    // Initialize filtered transactions if not done yet

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
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: BankingColors.primary500,
            ),
            onPressed: () => appState.toggleTheme(),
            tooltip: 'Переключить тему',
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
            ),
          ),
        ),
        ],
        ),
        body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(BankingTokens.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search and Filter Section
              Text(
                'All transactions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: BankingTokens.space16),

              // Search bar
              _buildSearchBar(localizations),
              const SizedBox(height: BankingTokens.space16),

              // Filters
              _buildFilters(appState, localizations),
              const SizedBox(height: BankingTokens.space24),

              // Transactions List
              Builder(
                builder: (context) {
                  final filteredTransactions = _getFilteredTransactions(appState.transactions, appState.accounts);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transactions (${filteredTransactions.length})',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: BankingTokens.space16),
                      if (filteredTransactions.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(BankingTokens.space32),
                            child: Text(
                              'No transactions found',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: BankingColors.neutral500,
                              ),
                            ),
                          ),
                        )
                      else
                        ...filteredTransactions.map((transaction) {
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
                },
              ),

              const SizedBox(height: BankingTokens.space32),

              // Analytics Section
              _buildAnalyticsSection(appState, localizations),

              const SizedBox(height: BankingTokens.space32),

              // Summary Section
              Container(
                padding: const EdgeInsets.all(BankingTokens.space24),
                decoration: BoxDecoration(
                  color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
                  borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
                  boxShadow: BankingTokens.getShadow(1),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total this month',
                          style: BankingTypography.bodyRegular.semiBold,
                        ),
                        Text(
                          '-\$1,250.00',
                          style: BankingTypography.amountMedium.copyWith(
                            color: BankingColors.error500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BankingTokens.space16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.averageTransaction ?? 'Average transaction',
                          style: BankingTypography.bodyRegular,
                        ),
                        Text(
                          '-\$125.00',
                          style: BankingTypography.amountSmall.copyWith(
                            color: BankingColors.error500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
        bottomNavigationBar: _buildBottomNavigation(appState, localizations),
      ),
    );
  }

  Widget _buildAnalyticsSection(AppState appState, AppLocalizations localizations) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate analytics
    final totalIncome = appState.transactions
        .where((t) => t.amount > 0)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpenses = appState.transactions
        .where((t) => t.amount < 0)
        .fold(0.0, (sum, t) => sum + t.amount.abs());

    final transactionCount = appState.transactions.length;

    // Category breakdown
    final categoryTotals = <String, double>{};
    for (final transaction in appState.transactions) {
      categoryTotals[transaction.category] = (categoryTotals[transaction.category] ?? 0) + transaction.amount.abs();
    }

    final topCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(BankingTokens.space24),
      decoration: BoxDecoration(
        color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
        boxShadow: BankingTokens.getShadow(1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.analytics,
            style: BankingTypography.heading4,
          ),
          const SizedBox(height: BankingTokens.space16),

          // Summary cards
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  title: localizations.income,
                  amount: totalIncome,
                  color: BankingColors.success500,
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: BankingTokens.space12),
              Expanded(
                child: _buildAnalyticsCard(
                  title: localizations.expenses,
                  amount: totalExpenses,
                  color: BankingColors.error500,
                  icon: Icons.trending_down,
                ),
              ),
            ],
          ),

          const SizedBox(height: BankingTokens.space16),

          // Transaction count and average
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  title: localizations.count,
                  amount: transactionCount.toDouble(),
                  subtitle: AppLocalizations.of(context)?.transactionsCount ?? 'transactions',
                  color: BankingColors.primary500,
                  icon: Icons.receipt,
                  isCount: true,
                ),
              ),
              const SizedBox(width: BankingTokens.space12),
              Expanded(
                child: _buildAnalyticsCard(
                  title: localizations.average,
                  amount: transactionCount > 0 ? (totalExpenses / transactionCount) : 0,
                  subtitle: localizations.amount,
                  color: BankingColors.secondary500,
                  icon: Icons.calculate,
                ),
              ),
            ],
          ),

          if (topCategories.isNotEmpty) ...[
            const SizedBox(height: BankingTokens.space24),
            Text(
              localizations.topCategories,
              style: BankingTypography.bodyRegular.semiBold,
            ),
            const SizedBox(height: BankingTokens.space12),
            ...topCategories.take(3).map((entry) {
              final percentage = totalExpenses > 0 ? (entry.value / totalExpenses * 100) : 0;
              return Container(
                margin: const EdgeInsets.only(bottom: BankingTokens.space8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      '${entry.value.toStringAsFixed(0)} ₽ (${percentage.toStringAsFixed(1)}%)',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard({
    required String title,
    required double amount,
    String? subtitle,
    required Color color,
    required IconData icon,
    bool isCount = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(BankingTokens.space16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: BankingTokens.iconSizeMedium,
              ),
              const SizedBox(width: BankingTokens.space8),
              Expanded(
                child: Text(
                  title,
                  style: BankingTypography.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: BankingTokens.space8),
          Text(
            isCount
                ? amount.toInt().toString()
                : '${amount.toStringAsFixed(0)} ₽',
            style: BankingTypography.amountMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? BankingColors.neutral0
                  : BankingColors.neutral900,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: BankingTokens.space4),
            Text(
              subtitle,
              style: BankingTypography.caption.copyWith(
                color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
              ),
            ),
          ],
        ],
      ),
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
      onTap: (index) => _onBottomNavigationTap(index, appState),
      items: items,
    );
  }

  void _onBottomNavigationTap(int index, AppState appState) {
    final hasHistory = appState.accounts.isNotEmpty;
    // Корректируем индекс для соответствия main.dart логике
    int correctedIndex;
    if (hasHistory) {
      correctedIndex = index;
    } else {
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

  Widget _buildSearchBar(AppLocalizations localizations) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
        borderRadius: BorderRadius.circular(BankingTokens.radius16),
        border: Border.all(
          color: isDark ? BankingColors.neutral700 : BankingColors.neutral200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search transactions...',
          hintStyle: TextStyle(
            color: isDark ? BankingColors.neutral500 : BankingColors.neutral400,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: BankingTokens.space16,
            vertical: BankingTokens.space12,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: BankingColors.primary500,
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: BankingColors.neutral500,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
        ),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
        ),
      ),
    );
  }

  Widget _buildFilters(AppState appState, AppLocalizations localizations) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(BankingTokens.space16),
      decoration: BoxDecoration(
        color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
        borderRadius: BorderRadius.circular(BankingTokens.radius12),
        boxShadow: BankingTokens.getShadow(1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
              'Filters',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(height: BankingTokens.space16),

          // Transaction type filter
          Row(
            children: [
              Text(
                AppLocalizations.of(context)?.type ?? 'Type:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: BankingTokens.space12),
              Expanded(
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment<String>(
                      value: 'all',
                      label: Text('All'),
                    ),
                    ButtonSegment<String>(
                      value: 'income',
                      label: Text('Income'),
                    ),
                    ButtonSegment<String>(
                      value: 'expense',
                      label: Text('Expenses'),
                    ),
                  ],
                  selected: {_transactionTypeFilter},
                  showSelectedIcon: false,
                  onSelectionChanged: (Set<String> selection) {
                    setState(() {
                      _transactionTypeFilter = selection.first;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return BankingColors.primary500.withOpacity(0.1);
                      }
                      return Colors.transparent;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return BankingColors.primary500;
                      }
                      return isDark ? BankingColors.neutral400 : BankingColors.neutral600;
                    }),
                    side: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return BorderSide(color: BankingColors.primary500, width: 1);
                      }
                      return BorderSide(color: isDark ? BankingColors.neutral600 : BankingColors.neutral300, width: 1);
                    }),
                    // iconColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: BankingTokens.space16),

          // Account filter
          if (appState.accounts.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'Card:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: BankingTokens.space12),
                Expanded(
                  child: DropdownButton<String?>(
                    value: _selectedAccountId,
                    hint: const Text('All cards'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text(AppLocalizations.of(context)?.allCards ?? 'All cards'),
                      ),
                      ...appState.accounts.map((account) {
                        return DropdownMenuItem<String?>(
                          value: account.id,
                          child: Text(
                            account.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        _selectedAccountId = value;
                      });
                    },
                    underline: Container(
                      height: 1,
                      color: BankingColors.primary500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: BankingTokens.space16),
          ],

          // Date filter
          Row(
            children: [
              Text(
                'Date:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: BankingTokens.space12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDateRange: _dateRange,
                    );
                    if (picked != null) {
                      setState(() {
                        _dateRange = picked;
                      });
                    }
                  },
                  child: Text(
                    _dateRange != null
                        ? '${_dateRange!.start.day}/${_dateRange!.start.month} - ${_dateRange!.end.day}/${_dateRange!.end.month}'
                        : 'Select period',
                  ),
                ),
              ),
              if (_dateRange != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _dateRange = null;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _onTransactionTap(Transaction transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)?.transactionOpened ?? 'Открыта транзакция'} "${_getLocalizedTransactionTitle(transaction.title, AppLocalizations.of(context)!)}"'),
        duration: const Duration(seconds: 1),
      ),
    );
    // TODO: Navigate to transaction details
  }

  String _getLocalizedTransactionTitle(String titleKey, AppLocalizations localizations) {
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

  List<Transaction> _getFilteredTransactions(List<Transaction> transactions, List<Account> accounts) {
    return transactions.where((transaction) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final title = transaction.title.toLowerCase();
        final category = transaction.category.toLowerCase();
        if (!title.contains(_searchQuery) && !category.contains(_searchQuery)) {
          return false;
        }
      }

      // Transaction type filter
      if (_transactionTypeFilter == 'income' && transaction.amount < 0) {
        return false;
      }
      if (_transactionTypeFilter == 'expense' && transaction.amount > 0) {
        return false;
      }

      // Account filter
      if (_selectedAccountId != null && transaction.accountId != _selectedAccountId) {
        return false;
      }

      // Date range filter
      if (_dateRange != null) {
        if (transaction.date.isBefore(_dateRange!.start) || transaction.date.isAfter(_dateRange!.end)) {
          return false;
        }
      }

      return true;
    }).toList();
  }


  void _onViewAllNotifications() {
    // TODO: Navigate to full notifications screen
    print('Открыть экран всех уведомлений');
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }
}
