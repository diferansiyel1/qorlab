import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';

import '../application/wake_word_service.dart';

/// Persistent overlay that indicates wake word listening state.
///
/// Shows different UIs based on the current [WakeWordPhase]:
/// - [disabled] / [paused]: hidden
/// - [idle]: small pulsing mic pill at top-right
/// - [activated]: expanded glassmorphism card with real-time transcription
/// - [processing]: brief "saving…" indicator
/// - [error]: brief error flash then auto-recover
class WakeWordOverlay extends ConsumerWidget {
  const WakeWordOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wakeWordServiceProvider);

    return switch (state.phase) {
      WakeWordPhase.disabled || WakeWordPhase.paused => const SizedBox.shrink(),
      WakeWordPhase.idle => const _IdlePill(),
      WakeWordPhase.activated => _ActivatedCard(state: state),
      WakeWordPhase.processing => const _ProcessingIndicator(),
      WakeWordPhase.error => _ErrorIndicator(message: state.errorMessage),
    };
  }
}

// ---------------------------------------------------------------------------
// Idle pill — small pulsing mic indicator
// ---------------------------------------------------------------------------

class _IdlePill extends StatefulWidget {
  const _IdlePill();

  @override
  State<_IdlePill> createState() => _IdlePillState();
}

class _IdlePillState extends State<_IdlePill>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final safeTop = MediaQuery.of(context).padding.top;

    return Positioned(
      top: safeTop + 8,
      right: 16,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final opacity = 0.6 + _pulse.value * 0.4;
          return Opacity(opacity: opacity, child: child);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.cyanAccent.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mic_rounded,
                    color: Colors.cyanAccent,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.wakeWordTitle,
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 11,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Activated card — expanded recording overlay
// ---------------------------------------------------------------------------

class _ActivatedCard extends StatelessWidget {
  final WakeWordState state;

  const _ActivatedCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final safeTop = MediaQuery.of(context).padding.top;

    return Positioned(
      top: safeTop + 8,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.redAccent.withValues(alpha: 0.6),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    _PulsingDot(),
                    const SizedBox(width: 8),
                    Text(
                      'HEY QORLAB',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const Spacer(),
                    // Manual cancel button as fallback
                    Consumer(
                      builder: (context, ref, _) {
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(wakeWordServiceProvider.notifier)
                                .disable();
                            ref
                                .read(wakeWordServiceProvider.notifier)
                                .enable();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.4),
                              ),
                            ),
                            child: const Text(
                              'X',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Transcribed text
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    minHeight: 60,
                    maxHeight: 120,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      state.transcribedText.isNotEmpty
                          ? state.transcribedText
                          : l10n.voiceRecorderListening,
                      style: TextStyle(
                        color: state.transcribedText.isNotEmpty
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        fontSize: 16,
                        height: 1.4,
                        fontStyle: state.transcribedText.isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Hint
                Text(
                  l10n.wakeWordSaySave,
                  style: TextStyle(
                    color: Colors.cyanAccent.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontFamily: 'Courier',
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Processing indicator
// ---------------------------------------------------------------------------

class _ProcessingIndicator extends StatelessWidget {
  const _ProcessingIndicator();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final safeTop = MediaQuery.of(context).padding.top;

    return Positioned(
      top: safeTop + 8,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.greenAccent.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.greenAccent,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.wakeWordSaving,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 11,
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error indicator
// ---------------------------------------------------------------------------

class _ErrorIndicator extends StatelessWidget {
  final String? message;
  const _ErrorIndicator({this.message});

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;

    return Positioned(
      top: safeTop + 8,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.redAccent.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.redAccent, size: 14),
                const SizedBox(width: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Text(
                    message ?? 'Error',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 11,
                      fontFamily: 'Courier',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pulsing dot animation for activated state
// ---------------------------------------------------------------------------

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent.withValues(
              alpha: 0.5 + _controller.value * 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(
                  alpha: _controller.value * 0.5,
                ),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
