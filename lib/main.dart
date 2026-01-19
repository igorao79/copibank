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
import 'design_system/screens/onboarding_screen.dart';
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
  bool? _isOnboardingCompleted;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // СНАЧАЛА инициализируем AppState, чтобы загрузить тему
    await _appState.init();
    
    // Проверяем состояние onboarding
    final prefs = await SharedPreferences.getInstance();
    final isOnboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    
    print('DEBUG: App initialization completed');

    // ПОТОМ показываем splash screen с правильной темой минимум 3 секунды
    await Future.delayed(const Duration(milliseconds: 3000));

    // Плавно скрываем splash screen
    if (mounted) {
      setState(() {
        _showSplash = false;
        _isInitialized = true;
        _isOnboardingCompleted = isOnboardingCompleted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            home: _buildHome(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  Widget _buildHome() {
    // Показываем splash screen
    if (_showSplash) {
      return const SplashScreen();
    }

    // Показываем onboarding если не завершен
    if (_isInitialized && _isOnboardingCompleted == false) {
      return const OnboardingScreen();
    }

    // Показываем PIN screen или main app
    if (_isInitialized && _isOnboardingCompleted == true) {
      return PinInputScreen(
        isSetupMode: !_appState.hasPinCode,
        onSuccess: () {
          // После успешного ввода PIN переходим к основному приложению
          setState(() {
            // Можно добавить флаг для перехода к main app
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const BankingAppHome()),
          );
        },
      );
    }

    // Fallback
    return const SizedBox.shrink();
  }
}

class BankingAppHome extends StatelessWidget {
  const BankingAppHome({super.key});

  @override
  Widget build(BuildContext context) {
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
}