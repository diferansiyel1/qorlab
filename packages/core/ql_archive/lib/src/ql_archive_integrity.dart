import 'dart:typed_data';

import 'ql_archive_bundle.dart';
import 'ql_archive_crypto.dart';

/// Integrity utilities for canonical `.ql` bundle content.
class QlArchiveIntegrity {
  /// Builds a deterministic `checksums.txt` content from [files].
  ///
  /// Output format per line:
  /// `<sha256_hex><two spaces><file_name>`
  static Future<String> buildChecksumsTxt(List<QlBundleFile> files) async {
    final sorted = [...files]..sort((a, b) => a.name.compareTo(b.name));
    final buffer = StringBuffer();
    for (final file in sorted) {
      final hash = await QlArchiveCrypto.sha256Hex(file.bytes);
      buffer.writeln('$hash  ${file.name}');
    }
    return buffer.toString();
  }

  /// Verifies checksums listed in [checksumsFileName] against [bundle] files.
  ///
  /// Throws [StateError] when:
  /// - checksums file is missing
  /// - an entry is malformed
  /// - a referenced file is missing
  /// - the computed hash does not match
  static Future<void> verifyChecksumsTxt({
    required QlArchiveBundle bundle,
    String checksumsFileName = 'checksums.txt',
  }) async {
    final checksumsFile = _findFile(bundle, checksumsFileName);
    final content = String.fromCharCodes(checksumsFile.bytes);
    final byName = <String, QlBundleFile>{
      for (final file in bundle.files) file.name: file,
    };
    final seenNames = <String>{};

    final lines = content.split('\n');
    for (var index = 0; index < lines.length; index++) {
      final rawLine = lines[index].trim();
      if (rawLine.isEmpty || rawLine.startsWith('#')) continue;

      final parts = rawLine.split(RegExp(r'\s{2,}'));
      if (parts.length != 2) {
        throw StateError('Malformed checksum line ${index + 1}: "$rawLine"');
      }
      final expectedHash = parts[0].toLowerCase();
      final fileName = parts[1];
      if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(expectedHash)) {
        throw StateError(
          'Invalid checksum hash at line ${index + 1}: "$expectedHash"',
        );
      }
      if (!seenNames.add(fileName)) {
        throw StateError('Duplicate checksum entry: $fileName');
      }

      final file = byName[fileName];
      if (file == null) {
        throw StateError('Checksum references missing file: $fileName');
      }
      final actualHash = await QlArchiveCrypto.sha256Hex(
        Uint8List.fromList(file.bytes),
      );
      if (actualHash != expectedHash) {
        throw StateError('Checksum mismatch for file: $fileName');
      }
    }
  }

  static QlBundleFile _findFile(QlArchiveBundle bundle, String name) {
    for (final file in bundle.files) {
      if (file.name == name) return file;
    }
    throw StateError('Missing required file: $name');
  }
}
