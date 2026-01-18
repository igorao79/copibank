import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';
import '../foundation/colors.dart';
import '../../l10n/app_localizations.dart';

class PinInputScreen extends StatefulWidget {
  final bool isSetupMode; // true для установки PIN, false для входа
  final VoidCallback? onSuccess;

  const PinInputScreen({
    super.key,
    this.isSetupMode = false,
    this.onSuccess,
  });

  @override
  State<PinInputScreen> createState() => _PinInputScreenState();
}

class _PinInputScreenState extends State<PinInputScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _enteredPin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String? _errorMessage;
  int _failedAttempts = 0;
  bool _isLocked = false;
  int _lockoutTime = 0;

  @override
  void initState() {
    super.initState();
    _startLockoutTimer();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onPinChanged(String value) {
    if (!_isLocked) {
      setState(() {
        _enteredPin = value;
        _errorMessage = null;
      });
    }
  }

  void _startLockoutTimer() {
    if (_lockoutTime > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _lockoutTime--;
          });
          _startLockoutTimer();
        }
      });
    } else {
      setState(() {
        _isLocked = false;
      });
    }
  }

  void _onPinCompleted(String value) async {
    final appState = context.read<AppState>();

    if (widget.isSetupMode) {
      // Режим установки PIN-кода
      if (!_isConfirming) {
        // Первый ввод - сохраняем и переходим к подтверждению
        setState(() {
          _confirmPin = value;
          _isConfirming = true;
          _enteredPin = '';
          _pinController.clear();
        });
      } else {
        // Подтверждение PIN-кода
        if (value == _confirmPin) {
          await appState.setPinCode(value);
          if (mounted) {
            if (widget.onSuccess != null) {
              widget.onSuccess!.call();
            } else {
              Navigator.of(context).pop(true);
            }
          }
        } else {
          setState(() {
            _errorMessage = AppLocalizations.of(context)?.passwordsDontMatch ?? 'PIN-коды не совпадают. Попробуйте снова.';
            _enteredPin = '';
            _pinController.clear();
            _isConfirming = false;
          });
        }
      }
    } else {
      // Режим входа - проверяем PIN-код
      if (_isLocked) {
        return; // Блокировка активна
      }

      if (appState.verifyPinCode(value)) {
        setState(() {
          _errorMessage = null; // Очищаем сообщение об ошибке при успешном вводе
        });
        if (mounted) {
          if (widget.onSuccess != null) {
            widget.onSuccess!.call();
          } else {
            Navigator.of(context).pop(true);
          }
        }
      } else {
        _failedAttempts++;
        if (_failedAttempts >= 3) {
          // Блокировка на 30 секунд после 3 неудачных попыток
          setState(() {
            _isLocked = true;
            _lockoutTime = 30;
            _errorMessage = '${AppLocalizations.of(context)?.tooManyAttempts ?? 'Слишком много неудачных попыток'}. ${AppLocalizations.of(context)?.tryAgainIn ?? 'Повторите через'} 30 ${AppLocalizations.of(context)?.seconds ?? 'сек.'}.';
            _enteredPin = '';
            _pinController.clear();
          });
          _startLockoutTimer();
        } else {
          setState(() {
            _errorMessage = '${AppLocalizations.of(context)?.wrongPin ?? 'Неверный PIN-код'}. ${AppLocalizations.of(context)?.attemptsLeft ?? 'Осталось попыток'}: ${3 - _failedAttempts}';
            _enteredPin = '';
            _pinController.clear();
          });
        }
      }
    }
  }

  void _showForgotPinDialog(BuildContext context) {
    final newPinController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppLocalizations.of(context)?.pinReset ?? 'Сброс PIN-кода'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)?.enterNewPin ?? 'Введите новый 4-значный PIN-код',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              PinCodeTextField(
                appContext: dialogContext,
                length: 4,
                controller: newPinController,
                obscureText: true,
                obscuringCharacter: '•',
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.grey[100],
                  inactiveFillColor: Colors.grey[50],
                  selectedFillColor: Colors.white,
                  activeColor: BankingColors.primary500,
                  inactiveColor: Colors.grey[300],
                  selectedColor: BankingColors.primary500,
                  borderWidth: 1,
                ),
                cursorColor: BankingColors.primary500,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                onChanged: (value) {
                  setState(() => errorMessage = null);
                },
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Отмена'),
            ),
            TextButton(
              onPressed: () async {
                final newPin = newPinController.text;
                if (newPin.length != 4) {
                  setState(() => errorMessage = 'PIN-код должен содержать 4 цифры');
                  return;
                }

                await context.read<AppState>().setPinCode(newPin);
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(true); // Возвращаем успех
              },
              child: Text(AppLocalizations.of(context)?.save ?? 'Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? BankingColors.neutral900 : BankingColors.neutral0,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Иконка замка
              Icon(
                Icons.lock_outline,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 32),

              // Заголовок
              Text(
                widget.isSetupMode
                    ? (_isConfirming
                        ? (AppLocalizations.of(context)?.confirmPin ?? 'Подтвердите PIN-код')
                        : (AppLocalizations.of(context)?.createPin ?? 'Создайте PIN-код'))
                    : (AppLocalizations.of(context)?.enterPin ?? 'Введите PIN-код'),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? BankingColors.neutral0 : BankingColors.neutral900,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Подзаголовок
              Text(
                widget.isSetupMode
                    ? (_isConfirming
                        ? (AppLocalizations.of(context)?.repeatPin ?? 'Повторите введенный PIN-код')
                        : (AppLocalizations.of(context)?.protectAccount ?? 'Придумайте 4-значный PIN-код для защиты аккаунта'))
                    : (AppLocalizations.of(context)?.enterPinToLogin ?? 'Введите ваш PIN-код для входа'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark ? BankingColors.neutral300 : BankingColors.neutral600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // PIN код поля
              AbsorbPointer(
                absorbing: _isLocked,
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _pinController,
                  obscureText: true,
                  obscuringCharacter: '•',
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 60,
                    fieldWidth: 50,
                    activeFillColor: _isLocked
                        ? (isDark ? BankingColors.neutral600 : BankingColors.neutral300)
                        : (isDark ? BankingColors.neutral800 : BankingColors.neutral0),
                    inactiveFillColor: _isLocked
                        ? (isDark ? BankingColors.neutral600 : BankingColors.neutral300)
                        : (isDark ? BankingColors.neutral700 : BankingColors.neutral50),
                    selectedFillColor: _isLocked
                        ? (isDark ? BankingColors.neutral600 : BankingColors.neutral300)
                        : (isDark ? BankingColors.neutral800 : BankingColors.neutral0),
                    activeColor: _isLocked ? BankingColors.neutral400 : BankingColors.primary500,
                    inactiveColor: _isLocked
                        ? BankingColors.neutral500
                        : (isDark ? BankingColors.neutral600 : BankingColors.neutral300),
                    selectedColor: _isLocked ? BankingColors.neutral400 : BankingColors.primary500,
                    borderWidth: 2,
                  ),
                  cursorColor: _isLocked ? BankingColors.neutral400 : Theme.of(context).primaryColor,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onChanged: _onPinChanged,
                  onCompleted: _onPinCompleted,
                ),
              ),

              // Сообщение об ошибке
              if (_errorMessage != null) ...[
                const SizedBox(height: 24),
                Text(
                  _isLocked && _lockoutTime > 0
                      ? '$_errorMessage\n${AppLocalizations.of(context)?.tryAgainIn ?? 'Осталось'}: $_lockoutTime ${AppLocalizations.of(context)?.seconds ?? 'сек.'}.'
                      : _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 24),

              // Кнопка "Забыл PIN-код" только в режиме входа
              if (!widget.isSetupMode) ...[
                TextButton(
                  onPressed: () => _showForgotPinDialog(context),
                  child: Text(
                    AppLocalizations.of(context)?.forgotPin ?? 'Забыл PIN-код',
                    style: TextStyle(
                      color: BankingColors.primary500,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
