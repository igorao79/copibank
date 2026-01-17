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
import 'design_system/screens/cards_screen.dart';
import 'design_system/utils/app_state.dart';

void main() {
  runApp(const BankingApp());
}

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: AppLocalizations(const Locale('ru')).appTitle,
            theme: BankingTheme.light,
            darkTheme: BankingTheme.dark,
            themeMode: appState.themeMode,
            locale: const Locale('ru'),
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

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isCompleted = prefs.getBool('onboarding_completed') ?? false;
    setState(() {
      _isOnboardingCompleted = isCompleted;
    });
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

    // Если onboarding завершен, показываем основной экран приложения
    return Consumer<AppState>(
      builder: (context, appState, child) {
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