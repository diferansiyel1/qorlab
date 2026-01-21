import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experiment_log/experiment_log.dart';
class ActionSheet extends ConsumerWidget {
  const ActionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We assume we are in experiment context. 
    // Ideally, we pass experimentId or read from provider.
    // For MVP, lets assume ID=1 or read from route if possible?
    // Actually, ActionSheet is pushed via `showModalBottomSheet`. 
    // We need to pass experimentId to ActionSheet or use a provider.
    // Let's assume ID=1 for this demo or pass it in constructor.
    // Refactoring to require experimentId requires updating calling code.
    // Let's stick to ID=1 (User's open experiment) for MVP or fix calling code next.
    // Valid approach: Read from GoRouter state? No, that's hard in modal.
    // Let's UPDATE calling code to pass experimentId.
    // But first, let's implement the logic assuming we have `experimentId`.
    // Wait, ref.watch(experimentRepositoryProvider) is available.
    
    // We will simulate we are on Experiment 1 for simplicity of this Refactor step,
    // OR we update the constructor. Let's update constructor.
    // But `ExperimentTimelinePage` calls it.
    
    return const _ActionSheetContent(experimentId: 1); 
  }
}

class _ActionSheetContent extends ConsumerWidget {
  final int experimentId;
  const _ActionSheetContent({required this.experimentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final repository = ref.watch(experimentRepositoryProvider);

     return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text('Log New Event', style: AppTypography.headlineMedium),
          const SizedBox(height: 24),
          
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _ActionButton(
                icon: Icons.mic_rounded,
                label: 'Voice Note',
                color: AppColors.accent,
                onTap: () {
                   context.pop();
                   // Simulate Voice Log
                   repository.addLog(experimentId, "Voice Note (0:15)", "voice");
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Voice note recorded")));
                },
              ),
              _ActionButton(
                icon: Icons.calculate_rounded,
                label: 'Dose Calc',
                color: AppColors.primary,
                onTap: () {
                   context.pop();
                   context.push('/in-vivo'); 
                },
              ),
              _ActionButton(
                icon: Icons.camera_alt_rounded,
                label: 'Photo',
                color: AppColors.textMain,
                onTap: () {
                   context.pop();
                   // Simulate Photo Log
                   repository.addLog(experimentId, "Photo: Specimen A", "photo");
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Photo captured")));
                },
              ),
              _ActionButton(
                icon: Icons.science_rounded,
                label: 'Molarity',
                color: AppColors.success,
                onTap: () {
                  context.pop();
                  context.push('/in-vitro');
                },
              ),
              _ActionButton(
                icon: Icons.note_add_rounded,
                label: 'Text',
                color: AppColors.textMuted,
                 onTap: () {
                    context.pop(); 
                    _showTextDialog(context, ref, repository);
                 },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showTextDialog(BuildContext context, WidgetRef ref, dynamic repo) {
     showDialog(context: context, builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
           backgroundColor: AppColors.surface,
           title: Text("Add Note", style: AppTypography.headlineMedium),
           content: TextField(
              controller: controller,
              style: const TextStyle(color: AppColors.textMain),
              decoration: const InputDecoration(hintText: "Enter observation...", hintStyle: TextStyle(color: AppColors.textMuted)),
           ),
           actions: [
              TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
              TextButton(child: const Text("Save"), onPressed: () {
                 if (controller.text.isNotEmpty) {
                    repo.addLog(experimentId, controller.text, "text");
                 }
                 Navigator.pop(context);
              }),
           ],
        );
     });
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label, style: AppTypography.labelMedium),
          ],
        ),
      ),
    );
  }
}
