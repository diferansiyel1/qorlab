import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:localization/localization.dart';

import '../application/wake_word_service.dart';
import '../application/wake_word_enabled_provider.dart';

/// Persistent overlay that reflects the wake-word state machine.
///
/// | Phase        | Visual                                             |
/// |--------------|----------------------------------------------------|
/// | `disabled`   | nothing                                            |
/// | `paused`     | nothing                                            |
/// | `idle`       | small pulsing mic pill (top-right)                  |
/// | `activated`  | expanding glassmorphism card with live text         |
/// | `processing` | brief "Saving…" indicator                          |
/// | `error`      | hidden (auto-recovers)                             |
class WakeWordOverlay extends ConsumerStatefulWidget {
  const WakeWordOverlay({super.key});

  @override
  ConsumerState<WakeWordOverlay> createState() => _WakeWordOverlayState();
}

class _WakeWordOverlayState extends ConsumerState<WakeWordOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(wakeWordEnabledProvider);
    final service = ref.watch(wakeWordServiceProvider);
    final wakeState = service.state;

    // Auto-enable / disable the service when the provider changes.
    ref.listen<bool>(wakeWordEnabledProvider, (prev, next) {
      if (next && service.state.phase == WakeWordPhase.disabled) {
        service.enable();
      } else if (!next && service.state.phase != WakeWordPhase.disabled) {
        service.disable();
      }
    });

    if (!enabled ||
        wakeState.phase == WakeWordPhase.disabled ||
        wakeState.phase == WakeWordPhase.paused ||
        wakeState.phase == WakeWordPhase.error) {
      return const SizedBox.shrink();
    }

    return switch (wakeState.phase) {
      WakeWordPhase.idle => _buildIdlePill(wakeState),
      WakeWordPhase.activated => _buildActivatedCard(wakeState),
      WakeWordPhase.processing => _buildProcessingIndicator(),
      _ => const SizedBox.shrink(),
    };
  }

  // ─── Idle: pulsing mic pill ──────────────────────────────

  Widget _buildIdlePill(WakeWordState wakeState) {
    final topInset = MediaQuery.of(context).viewPadding.top + 6;
    final lastHeard = wakeState.lastHeardText.trim();
    final showHeard = lastHeard.isNotEmpty;
    final isHearing = wakeState.soundLevelDb > -45;
    final micColor = wakeState.isListening ? Colors.cyanAccent : Colors.orange;
    return Positioned(
      top: topInset,
      right: 16,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final scale = 1.0 + (_pulseController.value * 0.08);
          final glowAlpha = (0.25 + _pulseController.value * 0.35);
          return Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: micColor.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: micColor.withValues(
                      alpha: isHearing ? glowAlpha + 0.15 : glowAlpha,
                    ),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.mic_rounded, color: micColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Hey Qorlab',
                        style: AppTypography.labelSmall.copyWith(
                          color: micColor.withValues(alpha: 0.9),
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  if (showHeard) ...[
                    const SizedBox(height: 2),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 180),
                      child: Text(
                        lastHeard,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Activated: glassmorphism card ───────────────────────

  Widget _buildActivatedCard(WakeWordState wakeState) {
    final topInset = MediaQuery.of(context).viewPadding.top + 6;
    final l10n = AppLocalizations.of(context);
    return Positioned(
      top: topInset,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.cyanAccent.withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    _PulsingDot(),
                    const SizedBox(width: 8),
                    Text(
                      l10n?.wakeWordActivated ?? 'Recording...',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.cyanAccent,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.mic_rounded, color: Colors.redAccent, size: 20),
                  ],
                ),
                const SizedBox(height: 12),

                // Live text
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    minHeight: 48,
                    maxHeight: 120,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.5),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      wakeState.noteText.isEmpty ? '...' : wakeState.noteText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Hint
                Text(
                  l10n?.wakeWordSaySave ??
                      'Say "kaydet" to save or "iptal" to cancel',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 10),

                // Fallback buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _OverlayButton(
                      label: l10n?.cancel ?? 'Cancel',
                      color: Colors.grey,
                      onTap: () {
                        ref.read(wakeWordServiceProvider).cancelFromButton();
                      },
                    ),
                    const SizedBox(width: 8),
                    _OverlayButton(
                      label: l10n?.save ?? 'Save',
                      color: Colors.greenAccent,
                      onTap: wakeState.noteText.trim().isNotEmpty
                          ? () {
                              ref
                                  .read(wakeWordServiceProvider)
                                  .saveFromButton();
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Processing: saving indicator ────────────────────────

  Widget _buildProcessingIndicator() {
    final topInset = MediaQuery.of(context).viewPadding.top + 6;
    final l10n = AppLocalizations.of(context);
    return Positioned(
      top: topInset,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n?.wakeWordSaved ?? 'Saving...',
              style: AppTypography.labelSmall.copyWith(
                color: Colors.greenAccent,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Helper widgets
// ───────────────────────────────────────────────────────────────

/// Small pulsing red dot indicating active recording.
class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent.withValues(
              alpha: 0.6 + _controller.value * 0.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(
                  alpha: _controller.value * 0.5,
                ),
                blurRadius: 6,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Compact button used inside the activated overlay.
class _OverlayButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _OverlayButton({required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.withValues(alpha: 0.1)
              : color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDisabled
                ? Colors.grey.withValues(alpha: 0.3)
                : color.withValues(alpha: 0.6),
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isDisabled ? Colors.grey : color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
