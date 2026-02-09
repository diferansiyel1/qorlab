import 'dart:async';

class PubChemRateLimiter {
  PubChemRateLimiter({
    this.maxRequestsPerSecond = 4,
  }) : assert(maxRequestsPerSecond > 0);

  final int maxRequestsPerSecond;
  final Duration _jitter = const Duration(milliseconds: 20);
  Future<void> _queue = Future<void>.value();
  DateTime _nextAllowedAt = DateTime.fromMillisecondsSinceEpoch(0);

  Future<T> schedule<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    final requestSlot = _queue.then((_) async {
      final now = DateTime.now();
      if (now.isBefore(_nextAllowedAt)) {
        await Future<void>.delayed(_nextAllowedAt.difference(now));
      }

      final interval = Duration(
        milliseconds: (1000 / maxRequestsPerSecond).ceil(),
      );
      _nextAllowedAt = DateTime.now().add(interval + _jitter);

      try {
        final result = await action();
        completer.complete(result);
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });

    _queue = requestSlot.catchError((_) {});
    return completer.future;
  }
}
