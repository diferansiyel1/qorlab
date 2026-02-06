import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Central theme mode controller for QorLab.
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.light;
});
