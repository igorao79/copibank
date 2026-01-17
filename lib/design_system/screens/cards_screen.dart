import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../components/cards.dart';
import '../components/buttons.dart';
import '../components/svg_background.dart';
import '../utils/app_state.dart';
import '../../l10n/app_localizations.dart';

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
      appBar: AppBar(
        title: Text(
          localizations.cards,
          style: BankingTypography.heading3,
        ),
        actions: [
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
                        subtitle: account.type,
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Открыть экран добавления карты'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
