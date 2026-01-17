import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../components/svg_background.dart';
import '../utils/app_state.dart';
import 'support_chat_screen.dart';
import 'notifications_chat_screen.dart';
import '../../l10n/app_localizations.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> with TickerProviderStateMixin {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    return SvgBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
      appBar: AppBar(
        title: Text(
          localizations.chats,
          style: BankingTypography.heading3,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: isDark ? BankingColors.neutral200 : BankingColors.neutral700,
            ),
            onPressed: () => _onSearch(),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: BankingTokens.screenHorizontalPadding,
              right: BankingTokens.screenHorizontalPadding,
              top: BankingTokens.screenVerticalPadding,
              bottom: BankingTokens.bottomNavigationHeight + BankingTokens.screenVerticalPadding,
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: BankingTokens.space16),

              // Lottie Animation
              Container(
                height: 120,
                width: 120,
                child: Lottie.asset(
                  'lottie/mail.json',
                  fit: BoxFit.contain,
                  repeat: true,
                  animate: true,
                ),
              ),

              const SizedBox(height: BankingTokens.space24),

              // Chat title
              Text(
                localizations.messagesAndSupport,
                style: BankingTypography.heading3,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: BankingTokens.space8),

              Text(
                localizations.messagesDescription,
                style: BankingTypography.bodyRegular.copyWith(
                  color: isDark ? BankingColors.neutral400 : BankingColors.neutral500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: BankingTokens.space32),

              // Main chats
              _buildChatItem(
                title: localizations.notifications,
                subtitle: 'Важные сообщения от банка',
                icon: Icons.notifications,
                lastMessage: 'Ваш платёж успешно обработан',
                time: '15:30',
                unreadCount: 3,
                onTap: () => _onChatTap('notifications'),
                showArrow: true,
              ),

              _buildChatItem(
                title: localizations.techSupport,
                subtitle: 'Помощь с приложением',
                icon: Icons.support_agent,
                lastMessage: 'Здравствуйте! Как мы можем помочь?',
                time: '12:45',
                unreadCount: 1,
                onTap: () => _onChatTap('support'),
                showArrow: true,
              ),

              const SizedBox(height: BankingTokens.space32),
            ],
          ),
          ),
        ),
      ),
        bottomNavigationBar: _buildBottomNavigation(localizations),
      ),
    );
  }

  Widget _buildChatItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required String lastMessage,
    required String time,
    required int unreadCount,
    required VoidCallback onTap,
    bool showArrow = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: BankingTokens.space8),
      decoration: BoxDecoration(
        color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        boxShadow: BankingTokens.getShadow(1),
      ),
      child: ListTile(
        leading: Container(
          width: BankingTokens.getAvatarSize('medium'),
          height: BankingTokens.getAvatarSize('medium'),
          decoration: BoxDecoration(
            color: BankingColors.primary500.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: BankingColors.primary500,
            size: BankingTokens.iconSizeMedium,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: BankingTypography.bodyRegular.semiBold,
              ),
            ),
            Text(
              time,
              style: BankingTypography.caption.copyWith(
                color: isDark ? BankingColors.neutral400 : BankingColors.neutral500,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: BankingTypography.caption.copyWith(
                color: isDark ? BankingColors.neutral400 : BankingColors.neutral500,
              ),
            ),
            const SizedBox(height: BankingTokens.space4),
            Text(
              lastMessage,
              style: BankingTypography.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(right: BankingTokens.space8),
                padding: const EdgeInsets.all(BankingTokens.space4),
                decoration: BoxDecoration(
                  color: BankingColors.primary500,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount.toString(),
                  style: BankingTypography.caption.copyWith(
                    color: BankingColors.neutral0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark ? BankingColors.neutral400 : BankingColors.neutral500,
              ),
          ],
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        ),
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

  void _onChatTap(String chatType) {
    switch (chatType) {
      case 'notifications':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsChatScreen()),
        );
        break;
      case 'support':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SupportChatScreen()),
        );
        break;
    }
  }

  void _onSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Поиск по чатам')),
    );
  }

}
