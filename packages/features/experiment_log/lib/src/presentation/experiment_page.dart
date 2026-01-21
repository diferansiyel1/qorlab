import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:experiment_log/experiment_log.dart';

import 'package:database/database.dart';

class ExperimentPage extends ConsumerWidget {
  final int experimentId;

  const ExperimentPage({super.key, required this.experimentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(experimentRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Lab Mode')),
      body: Column(
        children: [
          // Stream Area
          Expanded(
            child: StreamBuilder<List<LogEntry>>(
              stream: repository.watchLogs(experimentId),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final logs = snapshot.data!;
                return ListView.builder(
                  itemCount: logs.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.mic, color: AppColors.tealScience),
                        title: Text(log.content),
                        subtitle: Text(log.timestamp.toString()),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // Control Deck
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GloveButton(
                  label: 'PHOTO',
                  icon: Icons.camera_alt,
                  isPrimary: false,
                  onPressed: () {},
                ),
                 GloveButton(
                  label: 'LOG',
                  icon: Icons.mic,
                  backgroundColor: AppColors.deepLabBlue,
                  onPressed: () {
                    // Temporary simulation
                    repository.addLog(experimentId, "Simulated Log Entry", "voice");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
