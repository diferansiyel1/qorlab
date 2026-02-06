import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

/// Isar is not supported on web. The mobile app should override repositories on web.
final isarProvider = FutureProvider<Isar>((ref) async {
  throw UnsupportedError('Isar is not supported on web.');
});
