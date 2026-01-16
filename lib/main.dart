import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
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
              currentScreen = const CardsScreen(); // Оформить
              break;
            default:
              currentScreen = const DashboardScreen();
          }

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
            home: currentScreen,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}