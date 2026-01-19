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
      'selectProduct': 'Select product to apply for',
      'cardsAndPaymentMeans': 'Cards and payment methods',
      'debitCard': 'Debit card',
      'paymentSticker': 'Payment sticker',
      'savingsProducts': 'Savings products',
      'savingsAccount': 'Savings account',
      'myCards': 'My cards',
      'myCashback': 'My cashback',
      'bankRecipient': 'Recipient bank',
      'transferAmount': 'Transfer amount',
      'commentOptional': 'Comment (optional)',
      'transferMoney': 'Transfer money',
      'processing': 'Processing...',
      'receiveTransfer': 'Receive transfer',
      'success': 'Success!',
      'transferCompleted': 'Transfer completed successfully',
      'getGift': '🎁 Get a gift!',
      'inviteFriend': 'Invite a friend and get \$1,000!',
      'pinReset': 'PIN code reset',
      'enterNewPin': 'Enter new 4-digit PIN code',
      'createPin': 'Create PIN code',
      'confirmPin': 'Confirm PIN code',
      'enterPin': 'Enter PIN code',
      'repeatPin': 'Repeat the entered PIN code',
      'protectAccount': 'Create a 4-digit PIN code to protect your account',
      'enterPinToLogin': 'Enter your PIN code to log in',
      'forgotPin': 'Forgot PIN code',
      'wrongPin': 'Wrong PIN code',
      'attemptsLeft': 'attempts left',
      'tooManyAttempts': 'Too many failed attempts',
      'tryAgainIn': 'Try again in',
      'seconds': 'sec.',
      'averageTransaction': 'Average transaction',
      'transactionsCount': 'transactions',
      'type': 'Type:',
      'allCards': 'All cards',
      'toggleTheme': 'Switch theme',
      'crossAxisCount': '2 columns',
      'childAspectRatio': 'Aspect ratio for oval buttons',
      'height': 'Fixed height for oval buttons',
      'borderRadius': 'Completely oval',
      'minimumSize': 'Remove minimum size',
      'fontSize': 'Small font',
      'enterMessage': 'Enter message...',
      'specialistContact': 'Our specialist will contact you shortly.',
      'newChat': 'Start new chat',
      'chatHistory': 'Chat history',
      'helloBot': 'Hello! I am the bank assistant. How can I help?',
      'helloBotRu': 'Здравствуйте! Я помощник банка. Чем могу помочь?',
      'foodAndRestaurants': 'Food and restaurants',
      'foodRestaurantsDescription': 'Cashback on restaurants, cafes and food delivery',
      'shoppingDescription': 'Cashback on clothing, electronics and goods',
      'travel': 'Travel',
      'travelDescription': 'Cashback on flights, hotels and transport',
      'fuel': 'Fuel',
      'fuelDescription': 'Cashback on gas stations and fuel',
      'entertainmentDescription': 'Cashback on cinema, concerts and entertainment',
      'supermarkets': 'Supermarkets',
      'supermarketsDescription': 'Cashback on groceries and supermarket goods',
      'pinChanged': 'PIN code changed',
      'pinChangedMessage': 'Your PIN code has been successfully changed',
      'transferTo': 'Transfer to',
      'receivedTransferFrom': 'Received transfer from',
      'transferFromMikhail': 'Transfer from Mikhail',
      'storePurchase': 'Store purchase',
      'annaIvanova': 'Anna Ivanova',
      'mikhailPetrov': 'Mikhail Petrov',
      'elenaSidorova': 'Elena Sidorova',
      'dmitryKozlov': 'Dmitry Kozlov',
      'olgaNovikova': 'Olga Novikova',
      'alexeyMorozov': 'Alexey Morozov',
      'mariaVolkova': 'Maria Volkova',
      'sergeySokolov': 'Sergey Sokolov',
      'welcomeNotification': 'Welcome!',
      'loginSuccessMessage': 'You have successfully logged in',
      'savingsAccountOpened': 'Savings account opened!',
      'savingsAccountMessage': 'Now you can save money at 5% per annum',
      'savingsDeposit': 'Savings account deposit',
      'cardDeposit': 'Card deposit from savings account',
      'cashbackCategoriesSelected': 'Cashback categories selected',
      'cashbackCategoriesMessage': 'You have selected',
      'cashbackCategoriesCount': 'categories for cashback',
      'hoursAgo': 'hours ago',
      'minutesAgo': 'minutes ago',
      'justNow': 'just now',
      'acceptTerms': 'I agree to the terms and conditions',
      'noDebitCardsForTransfer': 'You have no debit cards for transfers',
      'maximumAmount': 'Maximum amount',
      'personalInformation': 'Personal information',
      'balance': 'Balance:',
      'cardInformation': 'Card information',
      'cardNumber': 'Card number',
      'cardNumberCopied': 'Card number copied!',
      'faqHowToTopUp': 'How to top up account?',
      'faqHowToTopUpAnswer': 'You can top up your account through:\n• ATM\n• Transfer from another card\n• Via mobile app\n• At bank branch',
      'faqHowToBlockCard': 'How to block card?',
      'faqHowToBlockCardAnswer': 'Block card can be done:\n• In mobile app (Cards → Select card → Block)\n• By hotline phone\n• At bank branch',
      'faqHowToChangePin': 'How to change PIN code?',
      'faqHowToChangePinAnswer': 'Change PIN code can be done:\n• At ATM\n• Via mobile app\n• At bank branch with passport',
      'faqWhyPaymentFailed': 'Why payment didn\'t go through?',
      'faqWhyPaymentFailedAnswer': 'Possible reasons:\n• Insufficient funds\n• Limit exceeded\n• Technical problems\n• Incorrect details\n\nCheck payment status in transaction history',
      'faqHowToEnableNotifications': 'How to enable notifications?',
      'faqHowToEnableNotificationsAnswer': 'Enable notifications:\n• Open app\n• Go to Settings\n• Select "Notifications"\n• Allow push notifications',
      'faqAccountSecurity': 'Account security',
      'faqAccountSecurityAnswer': 'Security recommendations:\n• Use strong password\n• Don\'t share data with third parties\n• Change password regularly\n• Enable two-factor authentication',

      // Important bank messages
      'welcomeToBank': 'Welcome to Banki2!',
      'welcomeTitle': 'Welcome!',
      'welcomeMessage': 'You have successfully logged in',
      'accountSecured': 'Your account is now secured with PIN code',
      'newCardAvailable': 'New card is now available in your wallet',
      'paymentReceived': 'Payment received successfully',
      'transferProcessed': 'Transfer has been processed',
      'savingsGoal': 'Great! You\'re on track to reach your savings goal',
      'cashbackEarned': 'Cashback earned on your recent purchase',

      // Card and account descriptions
      'debitCardDescription': 'Free maintenance • Up to 5% cashback • International payments',
      'creditCardDescription': 'Up to 120 days grace period • Credit limit up to 500,000 ₽ • Interest-free period',
      'debitType': 'Debit',
      'creditType': 'Credit',
      'cardType': 'Card type',
      'debitCardText': 'debit card',
      'creditCardText': 'credit card',
      'paymentStickerText': 'payment sticker',
      'your': 'Your',
      'willBeReady': 'will be ready within 3-5 business days',
      'paymentStickerDescription': 'Contactless payments • Quick transactions • Secure and convenient',
      'savingsAccountDescription': '5% annual interest • Build savings • No fees',

      // Profile settings
      'language': 'Language',
      'theme': 'Theme',
      'pinCode': 'PIN Code',
      'pinSet': 'Set',
      'pinNotSet': 'Not set',

      // Cashback selection
      'selectCashbackCategories': 'Select cashback categories',
      'selectUpTo3Categories': 'Select up to 3 categories where you want to receive cashback',
      'categoriesSelected': 'categories selected',
      'saveSelection': 'Save selection',
      'selectedCount': 'Selected: {count}/3',
      'selectMoreCategories': 'Select {count}/3 categories',
      'confirmSelection': 'Confirm selection',

      // Chat descriptions
      'importantBankMessages': 'Important messages from the bank',
      'technicalSupportDescription': 'Get help and support',
      'noNewNotifications': 'No new notifications',
      'helpWithApp': 'Help with the application',
      'helloHowCanWeHelp': 'Hello! How can we help?',

      // Dashboard actions
      'setupCashback': 'Set up cashback',
      'cashbackDescription': 'Select up to 3 categories and get cashback up to 5%',
      'selectCategories': 'Select categories',
      // Savings account
      'chooseCard': 'Select card:',
      'depositAccount': 'Deposit account',
      'noDebitCardsAvailable': 'No available debit cards for savings account deposit',
      'deleteSavingsAccount': 'Delete savings account',
      'qrScanInstruction': 'Point the camera at a QR code to scan it',
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
      'hoursAgo': 'часов назад',
      'minutesAgo': 'минут назад',
      'justNow': 'только что',
      'acceptTerms': 'Я согласен с условиями использования',
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
      'faqHowToTopUp': 'Как пополнить счет?',
      'faqHowToTopUpAnswer': 'Вы можете пополнить счет через:\n• Банкомат\n• Перевод с другой карты\n• Через мобильное приложение\n• В отделении банка',
      'faqHowToBlockCard': 'Как заблокировать карту?',
      'faqHowToBlockCardAnswer': 'Заблокировать карту можно:\n• В мобильном приложении (Карты → Выбрать карту → Заблокировать)\n• По телефону горячей линии\n• В отделении банка',
      'faqHowToChangePin': 'Как изменить ПИН-код?',
      'faqHowToChangePinAnswer': 'Изменить ПИН-код можно:\n• В банкомате\n• Через мобильное приложение\n• В отделении банка с паспортом',
      'faqWhyPaymentFailed': 'Почему платеж не прошел?',
      'faqWhyPaymentFailedAnswer': 'Возможные причины:\n• Недостаточно средств\n• Превышен лимит\n• Технические проблемы\n• Неправильные реквизиты\n\nПроверьте статус платежа в истории операций',
      'faqHowToEnableNotifications': 'Как подключить уведомления?',
      'faqHowToEnableNotificationsAnswer': 'Включить уведомления:\n• Откройте приложение\n• Перейдите в Настройки\n• Выберите "Уведомления"\n• Разрешите push-уведомления',
      'faqAccountSecurity': 'Безопасность аккаунта',
      'faqAccountSecurityAnswer': 'Рекомендации по безопасности:\n• Используйте сложный пароль\n• Не сообщайте данные третьим лицам\n• Регулярно меняйте пароль\n• Включайте двухфакторную аутентификацию',

      // Important bank messages
      'welcomeToBank': 'Добро пожаловать в Banki2!',
      'welcomeTitle': 'Добро пожаловать!',
      'welcomeMessage': 'Вы успешно вошли в систему',
      'accountSecured': 'Ваш аккаунт теперь защищен PIN-кодом',
      'newCardAvailable': 'Новая карта теперь доступна в вашем кошельке',
      'paymentReceived': 'Платеж успешно получен',
      'transferProcessed': 'Перевод был обработан',
      'savingsGoal': 'Отлично! Вы на пути к достижению цели по сбережениям',
      'cashbackEarned': 'Кэшбэк заработан на вашей недавней покупке',

      // Card and account descriptions
      'debitCardDescription': 'Бесплатное обслуживание • Кэшбэк до 5% • Международные платежи',
      'creditCardDescription': 'Льготный период до 120 дней • Кредитный лимит до 500 000 ₽ • Беспроцентный период',
      'debitType': 'Дебетовая',
      'creditType': 'Кредитная',
      'cardType': 'Тип карты',
      'debitCardText': 'дебетовая карта',
      'creditCardText': 'кредитная карта',
      'paymentStickerText': 'платежный стикер',
      'your': 'Ваша',
      'willBeReady': 'будет готова в течение 3-5 рабочих дней',
      'paymentStickerDescription': 'Бесконтактная оплата • Быстрые транзакции • Безопасно и удобно',
      'savingsAccountDescription': '5% годовых • Накопление сбережений • Без комиссий',

      // Profile settings
      'language': 'Язык',
      'theme': 'Тема',
      'pinCode': 'PIN-код',
      'pinSet': 'Установлен',
      'pinNotSet': 'Не установлен',

      // Cashback selection
      'selectCashbackCategories': 'Выберите категории кэшбэка',
      'selectUpTo3Categories': 'Выберите до 3 категорий, где хотите получать кэшбэк',
      'categoriesSelected': 'категорий выбрано',
      'saveSelection': 'Сохранить выбор',
      'selectedCount': 'Выбрано: {count}/3',
      'selectMoreCategories': 'Выберите {count}/3 категории',
      'confirmSelection': 'Подтвердить выбор',

      // Chat descriptions
      'importantBankMessages': 'Важные сообщения от банка',
      'technicalSupportDescription': 'Получите помощь и поддержку',
      'noNewNotifications': 'Нет новых уведомлений',
      'helpWithApp': 'Помощь с приложением',
      'helloHowCanWeHelp': 'Здравствуйте! Как мы можем помочь?',

      // Dashboard actions
      'setupCashback': 'Настройте кэшбэк',
      'cashbackDescription': 'Выберите до 3 категорий и получайте кэшбэк до 5%',
      'selectCategories': 'Выбрать категории',
      // Savings account
      'chooseCard': 'Выберите карту:',
      'depositAccount': 'Пополнить счет',
      'noDebitCardsAvailable': 'Нет доступных дебетовых карт для пополнения накопительного счета',
      'deleteSavingsAccount': 'Удалить накопительный счет',
      'qrScanInstruction': 'Наведите камеру на QR код для сканирования',
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

  // Additional getters for new keys
  String get selectProduct => _localizedValues[locale.languageCode]?['selectProduct'] ?? 'Select product to apply for';
  String get cardsAndPaymentMeans => _localizedValues[locale.languageCode]?['cardsAndPaymentMeans'] ?? 'Cards and payment methods';
  String get paymentSticker => _localizedValues[locale.languageCode]?['paymentSticker'] ?? 'Payment sticker';
  String get savingsProducts => _localizedValues[locale.languageCode]?['savingsProducts'] ?? 'Savings products';
  String get myCards => _localizedValues[locale.languageCode]?['myCards'] ?? 'My cards';
  String get myCashback => _localizedValues[locale.languageCode]?['myCashback'] ?? 'My cashback';
  String get bankRecipient => _localizedValues[locale.languageCode]?['bankRecipient'] ?? 'Recipient bank';
  String get transferAmount => _localizedValues[locale.languageCode]?['transferAmount'] ?? 'Transfer amount';
  String get commentOptional => _localizedValues[locale.languageCode]?['commentOptional'] ?? 'Comment (optional)';
  String get transferMoney => _localizedValues[locale.languageCode]?['transferMoney'] ?? 'Transfer money';
  String get processing => _localizedValues[locale.languageCode]?['processing'] ?? 'Processing...';
  String get receiveTransfer => _localizedValues[locale.languageCode]?['receiveTransfer'] ?? 'Receive transfer';
  String get success => _localizedValues[locale.languageCode]?['success'] ?? 'Success!';
  String get transferCompleted => _localizedValues[locale.languageCode]?['transferCompleted'] ?? 'Transfer completed successfully';
  String get getGift => _localizedValues[locale.languageCode]?['getGift'] ?? '🎁 Get a gift!';
  String get inviteFriend => _localizedValues[locale.languageCode]?['inviteFriend'] ?? 'Invite a friend and get \$1,000!';
  String get pinReset => _localizedValues[locale.languageCode]?['pinReset'] ?? 'PIN code reset';
  String get enterNewPin => _localizedValues[locale.languageCode]?['enterNewPin'] ?? 'Enter new 4-digit PIN code';
  String get createPin => _localizedValues[locale.languageCode]?['createPin'] ?? 'Create PIN code';
  String get confirmPin => _localizedValues[locale.languageCode]?['confirmPin'] ?? 'Confirm PIN code';
  String get enterPin => _localizedValues[locale.languageCode]?['enterPin'] ?? 'Enter PIN code';
  String get repeatPin => _localizedValues[locale.languageCode]?['repeatPin'] ?? 'Repeat the entered PIN code';
  String get protectAccount => _localizedValues[locale.languageCode]?['protectAccount'] ?? 'Create a 4-digit PIN code to protect your account';
  String get enterPinToLogin => _localizedValues[locale.languageCode]?['enterPinToLogin'] ?? 'Enter your PIN code to log in';
  String get forgotPin => _localizedValues[locale.languageCode]?['forgotPin'] ?? 'Forgot PIN code';
  String get wrongPin => _localizedValues[locale.languageCode]?['wrongPin'] ?? 'Wrong PIN code';
  String get attemptsLeft => _localizedValues[locale.languageCode]?['attemptsLeft'] ?? 'attempts left';
  String get tooManyAttempts => _localizedValues[locale.languageCode]?['tooManyAttempts'] ?? 'Too many failed attempts';
  String get tryAgainIn => _localizedValues[locale.languageCode]?['tryAgainIn'] ?? 'Try again in';
  String get averageTransaction => _localizedValues[locale.languageCode]?['averageTransaction'] ?? 'Average transaction';
  String get transactionsCount => _localizedValues[locale.languageCode]?['transactionsCount'] ?? 'transactions';
  String get type => _localizedValues[locale.languageCode]?['type'] ?? 'Type:';
  String get allCards => _localizedValues[locale.languageCode]?['allCards'] ?? 'All cards';
  String get toggleTheme => _localizedValues[locale.languageCode]?['toggleTheme'] ?? 'Switch theme';
  String get enterMessage => _localizedValues[locale.languageCode]?['enterMessage'] ?? 'Enter message...';
  String get specialistContact => _localizedValues[locale.languageCode]?['specialistContact'] ?? 'Our specialist will contact you shortly.';
  String get newChat => _localizedValues[locale.languageCode]?['newChat'] ?? 'Start new chat';
  String get chatHistory => _localizedValues[locale.languageCode]?['chatHistory'] ?? 'Chat history';
  String get helloBot => _localizedValues[locale.languageCode]?['helloBot'] ?? 'Hello! I am the bank assistant. How can I help?';
  String get foodAndRestaurants => _localizedValues[locale.languageCode]?['foodAndRestaurants'] ?? 'Food and restaurants';
  String get foodRestaurantsDescription => _localizedValues[locale.languageCode]?['foodRestaurantsDescription'] ?? 'Cashback on restaurants, cafes and food delivery';
  String get shoppingDescription => _localizedValues[locale.languageCode]?['shoppingDescription'] ?? 'Cashback on clothing, electronics and goods';
  String get travel => _localizedValues[locale.languageCode]?['travel'] ?? 'Travel';
  String get travelDescription => _localizedValues[locale.languageCode]?['travelDescription'] ?? 'Cashback on flights, hotels and transport';
  String get fuel => _localizedValues[locale.languageCode]?['fuel'] ?? 'Fuel';
  String get fuelDescription => _localizedValues[locale.languageCode]?['fuelDescription'] ?? 'Cashback on gas stations and fuel';
  String get entertainmentDescription => _localizedValues[locale.languageCode]?['entertainmentDescription'] ?? 'Cashback on cinema, concerts and entertainment';
  String get supermarkets => _localizedValues[locale.languageCode]?['supermarkets'] ?? 'Supermarkets';
  String get supermarketsDescription => _localizedValues[locale.languageCode]?['supermarketsDescription'] ?? 'Cashback on groceries and supermarket goods';
  String get pinChanged => _localizedValues[locale.languageCode]?['pinChanged'] ?? 'PIN code changed';
  String get pinChangedMessage => _localizedValues[locale.languageCode]?['pinChangedMessage'] ?? 'Your PIN code has been successfully changed';
  String get transferTo => _localizedValues[locale.languageCode]?['transferTo'] ?? 'Transfer to';
  String get receivedTransferFrom => _localizedValues[locale.languageCode]?['receivedTransferFrom'] ?? 'Received transfer from';
  String get transferFromMikhail => _localizedValues[locale.languageCode]?['transferFromMikhail'] ?? 'Transfer from Mikhail';
  String get storePurchase => _localizedValues[locale.languageCode]?['storePurchase'] ?? 'Store purchase';
  String get annaIvanova => _localizedValues[locale.languageCode]?['annaIvanova'] ?? 'Anna Ivanova';
  String get mikhailPetrov => _localizedValues[locale.languageCode]?['mikhailPetrov'] ?? 'Mikhail Petrov';
  String get elenaSidorova => _localizedValues[locale.languageCode]?['elenaSidorova'] ?? 'Elena Sidorova';
  String get dmitryKozlov => _localizedValues[locale.languageCode]?['dmitryKozlov'] ?? 'Dmitry Kozlov';
  String get olgaNovikova => _localizedValues[locale.languageCode]?['olgaNovikova'] ?? 'Olga Novikova';
  String get alexeyMorozov => _localizedValues[locale.languageCode]?['alexeyMorozov'] ?? 'Alexey Morozov';
  String get mariaVolkova => _localizedValues[locale.languageCode]?['mariaVolkova'] ?? 'Maria Volkova';
  String get sergeySokolov => _localizedValues[locale.languageCode]?['sergeySokolov'] ?? 'Sergey Sokolov';
  String get welcomeNotification => _localizedValues[locale.languageCode]?['welcomeNotification'] ?? 'Welcome!';
  String get loginSuccessMessage => _localizedValues[locale.languageCode]?['loginSuccessMessage'] ?? 'You have successfully logged in';
  String get savingsAccountOpened => _localizedValues[locale.languageCode]?['savingsAccountOpened'] ?? 'Savings account opened!';
  String get savingsAccountMessage => _localizedValues[locale.languageCode]?['savingsAccountMessage'] ?? 'Now you can save money at 5% per annum';
  String get savingsDeposit => _localizedValues[locale.languageCode]?['savingsDeposit'] ?? 'Savings account deposit';
  String get cardDeposit => _localizedValues[locale.languageCode]?['cardDeposit'] ?? 'Card deposit from savings account';
  String get cashbackCategoriesSelected => _localizedValues[locale.languageCode]?['cashbackCategoriesSelected'] ?? 'Cashback categories selected';
  String get cashbackCategoriesMessage => _localizedValues[locale.languageCode]?['cashbackCategoriesMessage'] ?? 'You have selected';
  String get cashbackCategoriesCount => _localizedValues[locale.languageCode]?['cashbackCategoriesCount'] ?? 'categories for cashback';
  String get hoursAgo => _localizedValues[locale.languageCode]?['hoursAgo'] ?? 'hours ago';
  String get minutesAgo => _localizedValues[locale.languageCode]?['minutesAgo'] ?? 'minutes ago';
  String get justNow => _localizedValues[locale.languageCode]?['justNow'] ?? 'just now';
  String get acceptTerms => _localizedValues[locale.languageCode]?['acceptTerms'] ?? 'I agree to the terms and conditions';
  String get noDebitCardsForTransfer => _localizedValues[locale.languageCode]?['noDebitCardsForTransfer'] ?? 'You have no debit cards for transfers';
  String get maximumAmount => _localizedValues[locale.languageCode]?['maximumAmount'] ?? 'Maximum amount';
  String get personalInformation => _localizedValues[locale.languageCode]?['personalInformation'] ?? 'Personal information';
  String get balance => _localizedValues[locale.languageCode]?['balance'] ?? 'Balance:';
  String get cardInformation => _localizedValues[locale.languageCode]?['cardInformation'] ?? 'Card information';
  String get cardNumber => _localizedValues[locale.languageCode]?['cardNumber'] ?? 'Card number';
  String get cardNumberCopied => _localizedValues[locale.languageCode]?['cardNumberCopied'] ?? 'Card number copied!';

  // FAQ getters
  String get faqHowToTopUp => _localizedValues[locale.languageCode]?['faqHowToTopUp'] ?? 'How to top up account?';
  String get faqHowToTopUpAnswer => _localizedValues[locale.languageCode]?['faqHowToTopUpAnswer'] ?? 'You can top up your account through:\n• ATM\n• Transfer from another card\n• Via mobile app\n• At bank branch';
  String get faqHowToBlockCard => _localizedValues[locale.languageCode]?['faqHowToBlockCard'] ?? 'How to block card?';
  String get faqHowToBlockCardAnswer => _localizedValues[locale.languageCode]?['faqHowToBlockCardAnswer'] ?? 'Block card can be done:\n• In mobile app (Cards → Select card → Block)\n• By hotline phone\n• At bank branch';
  String get faqHowToChangePin => _localizedValues[locale.languageCode]?['faqHowToChangePin'] ?? 'How to change PIN code?';
  String get faqHowToChangePinAnswer => _localizedValues[locale.languageCode]?['faqHowToChangePinAnswer'] ?? 'Change PIN code can be done:\n• At ATM\n• Via mobile app\n• At bank branch with passport';
  String get faqWhyPaymentFailed => _localizedValues[locale.languageCode]?['faqWhyPaymentFailed'] ?? 'Why payment didn\'t go through?';
  String get faqWhyPaymentFailedAnswer => _localizedValues[locale.languageCode]?['faqWhyPaymentFailedAnswer'] ?? 'Possible reasons:\n• Insufficient funds\n• Limit exceeded\n• Technical problems\n• Incorrect details\n\nCheck payment status in transaction history';
  String get faqHowToEnableNotifications => _localizedValues[locale.languageCode]?['faqHowToEnableNotifications'] ?? 'How to enable notifications?';
  String get faqHowToEnableNotificationsAnswer => _localizedValues[locale.languageCode]?['faqHowToEnableNotificationsAnswer'] ?? 'Enable notifications:\n• Open app\n• Go to Settings\n• Select "Notifications"\n• Allow push notifications';
  String get faqAccountSecurity => _localizedValues[locale.languageCode]?['faqAccountSecurity'] ?? 'Account security';
  String get faqAccountSecurityAnswer => _localizedValues[locale.languageCode]?['faqAccountSecurityAnswer'] ?? 'Security recommendations:\n• Use strong password\n• Don\'t share data with third parties\n• Change password regularly\n• Enable two-factor authentication';

  // Important bank messages
  String get welcomeToBank => _localizedValues[locale.languageCode]?['welcomeToBank'] ?? 'Welcome to Banki2!';
  String get welcomeTitle => _localizedValues[locale.languageCode]?['welcomeTitle'] ?? 'Welcome!';
  String get welcomeMessage => _localizedValues[locale.languageCode]?['welcomeMessage'] ?? 'You have successfully logged in';
  String get accountSecured => _localizedValues[locale.languageCode]?['accountSecured'] ?? 'Your account is now secured with PIN code';
  String get newCardAvailable => _localizedValues[locale.languageCode]?['newCardAvailable'] ?? 'New card is now available in your wallet';
  String get paymentReceived => _localizedValues[locale.languageCode]?['paymentReceived'] ?? 'Payment received successfully';
  String get transferProcessed => _localizedValues[locale.languageCode]?['transferProcessed'] ?? 'Transfer has been processed';
  String get savingsGoal => _localizedValues[locale.languageCode]?['savingsGoal'] ?? 'Great! You\'re on track to reach your savings goal';
  String get cashbackEarned => _localizedValues[locale.languageCode]?['cashbackEarned'] ?? 'Cashback earned on your recent purchase';

  // Card and account descriptions
  String get debitCardDescription => _localizedValues[locale.languageCode]?['debitCardDescription'] ?? 'Free maintenance • Up to 5% cashback • International payments';
  String get creditCardDescription => _localizedValues[locale.languageCode]?['creditCardDescription'] ?? 'Up to 120 days grace period • Credit limit up to 500,000 ₽ • Interest-free period';
  String get debitType => _localizedValues[locale.languageCode]?['debitType'] ?? 'Debit';
  String get creditType => _localizedValues[locale.languageCode]?['creditType'] ?? 'Credit';
  String get cardType => _localizedValues[locale.languageCode]?['cardType'] ?? 'Card type';
  String get debitCardText => _localizedValues[locale.languageCode]?['debitCardText'] ?? 'debit card';
  String get creditCardText => _localizedValues[locale.languageCode]?['creditCardText'] ?? 'credit card';
  String get paymentStickerText => _localizedValues[locale.languageCode]?['paymentStickerText'] ?? 'payment sticker';
  String get your => _localizedValues[locale.languageCode]?['your'] ?? 'Your';
  String get willBeReady => _localizedValues[locale.languageCode]?['willBeReady'] ?? 'will be ready within 3-5 business days';
  String get paymentStickerDescription => _localizedValues[locale.languageCode]?['paymentStickerDescription'] ?? 'Contactless payments • Quick transactions • Secure and convenient';
  String get savingsAccountDescription => _localizedValues[locale.languageCode]?['savingsAccountDescription'] ?? '5% annual interest • Build savings • No fees';

  // Profile settings
  String get language => _localizedValues[locale.languageCode]?['language'] ?? 'Language';
  String get theme => _localizedValues[locale.languageCode]?['theme'] ?? 'Theme';
  String get pinCode => _localizedValues[locale.languageCode]?['pinCode'] ?? 'PIN Code';
  String get pinSet => _localizedValues[locale.languageCode]?['pinSet'] ?? 'Set';
  String get pinNotSet => _localizedValues[locale.languageCode]?['pinNotSet'] ?? 'Not set';

  // Cashback selection
  String get selectCashbackCategories => _localizedValues[locale.languageCode]?['selectCashbackCategories'] ?? 'Select cashback categories';
  String get selectUpTo3Categories => _localizedValues[locale.languageCode]?['selectUpTo3Categories'] ?? 'Select up to 3 categories where you want to receive cashback';
  String get categoriesSelected => _localizedValues[locale.languageCode]?['categoriesSelected'] ?? 'categories selected';
  String get saveSelection => _localizedValues[locale.languageCode]?['saveSelection'] ?? 'Save selection';

  String selectedCount(int count) {
    final template = _localizedValues[locale.languageCode]?['selectedCount'] ?? 'Selected: {count}/3';
    return template.replaceAll('{count}', count.toString());
  }

  String selectMoreCategories(int count) {
    final template = _localizedValues[locale.languageCode]?['selectMoreCategories'] ?? 'Select {count}/3 categories';
    return template.replaceAll('{count}', count.toString());
  }

  String get confirmSelection => _localizedValues[locale.languageCode]?['confirmSelection'] ?? 'Confirm selection';

  // Chat descriptions
  String get importantBankMessages => _localizedValues[locale.languageCode]?['importantBankMessages'] ?? 'Important messages from the bank';
  String get technicalSupportDescription => _localizedValues[locale.languageCode]?['technicalSupportDescription'] ?? 'Get help and support';
  String get noNewNotifications => _localizedValues[locale.languageCode]?['noNewNotifications'] ?? 'No new notifications';
  String get helpWithApp => _localizedValues[locale.languageCode]?['helpWithApp'] ?? 'Help with the application';
  String get helloHowCanWeHelp => _localizedValues[locale.languageCode]?['helloHowCanWeHelp'] ?? 'Hello! How can we help?';

  // Dashboard actions
  String get setupCashback => _localizedValues[locale.languageCode]?['setupCashback'] ?? 'Set up cashback';
  String get cashbackDescription => _localizedValues[locale.languageCode]?['cashbackDescription'] ?? 'Select up to 3 categories and get cashback up to 5%';
  String get selectCategories => _localizedValues[locale.languageCode]?['selectCategories'] ?? 'Select categories';

  // Additional getters for UI elements
  String get debitCard => _localizedValues[locale.languageCode]?['debitCard'] ?? 'Дебетовая карта';
  String get savingsAccount => _localizedValues[locale.languageCode]?['savingsAccount'] ?? 'Накопительный счет';
  String get chooseCard => _localizedValues[locale.languageCode]?['chooseCard'] ?? 'Select card:';
  String get depositAccount => _localizedValues[locale.languageCode]?['depositAccount'] ?? 'Deposit account';
  String get noDebitCardsAvailable => _localizedValues[locale.languageCode]?['noDebitCardsAvailable'] ?? 'No available debit cards for savings account deposit';
  String get deleteSavingsAccount => _localizedValues[locale.languageCode]?['deleteSavingsAccount'] ?? 'Delete savings account';
  String get qrScanInstruction => _localizedValues[locale.languageCode]?['qrScanInstruction'] ?? 'Point the camera at a QR code to scan it';

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
