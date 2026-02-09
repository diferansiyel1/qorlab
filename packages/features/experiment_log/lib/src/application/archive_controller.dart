import 'dart:typed_data';

import 'package:experiment_log/src/data/ql_archive_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'archive_controller.g.dart';

@Riverpod(keepAlive: true)
class ArchiveController extends _$ArchiveController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  bool get isBusy => state.isLoading;

  Future<QlArchiveExportResult> exportAll({required String password}) async {
    state = const AsyncLoading();
    try {
      final result = await ref
          .read(qlArchiveServiceProvider)
          .exportAll(password: password);
      state = const AsyncData(null);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<QlArchiveExportResult> exportExperiment({
    required int experimentId,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final result = await ref
          .read(qlArchiveServiceProvider)
          .exportExperiment(experimentId: experimentId, password: password);
      state = const AsyncData(null);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<QlArchiveImportResult> importAsCopy({
    required Uint8List qlBytes,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final result = await ref
          .read(qlArchiveServiceProvider)
          .importAsCopy(qlBytes: qlBytes, password: password);
      state = const AsyncData(null);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<QlArchiveImportResult> importReplacingDeviceData({
    required Uint8List qlBytes,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final result = await ref
          .read(qlArchiveServiceProvider)
          .importReplacingDeviceData(qlBytes: qlBytes, password: password);
      state = const AsyncData(null);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
