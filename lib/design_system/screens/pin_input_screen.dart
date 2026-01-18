import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';

class PinInputScreen extends StatefulWidget {
  final bool isSetupMode; // true для установки PIN, false для входа

  const PinInputScreen({
    super.key,
    this.isSetupMode = false,
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

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onPinChanged(String value) {
    setState(() {
      _enteredPin = value;
      _errorMessage = null;
    });
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
            Navigator.of(context).pop(true); // Возвращаем успех
          }
        } else {
          setState(() {
            _errorMessage = 'PIN-коды не совпадают. Попробуйте снова.';
            _enteredPin = '';
            _pinController.clear();
            _isConfirming = false;
          });
        }
      }
    } else {
      // Режим входа - проверяем PIN-код
      if (appState.verifyPinCode(value)) {
        if (mounted) {
          Navigator.of(context).pop(true); // Возвращаем успех
        }
      } else {
        setState(() {
          _errorMessage = 'Неверный PIN-код. Попробуйте снова.';
          _enteredPin = '';
          _pinController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        ? 'Подтвердите PIN-код'
                        : 'Создайте PIN-код')
                    : 'Введите PIN-код',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Подзаголовок
              Text(
                widget.isSetupMode
                    ? (_isConfirming
                        ? 'Повторите введенный PIN-код'
                        : 'Придумайте 4-значный PIN-код для защиты аккаунта')
                    : 'Введите ваш PIN-код для входа',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // PIN код поля
              PinCodeTextField(
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
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.grey[100],
                  selectedFillColor: Colors.white,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.grey[300],
                  selectedColor: Theme.of(context).primaryColor,
                  borderWidth: 2,
                ),
                cursorColor: Theme.of(context).primaryColor,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                onChanged: _onPinChanged,
                onCompleted: _onPinCompleted,
              ),

              // Сообщение об ошибке
              if (_errorMessage != null) ...[
                const SizedBox(height: 24),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 48),

              // Кнопка "Пропустить" только в режиме установки
              if (widget.isSetupMode && !_isConfirming) ...[
                TextButton(
                  onPressed: () async {
                    await context.read<AppState>().setPinCode(''); // Устанавливаем пустой PIN
                    if (mounted) {
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: Text(
                    'Пропустить',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
