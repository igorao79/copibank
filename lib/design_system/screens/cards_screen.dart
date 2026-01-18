import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';
import '../components/cards.dart';
import '../components/buttons.dart';
import '../components/svg_background.dart';
import '../utils/app_state.dart';
import '../../l10n/app_localizations.dart';
import 'profile_screen.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> with TickerProviderStateMixin {
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

    // Ensure user data is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      if (appState.userName.isEmpty) {
        appState.init(); // Reload data if needed
      }
    });
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

    print('DEBUG: CardsScreen build - accounts count: ${appState.accounts.length}');
    for (var account in appState.accounts) {
      print('DEBUG: Account: ${account.name}, number: ${account.cardNumber}, balance: ${account.balance}');
    }

    return SvgBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                style: BankingTypography.heading3,
              ),
            ],
          ),
        ),
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
        IconButton(
            icon: Icon(
              Icons.add_card,
              color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
            ),
            onPressed: () => _onAddCard(),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(BankingTokens.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cards Section
              Text(
                'Ваши карты',
                style: BankingTypography.heading3,
              ),
              const SizedBox(height: BankingTokens.space16),

              // Account Cards
              SizedBox(
                height: BankingTokens.accountCardHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: appState.accounts.length,
                  itemBuilder: (context, index) {
                    final account = appState.accounts[index];
                    return Container(
                      width: 280,
                      margin: EdgeInsets.only(
                        right: index < appState.accounts.length - 1 ? BankingTokens.space16 : 0,
                      ),
                      child: BankingCards.gradientAccount(
                        title: account.name,
                        amount: account.formattedBalance,
                        subtitle: _formatCardNumber(account.cardNumber ?? '**** **** **** ****'),
                        gradientStart: account.color,
                        gradientEnd: account.color.withOpacity(0.7),
                        onTap: () => _onAccountTap(account),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: BankingTokens.space32),

              // Quick Actions
              Text(
                'Действия с картами',
                style: BankingTypography.heading4,
              ),
              const SizedBox(height: BankingTokens.space16),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: BankingTokens.space16,
                crossAxisSpacing: BankingTokens.space16,
                children: [
                  _buildActionCard(
                    icon: Icons.credit_card,
                    title: 'Блокировка карты',
                    subtitle: 'Временно заблокировать',
                    color: BankingColors.warning500,
                    onTap: () => _onCardAction('Блокировка карты'),
                  ),
                  _buildActionCard(
                    icon: Icons.pin,
                    title: 'Сменить PIN',
                    subtitle: 'Изменить PIN-код',
                    color: BankingColors.primary500,
                    onTap: () => _onCardAction('Сменить PIN'),
                  ),
                  _buildActionCard(
                    icon: Icons.contactless,
                    title: 'NFC',
                    subtitle: 'Включить бесконтактную оплату',
                    color: BankingColors.success500,
                    onTap: () => _onCardAction('NFC'),
                  ),
                  _buildActionCard(
                    icon: Icons.settings,
                    title: 'Настройки',
                    subtitle: 'Параметры карты',
                    color: BankingColors.secondary500,
                    onTap: () => _onCardAction('Настройки'),
                  ),
                ],
              ),

              const SizedBox(height: BankingTokens.space32),

              // Card Info Section
              Container(
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
                      'Информация о карте',
                      style: BankingTypography.heading4,
                    ),
                    const SizedBox(height: BankingTokens.space16),
                    _buildInfoRow('Номер карты', '**** **** **** 1234'),
                    _buildInfoRow('Срок действия', '12/27'),
                    _buildInfoRow('Статус', 'Активна'),
                    _buildInfoRow('Тип', 'Mastercard'),
                    const SizedBox(height: BankingTokens.space16),
                    BankingButtons.primary(
                      text: 'Подробная информация',
                      onPressed: () => _onCardDetails(),
                      fullWidth: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
        bottomNavigationBar: _buildBottomNavigation(localizations),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(BankingTokens.space16),
        decoration: BoxDecoration(
          color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
          borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
          boxShadow: BankingTokens.getShadow(1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(BankingTokens.space12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
              ),
              child: Icon(
                icon,
                color: color,
                size: BankingTokens.iconSizeLarge,
              ),
            ),
            const SizedBox(height: BankingTokens.space8),
            Text(
              title,
              style: BankingTypography.bodySmall.semiBold.copyWith(
                color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BankingTokens.space4),
            Text(
              subtitle,
              style: BankingTypography.caption.copyWith(
                color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: BankingTokens.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: BankingTypography.bodyRegular.copyWith(
              color: isDark ? BankingColors.neutral100 : BankingColors.neutral600,
            ),
          ),
          Text(
            value,
            style: BankingTypography.bodyRegular.semiBold.copyWith(
              color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(AppLocalizations localizations) {
    final appState = context.watch<AppState>();
    return BottomNavigationBar(
      currentIndex: appState.selectedTabIndex,
      onTap: (index) => appState.setSelectedTabIndex(index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance),
          label: localizations.myBank,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: localizations.history,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: localizations.chats,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: localizations.apply,
        ),
      ],
    );
  }

  void _onAccountTap(Account account) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Открыта карта "${account.name}"'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onCardAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Действие: $action'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onCardDetails() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Открыть подробную информацию о карте'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onAddCard() {
    _showCardTermsDialog();
  }

  String _generateCardNumber() {
    // Generate 16 random digits
    final random = Random();
    return List.generate(16, (_) => random.nextInt(10).toString()).join();
  }

  String _generateExpireDate() {
    final now = DateTime.now();
    final month = (1 + Random().nextInt(12)).toString().padLeft(2, '0');
    final year = (now.year + 1 + Random().nextInt(4)).toString().substring(2); // 1-4 years from now
    return '$month/$year';
  }

  String _generateCVC() {
    final random = Random();
    return (100 + random.nextInt(900)).toString(); // 3 digits
  }

  String _formatCardNumber(String cardNumber) {
    if (cardNumber.length >= 16) {
      final cleanNumber = cardNumber.replaceAll(' ', '');
      if (cleanNumber.length == 16) {
        return '${cleanNumber.substring(0, 4)} ${cleanNumber.substring(4, 8)} ${cleanNumber.substring(8, 12)} ${cleanNumber.substring(12, 16)}';
      }
    }
    return cardNumber;
  }

  void _showCardTermsDialog() {
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
                Text(
                  'Условия оформления карты',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BankingTokens.space16),
                const Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      'Для оформления дебетовой карты необходимо:\n\n'
                      '• Быть гражданином РФ\n'
                      '• Иметь постоянную регистрацию\n'
                      '• Предоставить паспортные данные\n'
                      '• Иметь доход от 30 000 руб/месяц\n\n'
                      'Карта будет доставлена в течение 7-10 рабочих дней.\n\n'
                      'Согласны ли вы с условиями?',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const SizedBox(height: BankingTokens.space24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Отмена'),
                      ),
                    ),
                    const SizedBox(width: BankingTokens.space12),
                    Expanded(
                      child:             ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _addNewCard();
              },
              child: const Text('Согласен'),
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

  Future<void> _addNewCard() async {
    final appState = context.read<AppState>();

    // Generate card data
    final cardNumber = _generateCardNumber();
    final expireDate = _generateExpireDate();
    final cvc = _generateCVC();

    print('DEBUG: Generated card data - number: $cardNumber, expire: $expireDate, cvc: $cvc');

    // Create new account/card
    final newAccount = Account(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Дебетовая карта',
      type: 'debit_card',
      balance: 5000.00, // Always start with $5,000
      currency: 'USD',
      color: const Color(0xFF2196F3), // Blue color for cards
      isPrimary: appState.accounts.isEmpty, // First card is primary
      cardNumber: cardNumber, // Store the full card number
      expireDate: expireDate,
      cvc: cvc,
    );

    print('DEBUG: Creating card with number: $cardNumber, expire: $expireDate, cvc: $cvc, balance: ${newAccount.balance}');
    appState.addAccount(newAccount);

    // Force rebuild to show new card immediately
    setState(() {});

    // Save card data to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final existingCards = prefs.getStringList('user_cards') ?? [];
    existingCards.add(newAccount.id);
    await prefs.setString('card_${newAccount.id}_number', cardNumber);
    await prefs.setString('card_${newAccount.id}_expire', expireDate);
    await prefs.setString('card_${newAccount.id}_cvc', cvc);
    await prefs.setDouble('card_${newAccount.id}_balance', 5000.00);
    await prefs.setStringList('user_cards', existingCards);

    print('DEBUG: Card saved to SharedPreferences:');
    print('  ID: ${newAccount.id}');
    print('  Number: $cardNumber');
    print('  Expire: $expireDate');
    print('  CVC: $cvc');
    print('  Balance: 5000.00');
    print('  Cards list: $existingCards');

    // Verify data was saved
    final savedNumber = prefs.getString('card_${newAccount.id}_number');
    final savedExpire = prefs.getString('card_${newAccount.id}_expire');
    final savedCvc = prefs.getString('card_${newAccount.id}_cvc');
    final savedBalance = prefs.getDouble('card_${newAccount.id}_balance');
    final savedCardsList = prefs.getStringList('user_cards');

    print('DEBUG: Verification - saved number: $savedNumber, expire: $savedExpire, cvc: $savedCvc, balance: $savedBalance');
    print('DEBUG: Verification - cards list: $savedCardsList');

    final formattedCardNumber = '${cardNumber.substring(0, 4)} ${cardNumber.substring(4, 8)} ${cardNumber.substring(8, 12)} ${cardNumber.substring(12, 16)}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Карта успешно оформлена! Номер: $formattedCardNumber'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onViewAllNotifications() {
    // TODO: Navigate to full notifications screen
    print('Открыть экран всех уведомлений');
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }
}
