import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

/// App State Management
/// Centralized state management for the banking application
class AppState extends ChangeNotifier {
  // Navigation management
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  // Cashback management
  final List<CashbackCategory> _allCashbackCategories = [
    const CashbackCategory(
      id: 'food',
      name: 'Еда и рестораны',
      icon: Icons.restaurant,
      description: 'Кэшбэк на рестораны, кафе и доставку еды',
      percentage: 5.0,
      color: Color(0xFF4CAF50),
    ),
    const CashbackCategory(
      id: 'shopping',
      name: 'Покупки',
      icon: Icons.shopping_bag,
      description: 'Кэшбэк на одежду, электронику и товары',
      percentage: 3.0,
      color: Color(0xFF2196F3),
    ),
    const CashbackCategory(
      id: 'travel',
      name: 'Путешествия',
      icon: Icons.flight,
      description: 'Кэшбэк на авиабилеты, отели и транспорт',
      percentage: 4.0,
      color: Color(0xFFFF9800),
    ),
    const CashbackCategory(
      id: 'fuel',
      name: 'Топливо',
      icon: Icons.local_gas_station,
      description: 'Кэшбэк на заправки и топливо',
      percentage: 2.0,
      color: Color(0xFFFF5722),
    ),
    const CashbackCategory(
      id: 'entertainment',
      name: 'Развлечения',
      icon: Icons.movie,
      description: 'Кэшбэк на кино, концерты и развлечения',
      percentage: 3.5,
      color: Color(0xFF9C27B0),
    ),
    const CashbackCategory(
      id: 'supermarket',
      name: 'Супермаркеты',
      icon: Icons.shopping_cart,
      description: 'Кэшбэк на продукты и товары в супермаркетах',
      percentage: 2.5,
      color: Color(0xFF795548),
    ),
  ];

  List<String> _selectedCashbackCategoryIds = [];
  bool _hasSelectedCashbackCategories = false;

  List<CashbackCategory> get allCashbackCategories => _allCashbackCategories;
  List<CashbackCategory> get selectedCashbackCategories => _allCashbackCategories
      .where((category) => _selectedCashbackCategoryIds.contains(category.id))
      .toList();
  bool get hasSelectedCashbackCategories => _hasSelectedCashbackCategories;

  // Initialize data from SharedPreferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? _userName;
    _userEmail = prefs.getString('user_email') ?? _userEmail;
    _userLanguage = prefs.getString('user_language') ?? _userLanguage;
    _selectedCashbackCategoryIds = prefs.getStringList('selected_cashback_categories') ?? [];
    _hasSelectedCashbackCategories = prefs.getBool('has_selected_cashback_categories') ?? false;

    // Load cards data
  final cardIds = prefs.getStringList('user_cards') ?? [];
  print('DEBUG: Found ${cardIds.length} cards in SharedPreferences');

  // Очистите _accounts перед загрузкой
  _accounts.clear();

  for (final cardId in cardIds) {
    final cardNumber = prefs.getString('card_${cardId}_number');
    final expireDate = prefs.getString('card_${cardId}_expire');
    final cvc = prefs.getString('card_${cardId}_cvc');
    final balance = prefs.getDouble('card_${cardId}_balance');

    print('DEBUG: Loading card $cardId:');
    print('  number: $cardNumber');
    print('  expire: $expireDate');
    print('  cvc: $cvc');
    print('  balance: $balance');

    // Проверяем что ВСЕ данные загружены
    if (cardNumber != null && cardNumber.isNotEmpty &&
        expireDate != null && cvc != null && balance != null) {

      // Форматируем номер карты для отображения
      final formattedNumber = _formatCardNumber(cardNumber);

      final account = Account(
        id: cardId,
        name: 'Дебетовая карта',
        type: 'debit_card',
        balance: balance, // ← Реальный баланс из SharedPreferences
        currency: 'USD',
        color: const Color(0xFF2196F3),
        isPrimary: _accounts.isEmpty,
        cardNumber: formattedNumber, // ← Реальный номер из генератора
        expireDate: expireDate, // ← Реальная дата из генератора
        cvc: cvc, // ← Реальный CVC из генератора
      );
      _accounts.add(account);
      print('DEBUG: ✓ Added card with number: $formattedNumber, balance: $balance');
    } else {
      print('DEBUG: ✗ Skipping card $cardId - missing data');
      print('  cardNumber is null: ${cardNumber == null}');
      print('  expireDate is null: ${expireDate == null}');
      print('  cvc is null: ${cvc == null}');
      print('  balance is null: ${balance == null}');
    }
  }

