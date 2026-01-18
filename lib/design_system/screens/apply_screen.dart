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
              bottom: BankingTokens.bottomNavigationHeight + BankingTokens.space16,
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

                // Дебетовая карта
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: BankingTokens.space8),
                  child: _buildFullWidthProductButton(
                    title: 'Дебетовая карта',
                    description: 'Бесплатное обслуживание • Кэшбэк до 5% • Международные платежи',
                    icon: Icons.credit_card,
                    onTap: () => _showDebitCardModal(context, appState),
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
                    onTap: () => _showCreditCardModal(context, appState),
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
                    isDisabled: appState.accounts.isEmpty,
                    onTap: appState.accounts.isNotEmpty ? () => _showPaymentStickerModal(context, appState) : null,
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
      height: 80,
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
    // Здесь можно добавить логику для платежного стикера
    // Пока просто показываем успех
    Navigator.of(context).pop();
    _showSuccessModal(context, 'Платежный стикер оформлен!', 'payment_sticker');
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
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(BankingTokens.space16),
        decoration: BoxDecoration(
          color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
          borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Container(
              padding: const EdgeInsets.all(BankingTokens.space16),
              decoration: BoxDecoration(
                color: BankingColors.primary500,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(BankingTokens.borderRadiusLarge),
                  topRight: Radius.circular(BankingTokens.borderRadiusLarge),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.credit_card,
                    color: BankingColors.neutral0,
                    size: BankingTokens.iconSizeLarge,
                  ),
                  const SizedBox(width: BankingTokens.space12),
                  Expanded(
                    child: Text(
                      'Условия дебетовой карты',
                      style: BankingTypography.heading4.copyWith(
                        color: BankingColors.neutral0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Содержимое
            Padding(
              padding: const EdgeInsets.all(BankingTokens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCondition('Стоимость обслуживания', '0 ₽/месяц'),
                  const SizedBox(height: BankingTokens.space12),
                  _buildCondition('Кэшбэк', 'До 5% на категории'),
                  const SizedBox(height: BankingTokens.space12),
                  _buildCondition('Снятие наличных', 'До 100 000 ₽/месяц бесплатно'),
                  const SizedBox(height: BankingTokens.space12),
                  _buildCondition('Международные платежи', 'Без комиссии'),
                  const SizedBox(height: BankingTokens.space24),

                  Text(
                    'При оформлении карты вы соглашаетесь с условиями использования и подтверждаете, что вам есть 18 лет.',
                    style: BankingTypography.bodySmall.copyWith(
                      color: isDark ? BankingColors.neutral100 : BankingColors.neutral600,
                    ),
                  ),
                  const SizedBox(height: BankingTokens.space24),

                  BankingButton(
                    text: 'Принять условия',
                    variant: BankingButtonVariant.primary,
                    onPressed: widget.onAccept,
                    fullWidth: true,
                  ),
                  const SizedBox(height: BankingTokens.space12),
                  BankingButton(
                    text: 'Отмена',
                    variant: BankingButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(),
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCondition(String title, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: BankingTypography.bodyRegular.copyWith(
            color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
          ),
        ),
        Text(
          value,
          style: BankingTypography.bodyRegular.semiBold.copyWith(
            color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
          ),
        ),
      ],
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
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(BankingTokens.space16),
        decoration: BoxDecoration(
          color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
          borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Container(
              padding: const EdgeInsets.all(BankingTokens.space16),
              decoration: BoxDecoration(
                color: BankingColors.secondary500,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(BankingTokens.borderRadiusLarge),
                  topRight: Radius.circular(BankingTokens.borderRadiusLarge),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.credit_card,
                    color: BankingColors.neutral0,
                    size: BankingTokens.iconSizeLarge,
                  ),
                  const SizedBox(width: BankingTokens.space12),
                  Expanded(
                    child: Text(
                      'Условия кредитной карты',
                      style: BankingTypography.heading4.copyWith(
                        color: BankingColors.neutral0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Содержимое
            Padding(
              padding: const EdgeInsets.all(BankingTokens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCondition('Кредитный лимит', 'До 500 000 ₽'),
                  const SizedBox(height: BankingTokens.space12),
                  _buildCondition('Льготный период', 'До 120 дней'),
                  const SizedBox(height: BankingTokens.space12),
                  _buildCondition('Процентная ставка', 'От 15% годовых'),
                  const SizedBox(height: BankingTokens.space12),
                  _buildCondition('Стоимость обслуживания', '590 ₽/год'),
                  const SizedBox(height: BankingTokens.space24),

                  Text(
                    'При оформлении карты вы соглашаетесь с условиями кредитования и подтверждаете свою платежеспособность.',
                    style: BankingTypography.bodySmall.copyWith(
                      color: isDark ? BankingColors.neutral100 : BankingColors.neutral600,
                    ),
                  ),
                  const SizedBox(height: BankingTokens.space24),

                  BankingButton(
                    text: 'Принять условия',
                    variant: BankingButtonVariant.primary,
                    onPressed: widget.onAccept,
                    fullWidth: true,
                  ),
                  const SizedBox(height: BankingTokens.space12),
                  BankingButton(
                    text: 'Отмена',
                    variant: BankingButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(),
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCondition(String title, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: BankingTypography.bodyRegular.copyWith(
            color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
          ),
        ),
        Text(
          value,
          style: BankingTypography.bodyRegular.semiBold.copyWith(
            color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
          ),
        ),
      ],
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
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  Account? selectedAccount;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(BankingTokens.space16),
        decoration: BoxDecoration(
          color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
          borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Container(
              padding: const EdgeInsets.all(BankingTokens.space16),
              decoration: BoxDecoration(
                color: BankingColors.info500,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(BankingTokens.borderRadiusLarge),
                  topRight: Radius.circular(BankingTokens.borderRadiusLarge),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.sticky_note_2,
                    color: BankingColors.neutral0,
                    size: BankingTokens.iconSizeLarge,
                  ),
                  const SizedBox(width: BankingTokens.space12),
                  Expanded(
                    child: Text(
                      'Оформление платежного стикера',
                      style: BankingTypography.heading4.copyWith(
                        color: BankingColors.neutral0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Содержимое
            Padding(
              padding: const EdgeInsets.all(BankingTokens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выберите карту для привязки стикера:',
                    style: BankingTypography.bodyRegular,
                  ),
                  const SizedBox(height: BankingTokens.space16),

                  // Выбор карты
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark ? BankingColors.neutral600 : BankingColors.neutral300,
                      ),
                      borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
                    ),
                    child: Column(
                      children: widget.accounts.map((account) {
                        return RadioListTile<Account>(
                          title: Text(
                            '${account.name} •••• ${account.id.substring(account.id.length - 4)}',
                            style: BankingTypography.bodyRegular,
                          ),
                          subtitle: Text(
                            account.formattedBalance,
                            style: BankingTypography.caption,
                          ),
                          value: account,
                          groupValue: selectedAccount,
                          onChanged: (value) {
                            setState(() {
                              selectedAccount = value;
                            });
                          },
                          activeColor: BankingColors.primary500,
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: BankingTokens.space24),

                  Text(
                    'Стоимость: 0 ₽\nДоставка: Бесплатно\nСрок изготовления: 3-5 рабочих дней',
                    style: BankingTypography.bodySmall.copyWith(
                      color: isDark ? BankingColors.neutral100 : BankingColors.neutral600,
                    ),
                  ),
                  const SizedBox(height: BankingTokens.space24),

                  BankingButton(
                    text: 'Оформить стикер',
                    variant: BankingButtonVariant.primary,
                    onPressed: selectedAccount != null ? widget.onAccept : null,
                    fullWidth: true,
                  ),
                  const SizedBox(height: BankingTokens.space12),
                  BankingButton(
                    text: 'Отмена',
                    variant: BankingButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(),
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ],
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

                // Дополнительная информация
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
