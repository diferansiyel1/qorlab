import 'package:database/database.dart';
import 'package:smart_timer/smart_timer.dart'; // For timerLoggerProvider
import 'timer_logger_adapter.dart'; // Local adapter

import 'package:decimal/decimal.dart';
import 'package:in_vitro/src/domain/molarity_logger.dart';
import 'package:in_vivo/src/domain/dose_logger.dart';

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

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(ProviderScope(
    overrides: [
      if (kIsWeb) ...[
        // Web Overrides
      ],
      // Adapter: Connect Timer to ExperimentLog
      timerLoggerProvider.overrideWith((ref) {
        final handler = ref.watch(experimentActionHandlerProvider);
        return TimerLoggerAdapter(handler);
      }),
    ],
    child: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F172A), // Slate 900
            Color(0xFF1E293B), // Slate 800
          ],
        ),
      ),
      child: const AppBootstrapper(),
    ),
  ));
}

class AppBootstrapper extends ConsumerWidget {
  const AppBootstrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      return ProviderScope(
        overrides: [
          experimentRepositoryProvider.overrideWithValue(FakeExperimentRepository()),
          experimentActionHandlerProvider.overrideWithValue(FakeExperimentActionHandler()),
          molarityLoggerProvider.overrideWith((ref) => MainMolarityLogger(ref.watch(experimentActionHandlerProvider))),
          doseLoggerProvider.overrideWith((ref) => MainDoseLogger(ref.watch(experimentActionHandlerProvider))),
        ],
        child: const QorLabApp(),
      );
    } else {
      final isarAsync = ref.watch(isarProvider);
      
      return isarAsync.when(
        data: (isar) {
          return ProviderScope(
             overrides: [
               molarityLoggerProvider.overrideWith((ref) => MainMolarityLogger(ref.watch(experimentActionHandlerProvider))),
               doseLoggerProvider.overrideWith((ref) => MainDoseLogger(ref.watch(experimentActionHandlerProvider))),
             ],
             child: const QorLabApp(),
          );
        },
        loading: () => const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        ),
        error: (err, stack) => MaterialApp(
          home: Scaffold(body: Center(child: Text("Database Error: $err"))),
        ),
      );
    }
  }
}

class QorLabApp extends StatelessWidget {
  const QorLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QorLab',
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: _router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
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
            // Use History Page for "Open Experiment"
            return ExperimentHistoryPage(experimentId: id);
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

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final experimentRepo = ref.watch(experimentRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitle)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.useGlovesWrapper, style: theme.textTheme.headlineLarge),
              const SizedBox(height: 32),
              GloveButton(
                label: AppLocalizations.of(context)!.newExperiment,
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
                label: AppLocalizations.of(context)!.openExperiment,
                icon: Icons.folder_open,
                isPrimary: false,
                onPressed: () {
                  context.go('/experiment/1');
                },
              ),
              const SizedBox(height: 16),
               GloveButton(
                label: AppLocalizations.of(context)!.timers,
                icon: Icons.timer,
                backgroundColor: AppColors.tealScience,
                onPressed: () {
                  context.go('/timers');
                },
              ),
              const SizedBox(height: 16),
              GloveButton(
                label: AppLocalizations.of(context)!.inVivoSafety,
                icon: Icons.health_and_safety,
                backgroundColor: AppColors.biohazardRed,
                onPressed: () {
                  context.go('/in-vivo');
                },
              ),
              const SizedBox(height: 16),
              GloveButton(
                label: AppLocalizations.of(context)!.chemistry,
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

// --- Adapters & Fakes ---

class MainMolarityLogger implements MolarityLogger {
  final ExperimentActionHandler handler;
  MainMolarityLogger(this.handler);

  @override
  Future<void> logResult({required String chemicalName, required Decimal molecularWeight, required Decimal volumeMl, required Decimal molarity, required Decimal massG}) {
    return handler.logMolarity(chemicalName: chemicalName, molecularWeight: molecularWeight, volumeMl: volumeMl, molarity: molarity, massG: massG);
  }
}

class MainDoseLogger implements DoseLogger {
  final ExperimentActionHandler handler;
  MainDoseLogger(this.handler);

  @override
  Future<void> logDose({required String species, required String route, required Decimal weightG, required Decimal doseMgPerKg, required Decimal concentrationMgMl, required Decimal volumeMl, required bool isSafe}) {
    return handler.logDose(species: species, route: route, weightG: weightG, doseMgPerKg: doseMgPerKg, concentrationMgMl: concentrationMgMl, volumeMl: volumeMl, isSafe: isSafe);
  }
}

class FakeExperimentRepository implements ExperimentRepository {
  @override
  Future<void> createExperiment(String title) async {
    debugPrint("Mock: Created experiment $title");
  }

  @override
  Future<void> addLog(int experimentId, String content, String type) async {
     debugPrint("Mock: Added log $content");
  }

  @override
  Stream<List<LogEntry>> watchLogs(int experimentId) {
    return Stream.value([]);
  }
}

class FakeExperimentActionHandler implements ExperimentActionHandler {
  @override
  Future<void> logDose({required String species, required String route, required Decimal weightG, required Decimal doseMgPerKg, required Decimal concentrationMgMl, required Decimal volumeMl, required bool isSafe}) async {
    debugPrint("Mock Log Dose: $species");
  }

  @override
  Future<void> logMolarity({required String chemicalName, required Decimal molecularWeight, required Decimal volumeMl, required Decimal molarity, required Decimal massG}) async {
    debugPrint("Mock Log Molarity: $chemicalName");
  }

  @override
  Future<void> logVoiceNote({required String text}) async {
    debugPrint("Mock Log Voice: $text");
  }

  @override
  Future<void> logNote({required String text}) async {
    debugPrint("Mock Log Note: $text");
  }
}
