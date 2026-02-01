import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'src/schema/experiment.dart';
import 'src/schema/log_entry.dart';

export 'src/experiment_repository_interface.dart';
// export 'src/experiment_repository.dart'; // Removed: File does not exist

export 'src/schema/log_entry.dart';
export 'src/schema/experiment.dart';

import 'package:flutter/foundation.dart';

/// Provider for the Isar database instance.
final isarProvider = FutureProvider<Isar>((ref) async {
  String? path;
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    path = dir.path;
  }

  if (Isar.instanceNames.isEmpty) {
    return Isar.open(
      [ExperimentSchema, LogEntrySchema],
      directory: path ?? '',
      inspector: !kIsWeb, // Inspector not supported on web in some versions or usually disabled for perf
    );
  }
  
  return Isar.getInstance()!;
});

