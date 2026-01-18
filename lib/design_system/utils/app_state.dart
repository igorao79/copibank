import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

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

    // Load sticker data for each card
    final stickerKeys = prefs.getKeys().where((key) => key.startsWith('sticker_')).toList();
    print('DEBUG: Found sticker keys: $stickerKeys');

    // Load savings account
    final savingsId = prefs.getString('savings_account_id');
    if (savingsId != null) {
      final savingsBalance = prefs.getDouble('savings_account_balance') ?? 0.0;
      final savingsRate = prefs.getDouble('savings_account_rate') ?? 0.05;
      final savingsCreatedStr = prefs.getString('savings_account_created');
      final savingsCreated = savingsCreatedStr != null
          ? DateTime.parse(savingsCreatedStr)
          : DateTime.now();

      _savingsAccount = SavingsAccount(
        id: savingsId,
        balance: savingsBalance,
        interestRate: savingsRate,
        createdDate: savingsCreated,
      );
      print('DEBUG: Loaded savings account: $savingsId, balance: $savingsBalance');
    }

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

      // Проверяем, есть ли стикер
      final hasSticker = prefs.getBool('sticker_$cardId') ?? false;

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
        hasSticker: hasSticker,
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

  // Transfer money between accounts
  Future<bool> transferMoney({
    required Account fromAccount,
    required TransferUser toUser,
    required double amount,
    String? comment,
  }) async {
    // Validate transfer
    if (amount <= 0) return false;
    if (fromAccount.balance < amount) return false;
    if (fromAccount.type != 'debit_card') return false; // Only debit cards allowed

    // Update account balance
    final accountIndex = _accounts.indexWhere((acc) => acc.id == fromAccount.id);
    if (accountIndex == -1) return false;

    final updatedAccount = Account(
      id: fromAccount.id,
      name: fromAccount.name,
      type: fromAccount.type,
      balance: fromAccount.balance - amount,
      currency: fromAccount.currency,
      color: fromAccount.color,
      isPrimary: fromAccount.isPrimary,
      cardNumber: fromAccount.cardNumber,
      expireDate: fromAccount.expireDate,
      cvc: fromAccount.cvc,
      hasSticker: fromAccount.hasSticker,
    );

    _accounts[accountIndex] = updatedAccount;

    // Save updated balance to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('card_${fromAccount.id}_balance', updatedAccount.balance);

    // Add transaction
    final transactionId = 'transfer_${DateTime.now().millisecondsSinceEpoch}';
    final transaction = Transaction(
      id: transactionId,
      title: 'Перевод ${toUser.name}',
      amount: -amount,
      date: DateTime.now(),
      category: 'Transfer',
      icon: Icons.send,
    );
    addTransaction(transaction);

    // Add notification
    final notification = NotificationItem(
      id: 'transfer_${transactionId}',
      title: 'Перевод выполнен',
      message: 'Перевод ${amount.toStringAsFixed(2)}\$ пользователю ${toUser.name} выполнен успешно',
      timestamp: DateTime.now(),
      isRead: false,
      type: NotificationType.transaction,
    );
    _notifications.insert(0, notification);

    notifyListeners();
    return true;
  }

  // Receive random transfer from random user
  Future<void> receiveRandomTransfer() async {
    final random = Random();
    final randomUser = _transferUsers[random.nextInt(_transferUsers.length)];
    final randomAmount = 1 + random.nextInt(1000); // 1 to 1000 dollars

    // Add to first debit account if exists
    final debitAccounts = _accounts.where((acc) => acc.type == 'debit_card').toList();
    if (debitAccounts.isNotEmpty) {
      final account = debitAccounts.first;
      final accountIndex = _accounts.indexOf(account);

      final updatedAccount = Account(
        id: account.id,
        name: account.name,
        type: account.type,
        balance: account.balance + randomAmount,
        currency: account.currency,
        color: account.color,
        isPrimary: account.isPrimary,
        cardNumber: account.cardNumber,
        expireDate: account.expireDate,
        cvc: account.cvc,
        hasSticker: account.hasSticker,
      );

      _accounts[accountIndex] = updatedAccount;

      // Save updated balance to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('card_${account.id}_balance', updatedAccount.balance);

      // Add transaction
      final transactionId = 'receive_${DateTime.now().millisecondsSinceEpoch}';
      final transaction = Transaction(
        id: transactionId,
        title: 'Получен перевод от ${randomUser.name}',
        amount: randomAmount.toDouble(),
        date: DateTime.now(),
        category: 'Income',
        icon: Icons.arrow_downward,
      );
      addTransaction(transaction);

      // Add notification
      final notification = NotificationItem(
        id: 'receive_${transactionId}',
        title: 'Получен перевод',
        message: 'Вы получили ${randomAmount.toStringAsFixed(2)}\$ от ${randomUser.name}',
        timestamp: DateTime.now(),
        isRead: false,
        type: NotificationType.transaction,
      );
      _notifications.insert(0, notification);

      notifyListeners();
    }
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
      id: 'scan',
      title: 'Scan QR',
      icon: Icons.qr_code_scanner,
      color: const Color(0xFF9C27B0),
    ),
  ];

  List<QuickAction> get quickActions => _quickActions;

  // Transfer users - mock users available for transfers
  final List<TransferUser> _transferUsers = [
    TransferUser(
      id: '1',
      name: 'Анна Иванова',
      avatarUrl: 'local_avatar_1', // Using local identifiers instead of external URLs
      phoneNumber: '+7 (999) 123-45-67',
    ),
    TransferUser(
      id: '2',
      name: 'Михаил Петров',
      avatarUrl: 'local_avatar_2',
      phoneNumber: '+7 (999) 234-56-78',
    ),
    TransferUser(
      id: '3',
      name: 'Елена Сидорова',
      avatarUrl: 'local_avatar_3',
      phoneNumber: '+7 (999) 345-67-89',
    ),
    TransferUser(
      id: '4',
      name: 'Дмитрий Козлов',
      avatarUrl: 'local_avatar_4',
      phoneNumber: '+7 (999) 456-78-90',
    ),
    TransferUser(
      id: '5',
      name: 'Ольга Новикова',
      avatarUrl: 'local_avatar_5',
      phoneNumber: '+7 (999) 567-89-01',
    ),
    TransferUser(
      id: '6',
      name: 'Алексей Морозов',
      avatarUrl: 'local_avatar_6',
      phoneNumber: '+7 (999) 678-90-12',
    ),
    TransferUser(
      id: '7',
      name: 'Мария Волкова',
      avatarUrl: 'local_avatar_7',
      phoneNumber: '+7 (999) 789-01-23',
    ),
    TransferUser(
      id: '8',
      name: 'Сергей Соколов',
      avatarUrl: 'local_avatar_8',
      phoneNumber: '+7 (999) 890-12-34',
    ),
  ];

  List<TransferUser> get transferUsers => _transferUsers;

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

  // Support chat messages
  int _unreadSupportMessages = 1; // Start with 1 unread message

  int get unreadSupportMessages => _unreadSupportMessages;

  void markSupportMessagesAsRead() {
    _unreadSupportMessages = 0;
    notifyListeners();
  }

  // Savings account
  SavingsAccount? _savingsAccount;

  SavingsAccount? get savingsAccount => _savingsAccount;

  bool get canOpenSavingsAccount => _accounts.isNotEmpty && _savingsAccount == null;

  bool get canOrderSticker => _accounts.any((account) => !account.hasSticker);

  Future<bool> openSavingsAccount() async {
    if (!canOpenSavingsAccount) return false;

    _savingsAccount = SavingsAccount(
      id: 'savings_${DateTime.now().millisecondsSinceEpoch}',
      balance: 0.0,
      interestRate: 0.05, // 5% annual interest
      createdDate: DateTime.now(),
    );

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savings_account_id', _savingsAccount!.id);
    await prefs.setDouble('savings_account_balance', _savingsAccount!.balance);
    await prefs.setDouble('savings_account_rate', _savingsAccount!.interestRate);
    await prefs.setString('savings_account_created', _savingsAccount!.createdDate.toIso8601String());

    // Add notification
    final notification = NotificationItem(
      id: 'savings_${_savingsAccount!.id}',
      title: 'Накопительный счет открыт!',
      message: 'Теперь вы можете копить деньги под 5% годовых',
      timestamp: DateTime.now(),
      isRead: false,
      type: NotificationType.transaction,
    );
    _notifications.insert(0, notification);

    notifyListeners();
    return true;
  }

  Future<bool> depositToSavings(double amount) async {
    if (_savingsAccount == null || amount <= 0) return false;

    // Check if user has enough money in any account
    final totalBalance = _accounts.fold<double>(0, (sum, account) => sum + account.balance);
    if (totalBalance < amount) return false;

    // Find account with sufficient balance (prefer debit cards)
    final debitAccounts = _accounts.where((acc) => acc.type == 'debit_card' && acc.balance >= amount).toList();
    Account? sourceAccount;

    if (debitAccounts.isNotEmpty) {
      sourceAccount = debitAccounts.first;
    } else {
      // Find any account with sufficient balance
      sourceAccount = _accounts.firstWhere((acc) => acc.balance >= amount);
    }

    // Update source account
    final sourceIndex = _accounts.indexOf(sourceAccount);
    final updatedSourceAccount = Account(
      id: sourceAccount.id,
      name: sourceAccount.name,
      type: sourceAccount.type,
      balance: sourceAccount.balance - amount,
      currency: sourceAccount.currency,
      color: sourceAccount.color,
      isPrimary: sourceAccount.isPrimary,
      cardNumber: sourceAccount.cardNumber,
      expireDate: sourceAccount.expireDate,
      cvc: sourceAccount.cvc,
      hasSticker: sourceAccount.hasSticker,
    );
    _accounts[sourceIndex] = updatedSourceAccount;

    // Update savings account
    final updatedSavingsAccount = SavingsAccount(
      id: _savingsAccount!.id,
      balance: _savingsAccount!.balance + amount,
      interestRate: _savingsAccount!.interestRate,
      createdDate: _savingsAccount!.createdDate,
    );
    _savingsAccount = updatedSavingsAccount;

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('savings_account_balance', _savingsAccount!.balance);
    await prefs.setDouble('card_${sourceAccount.id}_balance', updatedSourceAccount.balance);

    // Add transaction
    final transactionId = 'savings_deposit_${DateTime.now().millisecondsSinceEpoch}';
    final transaction = Transaction(
      id: transactionId,
      title: 'Пополнение накопительного счета',
      amount: -amount,
      date: DateTime.now(),
      category: 'Savings',
      icon: Icons.savings,
    );
    addTransaction(transaction);

    // Add notification
    final notification = NotificationItem(
      id: 'savings_deposit_$transactionId',
      title: 'Счет пополнен',
      message: 'Зачислено ${amount.toStringAsFixed(2)}\$ на накопительный счет',
      timestamp: DateTime.now(),
      isRead: false,
      type: NotificationType.transaction,
    );
    _notifications.insert(0, notification);

    notifyListeners();
    return true;
  }

  Future<bool> depositFromSavingsToCard(Account account, double amount) async {
    if (_savingsAccount == null || _savingsAccount!.balance < amount || amount <= 0) return false;

    // Update savings account
    final updatedSavingsAccount = SavingsAccount(
      id: _savingsAccount!.id,
      balance: _savingsAccount!.balance - amount,
      interestRate: _savingsAccount!.interestRate,
      createdDate: _savingsAccount!.createdDate,
    );
    _savingsAccount = updatedSavingsAccount;

    // Update card account
    final accountIndex = _accounts.indexOf(account);
    if (accountIndex == -1) return false;

    final updatedAccount = Account(
      id: account.id,
      name: account.name,
      type: account.type,
      balance: account.balance + amount,
      currency: account.currency,
      color: account.color,
      isPrimary: account.isPrimary,
      cardNumber: account.cardNumber,
      expireDate: account.expireDate,
      cvc: account.cvc,
      hasSticker: account.hasSticker,
    );
    _accounts[accountIndex] = updatedAccount;

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('savings_account_balance', _savingsAccount!.balance);
    await prefs.setDouble('card_${account.id}_balance', updatedAccount.balance);

    // Add transaction
    final transactionId = 'savings_to_card_${DateTime.now().millisecondsSinceEpoch}';
    final transaction = Transaction(
      id: transactionId,
      title: 'Пополнение карты с накопительного счета',
      amount: amount,
      date: DateTime.now(),
      category: 'Deposit',
      icon: Icons.add_circle,
    );
    addTransaction(transaction);

    // Add notification
    final notification = NotificationItem(
      id: 'deposit_$transactionId',
      title: 'Карта пополнена',
      message: 'Зачислено \$${amount.toStringAsFixed(2)} с накопительного счета',
      timestamp: DateTime.now(),
      isRead: false,
      type: NotificationType.transaction,
    );
    _notifications.insert(0, notification);

    notifyListeners();
    return true;
  }

  // Sticker methods
  Future<void> attachSticker(String accountId) async {
    final accountIndex = _accounts.indexWhere((account) => account.id == accountId);
    if (accountIndex != -1) {
      final updatedAccount = Account(
        id: _accounts[accountIndex].id,
        name: _accounts[accountIndex].name,
        type: _accounts[accountIndex].type,
        balance: _accounts[accountIndex].balance,
        currency: _accounts[accountIndex].currency,
        color: _accounts[accountIndex].color,
        isPrimary: _accounts[accountIndex].isPrimary,
        cardNumber: _accounts[accountIndex].cardNumber,
        expireDate: _accounts[accountIndex].expireDate,
        cvc: _accounts[accountIndex].cvc,
        hasSticker: true,
      );
      _accounts[accountIndex] = updatedAccount;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sticker_${accountId}', true);

      notifyListeners();
    }
  }

  Future<void> detachSticker(String accountId) async {
    final accountIndex = _accounts.indexWhere((account) => account.id == accountId);
    if (accountIndex != -1) {
      final updatedAccount = Account(
        id: _accounts[accountIndex].id,
        name: _accounts[accountIndex].name,
        type: _accounts[accountIndex].type,
        balance: _accounts[accountIndex].balance,
        currency: _accounts[accountIndex].currency,
        color: _accounts[accountIndex].color,
        isPrimary: _accounts[accountIndex].isPrimary,
        cardNumber: _accounts[accountIndex].cardNumber,
        expireDate: _accounts[accountIndex].expireDate,
        cvc: _accounts[accountIndex].cvc,
        hasSticker: false,
      );
      _accounts[accountIndex] = updatedAccount;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('sticker_${accountId}');

      notifyListeners();
    }
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
  final bool hasSticker;

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
    this.hasSticker = false,
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

/// Transfer User Model
/// Model for users available for money transfers
class TransferUser {
  final String id;
  final String name;
  final String avatarUrl;
  final String phoneNumber;

  const TransferUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.phoneNumber,
  });
}

/// Savings Account Model
/// Model for savings account with interest calculation
class SavingsAccount {
  final String id;
  final double balance;
  final double interestRate; // Annual interest rate (e.g., 0.05 for 5%)
  final DateTime createdDate;

  const SavingsAccount({
    required this.id,
    required this.balance,
    required this.interestRate,
    required this.createdDate,
  });

  // Calculate projected balance after given months
  double getProjectedBalance(int months) {
    final monthlyRate = interestRate / 12;
    return balance * (1 + monthlyRate * months);
  }

  // Get monthly income projection
  double getMonthlyIncome(int months) {
    return getProjectedBalance(months) - balance;
  }
}
