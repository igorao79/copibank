import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App State Management
/// Centralized state management for the banking application
class AppState extends ChangeNotifier {
  // Navigation management
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  // Initialize data from SharedPreferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? _userName;
    _userEmail = prefs.getString('user_email') ?? _userEmail;
    _userLanguage = prefs.getString('user_language') ?? _userLanguage;
    notifyListeners();
  }

  // Theme management
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // User management
  String _userName = 'Игорь'; // Default user name
  String get userName => _userName;

  String _userEmail = 'igor@example.com'; // Default user email
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

  // User balance
  double _balance = 15420.75;
  double get balance => _balance;

  void updateBalance(double newBalance) {
    _balance = newBalance;
    notifyListeners();
  }

  void addAccount(Account account) {
    _accounts.add(account);
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
      title: 'Добро пожаловать!',
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

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
    required this.color,
    required this.isPrimary,
  });

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
