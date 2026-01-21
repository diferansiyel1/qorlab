import 'package:database/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:smart_timer/smart_timer.dart';
import 'package:in_vivo/in_vivo.dart';
import 'package:in_vitro/in_vitro.dart';
import 'package:isar/isar.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(ProviderScope(
    overrides: kIsWeb ? [
      experimentRepositoryProvider.overrideWithValue(FakeExperimentRepository()),
    ] : [],
    child: const QorLabApp(),
  ));
}

/// Fake Repository for Web Demo
class FakeExperimentRepository implements ExperimentRepository {
  @override
  Future<void> createExperiment(String title) async {
    print("Mock: Created experiment $title");
  }

  @override
  Future<void> addLog(int experimentId, String content, String type) async {
     print("Mock: Added log $content");
  }

  @override
  Stream<List<LogEntry>> watchLogs(int experimentId) {
    return Stream.value([
      LogEntry()
       ..content = "Mock Log 1"
       ..timestamp = DateTime.now()
       ..type = "voice"
       ..experimentId = experimentId,
      LogEntry()
       ..content = "Mock Log 2"
       ..timestamp = DateTime.now().subtract(const Duration(minutes: 5))
       ..type = "text"
       ..experimentId = experimentId,
    ]);
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'experiment/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return ExperimentPage(experimentId: id);
          },
        ),
        GoRoute(
          path: 'timers',
          builder: (context, state) => const TimerPage(),
        ),
        GoRoute(
          path: 'in-vivo',
          builder: (context, state) => const DoseCalculatorPage(),
        ),
        GoRoute(
          path: 'in-vitro',
          builder: (context, state) => const MolarityCalculatorPage(),
        ),

      ],
    ),
  ],
);

class QorLabApp extends StatelessWidget {
  const QorLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QorLab',
      theme: createAppTheme(Brightness.light),
      darkTheme: createAppTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final experimentRepo = ref.watch(experimentRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('QorLab Dashboard')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Use Gloves!', style: theme.textTheme.headlineLarge),
              const SizedBox(height: 32),
              GloveButton(
                label: 'NEW EXPERIMENT',
                icon: Icons.science,
                onPressed: () async {
                   await experimentRepo.createExperiment("Experiment ${DateTime.now()}");
                   if (context.mounted) {
                     context.go('/experiment/1');
                   }
                },
              ),
               const SizedBox(height: 16),
               GloveButton(
                label: 'OPEN ID 1',
                icon: Icons.folder_open,
                isPrimary: false,
                onPressed: () {
                  context.go('/experiment/1');
                },
              ),
              const SizedBox(height: 16),
               GloveButton(
                label: 'TIMERS',
                icon: Icons.timer,
                backgroundColor: AppColors.tealScience,
                onPressed: () {
                  context.go('/timers');
                },
              ),
              const SizedBox(height: 16),
              GloveButton(
                label: 'IN-VIVO SAFETY',
                icon: Icons.health_and_safety,
                backgroundColor: AppColors.biohazardRed,
                onPressed: () {
                  context.go('/in-vivo');
                },
              ),
              const SizedBox(height: 16),
              GloveButton(
                label: 'CHEMISTRY',
                icon: Icons.science_outlined,
                backgroundColor: AppColors.deepLabBlue,
                onPressed: () {
                  context.go('/in-vitro');
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
