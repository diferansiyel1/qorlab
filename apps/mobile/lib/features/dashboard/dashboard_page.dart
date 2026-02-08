import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:database/database.dart';
import 'package:experiment_log/experiment_log.dart';

final recentActivityProvider = StreamProvider.family<List<LogEntry>, int?>((
  ref,
  experimentId,
) {
  if (experimentId == null) {
    return Stream.value(const <LogEntry>[]);
  }
  final repository = ref.watch(experimentRepositoryProvider);
  return repository
      .watchLogs(experimentId)
      .map((logs) => logs.take(3).toList());
});

/// Dashboard page - Lab Hub (light-first, dual-mode entry)
class DashboardPage extends ConsumerStatefulWidget {
  final VoidCallback? onOpenLabTools;
  final VoidCallback? onCreateProject;

  const DashboardPage({super.key, this.onOpenLabTools, this.onCreateProject});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _modeIndex = 0;
  final PageController _pageController = PageController();

  int _alpha(double opacity) {
    final value = (opacity * 255).round();
    if (value < 0) return 0;
    if (value > 255) return 255;
    return value;
  }

  Color _ink(
    Color target, {
    required bool isDark,
    double lightMix = 0.68,
    double darkMix = 0.82,
  }) {
    final mix = isDark ? darkMix : lightMix;
    return Color.lerp(AppColors.textMuted, target, mix) ?? target;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final experiments =
        ref.watch(experimentsProvider).valueOrNull ?? const <Experiment>[];
    final activeExperimentId = ref.watch(activeExperimentIdProvider);
    final activeExperiment = _pickActiveExperiment(
      experiments: experiments,
      preferredId: activeExperimentId,
    );
    final recentLogs =
        ref.watch(recentActivityProvider(activeExperiment?.id)).valueOrNull ??
        const <LogEntry>[];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateLabel = DateFormat('EEE, MMM d').format(DateTime.now());

    final inkBlue = _ink(AppColors.primary, isDark: isDark);
    final inkMint = _ink(
      AppColors.success,
      isDark: isDark,
      lightMix: 0.64,
      darkMix: 0.76,
    );
    final inkCyan = _ink(
      const Color(0xFF64D2FF),
      isDark: isDark,
      lightMix: 0.66,
      darkMix: 0.78,
    );
    final inkAmber = _ink(
      AppColors.warning,
      isDark: isDark,
      lightMix: 0.62,
      darkMix: 0.76,
    );

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.background, AppColors.surfaceHighlight],
              ),
            ),
          ),
        ),
        Positioned(
          top: -90,
          right: -70,
          child: _AmbientBlob(
            color: inkBlue.withAlpha(_alpha(isDark ? 0.10 : 0.07)),
          ),
        ),
        Positioned(
          top: 220,
          left: -120,
          child: _AmbientBlob(
            color: inkCyan.withAlpha(_alpha(isDark ? 0.08 : 0.06)),
          ),
        ),
        Positioned(
          bottom: -140,
          left: -90,
          child: _AmbientBlob(
            color: inkAmber.withAlpha(_alpha(isDark ? 0.08 : 0.06)),
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildHeader(dateLabel, syncedInk: inkMint),
              _buildActiveExperimentCard(
                isDark: isDark,
                runningInk: inkBlue,
                voiceInk: inkBlue,
                photoInk: inkCyan,
                noteInk: inkMint,
                activeExperiment: activeExperiment,
              ),
              _buildModeSection(
                modeInk: inkBlue,
                toolsInk: inkAmber,
                isDark: isDark,
              ),
              _buildQuickActions(
                isDark: isDark,
                experimentInk: inkBlue,
                calcInk: inkCyan,
              ),
              _buildRecentActivity(
                isDark: isDark,
                voiceInk: inkBlue,
                photoInk: inkMint,
                calcInk: inkAmber,
                recentLogs: recentLogs,
              ),
              const SizedBox(height: 110),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String dateLabel, {required Color syncedInk}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lab Notebook', style: AppTypography.headlineLarge),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _StatusPill(label: 'Synced', color: syncedInk),
                    const SizedBox(width: 8),
                    Text(dateLabel, style: AppTypography.labelMedium),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
              ],
            ),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveExperimentCard({
    required bool isDark,
    required Color runningInk,
    required Color voiceInk,
    required Color photoInk,
    required Color noteInk,
    required Experiment? activeExperiment,
  }) {
    final hasExperiment = activeExperiment != null;
    final title = hasExperiment
        ? activeExperiment.title
        : 'No active experiment';
    final subtitle = hasExperiment
        ? '${activeExperiment.projectName ?? 'General Lab'} · ${_relativeTime(activeExperiment.createdAt)}'
        : 'Create a new experiment to start logging.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(18),
        accentColor: runningInk,
        showBottomAccent: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('ACTIVE EXPERIMENT', style: AppTypography.labelUppercase),
                const Spacer(),
                _StatusPill(
                  label: hasExperiment ? 'Running' : 'Idle',
                  color: hasExperiment ? runningInk : AppColors.textMuted,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTypography.headlineMedium),
            const SizedBox(height: 6),
            Text(subtitle, style: AppTypography.bodySmall),
            const SizedBox(height: 16),
            Row(
              children: [
                _QuickLogButton(
                  icon: Icons.mic_rounded,
                  label: 'Voice',
                  color: voiceInk,
                  onTap: () => _openActiveLogbook(activeExperiment),
                ),
                const SizedBox(width: 10),
                _QuickLogButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Photo',
                  color: photoInk,
                  onTap: () => _openActiveLogbook(activeExperiment),
                ),
                const SizedBox(width: 10),
                _QuickLogButton(
                  icon: Icons.note_alt_rounded,
                  label: 'Note',
                  color: noteInk,
                  onTap: () => _openActiveLogbook(activeExperiment),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: LabButton(
                    label: hasExperiment ? 'Open Logbook' : 'Create Experiment',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => _openActiveLogbook(activeExperiment),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withAlpha(isDark ? 150 : 205),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add_rounded),
                    color: AppColors.textMain,
                    onPressed: () => context.push('/experiment/new'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openActiveLogbook(Experiment? activeExperiment) {
    if (activeExperiment == null) {
      context.push('/experiment/new');
      return;
    }
    ref.read(activeExperimentIdProvider.notifier).set(activeExperiment.id);
    context.push('/experiment/${activeExperiment.id}');
  }

  String _relativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'started just now';
    if (diff.inHours < 1) return 'started ${diff.inMinutes} min ago';
    if (diff.inDays < 1) return 'started ${diff.inHours} h ago';
    return 'started ${diff.inDays} d ago';
  }

  Widget _buildModeSection({
    required Color modeInk,
    required Color toolsInk,
    required bool isDark,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Modes', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          _ModeToggle(
            index: _modeIndex,
            modeInk: modeInk,
            isDark: isDark,
            onChanged: (index) {
              setState(() => _modeIndex = index);
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
              );
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _modeIndex = index),
              children: [
                _ModeCard(
                  title: 'Experiment Logbook',
                  subtitle: 'Capture every step, note, photo, and calculation.',
                  icon: Icons.playlist_add_check_rounded,
                  accent: modeInk,
                  actionLabel: 'Start New Experiment',
                  onAction: () => context.push('/experiment/new'),
                ),
                _ModeCard(
                  title: 'Lab Tools',
                  subtitle: 'Quick calculations, conversions, and protocols.',
                  icon: Icons.science_rounded,
                  accent: toolsInk,
                  actionLabel: l10n.openLabTools,
                  onAction: () {
                    final openLabTools = widget.onOpenLabTools;
                    if (openLabTools != null) {
                      openLabTools();
                      return;
                    }
                    context.push('/free-mode');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions({
    required bool isDark,
    required Color experimentInk,
    required Color calcInk,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  title: 'New Experiment',
                  subtitle: 'Create logbook',
                  icon: Icons.add_circle_outline_rounded,
                  accent: experimentInk,
                  isDark: isDark,
                  onTap: () => context.push('/experiment/new'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionTile(
                  title: 'Free Calculation',
                  subtitle: 'Scratchpad',
                  icon: Icons.calculate_outlined,
                  accent: calcInk,
                  isDark: isDark,
                  onTap: () => context.push('/free-mode'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ActionTile(
            title: l10n.newProject,
            subtitle: l10n.newProjectSubtitle,
            icon: Icons.create_new_folder_outlined,
            accent: experimentInk,
            isDark: isDark,
            onTap: () {
              final createProject = widget.onCreateProject;
              if (createProject != null) {
                createProject();
                return;
              }
              context.push('/project/new');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity({
    required bool isDark,
    required Color voiceInk,
    required Color photoInk,
    required Color calcInk,
    required List<LogEntry> recentLogs,
  }) {
    if (recentLogs.isEmpty) {
      return const SizedBox.shrink();
    }

    final activities = recentLogs
        .map(
          (log) => _mapActivity(
            log: log,
            voiceInk: voiceInk,
            photoInk: photoInk,
            calcInk: calcInk,
          ),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activity', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          for (var index = 0; index < activities.length; index++) ...[
            if (index > 0) const SizedBox(height: 8),
            _ActivityItem(
              icon: activities[index].icon,
              title: activities[index].title,
              subtitle: activities[index].subtitle,
              time: activities[index].timeLabel,
              iconInk: activities[index].iconInk,
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }

  _ActivityModel _mapActivity({
    required LogEntry log,
    required Color voiceInk,
    required Color photoInk,
    required Color calcInk,
  }) {
    final kind = (log.kind ?? log.type).toLowerCase();
    final subtitle = log.content.trim().isEmpty ? log.type : log.content.trim();
    if (kind == 'voice' || log.type == 'voice') {
      return _ActivityModel(
        icon: Icons.mic_rounded,
        title: 'Voice Note',
        subtitle: subtitle,
        timeLabel: _formatActivityTime(log.timestamp),
        iconInk: voiceInk,
      );
    }
    if (kind == 'photo' || log.type == 'photo') {
      return _ActivityModel(
        icon: Icons.camera_alt_rounded,
        title: 'Photo',
        subtitle: subtitle,
        timeLabel: _formatActivityTime(log.timestamp),
        iconInk: photoInk,
      );
    }
    if (kind == 'calculation' ||
        log.type == 'data_dose' ||
        log.type == 'data_molarity') {
      return _ActivityModel(
        icon: Icons.functions_rounded,
        title: 'Calculation',
        subtitle: subtitle,
        timeLabel: _formatActivityTime(log.timestamp),
        iconInk: calcInk,
      );
    }
    return _ActivityModel(
      icon: Icons.note_alt_rounded,
      title: 'Note',
      subtitle: subtitle,
      timeLabel: _formatActivityTime(log.timestamp),
      iconInk: AppColors.textMuted,
    );
  }

  String _formatActivityTime(DateTime timestamp) {
    final now = DateTime.now();
    final isSameDay =
        now.year == timestamp.year &&
        now.month == timestamp.month &&
        now.day == timestamp.day;
    if (isSameDay) {
      return DateFormat('HH:mm').format(timestamp);
    }
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday =
        timestamp.year == yesterday.year &&
        timestamp.month == yesterday.month &&
        timestamp.day == yesterday.day;
    if (isYesterday) {
      return 'Yesterday';
    }
    return DateFormat('MMM d').format(timestamp);
  }
}

class _ActivityModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final String timeLabel;
  final Color iconInk;

  const _ActivityModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.iconInk,
  });
}

class _AmbientBlob extends StatelessWidget {
  final Color color;

  const _AmbientBlob({required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 320,
        height: 320,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final Color modeInk;
  final bool isDark;

  const _ModeToggle({
    required this.index,
    required this.onChanged,
    required this.modeInk,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final segmentWidth = constraints.maxWidth / 2;
        return Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: index * segmentWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  width: segmentWidth,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withAlpha(isDark ? 85 : 168),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: modeInk.withAlpha(isDark ? 56 : 38),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  _ModeToggleItem(
                    label: 'Logbook',
                    isActive: index == 0,
                    modeInk: modeInk,
                    onTap: () => onChanged(0),
                  ),
                  _ModeToggleItem(
                    label: 'Tools',
                    isActive: index == 1,
                    modeInk: modeInk,
                    onTap: () => onChanged(1),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ModeToggleItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color modeInk;

  const _ModeToggleItem({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.modeInk,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: isActive ? modeInk : AppColors.textMuted,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final String actionLabel;
  final VoidCallback onAction;

  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withAlpha(isDark ? 42 : 28),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accent.withAlpha(isDark ? 66 : 38)),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: AppTypography.labelLarge)),
            ],
          ),
          const SizedBox(height: 12),
          Text(subtitle, style: AppTypography.bodySmall),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                foregroundColor: accent,
                side: BorderSide(color: accent.withAlpha(90)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickLogButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickLogButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withAlpha(28),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(45)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(62)),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;
  final bool isDark;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.accent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accent.withAlpha(isDark ? 40 : 26),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: accent.withAlpha(isDark ? 62 : 36)),
              ),
              child: Icon(icon, color: accent, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.labelLarge),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color iconInk;
  final bool isDark;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.iconInk,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconInk.withAlpha(isDark ? 40 : 22),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: iconInk.withAlpha(isDark ? 58 : 32)),
            ),
            child: Icon(icon, color: iconInk, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLarge),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.bodySmall),
              ],
            ),
          ),
          Text(time, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}
