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
import '../utils/assets_constants.dart';
import '../../l10n/app_localizations.dart';
import 'profile_screen.dart';

class ApplyScreen extends StatefulWidget {
  const ApplyScreen({super.key});

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _notificationController;
  late Animation<double> _notificationAnimation;
  OverlayEntry? _currentNotificationOverlay;

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

    _notificationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _notificationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _notificationController, curve: Curves.easeOut),
    );

    // Показываем уведомление о подарке через 1 секунду после загрузки страницы
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _showReferralNotification();
      }
    });
  }

  @override
  void dispose() {
    // Удаляем overlay уведомления при уходе со страницы
    _currentNotificationOverlay?.remove();
    _currentNotificationOverlay = null;

    _fadeController.dispose();
    _notificationController.dispose();
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
          backgroundColor: isDark ? BankingColors.neutral800 : Colors.white,
          elevation: 0,
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
                    isDark
                        ? BankingIcons.notification
                        : BankingIcons.notificationFilled,
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
                    final unreadCount = notifications
                        .where((n) => !n.isRead)
                        .length;

                    return [
                      PopupMenuItem<String>(
                        enabled: false,
                        child: Text(
                          unreadCount > 0
                              ? '${localizations.notificationsHeader} (${unreadCount} ${localizations.unreadNotifications})'
                              : localizations.notificationsHeader,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const PopupMenuDivider(),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: notification.isRead
                                                ? FontWeight.normal
                                                : FontWeight.bold,
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
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? BankingColors.neutral400
                                          : BankingColors.neutral600,
                                    ),
                              ),
                              Text(
                                notification.getTimeAgo(AppLocalizations.of(context)),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? BankingColors.neutral500
                                          : BankingColors.neutral500,
                                      fontSize: 10,
                                    ),
                              ),
                            ],
                          ),
                        );
                      }),
                      if (notifications.length > 3) const PopupMenuDivider(),
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
              bottom:
                  BankingTokens.bottomNavigationHeight + BankingTokens.space48,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Lottie.asset(
                      LottieAssets.cards,
                      fit: BoxFit.contain,
                      repeat: false,
                      animate: true,
                    ),
                  ),
                ),
                const SizedBox(height: BankingTokens.space24),

                Text(
                  localizations.selectProduct,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BankingTokens.space24),

                Text(
                  localizations.cardsAndPaymentMeans,
                  style: BankingTypography.heading3,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: BankingTokens.space16),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BankingTokens.space8,
                  ),
                  child: _buildFullWidthProductButton(
                    title: localizations.debitCard,
                    description:
                        'Бесплатное обслуживание • Кэшбэк до 5% • Международные платежи',
                    icon: Icons.credit_card,
                    isDisabled: _getDebitCardCount(appState) >= 2,
                    onTap: _getDebitCardCount(appState) >= 2
                        ? null
                        : () => _showDebitCardModal(context, appState),
                  ),
                ),
                const SizedBox(height: BankingTokens.space16),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BankingTokens.space8,
                  ),
                  child: _buildFullWidthProductButton(
                    title: localizations.creditCard,
                    description:
                        'Льготный период до 120 дней • Кредитный лимит до 500 000 ₽ • Беспроцентный период',
                    icon: Icons.credit_card,
                    isDisabled: _getCreditCardCount(appState) >= 2,
                    onTap: _getCreditCardCount(appState) >= 2
                        ? null
                        : () => _showCreditCardModal(context, appState),
                  ),
                ),
                const SizedBox(height: BankingTokens.space16),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BankingTokens.space8,
                  ),
                  child: _buildFullWidthProductButton(
                    title: localizations.paymentSticker,
                    description:
                        'Бесконтактная оплата • Привязка к карте • Мгновенные платежи',
                    icon: Icons.sticky_note_2,
                    isDisabled: !appState.canOrderSticker,
                    onTap: appState.canOrderSticker
                        ? () => _showPaymentStickerModal(context, appState)
                        : null,
                  ),
                ),
                const SizedBox(height: BankingTokens.space32),

                Divider(
                  color: BankingColors.neutral300,
                  thickness: 1,
                  height: BankingTokens.space32,
                ),

                Text(
                  localizations.savingsProducts,
                  style: BankingTypography.heading3,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: BankingTokens.space16),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BankingTokens.space8,
                  ),
                  child: _buildFullWidthProductButton(
                    title: localizations.savingsAccount,
                    description:
                        '5% годовых • Накопление сбережений • Без комиссий',
                    icon: Icons.savings,
                    isDisabled: !appState.canOpenSavingsAccount,
                    onTap: appState.canOpenSavingsAccount
                        ? () => _openSavingsAccount(context, appState)
                        : null,
                  ),
                ),

                if (appState.accounts.where((account) => account.type == 'debit_card' && !account.hasSticker).isEmpty) ...[
                  const SizedBox(height: BankingTokens.space12),
                  Container(
                    padding: const EdgeInsets.all(BankingTokens.space16),
                    decoration: BoxDecoration(
                      color: BankingColors.warning50,
                      borderRadius: BorderRadius.circular(
                        BankingTokens.borderRadiusMedium,
                      ),
                      border: Border.all(color: BankingColors.warning200),
                    ),
                    child: Text(
                      localizations.noCardsForSticker,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: isDark
                            ? BankingColors.warning200
                            : BankingColors.warning500,
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

  Widget _buildBottomNavigation(
    AppState appState,
    AppLocalizations localizations,
  ) {
    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance),
        label: localizations.myBank,
      ),
    ];

    if (appState.accounts.isNotEmpty) {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: localizations.history,
        ),
      );
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

    int currentNavIndex;
    final hasHistory = appState.accounts.isNotEmpty;
    if (hasHistory) {
      currentNavIndex = appState.selectedTabIndex;
    } else {
      switch (appState.selectedTabIndex) {
        case 0:
          currentNavIndex = 0;
          break;
        case 2:
          currentNavIndex = 1;
          break;
        case 3:
          currentNavIndex = 2;
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
    int correctedIndex;
    if (hasHistory) {
      correctedIndex = index;
    } else {
      switch (index) {
        case 0:
          correctedIndex = 0;
          break;
        case 1:
          correctedIndex = 2;
          break;
        case 2:
          correctedIndex = 3;
          break;
        default:
          correctedIndex = 0;
      }
    }
    appState.setSelectedTabIndex(correctedIndex);
  }

  void _onViewAllNotifications() {
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
            borderRadius: BorderRadius.circular(
              BankingTokens.borderRadiusMedium,
            ),
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
                          : (isDark
                                ? BankingColors.neutral50
                                : BankingColors.neutral900),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: BankingTokens.space4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDisabled
                          ? BankingColors.neutral400
                          : (isDark
                                ? BankingColors.neutral300
                                : BankingColors.neutral600),
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
    return appState.accounts
        .where((account) => account.type == 'debit_card')
        .length;
  }

  int _getCreditCardCount(AppState appState) {
    return appState.accounts
        .where((account) => account.type == 'credit_card')
        .length;
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
        accounts: appState.accounts.where((a) => a.type == 'debit_card' && !a.hasSticker).toList(),
        onAccept: () => _onPaymentStickerAccepted(context, appState),
      ),
    );
  }

  void _onDebitCardAccepted(BuildContext context, AppState appState) {
    final localizations = AppLocalizations.of(context)!;
    final cardNumber = _generateCardNumber();
    final expireDate = _generateExpireDate();
    final cvc = _generateCVC();

    print('DEBUG: ApplyScreen - Generated card data:');
    print('  cardNumber: $cardNumber');
    print('  expireDate: $expireDate');
    print('  cvc: $cvc');

    final newAccount = Account(
      id: 'debit_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Дебетовая карта',
      type: 'debit_card',
      balance: 5000.00,
      currency: 'USD',
      color: const Color(0xFF2196F3),
      isPrimary: appState.accounts.isEmpty,
      cardNumber: cardNumber,
      expireDate: expireDate,
      cvc: cvc,
      hasSticker: false,
    );

    print('DEBUG: ApplyScreen - Account created with cardNumber: ${newAccount.cardNumber}');

    final isFirstCard = appState.accounts.isEmpty;

    appState.addAccount(newAccount);
    _saveCardToSharedPreferences(newAccount);

    Navigator.of(context).pop();
        _showSuccessModal(context, localizations.debitCard + ' оформлена!', 'debit_card');

    if (isFirstCard) {
      print('DEBUG: First card added, showing referral notification');
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _showReferralNotification();
        }
      });
    }
  }

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
    await prefs.setString('card_${account.id}_type', account.type);
    await prefs.setBool('card_${account.id}_has_sticker', account.hasSticker);
    await prefs.setInt('card_${account.id}_color', account.color.value);
    await prefs.setStringList('user_cards', existingCards);

    print('DEBUG: ApplyScreen - Card saved to SharedPreferences: ${account.id}');
  }

  void _onCreditCardAccepted(BuildContext context, AppState appState) {
    final localizations = AppLocalizations.of(context)!;
    final cardNumber = _generateCardNumber();
    final expireDate = _generateExpireDate();
    final cvc = _generateCVC();

    print('DEBUG: ApplyScreen - Generated credit card data:');
    print('  cardNumber: $cardNumber');
    print('  expireDate: $expireDate');
    print('  cvc: $cvc');

    final newAccount = Account(
      id: 'credit_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Кредитная карта',
      type: 'credit_card',
      balance: 10000.00,
      currency: 'USD',
      color: const Color(0xFF1565C0),
      isPrimary: false,
      cardNumber: cardNumber,
      expireDate: expireDate,
      cvc: cvc,
      hasSticker: false,
    );

    print('DEBUG: ApplyScreen - Credit account created with cardNumber: ${newAccount.cardNumber}');

    appState.addAccount(newAccount);
    _saveCardToSharedPreferences(newAccount);

    Navigator.of(context).pop();
        _showSuccessModal(context, localizations.creditCard + ' оформлена!', 'credit_card');
  }

  void _onPaymentStickerAccepted(BuildContext context, AppState appState) {
    final localizations = AppLocalizations.of(context)!;
    final availableCards = appState.accounts
        .where((account) => !account.hasSticker && account.type == 'debit_card')
        .toList();

    if (availableCards.isNotEmpty) {
      final targetCard = availableCards.first;
      appState.attachSticker(targetCard.id);

      final stickerNotification = NotificationItem(
        id: 'sticker_${DateTime.now().millisecondsSinceEpoch}',
        title: localizations.applySticker + ' оформлен!',
        message: 'Стикер успешно привязан к вашей карте',
        timestamp: DateTime.now(),
        type: NotificationType.transaction,
      );
      appState.addNotification(stickerNotification);

      Navigator.of(context).pop();
      _showSuccessModal(
        context,
        'Платежный стикер привязан к карте ${targetCard.cardNumber ?? '**** **** **** ****'}!',
        'payment_sticker',
      );
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.noCardsForSticker),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showSuccessModal(
    BuildContext context,
    String message,
    String productType,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          SuccessModal(message: message, productType: productType),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  // ✅ РЕФЕРАЛЬНОЕ УВЕДОМЛЕНИЕ
  void _showReferralNotification() {
    print('DEBUG: _showReferralNotification called');
    final localizations = AppLocalizations.of(context)!;

    // Удаляем предыдущее уведомление если оно существует
    _currentNotificationOverlay?.remove();
    _currentNotificationOverlay = null;

    if (!mounted) return;

    final overlay = Overlay.of(context);
    _currentNotificationOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 60,
        left: 16,
        right: 16,
        child: AnimatedBuilder(
          animation: _notificationAnimation,
          builder: (context, child) => Opacity(
            opacity: _notificationAnimation.value,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  if (_currentNotificationOverlay != null) {
                    _hideReferralNotification(_currentNotificationOverlay!);
                  }
                  _showReferralDialog();
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BankingColors.primary500,
                    borderRadius: BorderRadius.circular(BankingTokens.radius12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.card_giftcard,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          localizations.getGift,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          localizations.inviteFriend,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                          ],
                        ),
                      ),
                      // Кнопка закрыть с увеличенной областью клика
                      GestureDetector(
                        onTap: () {
                          if (_currentNotificationOverlay != null) {
                            _hideReferralNotification(_currentNotificationOverlay!);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.close,
                            color: Colors.white.withOpacity(0.7),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_currentNotificationOverlay!);
    _notificationController.forward();

    Future.delayed(const Duration(seconds: 5), () {
      if (_currentNotificationOverlay != null && _currentNotificationOverlay!.mounted && mounted) {
        _hideReferralNotification(_currentNotificationOverlay!);
      }
    });
  }

  void _hideReferralNotification(OverlayEntry overlayEntry) {
    _notificationController.reverse().then((_) {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
        _currentNotificationOverlay = null;
      }
    });
  }

  // ✅ РЕФЕРАЛЬНЫЙ ДИАЛОГ
  void _showReferralDialog() {
    final appState = context.read<AppState>();
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BankingTokens.radius16),
          ),
          child: Container(
            padding: const EdgeInsets.all(BankingTokens.space24),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: BankingColors.primary100,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: BankingColors.primary500,
                    size: 40,
                  ),
                ),
                const SizedBox(height: BankingTokens.space16),
                Text(
                  localizations.inviteFriend,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: BankingColors.primary500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BankingTokens.space16),
                Text(
                  'Отправь другу эту ссылку. Если он оформит карту в нашем приложении, ты получишь \$1,000 на свой счет!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BankingTokens.space24),
                Container(
                  padding: const EdgeInsets.all(BankingTokens.space12),
                  decoration: BoxDecoration(
                    color: BankingColors.neutral100,
                    borderRadius: BorderRadius.circular(BankingTokens.radius8),
                    border: Border.all(color: BankingColors.neutral300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'https://banki2.app/referral?user=${appState.userName}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(localizations.linkCopied)),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: BankingTokens.space24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(localizations.later),
                      ),
                    ),
                    const SizedBox(width: BankingTokens.space12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(localizations.linkSent)),
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text(localizations.send),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Остальные классы без изменений...

class DebitCardApplicationModal extends StatefulWidget {
  final VoidCallback onAccept;

  const DebitCardApplicationModal({super.key, required this.onAccept});

  @override
  State<DebitCardApplicationModal> createState() =>
      _DebitCardApplicationModalState();
}

class _DebitCardApplicationModalState extends State<DebitCardApplicationModal>
    with TickerProviderStateMixin {
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

              Text(
                'Дебетовая карта',
                style: BankingTypography.heading2.copyWith(
                  color: isDark
                      ? BankingColors.neutral100
                      : BankingColors.neutral900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: BankingTokens.space16),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: BankingTokens.space16,
                        ),
                        side: BorderSide(color: BankingColors.neutral400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            BankingTokens.radius12,
                          ),
                        ),
                      ),
                      child: Text(
                        'Отмена',
                        style: BankingTypography.bodyMedium.copyWith(
                          color: isDark
                              ? BankingColors.neutral200
                              : BankingColors.neutral700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: BankingTokens.space16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onAccept,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: BankingTokens.space16,
                        ),
                        backgroundColor: BankingColors.primary500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            BankingTokens.radius12,
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.applyCard ??
                            'Оформить карту',
                      ),
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

class CreditCardApplicationModal extends StatefulWidget {
  final VoidCallback onAccept;

  const CreditCardApplicationModal({super.key, required this.onAccept});

  @override
  State<CreditCardApplicationModal> createState() =>
      _CreditCardApplicationModalState();
}

class _CreditCardApplicationModalState extends State<CreditCardApplicationModal>
    with TickerProviderStateMixin {
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

              Text(
                'Кредитная карта',
                style: BankingTypography.heading2.copyWith(
                  color: isDark
                      ? BankingColors.neutral100
                      : BankingColors.neutral900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: BankingTokens.space16),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: BankingTokens.space16,
                        ),
                        side: BorderSide(color: BankingColors.neutral400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            BankingTokens.radius12,
                          ),
                        ),
                      ),
                      child: Text(
                        'Отмена',
                        style: BankingTypography.bodyMedium.copyWith(
                          color: isDark
                              ? BankingColors.neutral200
                              : BankingColors.neutral700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: BankingTokens.space16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onAccept,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: BankingTokens.space16,
                        ),
                        backgroundColor: BankingColors.secondary500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            BankingTokens.radius12,
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.applyCard ??
                            'Оформить карту',
                      ),
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

class PaymentStickerApplicationModal extends StatefulWidget {
  final List<Account> accounts;
  final VoidCallback onAccept;

  const PaymentStickerApplicationModal({
    super.key,
    required this.accounts,
    required this.onAccept,
  });

  @override
  State<PaymentStickerApplicationModal> createState() =>
      _PaymentStickerApplicationModalState();
}

class _PaymentStickerApplicationModalState
    extends State<PaymentStickerApplicationModal>
    with TickerProviderStateMixin {
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

              Text(
                'Платежный стикер',
                style: BankingTypography.heading2.copyWith(
                  color: isDark
                      ? BankingColors.neutral100
                      : BankingColors.neutral900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: BankingTokens.space16),

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

                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark
                                ? BankingColors.neutral600
                                : BankingColors.neutral300,
                          ),
                          borderRadius: BorderRadius.circular(
                            BankingTokens.borderRadiusMedium,
                          ),
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
                          color: isDark
                              ? BankingColors.neutral400
                              : BankingColors.neutral600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: BankingTokens.space32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: BankingTokens.space16,
                        ),
                        side: BorderSide(color: BankingColors.neutral400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            BankingTokens.radius12,
                          ),
                        ),
                      ),
                      child: Text(
                        'Отмена',
                        style: BankingTypography.bodyMedium.copyWith(
                          color: isDark
                              ? BankingColors.neutral200
                              : BankingColors.neutral700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: BankingTokens.space16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedAccount != null
                          ? widget.onAccept
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: BankingTokens.space16,
                        ),
                        backgroundColor: BankingColors.info500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            BankingTokens.radius12,
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.applySticker ??
                            'Оформить стикер',
                      ),
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

