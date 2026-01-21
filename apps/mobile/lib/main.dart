import 'package:database/database.dart';
import 'fake_database.dart'; // Contains web fakes
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

import 'package:in_vivo/in_vivo.dart';
import 'package:in_vitro/in_vitro.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'home_page.dart';

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
            // return ExperimentHistoryPage(experimentId: id);
            return ExperimentTimelinePage(experimentId: id);
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

// --- Adapters ---

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
