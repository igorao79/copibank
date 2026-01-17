import 'package:flutter/material.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../components/svg_background.dart';

class NotificationsChatScreen extends StatefulWidget {
  const NotificationsChatScreen({super.key});

  @override
  State<NotificationsChatScreen> createState() => _NotificationsChatScreenState();
}

class _NotificationsChatScreenState extends State<NotificationsChatScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Платеж успешно выполнен',
      'message': 'Ваш перевод на сумму 5,000 ₽ был успешно выполнен',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'type': 'success',
      'read': false,
    },
    {
      'title': 'Новая карта готова',
      'message': 'Ваша дебетовая карта Visa готова к выдаче в отделении банка',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'info',
      'read': true,
    },
    {
      'title': 'Безопасность аккаунта',
      'message': 'Рекомендуем включить двухфакторную аутентификацию для большей безопасности',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'type': 'warning',
      'read': false,
    },
    {
      'title': 'Акция! Кешбэк до 10%',
      'message': 'Получите до 10% кешбэка при оплате в категориях "Кафе и рестораны"',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'type': 'promotion',
      'read': true,
    },
  ];

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

    return SvgBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          title: Text(
            'Уведомления',
            style: BankingTypography.heading3,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.mark_email_read),
              onPressed: _markAllAsRead,
              tooltip: 'Отметить все как прочитанные',
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: _showNotificationsMenu,
            ),
          ],
        ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _notifications.isEmpty
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
              color: isDark ? BankingColors.neutral400 : BankingColors.neutral500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(BankingTokens.screenHorizontalPadding),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationItem(notification, index);
      },
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRead = notification['read'] as bool;
    final type = notification['type'] as String;

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

    return Dismissible(
      key: Key('notification_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: BankingTokens.space24),
        decoration: BoxDecoration(
          color: BankingColors.error500,
          borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        ),
        child: Icon(
          Icons.delete,
          color: BankingColors.neutral0,
        ),
      ),
      onDismissed: (direction) => _deleteNotification(index),
      child: Container(
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
                  notification['title'] as String,
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
                notification['message'] as String,
                style: BankingTypography.bodySmall.copyWith(
                  color: isDark ? BankingColors.neutral300 : BankingColors.neutral600,
                ),
              ),
              const SizedBox(height: BankingTokens.space8),
              Text(
                _formatTimestamp(notification['timestamp'] as DateTime),
                style: BankingTypography.caption.copyWith(
                  color: isDark ? BankingColors.neutral500 : BankingColors.neutral400,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          onTap: () => _onNotificationTap(index),
        ),
      ),
    );
  }

  void _onNotificationTap(int index) {
    setState(() {
      _notifications[index]['read'] = true;
    });

    // Show full notification details
    final notification = _notifications[index];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(BankingTokens.borderRadiusLarge),
              topRight: Radius.circular(BankingTokens.borderRadiusLarge),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: BankingTokens.space12),
                decoration: BoxDecoration(
                  color: isDark ? BankingColors.neutral600 : BankingColors.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(BankingTokens.screenHorizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['title'] as String,
                        style: BankingTypography.heading3,
                      ),
                      const SizedBox(height: BankingTokens.space16),
                      Text(
                        notification['message'] as String,
                        style: BankingTypography.bodyRegular,
                      ),
                      const SizedBox(height: BankingTokens.space16),
                      Text(
                        _formatTimestamp(notification['timestamp'] as DateTime),
                        style: BankingTypography.caption.copyWith(
                          color: isDark ? BankingColors.neutral500 : BankingColors.neutral400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['read'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Все уведомления отмечены как прочитанные')),
    );
  }

  void _deleteNotification(int index) {
    final notification = _notifications[index];
    setState(() {
      _notifications.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Уведомление удалено'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            setState(() {
              _notifications.insert(index, notification);
            });
          },
        ),
      ),
    );
  }

  void _showNotificationsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(BankingTokens.borderRadiusLarge),
              topRight: Radius.circular(BankingTokens.borderRadiusLarge),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: BankingTokens.space12),
                decoration: BoxDecoration(
                  color: isDark ? BankingColors.neutral600 : BankingColors.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.delete_sweep, color: BankingColors.error500),
                title: Text('Удалить все прочитанные', style: BankingTypography.bodyRegular),
                onTap: () {
                  Navigator.pop(context);
                  _deleteReadNotifications();
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: BankingColors.primary500),
                title: Text('Настройки уведомлений', style: BankingTypography.bodyRegular),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Open notification settings
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteReadNotifications() {
    setState(() {
      _notifications.removeWhere((notification) => notification['read'] == true);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Прочитанные уведомления удалены')),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Вчера ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} д. назад';
    } else {
      return '${timestamp.day.toString().padLeft(2, '0')}.${timestamp.month.toString().padLeft(2, '0')}.${timestamp.year}';
    }
  }
}
