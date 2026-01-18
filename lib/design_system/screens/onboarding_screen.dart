import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../foundation/colors.dart';
import '../foundation/tokens.dart';
import '../components/buttons.dart';
import '../components/inputs.dart';
import '../utils/assets_constants.dart';
import '../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animationController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Сохраняем данные пользователя
      final prefs = await SharedPreferences.getInstance();
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      await prefs.setString('user_password', password);
      await prefs.setBool('onboarding_completed', true);

      print('DEBUG: Saved user data - name: $name, email: $email');

      // Переходим на главный экран
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)?.dataSaveError ?? 'Ошибка сохранения данных'}: $e'),
          backgroundColor: BankingColors.error500,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Пожалуйста, введите имя';
    }
    if (value.trim().length < 2) {
      return 'Имя должно содержать минимум 2 символа';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Пожалуйста, введите email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Введите корректный email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Пожалуйста, введите пароль';
    }
    if (value.length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? BankingColors.primary900 : BankingColors.primary50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(BankingTokens.space24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Анимация приветствия
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.asset(
                    LottieAssets.hello,
                    controller: _animationController,
                    onLoaded: (composition) {
                      _animationController
                        ..duration = composition.duration
                        ..forward();

                      // Вешаем слушатель прогресса
                      _animationController.addListener(() {
                        // За 0.5 секунды до конца фиксируем анимацию
                        if (_animationController.value >=
                            (_animationController.duration!.inMilliseconds - 100) /
                                _animationController.duration!.inMilliseconds) {
                          _animationController.stop(canceled: false);
                        }
                      });
                    },
                  ),
                ),

                const SizedBox(height: BankingTokens.space32),

                // Заголовок
                Text(
                  'Добро пожаловать!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? BankingColors.neutral50 : BankingColors.neutral900,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: BankingTokens.space16),

                // Подзаголовок
                Text(
                  'Заполните информацию для продолжения',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark ? BankingColors.neutral300 : BankingColors.neutral600,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: BankingTokens.space48),

                // Поле имени
                BankingInputs.text(
                  controller: _nameController,
                  label: 'Имя',
                  hint: 'Введите ваше имя',
                  validator: _validateName,
                  prefixIcon: Icon(Icons.person, color: BankingColors.primary500),
                ),

                const SizedBox(height: BankingTokens.space24),

                // Поле email
                BankingInputs.text(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Введите ваш email',
                  validator: _validateEmail,
                  prefixIcon: Icon(Icons.email, color: BankingColors.primary500),
                ),

                const SizedBox(height: BankingTokens.space24),

                // Поле пароля
                BankingInputs.password(
                  controller: _passwordController,
                  label: 'Пароль',
                  hint: 'Введите пароль (минимум 6 символов)',
                  validator: _validatePassword,
                ),

                const SizedBox(height: BankingTokens.space48),

                // Кнопка продолжения
                BankingButtons.primary(
                  text: 'Продолжить',
                  onPressed: _isLoading ? null : _completeOnboarding,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: BankingTokens.space24),

                // Уведомление о безопасности
                Container(
                  padding: const EdgeInsets.all(BankingTokens.space16),
                  decoration: BoxDecoration(
                    color: isDark ? BankingColors.neutral800 : BankingColors.neutral100,
                    borderRadius: BorderRadius.circular(BankingTokens.borderRadiusMedium),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: BankingColors.primary500,
                        size: BankingTokens.iconSizeSmall,
                      ),
                      const SizedBox(width: BankingTokens.space12),
                      Expanded(
                        child: Text(
                          'Ваши данные защищены и используются только для персонализации приложения',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark ? BankingColors.neutral300 : BankingColors.neutral600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
