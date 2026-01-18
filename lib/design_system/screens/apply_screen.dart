import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';
import '../components/buttons.dart';
import '../components/svg_background.dart';
import '../utils/app_state.dart';
import '../../l10n/app_localizations.dart';
import 'profile_screen.dart';

class ApplyScreen extends StatefulWidget {
  const ApplyScreen({super.key});

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
  }

  @override
  void dispose() {
    _fadeController.dispose();
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
        extendBody: true,
        appBar: AppBar(
        title: GestureDetector(
          onTap: () => _navigateToProfile(),
          child: Row(
            children: [
              Icon(
                Icons.account_circle,
                color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                appState.userName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
              ),
              onPressed: () => appState.toggleTheme(),
              tooltip: 'Переключить тему',
            ),
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Badge(
                label: appState.unreadNotificationsCount > 0
                    ? Text(appState.unreadNotificationsCount.toString())
                    : null,
                child: PopupMenuButton<String>(
                icon: Icon(
                  isDark ? BankingIcons.notification : BankingIcons.notificationFilled,
                  color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
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
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: BankingTokens.screenHorizontalPadding,
              right: BankingTokens.screenHorizontalPadding,
              top: BankingTokens.screenVerticalPadding,
              bottom: BankingTokens.bottomNavigationHeight + BankingTokens.space48,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cards Animation
                Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Lottie.asset(
                      'lottie/cards.json',
                      fit: BoxFit.contain,
                      repeat: false,
                      animate: true,
                      onLoaded: (composition) {
                        // Анимация останется в финальном состоянии после завершения
                      },
                    ),
                  ),
                ),
                const SizedBox(height: BankingTokens.space24),

                Text(
                  'Выберите продукт для оформления',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BankingTokens.space24),

                // Карты и платежные средства
                Text(
                  'Карты и платежные средства',
                  style: BankingTypography.heading3,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: BankingTokens.space16),

                // Дебетовая карта
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: BankingTokens.space8),
                  child: _buildFullWidthProductButton(
                    title: 'Дебетовая карта',
                    description: 'Бесплатное обслуживание • Кэшбэк до 5% • Международные платежи',
                    icon: Icons.credit_card,
                    isDisabled: _getDebitCardCount(appState) >= 2,
                    onTap: _getDebitCardCount(appState) >= 2 ? null : () => _showDebitCardModal(context, appState),
                  ),
                ),
                const SizedBox(height: BankingTokens.space16),

                // Кредитная карта
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: BankingTokens.space8),
                  child: _buildFullWidthProductButton(
                    title: 'Кредитная карта',
                    description: 'Льготный период до 120 дней • Кредитный лимит до 500 000 ₽ • Беспроцентный период',
                    icon: Icons.credit_card,
                    isDisabled: _getCreditCardCount(appState) >= 2,
                    onTap: _getCreditCardCount(appState) >= 2 ? null : () => _showCreditCardModal(context, appState),
                  ),
                ),
                const SizedBox(height: BankingTokens.space16),

                // Платежный стикер
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: BankingTokens.space8),
                  child: _buildFullWidthProductButton(
                    title: 'Платежный стикер',
                    description: 'Бесконтактная оплата • Привязка к карте • Мгновенные платежи',
                    icon: Icons.sticky_note_2,
                    isDisabled: !appState.canOrderSticker,
                    onTap: appState.canOrderSticker ? () => _showPaymentStickerModal(context, appState) : null,
                  ),
                ),
                const SizedBox(height: BankingTokens.space32),

                // Разделитель
                Divider(
                  color: BankingColors.neutral300,
                  thickness: 1,
                  height: BankingTokens.space32,
                ),

                // Накопительные продукты
                Text(
                  'Накопительные продукты',
                  style: BankingTypography.heading3,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: BankingTokens.space16),

                // Накопительный счет
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: BankingTokens.space8),
                  child: _buildFullWidthProductButton(
                    title: 'Накопительный счет',
                    description: '5% годовых • Накопление сбережений • Без комиссий',
                    icon: Icons.savings,
                    isDisabled: !appState.canOpenSavingsAccount,
                    onTap: appState.canOpenSavingsAccount ? () => _openSavingsAccount(context, appState) : null,
                  ),
                ),

                if (appState.accounts.isEmpty) ...[
                  const SizedBox(height: BankingTokens.space12),
                  Container(
                    padding: const EdgeInsets.all(BankingTokens.space16),
                    decoration: BoxDecoration(
                      color: BankingColors.warning50,
                      borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
                      border: Border.all(color: BankingColors.warning200),
                    ),
                    child: Text(
                      'Для оформления платежного стикера необходимо иметь хотя бы одну карту',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: isDark ? BankingColors.warning200 : BankingColors.warning500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigation(appState, localizations),
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

  void _onViewAllNotifications() {
    // TODO: Navigate to full notifications screen
    print('Открыть экран всех уведомлений');
  }

  Widget _buildFullWidthProductButton({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 88,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? (isDark ? BankingColors.neutral700 : BankingColors.neutral200)
              : (isDark ? BankingColors.neutral800 : BankingColors.neutral0),
          foregroundColor: isDisabled
              ? BankingColors.neutral400
              : BankingColors.primary500,
          elevation: 2,
          shadowColor: BankingColors.neutral900.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
          ),
          padding: const EdgeInsets.all(BankingTokens.space16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: BankingTokens.iconSizeLarge,
              color: isDisabled
                  ? BankingColors.neutral400
                  : BankingColors.primary500,
            ),
            const SizedBox(width: BankingTokens.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDisabled
                          ? BankingColors.neutral400
                          : (isDark ? BankingColors.neutral50 : BankingColors.neutral900),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: BankingTokens.space4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDisabled
                          ? BankingColors.neutral400
                          : (isDark ? BankingColors.neutral300 : BankingColors.neutral600),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: BankingTokens.iconSizeSmall,
              color: isDisabled
                  ? BankingColors.neutral400
                  : BankingColors.primary500,
            ),
          ],
        ),
      ),
    );
  }

  void _openSavingsAccount(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SavingsAccountApplicationModal(
        onAccept: () => _onSavingsAccountAccepted(context, appState),
      ),
    );
  }

  void _onSavingsAccountAccepted(BuildContext context, AppState appState) {
    appState.openSavingsAccount();
    Navigator.of(context).pop();
    _showSuccessModal(context, 'Накопительный счет открыт!', 'savings_account');
  }

  int _getDebitCardCount(AppState appState) {
    return appState.accounts.where((account) => account.type == 'debit_card').length;
  }

  int _getCreditCardCount(AppState appState) {
    return appState.accounts.where((account) => account.type == 'credit_card').length;
  }

  void _showDebitCardModal(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DebitCardApplicationModal(
        onAccept: () => _onDebitCardAccepted(context, appState),
      ),
    );
  }

  void _showCreditCardModal(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreditCardApplicationModal(
        onAccept: () => _onCreditCardAccepted(context, appState),
      ),
    );
  }

  void _showPaymentStickerModal(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentStickerApplicationModal(
        accounts: appState.accounts,
        onAccept: () => _onPaymentStickerAccepted(context, appState),
      ),
    );
  }

  void _onDebitCardAccepted(BuildContext context, AppState appState) {
    // Генерируем данные карты
    final cardNumber = _generateCardNumber();
    final expireDate = _generateExpireDate();
    final cvc = _generateCVC();

    print('DEBUG: ApplyScreen - Generated card data:');
    print('  cardNumber: $cardNumber');
    print('  expireDate: $expireDate');
    print('  cvc: $cvc');

    // Добавляем дебетовую карту в список аккаунтов
    final newAccount = Account(
      id: 'debit_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Дебетовая карта',
      type: 'debit_card',
      balance: 5000.00, // Always start with $5,000
      currency: 'USD',
      color: const Color(0xFF2196F3),
      isPrimary: appState.accounts.isEmpty,
      cardNumber: cardNumber,
      expireDate: expireDate,
      cvc: cvc,
      hasSticker: false,
    );

    print('DEBUG: ApplyScreen - Account created with cardNumber: ${newAccount.cardNumber}');

    appState.addAccount(newAccount);

    // Сохраняем данные в SharedPreferences
    _saveCardToSharedPreferences(newAccount);

    // Закрываем модальное окно и показываем успех
    Navigator.of(context).pop();
    _showSuccessModal(context, 'Дебетовая карта оформлена!', 'debit_card');
  }

  // Методы генерации данных карты
  String _generateCardNumber() {
    final random = Random();
    return List.generate(16, (_) => random.nextInt(10).toString()).join();
  }

  String _generateExpireDate() {
    final now = DateTime.now();
    final month = (1 + Random().nextInt(12)).toString().padLeft(2, '0');
    final year = (now.year + 1 + Random().nextInt(4)).toString().substring(2);
    return '$month/$year';
  }

  String _generateCVC() {
    final random = Random();
    return List.generate(3, (_) => random.nextInt(10).toString()).join();
  }

  Future<void> _saveCardToSharedPreferences(Account account) async {
    final prefs = await SharedPreferences.getInstance();
    final existingCards = prefs.getStringList('user_cards') ?? [];
    existingCards.add(account.id);
    await prefs.setString('card_${account.id}_number', account.cardNumber ?? '');
    await prefs.setString('card_${account.id}_expire', account.expireDate ?? '');
    await prefs.setString('card_${account.id}_cvc', account.cvc ?? '');
    await prefs.setDouble('card_${account.id}_balance', account.balance);
    await prefs.setStringList('user_cards', existingCards);

    print('DEBUG: ApplyScreen - Card saved to SharedPreferences: ${account.id}');
  }

  void _onCreditCardAccepted(BuildContext context, AppState appState) {
    // Генерируем данные карты
    final cardNumber = _generateCardNumber();
    final expireDate = _generateExpireDate();
    final cvc = _generateCVC();

    print('DEBUG: ApplyScreen - Generated credit card data:');
    print('  cardNumber: $cardNumber');
    print('  expireDate: $expireDate');
    print('  cvc: $cvc');

    // Добавляем кредитную карту в список аккаунтов
    final newAccount = Account(
      id: 'credit_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Кредитная карта',
      type: 'credit_card',
      balance: 10000.00, // Credit limit
      currency: 'USD',
      color: BankingColors.secondary500,
      isPrimary: false,
      cardNumber: cardNumber,
      expireDate: expireDate,
      cvc: cvc,
      hasSticker: false,
    );

    print('DEBUG: ApplyScreen - Credit account created with cardNumber: ${newAccount.cardNumber}');

    appState.addAccount(newAccount);

    // Сохраняем данные в SharedPreferences
    _saveCardToSharedPreferences(newAccount);

    // Закрываем модальное окно и показываем успех
    Navigator.of(context).pop();
    _showSuccessModal(context, 'Кредитная карта оформлена!', 'credit_card');
  }

  void _onPaymentStickerAccepted(BuildContext context, AppState appState) {
    // Привязываем стикер к первой доступной карте
    final availableCards = appState.accounts.where((account) => !account.hasSticker).toList();

    if (availableCards.isNotEmpty) {
      // Привязываем стикер к первой доступной карте
      final targetCard = availableCards.first;
      appState.attachSticker(targetCard.id);

      // Добавляем уведомление об оформлении стикера
      final stickerNotification = NotificationItem(
        id: 'sticker_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Платежный стикер оформлен!',
        message: 'Стикер успешно привязан к вашей карте',
        timestamp: DateTime.now(),
        type: NotificationType.transaction,
      );
      appState.addNotification(stickerNotification);

      Navigator.of(context).pop();
      _showSuccessModal(context, 'Платежный стикер привязан к карте ${targetCard.cardNumber ?? '**** **** **** ****'}!', 'payment_sticker');
    } else {
      // Нет доступных карт для привязки стикера
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нет доступных карт для привязки стикера. Сначала оформите карту.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showSuccessModal(BuildContext context, String message, String productType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SuccessModal(
        message: message,
        productType: productType,
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }
}

// Модальное окно для оформления дебетовой карты
class DebitCardApplicationModal extends StatefulWidget {
  final VoidCallback onAccept;

  const DebitCardApplicationModal({super.key, required this.onAccept});

  @override
  State<DebitCardApplicationModal> createState() => _DebitCardApplicationModalState();
}

class _DebitCardApplicationModalState extends State<DebitCardApplicationModal> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: BankingTokens.durationNormal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BankingTokens.radius20),
        ),
        backgroundColor: isDark ? BankingColors.neutral800 : Colors.white,
        child: Container(
          padding: const EdgeInsets.all(BankingTokens.space24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Иконка дебетовой карты
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: BankingColors.primary100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.credit_card,
                  color: BankingColors.primary600,
                  size: 40,
                ),
              ),
              const SizedBox(height: BankingTokens.space24),

              // Заголовок
              Text(
                'Дебетовая карта',
                style: BankingTypography.heading2.copyWith(
                  color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: BankingTokens.space16),

              // Описание
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    'Дебетовая карта для повседневных расчетов.\n\n'
                    '• Бесплатное обслуживание\n'
                    '• Кэшбэк до 5% на выбранные категории\n'
                    '• Бесплатное снятие до 100 000 ₽/месяц\n'
                    '• Международные платежи без комиссии\n'
                    '• Контактная и бесконтактная оплата\n'
                    '• Мобильное приложение с полным функционалом\n\n'
                    'Карта будет доставлена в течение 3-5 рабочих дней.',
                    textAlign: TextAlign.left,
                    style: BankingTypography.bodyRegular,
                  ),
                ),
              ),
              const SizedBox(height: BankingTokens.space32),

              // Кнопки
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: BankingTokens.space16),
                        side: BorderSide(color: BankingColors.neutral400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(BankingTokens.radius12),
                        ),
                      ),
                      child: Text(
                        'Отмена',
                        style: BankingTypography.bodyMedium.copyWith(
                          color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: BankingTokens.space16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onAccept,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: BankingTokens.space16),
                        backgroundColor: BankingColors.primary500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(BankingTokens.radius12),
                        ),
                      ),
                      child: const Text('Оформить карту'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Модальное окно для оформления кредитной карты
class CreditCardApplicationModal extends StatefulWidget {
  final VoidCallback onAccept;

  const CreditCardApplicationModal({super.key, required this.onAccept});

  @override
  State<CreditCardApplicationModal> createState() => _CreditCardApplicationModalState();
}

class _CreditCardApplicationModalState extends State<CreditCardApplicationModal> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: BankingTokens.durationNormal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BankingTokens.radius20),
        ),
        backgroundColor: isDark ? BankingColors.neutral800 : Colors.white,
        child: Container(
          padding: const EdgeInsets.all(BankingTokens.space24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Иконка кредитной карты
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: BankingColors.secondary100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.credit_card,
                  color: BankingColors.secondary600,
                  size: 40,
                ),
              ),
              const SizedBox(height: BankingTokens.space24),

              // Заголовок
              Text(
                'Кредитная карта',
                style: BankingTypography.heading2.copyWith(
                  color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: BankingTokens.space16),

              // Описание
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    'Кредитная карта с выгодными условиями кредитования.\n\n'
                    '• Кредитный лимит до 500 000 ₽\n'
                    '• Льготный период до 120 дней\n'
                    '• Процентная ставка от 15% годовых\n'
                    '• Стоимость обслуживания 590 ₽/год\n'
                    '• Кэшбэк на покупки\n'
                    '• Бесплатные SMS-уведомления\n\n'
                    'Карта будет доставлена в течение 3-7 рабочих дней после одобрения.',
                    textAlign: TextAlign.left,
                    style: BankingTypography.bodyRegular,
                  ),
                ),
              ),
              const SizedBox(height: BankingTokens.space32),

              // Кнопки
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: BankingTokens.space16),
                        side: BorderSide(color: BankingColors.neutral400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(BankingTokens.radius12),
                        ),
                      ),
                      child: Text(
                        'Отмена',
                        style: BankingTypography.bodyMedium.copyWith(
                          color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: BankingTokens.space16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onAccept,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: BankingTokens.space16),
                        backgroundColor: BankingColors.secondary500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(BankingTokens.radius12),
                        ),
                      ),
                      child: const Text('Оформить карту'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

// Модальное окно для оформления платежного стикера
class PaymentStickerApplicationModal extends StatefulWidget {
  final List<Account> accounts;
  final VoidCallback onAccept;

  const PaymentStickerApplicationModal({
    super.key,
    required this.accounts,
    required this.onAccept,
  });

  @override
  State<PaymentStickerApplicationModal> createState() => _PaymentStickerApplicationModalState();
}

class _PaymentStickerApplicationModalState extends State<PaymentStickerApplicationModal> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Account? selectedAccount;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: BankingTokens.durationNormal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BankingTokens.radius20),
        ),
        backgroundColor: isDark ? BankingColors.neutral800 : Colors.white,
        child: Container(
          padding: const EdgeInsets.all(BankingTokens.space24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Иконка платежного стикера
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: BankingColors.info100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sticky_note_2,
                  color: BankingColors.info600,
                  size: 40,
                ),
              ),
              const SizedBox(height: BankingTokens.space24),

              // Заголовок
              Text(
                'Платежный стикер',
                style: BankingTypography.heading2.copyWith(
                  color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: BankingTokens.space16),

              // Описание
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Бесконтактная оплата без телефона в кармане.\n\n'
                        '• NFC-технология для быстрой оплаты\n'
                        '• Привязка к существующей карте\n'
                        '• Работает с любыми NFC-терминалами\n'
                        '• Безопасная технология шифрования\n'
                        '• Легко прикрепляется к телефону\n\n'
                        'Выберите карту для привязки стикера:',
                        textAlign: TextAlign.left,
                        style: BankingTypography.bodyRegular,
                      ),
                      const SizedBox(height: BankingTokens.space16),

                      // Выбор карты
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? BankingColors.neutral600 : BankingColors.neutral300,
                          ),
                          borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: widget.accounts.map((account) {
                              return RadioListTile<Account>(
                                title: Text(
                                  '${account.name} •••• ${account.cardNumber?.substring(account.cardNumber!.length - 4) ?? account.id.substring(account.id.length - 4)}',
                                  style: BankingTypography.bodyRegular,
                                ),
                                subtitle: Text(
                                  '\$${account.balance.toStringAsFixed(2)}',
                                  style: BankingTypography.caption,
                                ),
                                value: account,
                                groupValue: selectedAccount,
                                onChanged: (value) {
                                  setState(() {
                                    selectedAccount = value;
                                  });
                                },
                                activeColor: BankingColors.info500,
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      const SizedBox(height: BankingTokens.space16),

                      Text(
                        'Стоимость: 0 ₽\nДоставка: Бесплатно\nСрок изготовления: 3-5 рабочих дней',
                        style: BankingTypography.bodySmall.copyWith(
                          color: isDark ? BankingColors.neutral400 : BankingColors.neutral600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: BankingTokens.space32),

              // Кнопки
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: BankingTokens.space16),
                        side: BorderSide(color: BankingColors.neutral400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(BankingTokens.radius12),
                        ),
                      ),
                      child: Text(
                        'Отмена',
                        style: BankingTypography.bodyMedium.copyWith(
                          color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: BankingTokens.space16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedAccount != null ? widget.onAccept : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: BankingTokens.space16),
                        backgroundColor: BankingColors.info500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(BankingTokens.radius12),
                        ),
                      ),
                      child: const Text('Оформить стикер'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Модальное окно успеха
class SuccessModal extends StatefulWidget {
  final String message;
  final String productType;

  const SuccessModal({
    super.key,
    required this.message,
    required this.productType,
  });

  @override
  State<SuccessModal> createState() => _SuccessModalState();
}

class _SuccessModalState extends State<SuccessModal> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _contentController;
  late Animation<double> _contentOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Анимация появления модального окна
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Анимация появления контента
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _contentOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );

    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(BankingTokens.space24),
          decoration: BoxDecoration(
            color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
            borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
            boxShadow: BankingTokens.getShadow(16),
          ),
          child: FadeTransition(
            opacity: _contentOpacityAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie анимация успеха
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Lottie.asset(
                    'assets/lottie/success.json',
                    repeat: false,
                  ),
                ),
                const SizedBox(height: BankingTokens.space16),

                // Заголовок успеха
                Text(
                  'Успех!',
                  style: BankingTypography.heading2.copyWith(
                    color: BankingColors.success500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BankingTokens.space8),

                // Сообщение
                Text(
                  widget.message,
                  style: BankingTypography.bodyRegular,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BankingTokens.space12),

                // Дополнительная информация (только для продуктов, не для пополнения)
                if (widget.productType != 'deposit')
                  Text(
                    'Ваша ${widget.productType == 'debit_card' ? 'дебетовая карта' : widget.productType == 'credit_card' ? 'кредитная карта' : 'платежный стикер'} будет готова в течение 3-5 рабочих дней.',
                    style: BankingTypography.caption.copyWith(
                      color: isDark ? BankingColors.neutral300 : BankingColors.neutral600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: BankingTokens.space24),

                // Кнопка закрытия
                BankingButton(
                  text: 'Понятно',
                  variant: BankingButtonVariant.primary,
                  onPressed: () => Navigator.of(context).pop(),
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SavingsAccountApplicationModal extends StatefulWidget {
  final VoidCallback onAccept;

  const SavingsAccountApplicationModal({
    super.key,
    required this.onAccept,
  });

  @override
  State<SavingsAccountApplicationModal> createState() => _SavingsAccountApplicationModalState();
}

class _SavingsAccountApplicationModalState extends State<SavingsAccountApplicationModal> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: BankingTokens.durationNormal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BankingTokens.radius20),
        ),
        backgroundColor: isDark ? BankingColors.neutral800 : Colors.white,
        child: Container(
          padding: const EdgeInsets.all(BankingTokens.space24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Иконка накопительного счета
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: BankingColors.primary100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.savings,
                  color: BankingColors.primary600,
                  size: 40,
                ),
              ),
              const SizedBox(height: BankingTokens.space24),

              // Заголовок
              Text(
                'Накопительный счет',
                style: BankingTypography.heading2.copyWith(
                  color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: BankingTokens.space16),

              // Описание
                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        'Накопительный счет позволяет вам копить деньги под 5% годовых.\n\n'
                        '• Процентная ставка: 5% годовых\n'
                        '• Начисление процентов: ежемесячно\n'
                        '• Снятие средств: в любое время\n'
                        '• Минимальный взнос: от 100₽\n'
                        '• Без комиссий за обслуживание\n\n'
                        'Вы сможете пополнять счет и следить за ростом ваших сбережений.',
                        textAlign: TextAlign.left,
                        style: BankingTypography.bodyRegular,
                      ),
                    ),
                  ),
              const SizedBox(height: BankingTokens.space32),

              // Кнопки
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: BankingTokens.space16),
                        side: BorderSide(color: BankingColors.neutral400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(BankingTokens.radius12),
                        ),
                      ),
                      child: Text(
                        'Отмена',
                        style: BankingTypography.bodyMedium.copyWith(
                          color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: BankingTokens.space16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onAccept,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: BankingTokens.space16),
                        backgroundColor: BankingColors.primary500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(BankingTokens.radius12),
                        ),
                      ),
                      child: const Text('Открыть счет'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

