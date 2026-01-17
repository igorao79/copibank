import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../components/cards.dart';
import '../components/svg_background.dart';
import '../utils/app_state.dart';
import '../../l10n/app_localizations.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  DateTimeRange? _selectedDateRange;
  List<Transaction> _filteredTransactions = [];

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

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterTransactions();
    });
  }

  void _filterTransactions() {
    final appState = context.read<AppState>();
    List<Transaction> filtered = appState.transactions;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        return transaction.title.toLowerCase().contains(_searchQuery) ||
               transaction.category.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply date filter
    if (_selectedDateRange != null) {
      filtered = filtered.where((transaction) {
        return transaction.date.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) &&
               transaction.date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    _filteredTransactions = filtered;
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange ?? DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _filterTransactions();
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedDateRange = null;
      _searchController.clear();
      _searchQuery = '';
      _filterTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    // Initialize filtered transactions if not done yet
    if (_filteredTransactions.isEmpty && _searchQuery.isEmpty && _selectedDateRange == null) {
      _filteredTransactions = appState.transactions;
    }

    return SvgBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          localizations.transactions,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
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
                'Все транзакции',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: BankingTokens.space16),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: BankingTokens.space16),
                decoration: BoxDecoration(
                  color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
                  borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
                  boxShadow: BankingTokens.getShadow(1),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Поиск транзакций...',
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                  ),
                ),
              ),

              const SizedBox(height: BankingTokens.space24),

              // Filter and Search Controls
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: BankingTokens.space16),
                      decoration: BoxDecoration(
                        color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
                        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
                        boxShadow: BankingTokens.getShadow(1),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Поиск транзакций...',
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: BankingTokens.space12),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
                      borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
                      boxShadow: BankingTokens.getShadow(1),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: (_selectedDateRange != null) ? BankingColors.primary500 : (isDark ? BankingColors.neutral400 : BankingColors.neutral500),
                      ),
                      onPressed: _selectDateRange,
                      tooltip: 'Фильтр по дате',
                    ),
                  ),
                  if (_selectedDateRange != null || _searchQuery.isNotEmpty) ...[
                    const SizedBox(width: BankingTokens.space8),
                    Container(
                      decoration: BoxDecoration(
                        color: BankingColors.error500,
                        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
                        boxShadow: BankingTokens.getShadow(1),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: BankingColors.neutral0,
                        ),
                        onPressed: _clearFilters,
                        tooltip: 'Очистить фильтры',
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: BankingTokens.space32),

              // Analytics Section
              _buildAnalyticsSection(localizations),

              const SizedBox(height: BankingTokens.space32),

              // Transactions List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Транзакции (${_filteredTransactions.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (_selectedDateRange != null)
                    Text(
                      '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: BankingColors.primary500,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: BankingTokens.space16),

              ..._filteredTransactions.map((transaction) {
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
                          'Итого за месяц',
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
                          'Средняя транзакция',
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

  Widget _buildAnalyticsSection(AppLocalizations localizations) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate analytics
    final totalIncome = _filteredTransactions
        .where((t) => t.amount > 0)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpenses = _filteredTransactions
        .where((t) => t.amount < 0)
        .fold(0.0, (sum, t) => sum + t.amount.abs());

    final transactionCount = _filteredTransactions.length;

    // Category breakdown
    final categoryTotals = <String, double>{};
    for (final transaction in _filteredTransactions) {
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
                  subtitle: 'транзакций',
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

  void _onTransactionTap(Transaction transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Открыта транзакция "${_getLocalizedTransactionTitle(transaction.title, AppLocalizations.of(context)!)}"'),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
