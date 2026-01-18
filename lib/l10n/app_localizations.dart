import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// App Localizations
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'appTitle': 'Banki2 - Banking App',
      'dashboard': 'Dashboard',
      'totalBalance': 'Total Balance',
      'quickActions': 'Quick Actions',
      'weeklySpending': 'Weekly Spending',
      'recentTransactions': 'Recent Transactions',
      'viewAll': 'View All',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'daysAgo': 'days ago',
      'transfer': 'Transfer',
      'payBills': 'Pay Bills',
      'topUp': 'Top Up',
      'scanQR': 'Scan QR',
      'home': 'Home',
      'transactions': 'Transactions',
      'cards': 'Cards',
      'profile': 'Profile',
      'myBank': 'My Bank',
      'history': 'History',
      'chats': 'Chats',
      'apply': 'Apply',
      'notifications': 'Notifications',
      'techSupport': 'Tech Support',
      'messagesAndSupport': 'Messages and Support',
      'messagesDescription': 'Get help and view notifications here',
      'analytics': 'Expense Analytics',
      'income': 'Income',
      'expenses': 'Expenses',
      'count': 'Count',
      'average': 'Average',
      'amount': 'amount',
      'topCategories': 'Top Categories',
      'settings': 'Settings',
      'switchToLightTheme': 'Switch to light theme',
      'switchToDarkTheme': 'Switch to dark theme',
      'systemTheme': 'System theme (tap to switch to light)',
      'lightTheme': 'Light theme (tap to switch to dark)',
      'darkTheme': 'Dark theme (tap to switch to system)',
      'mainAccount': 'Main Account',
      'savings': 'Savings',
      'creditCard': 'Credit Card',
      'checking': 'Checking',
      'amazonPurchase': 'Amazon Purchase',
      'salaryDeposit': 'Salary Deposit',
      'coffeeShop': 'Coffee Shop',
      'electricityBill': 'Electricity Bill',
      'freelancePayment': 'Freelance Payment',
      'shopping': 'Shopping',
      'food': 'Food',
      'transport': 'Transport',
      'entertainment': 'Entertainment',
      'health': 'Health',
      'education': 'Education',
      'utilities': 'Utilities',
      'viewAllNotifications': 'View all notifications',
      'welcomeMessage': 'Welcome!',
      'loginSuccess': 'You have successfully logged in',
      'notificationsHeader': 'Notifications',
      'unreadNotifications': 'unread notifications',
    },
    'ru': {
      'appTitle': 'Banki2 - Банковское приложение',
      'dashboard': 'Главная',
      'totalBalance': 'Общий баланс',
      'quickActions': 'Быстрые действия',
      'weeklySpending': 'Расходы за неделю',
      'recentTransactions': 'Последние транзакции',
      'viewAll': 'Показать все',
      'today': 'Сегодня',
      'yesterday': 'Вчера',
      'daysAgo': 'дней назад',
      'transfer': 'Перевод',
      'payBills': 'Оплатить счета',
      'topUp': 'Пополнить',
      'scanQR': 'Сканировать QR',
      'home': 'Главная',
      'transactions': 'Транзакции',
      'cards': 'Карты',
      'profile': 'Профиль',
      'myBank': 'Мой банк',
      'history': 'История',
      'chats': 'Чаты',
      'apply': 'Оформить',
      'notifications': 'Уведомления',
      'techSupport': 'Тех поддержка',
      'messagesAndSupport': 'Сообщения и поддержка',
      'messagesDescription': 'Здесь вы можете получить помощь и просмотреть уведомления',
      'analytics': 'Аналитика расходов',
      'income': 'Доходы',
      'expenses': 'Расходы',
      'count': 'Количество',
      'average': 'Средняя',
      'amount': 'сумма',
      'topCategories': 'Топ категорий',
      'settings': 'Настройки',
      'switchToLightTheme': 'Переключить на светлую тему',
      'switchToDarkTheme': 'Переключить на тёмную тему',
      'systemTheme': 'Системная тема (нажмите для переключения на светлую)',
      'lightTheme': 'Светлая тема (нажмите для переключения на тёмную)',
      'darkTheme': 'Тёмная тема (нажмите для переключения на системную)',
      'mainAccount': 'Основной счёт',
      'savings': 'Сбережения',
      'creditCard': 'Кредитная карта',
      'checking': 'Расчётный',
      'amazonPurchase': 'Покупка в Amazon',
      'salaryDeposit': 'Зарплатный перевод',
      'coffeeShop': 'Кофейня',
      'electricityBill': 'Счёт за электричество',
      'freelancePayment': 'Фриланс оплата',
      'shopping': 'Покупки',
      'food': 'Еда',
      'transport': 'Транспорт',
      'entertainment': 'Развлечения',
      'health': 'Здоровье',
      'education': 'Образование',
      'utilities': 'Коммунальные услуги',
      'viewAllNotifications': 'Показать все уведомления',
      'welcomeMessage': 'Добро пожаловать!',
      'loginSuccess': 'Вы успешно вошли',
      'notificationsHeader': 'Уведомления',
      'unreadNotifications': 'непрочитанных',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]?['appTitle'] ?? 'Banki2';
  String get dashboard => _localizedValues[locale.languageCode]?['dashboard'] ?? 'Dashboard';
  String get totalBalance => _localizedValues[locale.languageCode]?['totalBalance'] ?? 'Total Balance';
  String get quickActions => _localizedValues[locale.languageCode]?['quickActions'] ?? 'Quick Actions';
  String get weeklySpending => _localizedValues[locale.languageCode]?['weeklySpending'] ?? 'Weekly Spending';
  String get recentTransactions => _localizedValues[locale.languageCode]?['recentTransactions'] ?? 'Recent Transactions';
  String get viewAll => _localizedValues[locale.languageCode]?['viewAll'] ?? 'View All';
  String get today => _localizedValues[locale.languageCode]?['today'] ?? 'Today';
  String get yesterday => _localizedValues[locale.languageCode]?['yesterday'] ?? 'Yesterday';
  String get daysAgo => _localizedValues[locale.languageCode]?['daysAgo'] ?? 'days ago';
  String get transfer => _localizedValues[locale.languageCode]?['transfer'] ?? 'Transfer';
  String get payBills => _localizedValues[locale.languageCode]?['payBills'] ?? 'Pay Bills';
  String get topUp => _localizedValues[locale.languageCode]?['topUp'] ?? 'Top Up';
  String get scanQR => _localizedValues[locale.languageCode]?['scanQR'] ?? 'Scan QR';
  String get home => _localizedValues[locale.languageCode]?['home'] ?? 'Home';
  String get transactions => _localizedValues[locale.languageCode]?['transactions'] ?? 'Transactions';
  String get cards => _localizedValues[locale.languageCode]?['cards'] ?? 'Cards';
  String get profile => _localizedValues[locale.languageCode]?['profile'] ?? 'Profile';
  String get myBank => _localizedValues[locale.languageCode]?['myBank'] ?? 'My Bank';
  String get history => _localizedValues[locale.languageCode]?['history'] ?? 'History';
  String get chats => _localizedValues[locale.languageCode]?['chats'] ?? 'Chats';
  String get apply => _localizedValues[locale.languageCode]?['apply'] ?? 'Apply';
  String get notifications => _localizedValues[locale.languageCode]?['notifications'] ?? 'Notifications';
  String get techSupport => _localizedValues[locale.languageCode]?['techSupport'] ?? 'Tech Support';
  String get messagesAndSupport => _localizedValues[locale.languageCode]?['messagesAndSupport'] ?? 'Messages and Support';
  String get messagesDescription => _localizedValues[locale.languageCode]?['messagesDescription'] ?? 'Get help and view notifications here';
  String get analytics => _localizedValues[locale.languageCode]?['analytics'] ?? 'Analytics';
  String get income => _localizedValues[locale.languageCode]?['income'] ?? 'Income';
  String get expenses => _localizedValues[locale.languageCode]?['expenses'] ?? 'Expenses';
  String get count => _localizedValues[locale.languageCode]?['count'] ?? 'Count';
  String get average => _localizedValues[locale.languageCode]?['average'] ?? 'Average';
  String get amount => _localizedValues[locale.languageCode]?['amount'] ?? 'Amount';
  String get topCategories => _localizedValues[locale.languageCode]?['topCategories'] ?? 'Top Categories';
  String get settings => _localizedValues[locale.languageCode]?['settings'] ?? 'Settings';
  String get switchToLightTheme => _localizedValues[locale.languageCode]?['switchToLightTheme'] ?? 'Switch to light theme';
  String get switchToDarkTheme => _localizedValues[locale.languageCode]?['switchToDarkTheme'] ?? 'Switch to dark theme';
  String get systemTheme => _localizedValues[locale.languageCode]?['systemTheme'] ?? 'System theme';
  String get lightTheme => _localizedValues[locale.languageCode]?['lightTheme'] ?? 'Light theme';
  String get darkTheme => _localizedValues[locale.languageCode]?['darkTheme'] ?? 'Dark theme';
  String get mainAccount => _localizedValues[locale.languageCode]?['mainAccount'] ?? 'Main Account';
  String get savings => _localizedValues[locale.languageCode]?['savings'] ?? 'Savings';
  String get creditCard => _localizedValues[locale.languageCode]?['creditCard'] ?? 'Credit Card';
  String get checking => _localizedValues[locale.languageCode]?['checking'] ?? 'Checking';
  String get amazonPurchase => _localizedValues[locale.languageCode]?['amazonPurchase'] ?? 'Amazon Purchase';
  String get salaryDeposit => _localizedValues[locale.languageCode]?['salaryDeposit'] ?? 'Salary Deposit';
  String get coffeeShop => _localizedValues[locale.languageCode]?['coffeeShop'] ?? 'Coffee Shop';
  String get electricityBill => _localizedValues[locale.languageCode]?['electricityBill'] ?? 'Electricity Bill';
  String get freelancePayment => _localizedValues[locale.languageCode]?['freelancePayment'] ?? 'Freelance Payment';
  String get shopping => _localizedValues[locale.languageCode]?['shopping'] ?? 'Shopping';
  String get food => _localizedValues[locale.languageCode]?['food'] ?? 'Food';
  String get transport => _localizedValues[locale.languageCode]?['transport'] ?? 'Transport';
  String get entertainment => _localizedValues[locale.languageCode]?['entertainment'] ?? 'Entertainment';
  String get health => _localizedValues[locale.languageCode]?['health'] ?? 'Health';
  String get education => _localizedValues[locale.languageCode]?['education'] ?? 'Education';
  String get utilities => _localizedValues[locale.languageCode]?['utilities'] ?? 'Utilities';
  String get viewAllNotifications => _localizedValues[locale.languageCode]?['viewAllNotifications'] ?? 'View all notifications';
  String get welcomeMessage => _localizedValues[locale.languageCode]?['welcomeMessage'] ?? 'Welcome!';
  String get loginSuccess => _localizedValues[locale.languageCode]?['loginSuccess'] ?? 'You have successfully logged in';
  String get notificationsHeader => _localizedValues[locale.languageCode]?['notificationsHeader'] ?? 'Notifications';
  String get unreadNotifications => _localizedValues[locale.languageCode]?['unreadNotifications'] ?? 'unread notifications';

  String getTransactionTitle(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  String getAccountType(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

/// Delegate for AppLocalizations
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
