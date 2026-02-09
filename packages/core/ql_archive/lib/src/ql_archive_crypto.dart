import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'ql_archive_bundle.dart';
import 'ql_archive_format.dart';

class QlCryptoParams {
  final int iterations;
  final Uint8List salt;
  final Uint8List nonce;

  const QlCryptoParams({
    required this.iterations,
    required this.salt,
    required this.nonce,
  });
}

class QlArchiveCrypto {
  static const int envelopeVersion = 1;

  static const int _saltLen = 16;
  static const int _nonceLen = 12;
  static const int _keyBits = 256;

  static final Cipher _cipher = AesGcm.with256bits();
  static final Pbkdf2 _kdf = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 210000,
    bits: _keyBits,
  );

  static Future<QlCryptoParams> defaultParams() async {
    return QlCryptoParams(
      iterations: _kdf.iterations,
      salt: Uint8List.fromList(SecretKeyData.random(length: _saltLen).bytes),
      nonce: Uint8List.fromList(_cipher.newNonce()),
    );
  }

  static Future<Uint8List> encryptBundle({
    required String password,
    required QlArchiveBundle bundle,
    QlCryptoParams? params,
  }) async {
    final p = params ?? await defaultParams();
    final key = await _kdf.deriveKeyFromPassword(
      password: password,
      nonce: p.salt,
    );

    final plaintext = bundle.encode();
    final secretBox = await _cipher.encrypt(
      plaintext,
      secretKey: key,
      nonce: p.nonce,
    );

    final w = BytesWriter();
    w.bytes(QlFormat.ascii4(QlFormat.envelopeMagic));
    w.u8(envelopeVersion);
    w.u8(1); // kdfId: 1 = PBKDF2-HMAC-SHA256
    w.u32(p.iterations);
    w.u16(p.salt.length);
    w.bytes(p.salt);
    final nonce = Uint8List.fromList(secretBox.nonce);
    w.u16(nonce.length);
    w.bytes(nonce);
    w.u16(secretBox.mac.bytes.length);
    w.bytes(Uint8List.fromList(secretBox.mac.bytes));
    w.u64(secretBox.cipherText.length);
    w.bytes(Uint8List.fromList(secretBox.cipherText));
    return w.finish();
  }

  static Future<QlArchiveBundle> decryptBundle({
    required String password,
    required Uint8List encryptedArchiveBytes,
  }) async {
    final r = BytesReader(encryptedArchiveBytes);
    final magic = String.fromCharCodes(r.readBytes(4));
    if (magic != QlFormat.envelopeMagic) {
      throw StateError('Invalid archive magic: $magic');
    }
    final version = r.readU8();
    if (version != envelopeVersion) {
      throw StateError('Unsupported archive version: $version');
    }
    final kdfId = r.readU8();
    if (kdfId != 1) throw StateError('Unsupported kdfId: $kdfId');

    final iterations = r.readU32();
    final saltLen = r.readU16();
    final salt = r.readBytes(saltLen);
    final nonceLen = r.readU16();
    final nonce = r.readBytes(nonceLen);
    final macLen = r.readU16();
    final mac = r.readBytes(macLen);
    final ctLen = r.readU64();
    final ct = r.readBytes(ctLen);
    if (r.remaining != 0) {
      throw StateError('Trailing bytes in archive: ${r.remaining}');
    }

    final kdf = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: _keyBits,
    );
    final key = await kdf.deriveKeyFromPassword(password: password, nonce: salt);

    final box = SecretBox(
      ct,
      nonce: nonce,
      mac: Mac(mac),
    );
    final plain = await _cipher.decrypt(box, secretKey: key);
    return QlArchiveBundle.decode(Uint8List.fromList(plain));
  }

  static Future<String> sha256Hex(Uint8List bytes) async {
    final d = await Sha256().hash(bytes);
    final b = d.bytes;
    final sb = StringBuffer();
    for (final x in b) {
      sb.write(x.toRadixString(16).padLeft(2, '0'));
    }
    return sb.toString();
  }
}
