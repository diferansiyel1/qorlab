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
import 'package:smart_timer/smart_timer.dart';
import 'package:in_vivo/in_vivo.dart';
import 'package:in_vitro/in_vitro.dart';

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
      backgroundColor: Colors.transparent, // Let root gradient show through
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Section or Welcome
              Text(
                "Welcome to QorLab",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepLabBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Select a protocol to begin",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 48),

              // Main Actions
              GloveButton(
                label: AppLocalizations.of(context)!.newExperiment,
                icon: Icons.science,
                isPrimary: true,
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
                // Using Outline style via isPrimary=false
                onPressed: () {
                  context.go('/experiment/1');
                },
              ),
              
              const SizedBox(height: 32),
              
              // Tools Section
              Text(
                "Quick Tools",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: GloveButton(
                      label: AppLocalizations.of(context)!.timers,
                      icon: Icons.timer,
                      backgroundColor: AppColors.tealScience,
                      onPressed: () => context.go('/timers'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GloveButton(
                      label: "Safety", // Shortened for grid/row
                      icon: Icons.health_and_safety,
                      backgroundColor: AppColors.biohazardRed,
                      onPressed: () => context.go('/in-vivo'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GloveButton(
                      label: "Molarity", // Shortened
                      icon: Icons.science_outlined,
                      backgroundColor: AppColors.deepLabBlue,
                      onPressed: () => context.go('/in-vitro'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
