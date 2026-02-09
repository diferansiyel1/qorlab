import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanResult {
  const BarcodeScanResult({
    required this.rawValue,
    required this.format,
  });

  final String rawValue;
  final String format;
}

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.inventoryScanBarcode)),
      body: MobileScanner(
        onDetect: (capture) {
          if (_handled) return;
          for (final barcode in capture.barcodes) {
            final rawValue = barcode.rawValue?.trim();
            if (rawValue == null || rawValue.isEmpty) {
              continue;
            }
            _handled = true;
            Navigator.of(context).pop(
              BarcodeScanResult(
                rawValue: rawValue,
                format: barcode.format.name,
              ),
            );
            return;
          }
        },
      ),
    );
  }
}