class _SuccessModalState extends State<SuccessModal>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _contentController;
  late Animation<double> _contentOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

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
            borderRadius: BorderRadius.circular(
              BankingTokens.borderRadiusLarge,
            ),
            boxShadow: BankingTokens.getShadow(16),
          ),
          child: FadeTransition(
            opacity: _contentOpacityAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Lottie.asset(LottieAssets.success, repeat: false),
                ),
                const SizedBox(height: BankingTokens.space16),

                Text(
                  'Успех!',
                  style: BankingTypography.heading2.copyWith(
                    color: BankingColors.success500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BankingTokens.space8),

                Text(
                  widget.message,
                  style: BankingTypography.bodyRegular,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BankingTokens.space12),

                if (widget.productType != 'deposit')
                  Text(
                    'Ваша ${widget.productType == 'debit_card'
                        ? 'дебетовая карта'
                        : widget.productType == 'credit_card'
                        ? 'кредитная карта'
                        : 'платежный стикер'} будет готова в течение 3-5 рабочих дней.',
                    style: BankingTypography.caption.copyWith(
                      color: isDark
                          ? BankingColors.neutral300
                          : BankingColors.neutral600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: BankingTokens.space24),

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

  const SavingsAccountApplicationModal({super.key, required this.onAccept});

  @override
  State<SavingsAccountApplicationModal> createState() =>
      _SavingsAccountApplicationModalState();
}

class _SavingsAccountApplicationModalState
    extends State<SavingsAccountApplicationModal>
    with TickerProviderStateMixin {
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

              Text(
                'Накопительный счет',
                style: BankingTypography.heading2.copyWith(
                  color: isDark
                      ? BankingColors.neutral100
                      : BankingColors.neutral900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: BankingTokens.space16),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: BankingTokens.space16,
                        ),
                        side: BorderSide(color: BankingColors.neutral400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            BankingTokens.radius12,
                          ),
                        ),
                      ),
                      child: Text(
                        'Отмена',
                        style: BankingTypography.bodyMedium.copyWith(
                          color: isDark
                              ? BankingColors.neutral200
                              : BankingColors.neutral700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: BankingTokens.space16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onAccept,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: BankingTokens.space16,
                        ),
                        backgroundColor: BankingColors.primary500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            BankingTokens.radius12,
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.openAccount ??
                            'Открыть счет',
                      ),
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