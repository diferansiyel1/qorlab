import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'voice_recorder_controller.dart';

class VoiceRecorderDialog extends ConsumerStatefulWidget {
  const VoiceRecorderDialog({super.key});

  @override
  ConsumerState<VoiceRecorderDialog> createState() => _VoiceRecorderDialogState();
}

class _VoiceRecorderDialogState extends ConsumerState<VoiceRecorderDialog> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceRecorderProvider);
    final controller = ref.read(voiceRecorderProvider.notifier);

    // Color Palette
    final primaryColor = Colors.cyanAccent;
    final activeColor = Colors.redAccent;
    final backgroundColor = Colors.black.withValues(alpha: 0.7);
    final blurAmount = 10.0;

    return Stack(
      children: [
        // Glassmorphism Background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
          child: Container(color: Colors.transparent),
        ),
        AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: primaryColor.withValues(alpha: 0.3), width: 1)),
          title: Text(
            'LOG ENTRY',
            style: TextStyle(
              color: primaryColor,
              fontFamily: 'Courier', // Monospace for Sci-Fi feel
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ), 
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text Display Area
              Container(
                width: double.maxFinite,
                constraints: const BoxConstraints(minHeight: 150, maxHeight: 250),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: state.isListening ? activeColor : primaryColor.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    if (state.isListening)
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                  ]
                ),
                child: SingleChildScrollView(
                  child: Text(
                    state.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Confidence Meter
              Row(
                children: [
                   Text('SIGNAL CONFIDENCE:', style: TextStyle(color: primaryColor.withValues(alpha: 0.7), fontSize: 10)),
                   const SizedBox(width: 8),
                   Expanded(
                     child: LinearProgressIndicator(
                       value: state.confidence,
                       backgroundColor: Colors.grey.withValues(alpha: 0.2),
                       valueColor: AlwaysStoppedAnimation<Color>(
                         state.confidence > 0.8 ? primaryColor : Colors.orange,
                       ),
                       minHeight: 8,
                       borderRadius: BorderRadius.circular(4),
                     ),
                   ),
                   const SizedBox(width: 8),
                   Text('${(state.confidence * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 10)),
                ],
              ),
              const SizedBox(height: 24),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel Button
                  _LargeButton(
                    onTap: () {
                       // Stop listening before closing
                       controller.stopListening(); 
                       Navigator.of(context).pop();
                    },
                    icon: Icons.close,
                    label: 'ABORT',
                    color: Colors.grey,
                  ),
                  
                  // Record/Stop Button
                  _LargeButton(
                    onTap: controller.toggleListening,
                    icon: state.isListening ? Icons.stop : Icons.mic,
                    label: state.isListening ? 'STOP' : 'REC',
                    color: state.isListening ? activeColor : primaryColor,
                    isPulsing: state.isListening,
                  ),

                  // Save Button
                  _LargeButton(
                    onTap: state.text.isNotEmpty && state.text != 'Press the button to start recording'
                        ? () {
                            controller.stopListening();
                            Navigator.of(context).pop(state.text);
                          }
                        : null,
                    icon: Icons.check,
                    label: 'SAVE',
                    color: Colors.greenAccent,
                  ),
                ],
              ),
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LargeButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final String label;
  final Color color;
  final bool isPulsing;

  const _LargeButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
    this.isPulsing = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.withValues(alpha: 0.1) : color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDisabled ? Colors.grey.withValues(alpha: 0.3) : color,
            width: 2,
          ),
          boxShadow: isPulsing && !isDisabled
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isDisabled ? Colors.grey : color,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isDisabled ? Colors.grey : color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
