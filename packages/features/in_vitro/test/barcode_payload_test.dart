import 'package:flutter_test/flutter_test.dart';
import 'package:in_vitro/src/domain/barcode_payload.dart';

void main() {
  test('parses CID payload from QR-like content', () {
    final parsed = BarcodePayloadParser.parse(
      raw: 'cid=2244;name=Caffeine',
      formatHint: 'qrCode',
    );

    expect(parsed.cid, equals(2244));
    expect(parsed.format, equals(BottleBarcodeFormat.qr));
    expect(parsed.query, equals('Caffeine'));
  });

  test('parses CAS and query fallback', () {
    final parsed = BarcodePayloadParser.parse(
      raw: 'CAS 58-08-2',
      formatHint: 'code128',
    );

    expect(parsed.casNumber, equals('58-08-2'));
    expect(parsed.format, equals(BottleBarcodeFormat.code128));
  });

  test('recognizes ean/upc digit-only barcode', () {
    final parsed = BarcodePayloadParser.parse(raw: '1234567890123');

    expect(parsed.format, equals(BottleBarcodeFormat.eanUpc));
    expect(parsed.normalized, equals('1234567890123'));
  });
}
