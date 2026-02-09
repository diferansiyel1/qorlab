import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:database/database.dart';
import 'package:experiment_log/experiment_log.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/files/files_page.dart';
import 'features/tools/lab_tools_page.dart';
import 'features/settings/settings_page.dart';

/// Main home page with bottom navigation matching stich design
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  Experiment? _pickActiveExperiment({
    required List<Experiment> experiments,
    required int? preferredId,
  }) {
    if (experiments.isEmpty) return null;
    if (preferredId != null) {
      for (final experiment in experiments) {
        if (experiment.id == preferredId) return experiment;
      }
    }
    for (final experiment in experiments) {
      if (experiment.isActive) return experiment;
    }
    return experiments.first;
  }

  void _ensureActiveExperiment({
    required List<Experiment> experiments,
    required int? activeExperimentId,
  }) {
    final fallback = _pickActiveExperiment(
      experiments: experiments,
      preferredId: activeExperimentId,
    );
    if (fallback == null || fallback.id == activeExperimentId) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(activeExperimentIdProvider.notifier).set(fallback.id);
    });
  }

  String _generateQuickExperimentCode(DateTime now) {
    final suffix = now.microsecondsSinceEpoch
        .remainder(100000)
        .toString()
        .padLeft(5, '0');
    return 'EXP-$suffix';
  }

  Future<void> _quickStartExperiment() async {
    final repository = ref.read(experimentRepositoryProvider);
    final now = DateTime.now();
    final code = _generateQuickExperimentCode(now);

    final experiment = Experiment()
      ..title = code
      ..code = code
      ..projectName = 'General Lab'
      ..createdAt = now
      ..startedAt = now
      ..isActive = true;

    try {
      await repository.createExperiment(experiment);
      if (!mounted) return;
      ref.read(activeExperimentIdProvider.notifier).set(experiment.id);
      context.push('/experiment/${experiment.id}');
    } catch (_) {
      if (!mounted) return;
      context.push('/experiment/new');
    }
  }

  void _openLabToolsTab() {
    setState(() {
      _currentIndex = 2;
    });
  }

  void _openFilesTab() {
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final experiments =
        ref.watch(experimentsProvider).valueOrNull ?? const <Experiment>[];
    final activeExperimentId = ref.watch(activeExperimentIdProvider);
    _ensureActiveExperiment(
      experiments: experiments,
      activeExperimentId: activeExperimentId,
    );

    return AppLayout(
      currentIndex: _currentIndex,
      onTabTapped: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      onFabPressed: () {
        _quickStartExperiment();
      },
      onFabLongPressed: () {
        context.push('/free-mode');
      },
      homeTabLabel: l10n.homeTabHome,
      filesTabLabel: l10n.homeTabFiles,
      labTabLabel: l10n.homeTabLab,
      settingsTabLabel: l10n.homeTabSettings,
      fabTapHint: l10n.homeFabTapNewExperiment,
      fabHoldHint: l10n.homeFabHoldQuickCalc,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardPage(
            onOpenLabTools: _openLabToolsTab,
            onCreateProject: () => context.push('/project/new'),
            onSearch: _openFilesTab,
          ),
          const FilesPage(),
          const LabToolsPage(),
          const SettingsPage(),
        ],
      ),
    );
  }
}
