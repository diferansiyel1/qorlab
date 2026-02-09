import 'dart:typed_data';

import 'ql_archive_format.dart';

class QlBundleFile {
  final String name;
  final Uint8List bytes;

  const QlBundleFile({
    required this.name,
    required this.bytes,
  });
}

/// Plaintext bundle that gets encrypted into a `.ql` archive.
class QlArchiveBundle {
  final List<QlBundleFile> files;

  const QlArchiveBundle({required this.files});

  Uint8List encode() {
    final w = BytesWriter();
    w.bytes(QlFormat.ascii4(QlFormat.bundleMagic));
    w.u32(files.length);
    for (final f in files) {
      w.utf8String(f.name);
      w.u64(f.bytes.length);
      w.bytes(f.bytes);
    }
    return w.finish();
  }

  static QlArchiveBundle decode(Uint8List bytes) {
    final r = BytesReader(bytes);
    final magic = String.fromCharCodes(r.readBytes(4));
    if (magic != QlFormat.bundleMagic) {
      throw StateError('Invalid bundle magic: $magic');
    }
    final count = r.readU32();
    final files = <QlBundleFile>[];
    for (int i = 0; i < count; i++) {
      final name = r.readUtf8String();
      final len = r.readU64();
      final content = r.readBytes(len);
      files.add(QlBundleFile(name: name, bytes: content));
    }
    if (r.remaining != 0) {
      throw StateError('Trailing bytes in bundle: ${r.remaining}');
    }
    return QlArchiveBundle(files: files);
  }
}

