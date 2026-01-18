import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  String _currentPin = '';
  String _newPin = '';
  String _confirmPin = '';
  int _step = 0; // 0 - текущий PIN, 1 - новый PIN, 2 - подтверждение
  String? _errorMessage;

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _onPinChanged(String value, int step) {
    setState(() {
      _errorMessage = null;
      switch (step) {
        case 0:
          _currentPin = value;
          break;
        case 1:
          _newPin = value;
          break;
        case 2:
          _confirmPin = value;
          break;
      }
    });
  }

  void _onPinCompleted(String value, int step) async {
    final appState = context.read<AppState>();

    switch (step) {
      case 0: // Проверка текущего PIN
        if (appState.verifyPinCode(value)) {
          setState(() {
            _step = 1;
            _currentPin = '';
            _currentPinController.clear();
          });
        } else {
          setState(() {
            _errorMessage = 'Неверный текущий PIN-код';
            _currentPin = '';
            _currentPinController.clear();
          });
        }
        break;

      case 1: // Ввод нового PIN
        setState(() {
          _newPin = value;
          _step = 2;
          _newPinController.clear();
        });
        break;

      case 2: // Подтверждение нового PIN
        if (value == _newPin) {
          await appState.changePinCode(value);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PIN-код успешно изменен')),
            );
            Navigator.of(context).pop();
          }
        } else {
          setState(() {
            _errorMessage = 'PIN-коды не совпадают. Попробуйте снова.';
            _confirmPin = '';
            _confirmPinController.clear();
            _step = 1; // Возвращаемся к вводу нового PIN
            _newPin = '';
            _newPinController.clear();
          });
        }
        break;
    }
  }

  Widget _buildPinInput({
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required int step,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        PinCodeTextField(
          appContext: context,
          length: 4,
          controller: controller,
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
          onChanged: (value) => _onPinChanged(value, step),
          onCompleted: (value) => _onPinCompleted(value, step),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Изменить PIN-код'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Иконка замка
              Icon(
                Icons.lock_reset,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 32),

              // PIN поля в зависимости от шага
              Expanded(
                child: _step == 0
                    ? _buildPinInput(
                        title: 'Введите текущий PIN-код',
                        subtitle: 'Для подтверждения личности',
                        controller: _currentPinController,
                        step: 0,
                      )
                    : _step == 1
                        ? _buildPinInput(
                            title: 'Введите новый PIN-код',
                            subtitle: 'Придумайте новый 4-значный код',
                            controller: _newPinController,
                            step: 1,
                          )
                        : _buildPinInput(
                            title: 'Подтвердите новый PIN-код',
                            subtitle: 'Повторите новый PIN-код',
                            controller: _confirmPinController,
                            step: 2,
                          ),
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
            ],
          ),
        ),
      ),
    );
  }
}