  print('DEBUG: Total cards loaded: ${_accounts.length}');

    print('DEBUG: Loaded user data - name: $_userName, email: $_userEmail, language: $_userLanguage, cards: ${_accounts.length}');
    notifyListeners();
  }

  // Theme management
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // User management
  String _userName = ''; // Default user name - loaded from SharedPreferences
  String get userName => _userName;

  String _userEmail = ''; // Default user email - loaded from SharedPreferences
  String get userEmail => _userEmail;

  String _userLanguage = 'ru'; // Default language
  String get userLanguage => _userLanguage;

  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }

  void setUserLanguage(String language) async {
    _userLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_language', language);
    notifyListeners();
  }

  void toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.system:
        _themeMode = ThemeMode.light;
        break;
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }

  // User balance - calculated from all accounts
  double get balance => _accounts.fold<double>(0.0, (sum, account) => sum + account.balance);

  void addAccount(Account account) {
    print('DEBUG: addAccount called with ID: ${account.id}, cardNumber: ${account.cardNumber}');
    print('DEBUG: Before adding - account object: $account');
    _accounts.add(account);
    print('DEBUG: Account added to local list. Total accounts: ${_accounts.length}');
    print('DEBUG: After adding - accounts[0] cardNumber: ${_accounts[0].cardNumber}');

    // Add notification about new card
    final notification = NotificationItem(
      id: 'card_${account.id}_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Карта оформлена!',
      message: 'Ваша новая дебетовая карта готова к использованию',
      timestamp: DateTime.now(),
      isRead: false,
      type: NotificationType.transaction,
    );
    _notifications.insert(0, notification);

    notifyListeners();
  }

  Future<void> removeAccount(String accountId) async {
    _accounts.removeWhere((account) => account.id == accountId);

    // Remove from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final existingCards = prefs.getStringList('user_cards') ?? [];
    existingCards.remove(accountId);
    await prefs.setStringList('user_cards', existingCards);
    await prefs.remove('card_${accountId}_number');
    await prefs.remove('card_${accountId}_expire');
    await prefs.remove('card_${accountId}_cvc');
    await prefs.remove('card_${accountId}_balance');

    notifyListeners();
  }

  // Recent transactions
  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      title: 'Amazon Purchase',
      amount: -89.99,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      category: 'Shopping',
      icon: Icons.shopping_cart,
    ),
    Transaction(
      id: '2',
      title: 'Salary Deposit',
      amount: 3500.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Income',
      icon: Icons.account_balance_wallet,
    ),
    Transaction(
      id: '3',
      title: 'Coffee Shop',
      amount: -4.50,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      category: 'Food',
      icon: Icons.restaurant,
    ),
    Transaction(
      id: '4',
      title: 'Electricity Bill',
      amount: -120.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Utilities',
      icon: Icons.flash_on,
    ),
    Transaction(
      id: '5',
      title: 'Freelance Payment',
      amount: 750.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Income',
      icon: Icons.work,
    ),
  ];

  List<Transaction> get transactions => _transactions;

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  // Quick actions
  final List<QuickAction> _quickActions = [
    QuickAction(
      id: 'transfer',
      title: 'Transfer',
      icon: Icons.send,
      color: const Color(0xFF0077FF),
    ),
    QuickAction(
      id: 'topup',
      title: 'Top Up',
      icon: Icons.add_circle,
      color: const Color(0xFFFFC107),
    ),
    QuickAction(
      id: 'scan',
      title: 'Scan QR',
      icon: Icons.qr_code_scanner,
      color: const Color(0xFF9C27B0),
    ),
  ];

  List<QuickAction> get quickActions => _quickActions;

  // Accounts - starts empty, will be populated by user actions
  final List<Account> _accounts = [];

  List<Account> get accounts => _accounts;
  Account? get primaryAccount => _accounts.isEmpty ? null : _accounts.firstWhere((account) => account.isPrimary, orElse: () => _accounts.first);

  // Notifications
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Добро пожаловать!', // Will be localized later
      message: 'Вы успешно вошли в систему',
      timestamp: DateTime.now(),
      isRead: false,
      type: NotificationType.welcome,
    ),
  ];

  List<NotificationItem> get notifications => _notifications;

  void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void markNotificationAsRead(String notificationId) {
    final notification = _notifications.firstWhere((n) => n.id == notificationId);
    notification.isRead = true;
    notifyListeners();
  }

  void markAllNotificationsAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }

  int get unreadNotificationsCount {
    return _notifications.where((n) => !n.isRead).length;
  }

  // Cashback methods
  Future<void> selectCashbackCategories(List<String> categoryIds) async {
    if (categoryIds.length > 3) {
      throw ArgumentError('Можно выбрать не более 3 категорий кэшбэка');
    }

    _selectedCashbackCategoryIds = categoryIds;
    _hasSelectedCashbackCategories = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selected_cashback_categories', categoryIds);
    await prefs.setBool('has_selected_cashback_categories', true);

    // Add notification about cashback categories selection
    addNotification(NotificationItem(
      id: 'cashback_selected_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Категории кэшбэка выбраны',
      message: 'Вы выбрали ${categoryIds.length} категорию(й) для получения кэшбэка',
      timestamp: DateTime.now(),
      type: NotificationType.promotion,
    ));

    notifyListeners();
  }

  // Helper method to format card number for display
  String _formatCardNumber(String cardNumber) {
    // Убираем все пробелы
    final cleanNumber = cardNumber.replaceAll(' ', '');

    // Если номер уже отформатирован или некорректен, возвращаем как есть
    if (cleanNumber.length != 16) {
      return cardNumber;
    }

    // Форматируем: XXXX XXXX XXXX XXXX
    return '${cleanNumber.substring(0, 4)} ${cleanNumber.substring(4, 8)} ${cleanNumber.substring(8, 12)} ${cleanNumber.substring(12, 16)}';
  }
}

