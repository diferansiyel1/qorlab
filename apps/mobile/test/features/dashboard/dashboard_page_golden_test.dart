import 'package:database/database.dart';
import 'package:experiment_log/experiment_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localization/localization.dart';
import 'package:mobile/features/dashboard/dashboard_page.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('DashboardPage goldens', () {
    testWidgets('active experiment hero', (tester) async {
      final now = DateTime.now();
      final activeExperiment = _experiment(
        id: 1,
        code: 'PGX-2741',
        title: 'PGX-2741',
        projectName: 'PTZ-GLP1',
        createdAt: now,
        isActive: true,
      );
      final logs = <LogEntry>[
        _log(
          id: 11,
          experimentId: 1,
          type: 'voice',
          kind: 'voice',
          content: 'Dose step completed',
          timestamp: DateTime(2020, 1, 1, 10, 30),
        ),
        _log(
          id: 12,
          experimentId: 1,
          type: 'photo',
          kind: 'photo',
          content: 'Microscope capture',
          timestamp: DateTime(2020, 1, 1, 10, 45),
        ),
      ];

      await _pumpDashboard(
        tester,
        repository: _FakeExperimentRepository(
          experiments: <Experiment>[activeExperiment],
          logsByExperiment: <int, List<LogEntry>>{1: logs},
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/dashboard_active_experiment.png'),
      );
    });

    testWidgets('no active experiment create state', (tester) async {
      await _pumpDashboard(
        tester,
        repository: _FakeExperimentRepository(
          experiments: const <Experiment>[],
          logsByExperiment: const <int, List<LogEntry>>{},
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/dashboard_no_experiment.png'),
      );
    });

    testWidgets('first usage with empty recent activity', (tester) async {
      final now = DateTime.now();
      final activeExperiment = _experiment(
        id: 7,
        code: 'EXP-9001',
        title: 'EXP-9001',
        projectName: 'General Lab',
        createdAt: now,
        isActive: true,
      );

      await _pumpDashboard(
        tester,
        repository: _FakeExperimentRepository(
          experiments: <Experiment>[activeExperiment],
          logsByExperiment: const <int, List<LogEntry>>{},
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/dashboard_first_usage.png'),
      );
    });
  });

  group('DashboardPage behavior', () {
    testWidgets('shows one primary create CTA when no experiment', (
      tester,
    ) async {
      await _pumpDashboard(
        tester,
        repository: _FakeExperimentRepository(
          experiments: const <Experiment>[],
          logsByExperiment: const <int, List<LogEntry>>{},
        ),
      );

      expect(find.text('Create Experiment'), findsOneWidget);
      expect(find.text('Start New Experiment'), findsNothing);
    });

    testWidgets('quick log buttons keep minimum glove-friendly height', (
      tester,
    ) async {
      final now = DateTime.now();
      final activeExperiment = _experiment(
        id: 5,
        code: 'EXP-005',
        title: 'EXP-005',
        projectName: 'General Lab',
        createdAt: now,
        isActive: true,
      );

      await _pumpDashboard(
        tester,
        repository: _FakeExperimentRepository(
          experiments: <Experiment>[activeExperiment],
          logsByExperiment: const <int, List<LogEntry>>{},
        ),
      );

      final voiceButton = find.ancestor(
        of: find.text('Voice'),
        matching: find.byType(InkWell),
      );
      final photoButton = find.ancestor(
        of: find.text('Photo'),
        matching: find.byType(InkWell),
      );
      final noteButton = find.ancestor(
        of: find.text('Note'),
        matching: find.byType(InkWell),
      );

      expect(
        tester.getSize(voiceButton.first).height,
        greaterThanOrEqualTo(56),
      );
      expect(
        tester.getSize(photoButton.first).height,
        greaterThanOrEqualTo(56),
      );
      expect(tester.getSize(noteButton.first).height, greaterThanOrEqualTo(56));
    });

    testWidgets('search icon triggers callback', (tester) async {
      var called = 0;

      await _pumpDashboard(
        tester,
        repository: _FakeExperimentRepository(
          experiments: const <Experiment>[],
          logsByExperiment: const <int, List<LogEntry>>{},
        ),
        onSearch: () => called++,
      );

      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pump();

      expect(called, 1);
    });
  });
}

Future<void> _pumpDashboard(
  WidgetTester tester, {
  required _FakeExperimentRepository repository,
  VoidCallback? onSearch,
}) async {
  await tester.binding.setSurfaceSize(const Size(393, 852));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        experimentRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        theme: LabTheme.getLight(),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          final brightness = Theme.of(context).brightness;
          AppColors.setBrightness(brightness);
          LabColors.setBrightness(brightness);
          return child ?? const SizedBox.shrink();
        },
        home: Scaffold(
          body: DashboardPage(
            onSearch: onSearch,
            onOpenLabTools: () {},
            onCreateProject: () {},
          ),
        ),
      ),
    ),
  );

  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}

Experiment _experiment({
  required int id,
  required String code,
  required String title,
  required String projectName,
  required DateTime createdAt,
  required bool isActive,
}) {
  return Experiment()
    ..id = id
    ..code = code
    ..title = title
    ..projectName = projectName
    ..createdAt = createdAt
    ..startedAt = createdAt
    ..isActive = isActive;
}

LogEntry _log({
  required int id,
  required int experimentId,
  required String type,
  required String kind,
  required String content,
  required DateTime timestamp,
}) {
  return LogEntry()
    ..id = id
    ..experimentId = experimentId
    ..type = type
    ..kind = kind
    ..content = content
    ..timestamp = timestamp;
}

class _FakeExperimentRepository implements ExperimentRepositoryInterface {
  _FakeExperimentRepository({
    required this.experiments,
    required this.logsByExperiment,
  });

  final List<Experiment> experiments;
  final Map<int, List<LogEntry>> logsByExperiment;

  @override
  Future<void> createExperiment(Experiment experiment) async {}

  @override
  Future<void> addLog(int experimentId, String content, String type) async {}

  @override
  Future<void> setExperimentStatus({
    required int experimentId,
    required bool isActive,
  }) async {}

  @override
  Future<void> deleteExperiment(int experimentId) async {}

  @override
  Future<void> deleteProject(String projectName) async {}

  @override
  Future<void> deleteLogEntry(int logEntryId) async {}

  @override
  Stream<List<LogEntry>> watchLogs(int experimentId) {
    return Stream<List<LogEntry>>.value(
      logsByExperiment[experimentId] ?? const <LogEntry>[],
    );
  }

  @override
  Stream<List<Experiment>> watchExperiments() {
    return Stream<List<Experiment>>.value(experiments);
  }
}
