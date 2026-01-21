import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'src/schema/experiment.dart';
import 'src/schema/log_entry.dart';

export 'src/schema/experiment.dart';
export 'src/schema/log_entry.dart';

import 'package:flutter/foundation.dart';

/// Provider for the Isar database instance.
final isarProvider = FutureProvider<Isar>((ref) async {
  if (kIsWeb) {
    throw UnimplementedError("Isar is disabled on web. Use FakeRepository.");
  }

  final dir = await getApplicationDocumentsDirectory();
  
  if (Isar.instanceNames.isEmpty) {
    return Isar.open(
      [ExperimentSchema, LogEntrySchema],
      directory: dir.path,
    );
  }
  
  return Isar.getInstance()!;
});

