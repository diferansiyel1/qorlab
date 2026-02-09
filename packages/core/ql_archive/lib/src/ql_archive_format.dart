import 'dart:convert';
import 'dart:typed_data';

/// Binary encoding helpers for the `.ql` archive format.
///
/// Format is designed to be:
/// - Deterministic
/// - Cross-platform
/// - Independent of Isar internals
///
/// Numbers are little-endian unless otherwise stated.
class QlFormat {
  static const envelopeMagic = 'QLAR'; // QorLab ARchive envelope
  static const bundleMagic = 'QLB1'; // QorLab Bundle v1 (plaintext payload)

  static Uint8List ascii4(String s) {
    final bytes = ascii.encode(s);
    if (bytes.length != 4) {
      throw ArgumentError('Expected 4 ASCII bytes, got ${bytes.length}');
    }
    return Uint8List.fromList(bytes);
  }
}

class BytesWriter {
  final BytesBuilder _builder = BytesBuilder(copy: false);

  void u8(int v) => _builder.add([v & 0xff]);

  void u16(int v) {
    final b = ByteData(2)..setUint16(0, v, Endian.little);
    _builder.add(b.buffer.asUint8List());
  }

  void u32(int v) {
    final b = ByteData(4)..setUint32(0, v, Endian.little);
    _builder.add(b.buffer.asUint8List());
  }

  void u64(int v) {
    final b = ByteData(8)..setUint64(0, v, Endian.little);
    _builder.add(b.buffer.asUint8List());
  }

  void bytes(Uint8List b) => _builder.add(b);

  void utf8String(String s) {
    final b = utf8.encode(s);
    u16(b.length);
    _builder.add(b);
  }

  Uint8List finish() => _builder.toBytes();
}

class BytesReader {
  final Uint8List _bytes;
  int _offset = 0;

  BytesReader(this._bytes);

  int get remaining => _bytes.length - _offset;

  Uint8List readBytes(int length) {
    if (length < 0 || length > remaining) {
      throw StateError('Invalid read length: $length (remaining=$remaining)');
    }
    final out = _bytes.sublist(_offset, _offset + length);
    _offset += length;
    return out;
  }

  int readU8() => readBytes(1)[0];

  int readU16() {
    final b = readBytes(2);
    return ByteData.sublistView(b).getUint16(0, Endian.little);
  }

  int readU32() {
    final b = readBytes(4);
    return ByteData.sublistView(b).getUint32(0, Endian.little);
  }

  int readU64() {
    final b = readBytes(8);
    return ByteData.sublistView(b).getUint64(0, Endian.little);
  }

  String readUtf8String() {
    final len = readU16();
    final b = readBytes(len);
    return utf8.decode(b);
  }
}

