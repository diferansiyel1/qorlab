import 'dart:typed_data';

import 'package:ql_archive/ql_archive.dart';
import 'package:test/test.dart';

void main() {
  test('encrypt/decrypt roundtrip', () async {
    final bundle = QlArchiveBundle(
      files: [
        QlBundleFile(
          name: 'manifest.json',
          bytes: Uint8List.fromList([1, 2, 3]),
        ),
        QlBundleFile(
          name: 'experiments.jsonl',
          bytes: Uint8List.fromList([4, 5]),
        ),
      ],
    );
    final enc = await QlArchiveCrypto.encryptBundle(
      password: 'correct horse battery staple',
      bundle: bundle,
    );
    final dec = await QlArchiveCrypto.decryptBundle(
      password: 'correct horse battery staple',
      encryptedArchiveBytes: enc,
    );
    expect(dec.files.length, 2);
    expect(dec.files[0].name, 'manifest.json');
    expect(dec.files[0].bytes, bundle.files[0].bytes);
  });

  test('wrong password fails', () async {
    final bundle = QlArchiveBundle(
      files: [
        QlBundleFile(name: 'a.txt', bytes: Uint8List.fromList([1, 2, 3])),
      ],
    );
    final enc = await QlArchiveCrypto.encryptBundle(
      password: 'pw1',
      bundle: bundle,
    );
    expect(
      () => QlArchiveCrypto.decryptBundle(
        password: 'pw2',
        encryptedArchiveBytes: enc,
      ),
      throwsA(isA<Object>()),
    );
  });

  test('checksums validation passes for untampered bundle', () async {
    final dataFiles = [
      QlBundleFile(
        name: 'experiments.jsonl',
        bytes: Uint8List.fromList([1, 2]),
      ),
      QlBundleFile(
        name: 'log_entries.jsonl',
        bytes: Uint8List.fromList([3, 4]),
      ),
    ];
    final checksums = await QlArchiveIntegrity.buildChecksumsTxt(dataFiles);
    final bundle = QlArchiveBundle(
      files: [
        ...dataFiles,
        QlBundleFile(
          name: 'checksums.txt',
          bytes: Uint8List.fromList(checksums.codeUnits),
        ),
      ],
    );

    await expectLater(
      QlArchiveIntegrity.verifyChecksumsTxt(bundle: bundle),
      completes,
    );
  });

  test('checksums validation fails for tampered file', () async {
    final original = QlBundleFile(
      name: 'measurement_points.jsonl',
      bytes: Uint8List.fromList([9, 8, 7]),
    );
    final checksums = await QlArchiveIntegrity.buildChecksumsTxt([original]);
    final tampered = QlBundleFile(
      name: original.name,
      bytes: Uint8List.fromList([9, 8, 6]),
    );
    final bundle = QlArchiveBundle(
      files: [
        tampered,
        QlBundleFile(
          name: 'checksums.txt',
          bytes: Uint8List.fromList(checksums.codeUnits),
        ),
      ],
    );

    expect(
      () => QlArchiveIntegrity.verifyChecksumsTxt(bundle: bundle),
      throwsA(isA<StateError>()),
    );
  });
}
