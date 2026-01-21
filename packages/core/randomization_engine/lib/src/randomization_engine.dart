import 'dart:math';

enum RandomizationMethod {
  simple, // Coin toss (unequal groups possible)
  block,  // Guarantees balance (e.g. AABB, ABAB)
}

class RandomizationGroup {
  final String id;
  final String name;
  final int targetSize; // For simple constrained or verification

  const RandomizationGroup({required this.id, required this.name, this.targetSize = 0});
}

class RandomizationEngine {
  final _random = Random();

  /// Generates a randomized list of group assignments for [totalSubjects].
  /// 
  /// [groups]: List of available groups (e.g. "Control", "Treatment").
  /// [method]: Block is recommended for small N.
  /// 
  /// Returns a map of Subject Index (1-based) -> Group.
  Map<int, RandomizationGroup> randomize({
    required int totalSubjects,
    required List<RandomizationGroup> groups,
    RandomizationMethod method = RandomizationMethod.block,
  }) {
    if (groups.isEmpty) throw ArgumentError("Must provide at least one group.");
    
    if (method == RandomizationMethod.simple) {
      return _simpleRandomization(totalSubjects, groups);
    } else {
      return _blockRandomization(totalSubjects, groups);
    }
  }

  Map<int, RandomizationGroup> _simpleRandomization(int n, List<RandomizationGroup> groups) {
    final result = <int, RandomizationGroup>{};
    for (int i = 1; i <= n; i++) {
      result[i] = groups[_random.nextInt(groups.length)];
    }
    return result;
  }

  Map<int, RandomizationGroup> _blockRandomization(int n, List<RandomizationGroup> groups) {
    // Block size must be a multiple of group count.
    // For simplicity, we use the smallest block size = number of groups.
    // E.g. Groups A, B -> Block [A, B] shuffled.
    
    // We need enough blocks to cover n.
    // If n is not divisible by group count, the last block will be partial (or we error).
    // In clinical trials, we usually overallocate. Here we'll truncate.
    
    final blockSize = groups.length; 
    final assignments = <RandomizationGroup>[];
    
    while (assignments.length < n) {
      // Create a balanced block
      final block = List<RandomizationGroup>.from(groups);
      block.shuffle(_random);
      assignments.addAll(block);
    }
    
    // Assign to subjects
    final result = <int, RandomizationGroup>{};
    for (int i = 0; i < n; i++) {
        result[i + 1] = assignments[i];
    }
    
    return result;
  }
}
