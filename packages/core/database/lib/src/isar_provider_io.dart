import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'schema/experiment.dart';
import 'schema/log_entry.dart';
import 'schema/measurement_point.dart';
import 'schema/measurement_series.dart';

const String _isarName = 'qorlab';

/// Provider for the Isar database instance.
final isarProvider = FutureProvider<Isar>((ref) async {
  // On iOS 26 + some Flutter toolchains, `path_provider_foundation` currently
  // relies on native-assets (`objective_c.framework`). If those native assets
  // fail to embed in debug builds, this call can throw and would block the app
  // from booting. We fall back to `Directory.systemTemp` in debug so the app
  // can still run in Simulator.
  Directory docsDir;
  try {
    docsDir = await getApplicationDocumentsDirectory();
  } catch (e, st) {
    if (!kDebugMode) rethrow;
    debugPrint('path_provider failed ($e). Falling back to systemTemp for Isar.');
    debugPrintStack(stackTrace: st);
    docsDir = Directory.systemTemp;
  }
  final isarDir = Directory('${docsDir.path}/isar');
  await isarDir.create(recursive: true);

  Future<Isar> open() {
    return Isar.open(
      [
        ExperimentSchema,
        LogEntrySchema,
        MeasurementSeriesSchema,
        MeasurementPointSchema,
      ],
      directory: isarDir.path,
      name: _isarName,
      inspector: kDebugMode,
    );
  }

  final existing = Isar.getInstance(_isarName);
  if (existing != null) return existing;

  try {
    return await open();
  } catch (e, st) {
    if (!kDebugMode) rethrow;

    debugPrint('Isar open failed ($e). Wiping local db and retrying...');
    debugPrintStack(stackTrace: st);

    try {
      // Best-effort: close any half-open instance.
      await Isar.getInstance(_isarName)?.close(deleteFromDisk: true);
    } catch (_) {}

    // Delete both the new location and legacy default db if present.
    try {
      if (await isarDir.exists()) {
        await isarDir.delete(recursive: true);
      }
    } catch (_) {}

    try {
      final legacy = File('${docsDir.path}/default.isar');
      final legacyLock = File('${docsDir.path}/default.isar.lock');
      if (await legacy.exists()) await legacy.delete();
      if (await legacyLock.exists()) await legacyLock.delete();
    } catch (_) {}

    await isarDir.create(recursive: true);
    return await open();
  }
});
