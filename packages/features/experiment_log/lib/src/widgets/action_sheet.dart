import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ui_kit/ui_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ActionSheet extends ConsumerWidget {
  final int experimentId;
  
  const ActionSheet({super.key, required this.experimentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Validate experimentId in debug mode
    assert(experimentId > 0, 'experimentId must be a positive integer');
    
    return _ActionSheetContent(experimentId: experimentId); 
  }
}

class _ActionSheetContent extends ConsumerWidget {
  final int experimentId;
  const _ActionSheetContent({required this.experimentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final repository = ref.watch(experimentRepositoryProvider);

     return Container(
      decoration: BoxDecoration(
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
                onTap: () async {
                   context.pop();
                   await _capturePhoto(context, repository);
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
              _ActionButton(
                icon: Icons.thermostat_rounded,
                label: 'Parameter',
                color: AppColors.alert,
                 onTap: () {
                    context.pop(); 
                    _showParameterDialog(context, repository);
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
              style: TextStyle(color: AppColors.textMain),
              decoration: InputDecoration(hintText: "Enter observation...", hintStyle: TextStyle(color: AppColors.textMuted)),
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

  void _showParameterDialog(BuildContext context, dynamic repo) {
     showDialog(context: context, builder: (context) {
        String selectedParameter = 'Temperature';
        final valueController = TextEditingController();
        final units = {
          'Temperature': '°C',
          'pH': '',
          'Weight': 'g',
          'Glucose': 'mg/dL',
        };
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
               backgroundColor: AppColors.surface,
               title: Text("Log Parameter", style: AppTypography.headlineMedium),
               content: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   DropdownButtonFormField<String>(
                     value: selectedParameter,
                     dropdownColor: AppColors.surface,
                     style: TextStyle(color: AppColors.textMain),
                     decoration: InputDecoration(
                       labelText: 'Parameter Type',
                       labelStyle: TextStyle(color: AppColors.textMuted),
                     ),
                     items: ['Temperature', 'pH', 'Weight', 'Glucose']
                         .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                         .toList(),
                     onChanged: (value) {
                       setState(() => selectedParameter = value!);
                     },
                   ),
                   const SizedBox(height: 16),
                   TextField(
                     controller: valueController,
                     keyboardType: const TextInputType.numberWithOptions(decimal: true),
                     style: TextStyle(color: AppColors.textMain),
                     decoration: InputDecoration(
                       hintText: "Enter value...",
                       hintStyle: TextStyle(color: AppColors.textMuted),
                       suffixText: units[selectedParameter],
                       suffixStyle: TextStyle(color: AppColors.textMuted),
                     ),
                   ),
                 ],
               ),
               actions: [
                  TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
                  TextButton(child: const Text("Save"), onPressed: () {
                     if (valueController.text.isNotEmpty) {
                        final unit = units[selectedParameter] ?? '';
                        final content = '$selectedParameter: ${valueController.text} $unit'.trim();
                        repo.addLog(experimentId, content, "parameter");
                     }
                     Navigator.pop(context);
                  }),
               ],
            );
          },
        );
     });
  }
  Future<void> _capturePhoto(BuildContext context, dynamic repository) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      
      if (pickedFile != null) {
        // Get the app's documents directory
        final appDir = await getApplicationDocumentsDirectory();
        final experimentDir = Directory('${appDir.path}/experiments/$experimentId');
        
        // Create directory if it doesn't exist
        if (!await experimentDir.exists()) {
          await experimentDir.create(recursive: true);
        }
        
        // Copy image to permanent location
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = '$timestamp.jpg';
        final savedPath = '${experimentDir.path}/$fileName';
        
        await File(pickedFile.path).copy(savedPath);
        
        // Log the photo with its path
        repository.addLog(experimentId, savedPath, "photo");
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Photo captured and saved")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to capture photo: $e")),
        );
      }
    }
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
