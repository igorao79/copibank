import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../foundation/colors.dart';
import '../foundation/tokens.dart';
import '../foundation/icons.dart';
import '../components/buttons.dart';
import '../components/svg_background.dart';
import '../utils/app_state.dart';
import '../screens/change_pin_screen.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
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
      appState.init(); // Reload data if needed
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

    print('DEBUG: Profile screen - userName: ${appState.userName}, userEmail: ${appState.userEmail}');

    // If data is empty, try to load it synchronously
    if (appState.userName.isEmpty || appState.userEmail.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await appState.init();
      });
    }

    return SvgBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          title: Row(
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
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  PopupMenuButton<String>(
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
                  if (appState.unreadNotificationsCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: BankingColors.error500,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          appState.unreadNotificationsCount > 99
                              ? '99+'
                              : appState.unreadNotificationsCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
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
              bottom: BankingTokens.bottomNavigationHeight + BankingTokens.space16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              BankingColors.primary500,
                              BankingColors.primary700,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.account_circle,
                          size: 60,
                          color: BankingColors.neutral0,
                        ),
                      ),
                      const SizedBox(height: BankingTokens.space16),
                      Text(
                        appState.userName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: BankingTokens.space32),

                // Profile Information Section
                Text(
                  AppLocalizations.of(context)?.personalInformation ?? 'Личная информация',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: BankingTokens.space16),

                // Name Field
                _buildProfileField(
                  context: context,
                  label: AppLocalizations.of(context)?.name ?? 'Имя',
                  value: appState.userName,
                  icon: Icons.person,
                  onEdit: () => _showEditNameDialog(context, appState),
                ),
                const SizedBox(height: BankingTokens.space16),

                // Email Field
                _buildProfileField(
                  context: context,
                  label: 'Email',
                  value: appState.userEmail,
                  icon: Icons.email,
                  onEdit: () => _showEditEmailDialog(context, appState),
                ),
                const SizedBox(height: BankingTokens.space16),

                // Password Field
                _buildProfileField(
                  context: context,
                  label: 'Пароль',
                  value: '••••••••',
                  icon: Icons.lock,
                  onEdit: () => _showChangePasswordDialog(context),
                  isPassword: true,
                ),
                const SizedBox(height: BankingTokens.space32),

                // Settings Section
                Text(
                  AppLocalizations.of(context)?.settings ?? 'Настройки',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: BankingTokens.space16),

                // Language Setting
                _buildSettingItem(
                  context: context,
                  title: AppLocalizations.of(context)?.language ?? 'Язык',
                  value: appState.userLanguage == 'ru' ? (AppLocalizations.of(context)?.russian ?? 'Русский') : (AppLocalizations.of(context)?.english ?? 'Английский'),
                  icon: Icons.language,
                  onTap: () => _showLanguageDialog(context, appState),
                ),
                const SizedBox(height: BankingTokens.space16),

                // PIN Code Setting
                _buildSettingItem(
                  context: context,
                  title: AppLocalizations.of(context)?.pinCode ?? 'PIN код',
                  value: appState.hasPinCode ? (AppLocalizations.of(context)?.pinSet ?? 'Установлен') : (AppLocalizations.of(context)?.pinNotSet ?? 'Не установлен'),
                  icon: Icons.lock,
                  onTap: () => _navigateToChangePin(context),
                ),
                const SizedBox(height: BankingTokens.space16),

                // Theme Setting
                _buildSettingItem(
                  context: context,
                  title: AppLocalizations.of(context)?.theme ?? 'Тема',
                  value: appState.themeMode == ThemeMode.dark ? (AppLocalizations.of(context)?.dark ?? 'Тёмная') :
                         appState.themeMode == ThemeMode.light ? (AppLocalizations.of(context)?.light ?? 'Светлая') : (AppLocalizations.of(context)?.system ?? 'Системная'),
                  icon: Icons.palette,
                  onTap: () => _showThemeDialog(context, appState),
                ),
                const SizedBox(height: BankingTokens.space32),

                // Logout Button
                Center(
                  child: BankingButtons.secondary(
                    text: AppLocalizations.of(context)?.logout ?? 'Выйти',
                    onPressed: () => _showLogoutDialog(context),
                    fullWidth: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onEdit,
    bool isPassword = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(BankingTokens.space16),
      decoration: BoxDecoration(
        color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
        borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
        boxShadow: BankingTokens.getShadow(1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(BankingTokens.space8),
            decoration: BoxDecoration(
              color: BankingColors.primary500.withOpacity(0.1),
              borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
            ),
            child: Icon(
              icon,
              color: BankingColors.primary500,
              size: BankingTokens.iconSizeMedium,
            ),
          ),
          const SizedBox(width: BankingTokens.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? BankingColors.neutral400 : BankingColors.neutral600,
                  ),
                ),
                const SizedBox(height: BankingTokens.space4),
                Text(
                  isPassword ? '••••••••' : value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: BankingColors.primary500,
              size: BankingTokens.iconSizeMedium,
            ),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(BankingTokens.space16),
        decoration: BoxDecoration(
          color: isDark ? BankingColors.neutral800 : BankingColors.neutral0,
          borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
          boxShadow: BankingTokens.getShadow(1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(BankingTokens.space8),
              decoration: BoxDecoration(
                color: BankingColors.info500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
              ),
              child: Icon(
                icon,
                color: BankingColors.info500,
                size: BankingTokens.iconSizeMedium,
              ),
            ),
            const SizedBox(width: BankingTokens.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? BankingColors.neutral400 : BankingColors.neutral600,
              ),
            ),
            const SizedBox(width: BankingTokens.space8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? BankingColors.neutral400 : BankingColors.neutral600,
            ),
          ],
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

  void _onViewAllNotifications() {
    // TODO: Navigate to full notifications screen
    print('Открыть экран всех уведомлений');
  }

  void _showEditNameDialog(BuildContext context, AppState appState) {
    final controller = TextEditingController(text: appState.userName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.changeName ?? 'Изменить имя'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Введите новое имя',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                appState.setUserName(controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)?.nameChangedSuccessfully ?? 'Имя успешно изменено')),
                );
              }
            },
            child: Text(AppLocalizations.of(context)?.save ?? 'Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showEditEmailDialog(BuildContext context, AppState appState) async {
    final controller = TextEditingController(text: appState.userEmail);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.changeEmail ?? 'Изменить email'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Введите новый email',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Отмена'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                // Save email to SharedPreferences and update AppState
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('user_email', controller.text);
                appState.setUserEmail(controller.text);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)?.emailChangedSuccessfully ?? 'Email успешно изменен')),
                );
              }
            },
            child: Text(AppLocalizations.of(context)?.save ?? 'Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.changePassword ?? 'Изменить пароль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              decoration: const InputDecoration(
                hintText: 'Текущий пароль',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newController,
              decoration: const InputDecoration(
                hintText: 'Новый пароль',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                hintText: 'Подтвердите новый пароль',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (newController.text == confirmController.text && newController.text.isNotEmpty) {
                // TODO: Change password
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)?.passwordChangedSuccessfully ?? 'Пароль успешно изменен')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)?.passwordsDontMatch ?? 'Пароли не совпадают')),
                );
              }
            },
            child: Text(AppLocalizations.of(context)?.save ?? 'Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.selectLanguage ?? 'Выберите язык'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)?.russian ?? 'Русский'),
              leading: appState.userLanguage == 'ru' ? const Icon(Icons.check) : const SizedBox(),
              onTap: () {
                appState.setUserLanguage('ru');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)?.english ?? 'Английский'),
              leading: appState.userLanguage == 'en' ? const Icon(Icons.check) : const SizedBox(),
              onTap: () {
                appState.setUserLanguage('en');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.selectTheme ?? 'Выберите тему'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)?.light ?? 'Светлая'),
              leading: appState.themeMode == ThemeMode.light ? const Icon(Icons.check) : const SizedBox(),
              onTap: () {
                appState.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)?.dark ?? 'Темная'),
              leading: appState.themeMode == ThemeMode.dark ? const Icon(Icons.check) : const SizedBox(),
              onTap: () {
                appState.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)?.system ?? 'Системная'),
              leading: appState.themeMode == ThemeMode.system ? const Icon(Icons.check) : const SizedBox(),
              onTap: () {
                appState.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChangePin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChangePinScreen(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.logout ?? 'Выйти из аккаунта'),
        content: Text(AppLocalizations.of(context)?.logoutConfirmation ?? 'Вы уверены, что хотите выйти из аккаунта?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Отмена'),
          ),
          TextButton(
            onPressed: () async {
              // Logout logic - сбросить onboarding и вернуть к начальному экрану
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('onboarding_completed', false);

              if (mounted) {
                Navigator.pop(context); // Закрыть диалог
                // Вернуться к главному экрану приложения (который проверит onboarding)
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            child: Text(AppLocalizations.of(context)?.logout ?? 'Выйти'),
            style: TextButton.styleFrom(
              foregroundColor: BankingColors.error500,
            ),
          ),
        ],
      ),
    );
  }
}
