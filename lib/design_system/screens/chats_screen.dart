import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';
import '../components/svg_background.dart';
import '../utils/app_state.dart';
import 'support_chat_screen.dart';
import 'notifications_chat_screen.dart';
import 'profile_screen.dart';
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
                  color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
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
        bottomNavigationBar: _buildBottomNavigation(appState, localizations),
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
                color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
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
                color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
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
                color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
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
