import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';
import '../components/buttons.dart';
import '../utils/app_state.dart';
import '../../l10n/app_localizations.dart';
import 'transfer_screen.dart';

class CardDetailsScreen extends StatefulWidget {
  final Account account;

  const CardDetailsScreen({super.key, required this.account});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isCardFlipped = false;

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

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  void _toggleCardFlip() {
    setState(() {
      _isCardFlipped = !_isCardFlipped;
    });
    if (_isCardFlipped) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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

              // Card Display with Flip Animation
              AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final angle = _flipAnimation.value * 3.14159;
                  final isFlipped = angle > 3.14159 / 2;

                  return Stack(
                    children: [
                      Transform(
                        transform: Matrix4.rotationY(angle),
                        alignment: Alignment.center,
                        child: Container(
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
                          child: isFlipped
                              ? _buildCardBack() // Back side of card
                              : _buildCardFront(), // Front side of card
                        ),
                      ),
                      // Flip button in top right corner
                      Positioned(
                        top: BankingTokens.space12,
                        right: BankingTokens.space12,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isCardFlipped ? Icons.flip_to_front : Icons.flip_to_back,
                              color: Colors.black87,
                              size: 20,
                            ),
                            onPressed: _toggleCardFlip,
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
                      style: BankingTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                      ),
                    ),
                    Text(
                      '\$${widget.account.balance.toStringAsFixed(2)}',
                      style: BankingTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: BankingColors.primary500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: BankingTokens.space24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: BankingButtons.primary(
                      text: 'Перевод',
                      onPressed: () => _onTransferPressed(),
                      icon: Icons.send,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: BankingTokens.space32),

              // Card Details
              Container(
                padding: const EdgeInsets.all(BankingTokens.space16),
                decoration: BoxDecoration(
                  color: isDark ? BankingColors.neutral800 : BankingColors.neutral50,
                  borderRadius: BorderRadius.circular(BankingTokens.radius12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Информация о карте',
                      style: BankingTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: BankingTokens.space16),

                    _buildInfoRow('Номер карты', _formatCardNumber(widget.account.cardNumber ?? '**** **** **** ****')),
                    _buildInfoRow('Срок действия', widget.account.expireDate ?? 'MM/YY'),
                    _buildInfoRow('CVC', widget.account.cvc ?? '***'),
                    _buildInfoRow('Тип карты', widget.account.type == 'debit_card' ? 'Дебетовая' : 'Кредитная'),
                    if (widget.account.hasSticker)
                      _buildInfoRow('Стикер', 'Привязан'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return Padding(
      padding: const EdgeInsets.all(BankingTokens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bank Name at top
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'copibank',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),

          const SizedBox(height: BankingTokens.space8),

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

          // Card Number with Copy Button
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatCardNumber(widget.account.cardNumber ?? '****************'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  final cardNumber = widget.account.cardNumber ?? '****************';
                  Clipboard.setData(ClipboardData(text: cardNumber)).then((_) {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        });

                        return Dialog(
                          backgroundColor: BankingColors.primary500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(BankingTokens.radius16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(BankingTokens.space24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 48,
                                ),
                                const SizedBox(height: BankingTokens.space16),
                                Text(
                                  'Номер карты скопирован!',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: BankingTokens.space8),
                                Text(
                                  cardNumber,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontFamily: 'monospace',
                                    letterSpacing: 1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  });
                },
                icon: const Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
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
                    '***',
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
    );
  }

  Widget _buildCardBack() {
    return Padding(
      padding: const EdgeInsets.all(BankingTokens.space16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Magnetic stripe
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(BankingTokens.radius4),
            ),
          ),

          const SizedBox(height: BankingTokens.space24),

          // CVC area
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(BankingTokens.radius4),
              ),
              child: Center(
                child: Text(
                  widget.account.cvc ?? '***',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: BankingTokens.space16),

          // Bank name at bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'copibank',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
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
              color: isDark ? BankingColors.neutral400 : BankingColors.neutral600,
            ),
          ),
          Text(
            value,
            style: BankingTypography.bodyRegular.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
            ),
          ),
        ],
      ),
    );
  }

  void _onTransferPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransferScreen(selectedAccount: widget.account),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.of(context).pushNamed('/profile');
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
}