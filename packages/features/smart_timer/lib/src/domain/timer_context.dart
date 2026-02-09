import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Optional active experiment context for timer records.
///
/// The app layer can override this provider to bridge experiment context
/// without creating feature-to-feature imports inside this package.
final timerExperimentContextProvider = Provider<int?>((ref) => null);

