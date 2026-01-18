import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'design_system/design_system.dart';
import 'l10n/app_localizations.dart';
import 'design_system/themes/banking_theme.dart';
import 'design_system/screens/dashboard_screen.dart';
import 'design_system/screens/transactions_screen.dart';
import 'design_system/screens/chats_screen.dart';
import 'design_system/screens/splash_screen.dart';
import 'design_system/screens/pin_input_screen.dart';
import 'design_system/utils/app_state.dart';

void main() {
  runApp(const BankingApp());
}

class BankingApp extends StatefulWidget {
  const BankingApp({super.key});

  @override
  State<BankingApp> createState() => _BankingAppState();
}

class _BankingAppState extends State<BankingApp> {
  final AppState _appState = AppState();
  bool _isInitialized = false;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Показываем splash screen минимум 2 секунды
    await Future.delayed(const Duration(seconds: 2));

    // Инициализируем данные приложения
    await _appState.init();
    print('DEBUG: App initialization completed');

    if (mounted) {
      setState(() {
        _showSplash = false;
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen first
    if (_showSplash) {
      return const MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      );
    }

    // Show loading while initializing
    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _appState),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: AppLocalizations(Locale(appState.userLanguage)).appTitle,
            theme: BankingTheme.light,
            darkTheme: BankingTheme.dark,
            themeMode: appState.themeMode,
            locale: Locale(appState.userLanguage),
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('ru', ''),
            ],
            home: const BankingAppHome(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class BankingAppHome extends StatefulWidget {
  const BankingAppHome({super.key});

  @override
  State<BankingAppHome> createState() => _BankingAppHomeState();
}

class _BankingAppHomeState extends State<BankingAppHome> {
  bool? _isOnboardingCompleted;
  bool? _isPinVerified;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isCompleted = prefs.getBool('onboarding_completed') ?? false;
    print('DEBUG: Onboarding completed: $isCompleted');
    setState(() {
      _isOnboardingCompleted = isCompleted;
    });
  }

  Future<void> _showPinSetupIfNeeded(BuildContext context, AppState appState) async {
    // Если PIN-код еще не установлен, показываем экран установки
    if (!appState.hasPinCode) {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const PinInputScreen(isSetupMode: true),
          fullscreenDialog: true,
        ),
      );
      if (result == true) {
        setState(() {
          _isPinVerified = true;
        });
      }
    } else {
      // Если PIN-код установлен, показываем экран ввода
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const PinInputScreen(isSetupMode: false),
          fullscreenDialog: true,
        ),
      );
      if (result == true) {
        setState(() {
          _isPinVerified = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Показываем загрузку пока проверяем статус onboarding
    if (_isOnboardingCompleted == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Если onboarding не завершен, показываем экран onboarding
    if (!_isOnboardingCompleted!) {
      return const OnboardingScreen();
    }

    // Если onboarding завершен, проверяем PIN-код
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Если PIN еще не проверен, показываем экран PIN
        if (_isPinVerified != true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showPinSetupIfNeeded(context, appState);
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Если PIN проверен, показываем основной экран приложения
        Widget currentScreen;
        switch (appState.selectedTabIndex) {
          case 0:
            currentScreen = const DashboardScreen(); // Мой банк
            break;
          case 1:
            currentScreen = const TransactionsScreen(); // История
            break;
          case 2:
            currentScreen = const ChatsScreen(); // Чаты
            break;
          case 3:
            currentScreen = const ApplyScreen(); // Оформить
            break;
          default:
            currentScreen = const DashboardScreen();
        }
        return currentScreen;
      },
    );
  }
}