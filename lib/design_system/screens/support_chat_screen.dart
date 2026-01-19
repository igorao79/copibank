import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';
import '../components/svg_background.dart';
import '../utils/app_state.dart';
import '../../l10n/app_localizations.dart';
import 'profile_screen.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isWaitingForBotResponse = false;

  List<Map<String, dynamic>> _messages = [
    {
      'text': '', // Will be set in initState based on current locale
      'isBot': true,
      'timestamp': DateTime.now(),
      'type': 'text',
    }
  ];

  List<Map<String, String>> get _quickQuestions => [
    {
      'question': AppLocalizations.of(context)?.faqHowToTopUp ?? 'How to top up account?',
      'answer': AppLocalizations.of(context)?.faqHowToTopUpAnswer ?? 'You can top up your account through:\n• ATM\n• Transfer from another card\n• Via mobile app\n• At bank branch'
    },
    {
      'question': AppLocalizations.of(context)?.faqHowToBlockCard ?? 'How to block card?',
      'answer': AppLocalizations.of(context)?.faqHowToBlockCardAnswer ?? 'Block card can be done:\n• In mobile app (Cards → Select card → Block)\n• By hotline phone\n• At bank branch'
    },
    {
      'question': AppLocalizations.of(context)?.faqHowToChangePin ?? 'How to change PIN code?',
      'answer': AppLocalizations.of(context)?.faqHowToChangePinAnswer ?? 'Change PIN code can be done:\n• At ATM\n• Via mobile app\n• At bank branch with passport'
    },
    {
      'question': AppLocalizations.of(context)?.faqWhyPaymentFailed ?? 'Why payment didn\'t go through?',
      'answer': AppLocalizations.of(context)?.faqWhyPaymentFailedAnswer ?? 'Possible reasons:\n• Insufficient funds\n• Limit exceeded\n• Technical problems\n• Incorrect details\n\nCheck payment status in transaction history'
    },
    {
      'question': AppLocalizations.of(context)?.faqHowToEnableNotifications ?? 'How to enable notifications?',
      'answer': AppLocalizations.of(context)?.faqHowToEnableNotificationsAnswer ?? 'Enable notifications:\n• Open app\n• Go to Settings\n• Select "Notifications"\n• Allow push notifications'
    },
    {
      'question': AppLocalizations.of(context)?.faqAccountSecurity ?? 'Account security',
      'answer': AppLocalizations.of(context)?.faqAccountSecurityAnswer ?? 'Security recommendations:\n• Use strong password\n• Don\'t share data with third parties\n• Change password regularly\n• Enable two-factor authentication'
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

    // Initialize bot message based on current locale
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final localizations = AppLocalizations.of(context);
        _messages[0]['text'] = localizations?.locale.languageCode == 'ru'
            ? 'Здравствуйте! Я помощник банка. Чем могу помочь?'
            : 'Hello! I am the bank assistant. How can I help?';
      });
      context.read<AppState>().markSupportMessagesAsRead();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
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
                style: BankingTypography.heading3.copyWith(
                  color: BankingColors.primary500,
                ),
              ),
            ],
          ),
        ),
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
                  isDark ? BankingIcons.notification : BankingIcons.notificationFilled,
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
                                  notification.getLocalizedTitle(localizations),
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
                            if (notification.getLocalizedMessage(AppLocalizations.of(context)).isNotEmpty)
                              Text(
                                notification.getLocalizedMessage(AppLocalizations.of(context)),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? BankingColors.neutral400
                                      : BankingColors.neutral600,
                                ),
                              ),
                            Text(
                            notification.getTimeAgo(AppLocalizations.of(context)),
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
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Chat messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(BankingTokens.screenHorizontalPadding),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
                ),

                // Quick questions (only show if bot's last message)
                if (_messages.isNotEmpty && _messages.last['isBot'] == true && _messages.last['showQuestions'] != false)
                  _buildQuickQuestions(),

                // Message input
                _buildMessageInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isBot = message['isBot'] as bool;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: BankingTokens.space12),
      child: Row(
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: BankingColors.primary500,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy,
                color: BankingColors.neutral0,
                size: 16,
              ),
            ),
            const SizedBox(width: BankingTokens.space8),
          ],

          Flexible(
            child: Container(
              padding: const EdgeInsets.all(BankingTokens.space12),
              decoration: BoxDecoration(
                color: isBot
                    ? (isDark ? BankingColors.neutral800 : BankingColors.neutral100)
                    : BankingColors.primary500,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(BankingTokens.borderRadiusMedium),
                  topRight: const Radius.circular(BankingTokens.borderRadiusMedium),
                  bottomLeft: isBot ? Radius.zero : const Radius.circular(BankingTokens.borderRadiusMedium),
                  bottomRight: isBot ? const Radius.circular(BankingTokens.borderRadiusMedium) : Radius.zero,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'] as String,
                    style: BankingTypography.bodyRegular.copyWith(
                      color: isBot
                          ? (isDark ? BankingColors.neutral100 : BankingColors.neutral900)
                          : BankingColors.neutral0,
                    ),
                  ),
                  const SizedBox(height: BankingTokens.space4),
                  Text(
                    _formatTime(message['timestamp'] as DateTime),
                    style: BankingTypography.caption.copyWith(
                      color: isBot
                          ? (isDark ? BankingColors.neutral200 : BankingColors.neutral500)
                          : BankingColors.neutral200,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (!isBot) ...[
            const SizedBox(width: BankingTokens.space8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: BankingColors.primary400,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: BankingColors.neutral0,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickQuestions() {
    return Container(
      margin: const EdgeInsets.only(
        left: BankingTokens.screenHorizontalPadding,
        right: BankingTokens.screenHorizontalPadding,
        bottom: BankingTokens.space16,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 столбца
          childAspectRatio: 3.5, // Соотношение сторон для овальных кнопок
          crossAxisSpacing: BankingTokens.space8,
          mainAxisSpacing: BankingTokens.space8,
        ),
        itemCount: _quickQuestions.length,
        itemBuilder: (context, index) {
          final question = _quickQuestions[index];
          return _buildQuickQuestionButton(question);
        },
      ),
    );
  }

  Widget _buildQuickQuestionButton(Map<String, String> question) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 48, // Фиксированная высота для овальных кнопок
      child: ElevatedButton(
        onPressed: () => _onQuestionTap(question),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
          foregroundColor: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BankingTokens.borderRadiusFull), // Полностью овальные
          ),
          padding: const EdgeInsets.symmetric(horizontal: BankingTokens.space16, vertical: BankingTokens.space8),
          minimumSize: Size.zero, // Убираем минимальный размер
        ),
        child: Text(
          question['question']!,
          style: BankingTypography.caption.copyWith(
            fontSize: 12, // Маленький шрифт
            height: 1.2,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(BankingTokens.screenHorizontalPadding),
      decoration: BoxDecoration(
        color: isDark ? BankingColors.neutral900 : BankingColors.neutral0,
        border: Border(
          top: BorderSide(
            color: isDark ? BankingColors.neutral700 : BankingColors.neutral200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: BankingTokens.space16,
                vertical: BankingTokens.space8,
              ),
              decoration: BoxDecoration(
                color: isDark ? BankingColors.neutral800 : BankingColors.neutral100,
                borderRadius: BorderRadius.circular(BankingTokens.borderRadiusLarge),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)?.enterMessage ?? 'Enter message...',
                  border: InputBorder.none,
                  hintStyle: BankingTypography.bodyRegular.copyWith(
                    color: isDark ? BankingColors.neutral200 : BankingColors.neutral400,
                  ),
                ),
                style: BankingTypography.bodyRegular.copyWith(
                  color: isDark ? BankingColors.neutral100 : BankingColors.neutral900,
                ),
                maxLines: 3,
                minLines: 1,
              ),
            ),
          ),
          const SizedBox(width: BankingTokens.space12),
          Container(
            decoration: BoxDecoration(
              color: BankingColors.primary500,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: BankingColors.neutral0,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _onQuestionTap(Map<String, String> question) {
    // Add user message
    setState(() {
      _messages.add({
        'text': question['question']!,
        'isBot': false,
        'timestamp': DateTime.now(),
        'type': 'text',
      });

      // Add bot response
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _messages.add({
            'text': question['answer']!,
            'isBot': true,
            'timestamp': DateTime.now(),
            'type': 'text',
            'showQuestions': true,
          });
          _scrollToBottom();
        });
      });
    });

    _scrollToBottom();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'isBot': false,
        'timestamp': DateTime.now(),
        'type': 'text',
      });

      _messageController.clear();
    });

    _scrollToBottom();

    // Bot response - только если не ждем предыдущий ответ
    if (!_isWaitingForBotResponse) {
      _isWaitingForBotResponse = true;
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _messages.add({
              'text': AppLocalizations.of(context)?.specialistContact ?? 'Thank you for your message. Our specialist will contact you shortly.',
              'isBot': true,
              'timestamp': DateTime.now(),
              'type': 'text',
              'showQuestions': false,
            });
            _isWaitingForBotResponse = false;
            _scrollToBottom();
          });
        }
      });
    }
  }

  void _showChatMenu() {
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
                  color: isDark ? BankingColors.neutral200 : BankingColors.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ...AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 600),
                childAnimationBuilder: (widget) => SlideAnimation(
                  key: UniqueKey(),
                  verticalOffset: 50.0,
                  child: ScaleAnimation(
                    key: UniqueKey(),
                    scale: 0.8,
                    child: FlipAnimation(key: UniqueKey(), child: widget),
                  ),
                ),
                children: [
                  ListTile(
                    leading: Icon(Icons.refresh, color: BankingColors.primary500),
                    title: Text(AppLocalizations.of(context)?.newChat ?? 'Start new chat', style: BankingTypography.bodyRegular),
                    onTap: () {
                      Navigator.pop(context);
                      _startNewChat();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: BankingColors.primary500),
                    title: Text(AppLocalizations.of(context)?.chatHistory ?? 'Chat history', style: BankingTypography.bodyRegular),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Show chat history
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _startNewChat() {
    setState(() {
      _messages = [
        {
          'text': AppLocalizations.of(context)?.helloBot ?? 'Hello! I am the bank assistant. How can I help?',
          'isBot': true,
          'timestamp': DateTime.now(),
          'type': 'text',
        }
      ];
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
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
