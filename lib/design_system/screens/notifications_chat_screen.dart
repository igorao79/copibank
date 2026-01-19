import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../components/svg_background.dart';
import 'profile_screen.dart';
import '../utils/app_state.dart';
import '../../l10n/app_localizations.dart';

class NotificationsChatScreen extends StatefulWidget {
  const NotificationsChatScreen({super.key});

  @override
  State<NotificationsChatScreen> createState() => _NotificationsChatScreenState();
}

class _NotificationsChatScreenState extends State<NotificationsChatScreen> with TickerProviderStateMixin {
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

    return SvgBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
        title: GestureDetector(
          onTap: () => _navigateToProfile(context),
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
          ],
        ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: appState.notifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationsList(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: BankingColors.primary500.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 60,
              color: BankingColors.primary500,
            ),
          ),
          const SizedBox(height: BankingTokens.space24),
          Text(
            'Уведомлений пока нет',
            style: BankingTypography.heading4,
          ),
          const SizedBox(height: BankingTokens.space8),
          Text(
            'Здесь будут появляться важные сообщения от банка',
            style: BankingTypography.bodyRegular.copyWith(
              color: isDark ? BankingColors.neutral200 : BankingColors.neutral500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    final appState = context.read<AppState>();
    return ListView.builder(
      padding: const EdgeInsets.all(BankingTokens.screenHorizontalPadding),
      itemCount: appState.notifications.length,
      itemBuilder: (context, index) {
        final notification = appState.notifications[index];
        return _buildNotificationItem(notification, index);
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRead = notification.isRead;
    final type = notification.type.toString().split('.').last; // Convert enum to string

    Color iconColor;
    IconData iconData;

    switch (type) {
      case 'success':
        iconColor = BankingColors.success500;
        iconData = Icons.check_circle;
        break;
      case 'warning':
        iconColor = BankingColors.warning500;
        iconData = Icons.warning;
        break;
      case 'error':
        iconColor = BankingColors.error500;
        iconData = Icons.error;
        break;
      case 'promotion':
        iconColor = BankingColors.secondary500;
        iconData = Icons.local_offer;
        break;
      default:
        iconColor = BankingColors.primary500;
        iconData = Icons.info;
    }

    return Container(
        margin: const EdgeInsets.only(bottom: BankingTokens.space12),
        decoration: BoxDecoration(
          color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
          borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
          boxShadow: BankingTokens.getShadow(1),
          border: !isRead
              ? Border.all(
                  color: BankingColors.primary500.withOpacity(0.3),
                  width: 2,
                )
              : null,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(BankingTokens.space16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 24,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  notification.title,
                  style: BankingTypography.bodyRegular.semiBold.copyWith(
                    color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                  ),
                ),
              ),
              if (!isRead)
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: BankingTokens.space4),
              Text(
                notification.message,
                style: BankingTypography.bodySmall.copyWith(
                  color: isDark ? BankingColors.neutral100 : BankingColors.neutral600,
                ),
              ),
              const SizedBox(height: BankingTokens.space8),
              Text(
                notification.getTimeAgo(AppLocalizations.of(context)),
                style: BankingTypography.caption.copyWith(
                  color: isDark ? BankingColors.neutral200 : BankingColors.neutral400,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          onTap: () => _onNotificationTap(index),
        ),
    );
  }

  void _onNotificationTap(int index) {
    final appState = context.read<AppState>();
    final notification = appState.notifications[index];

    // Mark as read if not already read
    if (!notification.isRead) {
      notification.isRead = true;
      appState.notifyListeners();
    }
    // Removed modal bottom sheet - notifications no longer expand on tap
  }




  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }
}
