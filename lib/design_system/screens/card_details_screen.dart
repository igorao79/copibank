import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../foundation/colors.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';
import '../components/svg_background.dart';
import '../utils/app_state.dart';
import '../../l10n/app_localizations.dart';

class CardDetailsScreen extends StatefulWidget {
  final Account account;

  const CardDetailsScreen({super.key, required this.account});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> with TickerProviderStateMixin {
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
          title: Row(
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
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
                      // TODO: Navigate to notifications
                    }
                  },
                  onOpened: () {
                    appState.markAllNotificationsAsRead();
                  },
                  itemBuilder: (BuildContext context) {
                    final notifications = appState.notifications;
                    final unreadCount = notifications.where((n) => !n.isRead).length;

                    return [
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
            padding: const EdgeInsets.all(BankingTokens.screenHorizontalPadding),
            child: Column(
              children: [
                const SizedBox(height: BankingTokens.space32),
                // Card Display
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.account.color,
                        widget.account.color.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(BankingTokens.radius16),
                    boxShadow: [
                      BoxShadow(
                        color: widget.account.color.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(BankingTokens.space24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Card Type and Chip
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'DEBIT',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.credit_card,
                              color: Colors.white.withOpacity(0.8),
                              size: 28,
                            ),
                          ],
                        ),

                        // Card Number
                        Text(
                          _formatCardNumber(widget.account.cardNumber ?? '****************'),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),

                        // Bottom Row: Expire and CVC
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'VALID THRU',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  widget.account.expireDate ?? 'MM/YY',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'CVC',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  widget.account.cvc ?? '***',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: BankingTokens.space48),

                // Balance Info
                Container(
                  padding: const EdgeInsets.all(BankingTokens.space16),
                  decoration: BoxDecoration(
                    color: isDark ? BankingColors.neutral800 : BankingColors.neutral100,
                    borderRadius: BorderRadius.circular(BankingTokens.radius12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Баланс:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.account.formattedBalance,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.account.isPositive ? BankingColors.success500 : BankingColors.error500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: BankingTokens.space32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _onTransferPressed(),
                        icon: const Icon(Icons.send),
                        label: const Text('Перевести'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: BankingTokens.space16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(BankingTokens.radius12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: BankingTokens.space16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _onCloseCardPressed(),
                        icon: const Icon(Icons.delete_forever),
                        label: const Text('Закрыть карту'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: BankingTokens.space16),
                          side: const BorderSide(color: BankingColors.error500),
                          foregroundColor: BankingColors.error500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(BankingTokens.radius12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTransferPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функция перевода будет реализована позже'),
        duration: Duration(seconds: 2),
      ),
    );
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

  Future<void> _onCloseCardPressed() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Закрыть карту'),
          content: const Text(
            'Вы уверены, что хотите закрыть эту карту? '
            'Это действие нельзя отменить.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                final appState = context.read<AppState>();
                await appState.removeAccount(widget.account.id);
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to dashboard
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Карта закрыта'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BankingColors.error500,
              ),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}
