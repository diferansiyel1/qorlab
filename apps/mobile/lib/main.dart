import 'package:database/database.dart';
import 'fake_database.dart'; // Contains web fakes
import 'package:smart_timer/smart_timer.dart'; // For timerLoggerProvider
import 'timer_logger_adapter.dart'; // Local adapter

import 'package:decimal/decimal.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:experiment_log/experiment_log.dart';

import 'package:in_vivo/in_vivo.dart';
import 'package:in_vitro/in_vitro.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'home_page.dart';
import 'features/tools/centrifuge_page.dart';
import 'features/tools/power_analysis_page.dart';
import 'features/tools/plate_map_page.dart';
import 'features/free_mode/free_mode_page.dart';
import 'features/experiment/new_experiment_page.dart';
import 'features/project/new_project_page.dart';
import 'features/settings/premium_page.dart';
import 'services/local_timer_notification_scheduler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final timerScheduler = await createLocalTimerNotificationScheduler();

  runApp(
    ProviderScope(
      overrides: [
        if (kIsWeb) ...[
          experimentRepositoryProvider.overrideWithValue(
            FakeExperimentRepository(),
          ),
          experimentActionHandlerProvider.overrideWithValue(
            FakeExperimentActionHandler(),
          ),
          molarityLoggerProvider.overrideWith(
            (ref) =>
                MainMolarityLogger(ref.watch(experimentActionHandlerProvider)),
          ),
          doseLoggerProvider.overrideWith(
            (ref) => MainDoseLogger(ref.watch(experimentActionHandlerProvider)),
          ),
          molecularMethodsLoggerProvider.overrideWith(
            (ref) => MainMolecularMethodsLogger(
              ref.watch(experimentActionHandlerProvider),
            ),
          ),
        ],
        timerNotificationSchedulerProvider.overrideWithValue(timerScheduler),
        // Adapter: Connect Timer to ExperimentLog
        timerLoggerProvider.overrideWith((ref) {
          final handler = ref.watch(experimentActionHandlerProvider);
          return TimerLoggerAdapter(handler);
        }),
        timerExperimentContextProvider.overrideWith(
          (ref) => ref.watch(activeExperimentIdProvider),
        ),
      ],
      child: const AppBootstrapper(),
    ),
  );
}

class AppBootstrapper extends ConsumerWidget {
  const AppBootstrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      return const QorLabApp();
    } else {
      final isarAsync = ref.watch(isarProvider);

      return isarAsync.when(
        data: (isar) {
          return ProviderScope(
            overrides: [
              molarityLoggerProvider.overrideWith(
                (ref) => MainMolarityLogger(
                  ref.watch(experimentActionHandlerProvider),
                ),
              ),
              doseLoggerProvider.overrideWith(
                (ref) =>
                    MainDoseLogger(ref.watch(experimentActionHandlerProvider)),
              ),
              molecularMethodsLoggerProvider.overrideWith(
                (ref) => MainMolecularMethodsLogger(
                  ref.watch(experimentActionHandlerProvider),
                ),
              ),
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

class QorLabApp extends ConsumerWidget {
  const QorLabApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'QorLab',
      theme: LabTheme.getLight(),
      darkTheme: LabTheme.getDark(),
      themeMode: themeMode,
      locale: const Locale('en'),
      routerConfig: _router,
      builder: (context, child) {
        final brightness = Theme.of(context).brightness;
        AppColors.setBrightness(brightness);
        LabColors.setBrightness(brightness);
        return child ?? const SizedBox.shrink();
      },
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
          path: 'experiment/new',
          builder: (context, state) => const NewExperimentPage(),
        ),
        GoRoute(
          path: 'project/new',
          builder: (context, state) => const NewProjectPage(),
        ),
        GoRoute(
          path: 'experiment/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            // Use History Page for "Open Experiment"
            // return ExperimentHistoryPage(experimentId: id);
            return ExperimentTimelinePage(experimentId: id);
          },
        ),
        GoRoute(
          path: 'free-mode',
          builder: (context, state) => const FreeModePage(),
        ),
        GoRoute(path: 'timers', builder: (context, state) => const TimerPage()),
        GoRoute(
          path: 'in-vivo',
          builder: (context, state) => const DoseCalculatorPage(),
        ),
        GoRoute(
          path: 'in-vitro',
          builder: (context, state) => const MolarityCalculatorPage(),
        ),
        GoRoute(
          path: 'pubchem-explorer',
          builder: (context, state) => const PubChemExplorerPage(),
        ),
        GoRoute(
          path: 'stat-wizard',
          builder: (context, state) => const StatWizardPage(),
        ),
        GoRoute(
          path: 'molecular-methods',
          builder: (context, state) => const MolecularMethodsPage(),
        ),
        GoRoute(
          path: 'centrifuge',
          builder: (context, state) => const CentrifugePage(),
        ),
        GoRoute(
          path: 'power-analysis',
          builder: (context, state) => const PowerAnalysisPage(),
        ),
        GoRoute(
          path: 'plate-map',
          builder: (context, state) => const PlateMapPage(),
        ),
        GoRoute(
          path: 'archive',
          builder: (context, state) => const ArchivePage(),
        ),
        GoRoute(
          path: 'premium',
          builder: (context, state) => const PremiumPage(),
        ),
      ],
    ),
  ],
);

// --- Adapters ---

class MainMolarityLogger implements MolarityLogger {
  final ExperimentActionHandler handler;
  MainMolarityLogger(this.handler);

  @override
  Future<void> logResult({
    required String chemicalName,
    required Decimal molecularWeight,
    required Decimal volumeMl,
    required Decimal molarity,
    required Decimal massG,
    Decimal? purityPercent,
    String? barcode,
    String? source,
  }) {
    return handler.logMolarity(
      chemicalName: chemicalName,
      molecularWeight: molecularWeight,
      volumeMl: volumeMl,
      molarity: molarity,
      massG: massG,
      purityPercent: purityPercent,
      barcode: barcode,
      source: source,
    );
  }
}

class MainDoseLogger implements DoseLogger {
  final ExperimentActionHandler handler;
  MainDoseLogger(this.handler);

  @override
  Future<void> logDose({
    required String species,
    required String route,
    required Decimal weightG,
    required Decimal doseMgPerKg,
    required Decimal concentrationMgMl,
    required Decimal volumeMl,
    required bool isSafe,
  }) {
    return handler.logDose(
      species: species,
      route: route,
      weightG: weightG,
      doseMgPerKg: doseMgPerKg,
      concentrationMgMl: concentrationMgMl,
      volumeMl: volumeMl,
      isSafe: isSafe,
    );
  }
}

class MainMolecularMethodsLogger implements MolecularMethodsLogger {
  MainMolecularMethodsLogger(this.handler);

  final ExperimentActionHandler handler;

  @override
  Future<void> logCalculation({
    required String summary,
    required String calculatorId,
    required int algorithmVersion,
    required Map<String, String> inputs,
    required Map<String, String> outputs,
    Map<String, String> units = const <String, String>{},
    List<String> assumptions = const <String>[],
  }) {
    return handler.logCalculation(
      summary: summary,
      calculatorId: calculatorId,
      algorithmVersion: algorithmVersion,
      inputs: inputs,
      outputs: outputs,
      units: units,
      assumptions: assumptions,
    );
  }
}
