enum BottleBarcodeFormat {
  eanUpc,
  code128,
  qr,
  unknown,
}

class BarcodePayload {
  const BarcodePayload({
    required this.raw,
    required this.normalized,
    required this.format,
    required this.cid,
    required this.casNumber,
    required this.query,
  });

  final String raw;
  final String normalized;
  final BottleBarcodeFormat format;
  final int? cid;
  final String? casNumber;
  final String? query;
}

class BarcodePayloadParser {
  static final RegExp _cidPattern = RegExp(
    r'(?:^|[\s;|,])cid[:=\s]+(\d+)|/compound/cid/(\d+)',
    caseSensitive: false,
  );
  static final RegExp _casPattern = RegExp(r'\b\d{2,7}-\d{2}-\d\b');
  static final RegExp _namePattern = RegExp(
    r'(?:name|compound|chemical)[:=\s]+([^;|]+)',
    caseSensitive: false,
  );
  static final RegExp _eanUpcPattern = RegExp(r'^\d{8,14}$');

  static BarcodePayload parse({
    required String raw,
    String? formatHint,
  }) {
    final trimmed = raw.trim();
    final normalized = _normalize(trimmed);
    final decoded = _decodeSafe(trimmed);
    final format =
        _resolveFormat(raw: trimmed, normalized: normalized, hint: formatHint);

    final cidMatch = _cidPattern.firstMatch(decoded);
    final cid = int.tryParse(
      cidMatch?.group(1) ?? cidMatch?.group(2) ?? '',
    );

    final cas = _casPattern.firstMatch(decoded)?.group(0);
    final query = _extractQuery(decoded, cas: cas, cid: cid);

    return BarcodePayload(
      raw: trimmed,
      normalized: normalized,
      format: format,
      cid: cid,
      casNumber: cas,
      query: query,
    );
  }

  static String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');
  }

  static String _decodeSafe(String value) {
    try {
      return Uri.decodeComponent(value);
    } catch (_) {
      return value;
    }
  }

  static BottleBarcodeFormat _resolveFormat({
    required String raw,
    required String normalized,
    required String? hint,
  }) {
    final lowerHint = hint?.toLowerCase() ?? '';
    if (lowerHint.contains('ean') || lowerHint.contains('upc')) {
      return BottleBarcodeFormat.eanUpc;
    }
    if (lowerHint.contains('code128') || lowerHint.contains('code_128')) {
      return BottleBarcodeFormat.code128;
    }
    if (lowerHint.contains('qr')) {
      return BottleBarcodeFormat.qr;
    }

    if (_eanUpcPattern.hasMatch(normalized)) {
      return BottleBarcodeFormat.eanUpc;
    }
    if (raw.contains('://') || raw.contains(';') || raw.contains('|')) {
      return BottleBarcodeFormat.qr;
    }
    if (RegExp(r'^[A-Za-z0-9\-_.:/]+$').hasMatch(raw)) {
      return BottleBarcodeFormat.code128;
    }
    return BottleBarcodeFormat.unknown;
  }

  static String? _extractQuery(
    String decoded, {
    required String? cas,
    required int? cid,
  }) {
    final fromNamed = _namePattern.firstMatch(decoded)?.group(1)?.trim();
    if (fromNamed != null && fromNamed.length >= 2) {
      return fromNamed;
    }

    if (cid != null) {
      return null;
    }

    final plain = decoded.trim();
    if (cas != null && plain.length < 2) {
      return null;
    }
    if (plain.length >= 2 && RegExp(r'[A-Za-z]').hasMatch(plain)) {
      return plain;
    }
    return null;
  }
}

extension BottleBarcodeFormatValue on BottleBarcodeFormat {
  String get storageValue {
    return switch (this) {
      BottleBarcodeFormat.eanUpc => 'ean_upc',
      BottleBarcodeFormat.code128 => 'code128',
      BottleBarcodeFormat.qr => 'qr',
      BottleBarcodeFormat.unknown => 'unknown',
    };
  }
}
