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
      'insufficientFunds': 'Insufficient funds in savings account',
      'selectRecipient': 'Select recipient',
      'selectCard': 'Select card for transfer',
      'debitOnly': 'Transfers are only possible from debit cards',
      'enterValidAmount': 'Enter valid amount',
      'insufficientCardFunds': 'Insufficient funds on card',
      'transferError': 'Transfer execution error',
      'receiveError': 'Receive transfer error',
      'depositSavingsTitle': 'Deposit to savings account',
      'cancel': 'Cancel',
      'accountDeposited': 'Account deposited with',
      'insufficientFundsGeneral': 'Insufficient funds',
      'deposit': 'Deposit',
      'actionSelected': 'Action selected',
      'openAllNotifications': 'Open all notifications screen',
      'transactionOpened': 'Transaction opened',
      'openFullChart': 'Open full expense chart',
      'openAllTransactions': 'Open all transactions',
      'noCardsForSticker': 'No available cards for sticker attachment. Apply for a card first.',
      'applyCard': 'Apply for card',
      'applySticker': 'Apply for sticker',
      'openAccount': 'Open account',
      'error': 'Error',
      'cardOpened': 'Card opened',
      'action': 'Action',
      'openCardDetails': 'Open detailed card information',
      'cardLimitReached': 'Card limit reached (maximum 4 cards)',
      'agree': 'Agree',
      'cardSuccessfullyApplied': 'Card successfully applied!',
      'linkCopied': 'Link copied!',
      'later': 'Later',
      'linkSent': 'Link sent!',
      'send': 'Send',
      'dataSaveError': 'Data save error',
      'changeName': 'Change name',
      'nameChangedSuccessfully': 'Name changed successfully',
      'save': 'Save',
      'changeEmail': 'Change email',
      'emailChangedSuccessfully': 'Email changed successfully',
      'changePassword': 'Change password',
      'passwordChangedSuccessfully': 'Password changed successfully',
      'passwordsDontMatch': 'Passwords don\'t match',
      'selectLanguage': 'Select language',
      'russian': 'Russian',
      'languageChangedToRussian': 'Language changed to Russian',
      'english': 'English',
      'languageChangedToEnglish': 'Language changed to English',
      'selectTheme': 'Select theme',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'logout': 'Logout',
      'logoutConfirmation': 'Are you sure you want to log out?',
      'loggedOut': 'You have been logged out',
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
      'insufficientFunds': 'Недостаточно средств на накопительном счете',
      'selectRecipient': 'Выберите получателя',
      'selectCard': 'Выберите карту для перевода',
      'debitOnly': 'Переводы возможны только с дебетовых карт',
      'enterValidAmount': 'Введите корректную сумму',
      'insufficientCardFunds': 'Недостаточно средств на карте',
      'transferError': 'Ошибка при выполнении перевода',
      'receiveError': 'Ошибка при получении перевода',
      'depositSavingsTitle': 'Пополнение накопительного счета',
      'cancel': 'Отмена',
      'accountDeposited': 'Счет пополнен на',
      'insufficientFundsGeneral': 'Недостаточно средств',
      'deposit': 'Пополнить',
      'actionSelected': 'Действие выбрано',
      'openAllNotifications': 'Открыть экран всех уведомлений',
      'transactionOpened': 'Открыта транзакция',
      'openFullChart': 'Открыть полный график расходов',
      'openAllTransactions': 'Открыть все транзакции',
      'noCardsForSticker': 'Нет доступных дебетовых карт для привязки стикера. Сначала оформите дебетовую карту.',
      'applyCard': 'Оформить карту',
      'applySticker': 'Оформить стикер',
      'openAccount': 'Открыть счет',
      'error': 'Ошибка',
      'cardOpened': 'Открыта карта',
      'action': 'Действие',
      'openCardDetails': 'Открыть подробную информацию о карте',
      'cardLimitReached': 'Достигнут лимит карт (максимум 4 карты)',
      'agree': 'Согласен',
      'cardSuccessfullyApplied': 'Карта успешно оформлена!',
      'linkCopied': 'Ссылка скопирована!',
      'later': 'Позже',
      'linkSent': 'Ссылка отправлена!',
      'send': 'Отправить',
      'dataSaveError': 'Ошибка сохранения данных',
      'changeName': 'Изменить имя',
      'nameChangedSuccessfully': 'Имя успешно изменено',
      'save': 'Сохранить',
      'changeEmail': 'Изменить email',
      'emailChangedSuccessfully': 'Email успешно изменен',
      'changePassword': 'Изменить пароль',
      'passwordChangedSuccessfully': 'Пароль успешно изменен',
      'passwordsDontMatch': 'Пароли не совпадают',
      'selectLanguage': 'Выберите язык',
      'russian': 'Русский',
      'languageChangedToRussian': 'Язык изменен на русский',
      'english': 'English',
      'languageChangedToEnglish': 'Language changed to English',
      'selectTheme': 'Выберите тему',
      'light': 'Светлая',
      'dark': 'Темная',
      'system': 'Системная',
      'logout': 'Выйти из аккаунта',
      'logoutConfirmation': 'Вы уверены, что хотите выйти из аккаунта?',
      'loggedOut': 'Вы вышли из аккаунта',
      'selectProduct': 'Выберите продукт для оформления',
      'cardsAndPaymentMeans': 'Карты и платежные средства',
      'debitCard': 'Дебетовая карта',
      'paymentSticker': 'Платежный стикер',
      'savingsProducts': 'Накопительные продукты',
      'savingsAccount': 'Накопительный счет',
      'myCards': 'Мои карты',
      'myCashback': 'Мой кэшбэк',
      'bankRecipient': 'Банк получателя',
      'transferAmount': 'Сумма перевода',
      'commentOptional': 'Комментарий (необязательно)',
      'transferMoney': 'Перевод денег',
      'processing': 'Выполняется...',
      'receiveTransfer': 'Получить перевод',
      'success': 'Успех!',
      'transferCompleted': 'Перевод успешно совершен',
      'getGift': '🎁 Получи подарок!',
      'inviteFriend': 'Приведи друга и получи \$1,000!',
      'pinReset': 'Сброс PIN-кода',
      'enterNewPin': 'Введите новый 4-значный PIN-код',
      'createPin': 'Создайте PIN-код',
      'confirmPin': 'Подтвердите PIN-код',
      'enterPin': 'Введите PIN-код',
      'repeatPin': 'Повторите введенный PIN-код',
      'protectAccount': 'Придумайте 4-значный PIN-код для защиты аккаунта',
      'enterPinToLogin': 'Введите ваш PIN-код для входа',
      'forgotPin': 'Забыл PIN-код',
      'wrongPin': 'Неверный PIN-код',
      'attemptsLeft': 'осталось попыток',
      'tooManyAttempts': 'Слишком много неудачных попыток',
      'tryAgainIn': 'Повторите через',
      'seconds': 'сек.',
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
  String get insufficientFunds => _localizedValues[locale.languageCode]?['insufficientFunds'] ?? 'Insufficient funds in savings account';
  String get selectRecipient => _localizedValues[locale.languageCode]?['selectRecipient'] ?? 'Select recipient';
  String get selectCard => _localizedValues[locale.languageCode]?['selectCard'] ?? 'Select card for transfer';
  String get debitOnly => _localizedValues[locale.languageCode]?['debitOnly'] ?? 'Transfers are only possible from debit cards';
  String get enterValidAmount => _localizedValues[locale.languageCode]?['enterValidAmount'] ?? 'Enter valid amount';
  String get insufficientCardFunds => _localizedValues[locale.languageCode]?['insufficientCardFunds'] ?? 'Insufficient funds on card';
  String get transferError => _localizedValues[locale.languageCode]?['transferError'] ?? 'Transfer execution error';
  String get receiveError => _localizedValues[locale.languageCode]?['receiveError'] ?? 'Receive transfer error';
  String get depositSavingsTitle => _localizedValues[locale.languageCode]?['depositSavingsTitle'] ?? 'Deposit to savings account';
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? 'Cancel';
  String get accountDeposited => _localizedValues[locale.languageCode]?['accountDeposited'] ?? 'Account deposited with';
  String get insufficientFundsGeneral => _localizedValues[locale.languageCode]?['insufficientFundsGeneral'] ?? 'Insufficient funds';
  String get deposit => _localizedValues[locale.languageCode]?['deposit'] ?? 'Deposit';
  String get actionSelected => _localizedValues[locale.languageCode]?['actionSelected'] ?? 'Action selected';
  String get openAllNotifications => _localizedValues[locale.languageCode]?['openAllNotifications'] ?? 'Open all notifications screen';
  String get transactionOpened => _localizedValues[locale.languageCode]?['transactionOpened'] ?? 'Transaction opened';
  String get openFullChart => _localizedValues[locale.languageCode]?['openFullChart'] ?? 'Open full expense chart';
  String get openAllTransactions => _localizedValues[locale.languageCode]?['openAllTransactions'] ?? 'Open all transactions';
  String get noCardsForSticker => _localizedValues[locale.languageCode]?['noCardsForSticker'] ?? 'No available cards for sticker attachment. Apply for a card first.';
  String get applyCard => _localizedValues[locale.languageCode]?['applyCard'] ?? 'Apply for card';
  String get applySticker => _localizedValues[locale.languageCode]?['applySticker'] ?? 'Apply for sticker';
  String get openAccount => _localizedValues[locale.languageCode]?['openAccount'] ?? 'Open account';
  String get error => _localizedValues[locale.languageCode]?['error'] ?? 'Error';
  String get cardOpened => _localizedValues[locale.languageCode]?['cardOpened'] ?? 'Card opened';
  String get action => _localizedValues[locale.languageCode]?['action'] ?? 'Action';
  String get openCardDetails => _localizedValues[locale.languageCode]?['openCardDetails'] ?? 'Open detailed card information';
  String get cardLimitReached => _localizedValues[locale.languageCode]?['cardLimitReached'] ?? 'Card limit reached (maximum 4 cards)';
  String get agree => _localizedValues[locale.languageCode]?['agree'] ?? 'Agree';
  String get cardSuccessfullyApplied => _localizedValues[locale.languageCode]?['cardSuccessfullyApplied'] ?? 'Card successfully applied!';
  String get linkCopied => _localizedValues[locale.languageCode]?['linkCopied'] ?? 'Link copied!';
  String get later => _localizedValues[locale.languageCode]?['later'] ?? 'Later';
  String get linkSent => _localizedValues[locale.languageCode]?['linkSent'] ?? 'Link sent!';
  String get send => _localizedValues[locale.languageCode]?['send'] ?? 'Send';
  String get dataSaveError => _localizedValues[locale.languageCode]?['dataSaveError'] ?? 'Data save error';
  String get changeName => _localizedValues[locale.languageCode]?['changeName'] ?? 'Change name';
  String get nameChangedSuccessfully => _localizedValues[locale.languageCode]?['nameChangedSuccessfully'] ?? 'Name changed successfully';
  String get save => _localizedValues[locale.languageCode]?['save'] ?? 'Save';
  String get changeEmail => _localizedValues[locale.languageCode]?['changeEmail'] ?? 'Change email';
  String get emailChangedSuccessfully => _localizedValues[locale.languageCode]?['emailChangedSuccessfully'] ?? 'Email changed successfully';
  String get changePassword => _localizedValues[locale.languageCode]?['changePassword'] ?? 'Change password';
  String get passwordChangedSuccessfully => _localizedValues[locale.languageCode]?['passwordChangedSuccessfully'] ?? 'Password changed successfully';
  String get passwordsDontMatch => _localizedValues[locale.languageCode]?['passwordsDontMatch'] ?? 'Passwords don\'t match';
  String get selectLanguage => _localizedValues[locale.languageCode]?['selectLanguage'] ?? 'Select language';
  String get russian => _localizedValues[locale.languageCode]?['russian'] ?? 'Russian';
  String get languageChangedToRussian => _localizedValues[locale.languageCode]?['languageChangedToRussian'] ?? 'Language changed to Russian';
  String get english => _localizedValues[locale.languageCode]?['english'] ?? 'English';
  String get languageChangedToEnglish => _localizedValues[locale.languageCode]?['languageChangedToEnglish'] ?? 'Language changed to English';
  String get selectTheme => _localizedValues[locale.languageCode]?['selectTheme'] ?? 'Select theme';
  String get light => _localizedValues[locale.languageCode]?['light'] ?? 'Light';
  String get dark => _localizedValues[locale.languageCode]?['dark'] ?? 'Dark';
  String get system => _localizedValues[locale.languageCode]?['system'] ?? 'System';
  String get logout => _localizedValues[locale.languageCode]?['logout'] ?? 'Logout';
  String get logoutConfirmation => _localizedValues[locale.languageCode]?['logoutConfirmation'] ?? 'Are you sure you want to log out?';
  String get loggedOut => _localizedValues[locale.languageCode]?['loggedOut'] ?? 'You have been logged out';

  // Additional localization keys
  String get selectProduct => _localizedValues[locale.languageCode]?['selectProduct'] ?? 'Выберите продукт для оформления';
  String get cardsAndPaymentMeans => _localizedValues[locale.languageCode]?['cardsAndPaymentMeans'] ?? 'Карты и платежные средства';
  String get paymentSticker => _localizedValues[locale.languageCode]?['paymentSticker'] ?? 'Платежный стикер';
  String get savingsProducts => _localizedValues[locale.languageCode]?['savingsProducts'] ?? 'Накопительные продукты';
  String get myCards => _localizedValues[locale.languageCode]?['myCards'] ?? 'Мои карты';
  String get myCashback => _localizedValues[locale.languageCode]?['myCashback'] ?? 'Мой кэшбэк';
  String get bankRecipient => _localizedValues[locale.languageCode]?['bankRecipient'] ?? 'Банк получателя';
  String get transferAmount => _localizedValues[locale.languageCode]?['transferAmount'] ?? 'Сумма перевода';
  String get commentOptional => _localizedValues[locale.languageCode]?['commentOptional'] ?? 'Комментарий (необязательно)';
  String get transferMoney => _localizedValues[locale.languageCode]?['transferMoney'] ?? 'Перевод денег';
  String get processing => _localizedValues[locale.languageCode]?['processing'] ?? 'Выполняется...';
  String get receiveTransfer => _localizedValues[locale.languageCode]?['receiveTransfer'] ?? 'Получить перевод';
  String get success => _localizedValues[locale.languageCode]?['success'] ?? 'Успех!';
  String get transferCompleted => _localizedValues[locale.languageCode]?['transferCompleted'] ?? 'Перевод успешно совершен';
  String get getGift => _localizedValues[locale.languageCode]?['getGift'] ?? '🎁 Получи подарок!';
  String get inviteFriend => _localizedValues[locale.languageCode]?['inviteFriend'] ?? 'Приведи друга и получи \$1,000!';
  String get pinReset => _localizedValues[locale.languageCode]?['pinReset'] ?? 'Сброс PIN-кода';
  String get enterNewPin => _localizedValues[locale.languageCode]?['enterNewPin'] ?? 'Введите новый 4-значный PIN-код';
  String get createPin => _localizedValues[locale.languageCode]?['createPin'] ?? 'Создайте PIN-код';
  String get confirmPin => _localizedValues[locale.languageCode]?['confirmPin'] ?? 'Подтвердите PIN-код';
  String get enterPin => _localizedValues[locale.languageCode]?['enterPin'] ?? 'Введите PIN-код';
  String get repeatPin => _localizedValues[locale.languageCode]?['repeatPin'] ?? 'Повторите введенный PIN-код';
  String get protectAccount => _localizedValues[locale.languageCode]?['protectAccount'] ?? 'Придумайте 4-значный PIN-код для защиты аккаунта';
  String get enterPinToLogin => _localizedValues[locale.languageCode]?['enterPinToLogin'] ?? 'Введите ваш PIN-код для входа';
  String get forgotPin => _localizedValues[locale.languageCode]?['forgotPin'] ?? 'Забыл PIN-код';
  String get wrongPin => _localizedValues[locale.languageCode]?['wrongPin'] ?? 'Неверный PIN-код';
  String get attemptsLeft => _localizedValues[locale.languageCode]?['attemptsLeft'] ?? 'осталось попыток';
  String get tooManyAttempts => _localizedValues[locale.languageCode]?['tooManyAttempts'] ?? 'Слишком много неудачных попыток';
  String get tryAgainIn => _localizedValues[locale.languageCode]?['tryAgainIn'] ?? 'Повторите через';
  String get seconds => _localizedValues[locale.languageCode]?['seconds'] ?? 'сек.';

  // Additional getters for UI elements
  String get debitCard => _localizedValues[locale.languageCode]?['debitCard'] ?? 'Дебетовая карта';
  String get savingsAccount => _localizedValues[locale.languageCode]?['savingsAccount'] ?? 'Накопительный счет';

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
