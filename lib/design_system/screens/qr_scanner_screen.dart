import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../foundation/colors.dart';
import '../foundation/tokens.dart';
import '../../l10n/app_localizations.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.scanQR),
        actions: [
          IconButton(
            icon: Icon(
              cameraController.torchEnabled
                  ? Icons.flash_on
                  : Icons.flash_off,
            ),
            onPressed: () => cameraController.toggleTorch(),
            tooltip: 'Toggle flash',
          ),
          IconButton(
            icon: const Icon(Icons.camera_rear),
            onPressed: () => cameraController.switchCamera(),
            tooltip: 'Switch camera',
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  // Обработка отсканированного QR кода
                  _onQrCodeDetected(barcode.rawValue!);
                  break;
                }
              }
            },
          ),
          // Overlay с рамкой для сканирования
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: BankingColors.primary500,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(BankingTokens.radius8),
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: BankingColors.primary500,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
          // Инструкции внизу
          Positioned(
            bottom: BankingTokens.screenHorizontalPadding,
            left: BankingTokens.screenHorizontalPadding,
            right: BankingTokens.screenHorizontalPadding,
            child: Container(
              padding: const EdgeInsets.all(BankingTokens.space16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(BankingTokens.radius12),
              ),
              child: Text(
                localizations.qrScanInstruction,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQrCodeDetected(String qrCode) {
    // Вибрация для обратной связи
    // HapticFeedback.vibrate();

    // Закрываем экран сканера и возвращаем результат
    Navigator.of(context).pop(qrCode);

    // Показываем результат
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('QR код отсканирован: $qrCode'),
        backgroundColor: BankingColors.success500,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
