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
  double _splashOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Показываем splash screen минимум 3 секунды
    await Future.delayed(const Duration(milliseconds: 3000));

    // Инициализируем данные приложения
    await _appState.init();
    print('DEBUG: App initialization completed');

    // Плавно скрываем splash screen
    if (mounted) {
      // Анимируем opacity в течение 0.5 секунды
      const duration = Duration(milliseconds: 500);
      const steps = 10;
      const stepDuration = Duration(milliseconds: 50);

      for (int i = 0; i < steps; i++) {
        await Future.delayed(stepDuration);
        if (mounted) {
          setState(() {
            _splashOpacity = 1.0 - (i + 1) / steps;
          });
        }
      }

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
      return MaterialApp(
        home: Opacity(
          opacity: _splashOpacity,
          child: const SplashScreen(),
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    // Go directly to BankingAppHome after splash - it will handle PIN logic
    if (!_isInitialized) {
      return const MaterialApp(
        home: BankingAppHome(),
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
  bool _isReady = false;
  Widget? _targetScreen;

  @override
  void initState() {
    super.initState();
    _prepareApp();
  }

  Future<void> _prepareApp() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (!isOnboardingCompleted) {
      // Готовим onboarding
      setState(() {
        _targetScreen = const OnboardingScreen();
        _isReady = true;
      });
    } else {
      // Готовим PIN screen
      final appState = context.read<AppState>();
      setState(() {
        _targetScreen = PinInputScreen(
          isSetupMode: !appState.hasPinCode,
          onSuccess: () {
            setState(() {
              _targetScreen = _buildMainApp();
            });
          },
        );
        _isReady = true;
      });
    }
  }

  Widget _buildMainApp() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        Widget currentScreen;
        switch (appState.selectedTabIndex) {
          case 0:
            currentScreen = const DashboardScreen();
            break;
          case 1:
            currentScreen = const TransactionsScreen();
            break;
          case 2:
            currentScreen = const ChatsScreen();
            break;
          case 3:
            currentScreen = const ApplyScreen();
            break;
          default:
            currentScreen = const DashboardScreen();
        }
        return currentScreen;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _targetScreen == null) {
      // Показываем только пока готовим
      return const SizedBox.shrink();
    }

    return _targetScreen!;
  }
}