/// Transaction Model
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final IconData icon;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.icon,
  });

  bool get isPositive => amount >= 0;
  bool get isNegative => amount < 0;

  String get formattedAmount => '${isPositive ? '+' : ''}\$${amount.abs().toStringAsFixed(2)}';
}

/// Quick Action Model
class QuickAction {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  const QuickAction({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

/// Account Model
class Account {
  final String id;
  final String name;
  final String type;
  final double balance;
  final String currency;
  final Color color;
  final bool isPrimary;
  final String? cardNumber;
  final String? expireDate;
  final String? cvc;

  Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
    required this.color,
    required this.isPrimary,
    this.cardNumber,
    this.expireDate,
    this.cvc,
  }) {
    // Debug logging in constructor
    print('DEBUG: Account constructor called:');
    print('  id: $id');
    print('  cardNumber: $cardNumber');
    print('  expireDate: $expireDate');
    print('  cvc: $cvc');
    print('  balance: $balance');
  }

  bool get isPositive => balance >= 0;
  bool get isNegative => balance < 0;

  String get formattedBalance => '${isPositive ? '' : '-'}\$${balance.abs().toStringAsFixed(2)}';
}

/// Notification Types
enum NotificationType {
  welcome,
  transaction,
  security,
  promotion,
}

/// Notification Model
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final NotificationType type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} д. назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ч. назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} мин. назад';
    } else {
      return 'только что';
    }
  }
}

/// Cashback Category Model
class CashbackCategory {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final double percentage;
  final Color color;

  const CashbackCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.percentage,
    required this.color,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CashbackCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
