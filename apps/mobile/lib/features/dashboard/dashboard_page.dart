import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      .map((logs) => logs.take(2).toList());
});

/// Dashboard page - Lab Hub (light-first, dual-mode entry)
class DashboardPage extends ConsumerStatefulWidget {
  final VoidCallback? onOpenLabTools;
  final VoidCallback? onCreateProject;
  final VoidCallback? onSearch;

  const DashboardPage({
    super.key,
    this.onOpenLabTools,
    this.onCreateProject,
    this.onSearch,
  });

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
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

  void _lightHaptic() {
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
    final isDesktop = MediaQuery.sizeOf(context).width >= 1000;
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
              _buildHeader(
                l10n: l10n,
                dateLabel: dateLabel,
                statusInk: inkMint,
                isDesktop: isDesktop,
              ),
              _RevealSection(
                delay: const Duration(milliseconds: 40),
                child: _buildActiveExperimentCard(
                  l10n: l10n,
                  runningInk: inkBlue,
                  voiceInk: inkBlue,
                  photoInk: inkCyan,
                  noteInk: inkMint,
                  activeExperiment: activeExperiment,
                  isDesktop: isDesktop,
                ),
              ),
              _RevealSection(
                delay: const Duration(milliseconds: 90),
                child: _buildCommandDeck(
                  l10n: l10n,
                  primaryInk: inkBlue,
                  toolsInk: inkAmber,
                  isDark: isDark,
                  activeExperiment: activeExperiment,
                  isDesktop: isDesktop,
                ),
              ),
              _RevealSection(
                delay: const Duration(milliseconds: 140),
                child: _buildRecentActivity(
                  l10n: l10n,
                  isDark: isDark,
                  voiceInk: inkBlue,
                  photoInk: inkMint,
                  calcInk: inkAmber,
                  recentLogs: recentLogs,
                  activeExperiment: activeExperiment,
                  isDesktop: isDesktop,
                ),
              ),
              const SizedBox(height: 110),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader({
    required AppLocalizations l10n,
    required String dateLabel,
    required Color statusInk,
    required bool isDesktop,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 28 : 20,
        isDesktop ? 16 : 12,
        isDesktop ? 28 : 20,
        isDesktop ? 8 : 6,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.dashboardTitle, style: AppTypography.headlineLarge),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _StatusPill(
                      label: l10n.dashboardOfflineReady,
                      color: statusInk,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        dateLabel,
                        style: AppTypography.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
            child: IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                final onSearch = widget.onSearch;
                if (onSearch != null) {
                  onSearch();
                }
              },
              icon: Icon(
                Icons.search_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveExperimentCard({
    required AppLocalizations l10n,
    required Color runningInk,
    required Color voiceInk,
    required Color photoInk,
    required Color noteInk,
    required Experiment? activeExperiment,
    required bool isDesktop,
  }) {
    final hasExperiment = activeExperiment != null;
    final code = hasExperiment ? activeExperiment.code.trim() : '';
    final title = hasExperiment
        ? (code.isNotEmpty ? code : activeExperiment.title)
        : l10n.dashboardNoActiveExperimentTitle;
    final projectName = hasExperiment
        ? ((activeExperiment.projectName ?? '').trim().isEmpty
              ? l10n.dashboardGeneralLab
              : activeExperiment.projectName!.trim())
        : l10n.dashboardGeneralLab;
    final subtitle = hasExperiment
        ? '$projectName · ${_relativeTime(l10n, activeExperiment.createdAt)}'
        : l10n.dashboardNoActiveExperimentSubtitle;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 28 : 20,
        vertical: isDesktop ? 14 : 12,
      ),
      child: GlassContainer(
        padding: EdgeInsets.all(isDesktop ? 22 : 18),
        accentColor: runningInk,
        showBottomAccent: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.dashboardSectionActiveExperiment,
                    style: AppTypography.labelUppercase,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _StatusPill(
                  label: hasExperiment
                      ? l10n.dashboardStatusRunning
                      : l10n.dashboardStatusIdle,
                  color: hasExperiment ? runningInk : AppColors.textMuted,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTypography.headlineLarge),
            const SizedBox(height: 6),
            Text(subtitle, style: AppTypography.bodySmall),
            const SizedBox(height: 16),
            Row(
              children: [
                _QuickLogButton(
                  icon: Icons.mic_rounded,
                  label: l10n.dashboardVoice,
                  color: voiceInk,
                  isDesktop: isDesktop,
                  onTap: () => _openActiveLogbook(activeExperiment),
                ),
                const SizedBox(width: 10),
                _QuickLogButton(
                  icon: Icons.camera_alt_rounded,
                  label: l10n.dashboardPhoto,
                  color: photoInk,
                  isDesktop: isDesktop,
                  onTap: () => _openActiveLogbook(activeExperiment),
                ),
                const SizedBox(width: 10),
                _QuickLogButton(
                  icon: Icons.note_alt_rounded,
                  label: l10n.dashboardNote,
                  color: noteInk,
                  isDesktop: isDesktop,
                  onTap: () => _openActiveLogbook(activeExperiment),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: LabButton(
                label: hasExperiment
                    ? l10n.dashboardOpenLogbook
                    : l10n.dashboardCreateExperiment,
                icon: Icons.play_arrow_rounded,
                onPressed: () => _openActiveLogbook(activeExperiment),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openActiveLogbook(Experiment? activeExperiment) {
    _lightHaptic();
    if (!mounted) return;
    if (activeExperiment == null) {
      context.push('/experiment/new');
      return;
    }
    ref.read(activeExperimentIdProvider.notifier).set(activeExperiment.id);
    context.push('/experiment/${activeExperiment.id}');
  }

  void _openExperimentWorkspace(Experiment? activeExperiment) {
    _lightHaptic();
    if (!mounted) return;
    if (activeExperiment != null) {
      _openActiveLogbook(activeExperiment);
      return;
    }
    final onSearch = widget.onSearch;
    if (onSearch != null) {
      onSearch();
      return;
    }
    context.push('/experiment/new');
  }

  void _openToolsWorkspace() {
    _lightHaptic();
    if (!mounted) return;
    final openLabTools = widget.onOpenLabTools;
    if (openLabTools != null) {
      openLabTools();
      return;
    }
    context.push('/free-mode');
  }

  String _relativeTime(AppLocalizations l10n, DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return l10n.dashboardStartedJustNow;
    if (diff.inHours < 1) {
      return l10n.dashboardStartedMinutesAgo(diff.inMinutes);
    }
    if (diff.inDays < 1) {
      return l10n.dashboardStartedHoursAgo(diff.inHours);
    }
    return l10n.dashboardStartedDaysAgo(diff.inDays);
  }

  Widget _buildCommandDeck({
    required AppLocalizations l10n,
    required Color primaryInk,
    required Color toolsInk,
    required bool isDark,
    required Experiment? activeExperiment,
    required bool isDesktop,
  }) {
    final hasExperiment = activeExperiment != null;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 28 : 20,
        isDesktop ? 10 : 8,
        isDesktop ? 28 : 20,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dashboardWorkspaceTitle,
            style: AppTypography.headlineMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CommandTile(
                  title: l10n.dashboardModeLogbookTitle,
                  subtitle: hasExperiment
                      ? l10n.dashboardOpenLogbook
                      : l10n.dashboardBrowseExperiments,
                  icon: Icons.playlist_add_check_rounded,
                  accent: primaryInk,
                  isDark: isDark,
                  onTap: () => _openExperimentWorkspace(activeExperiment),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CommandTile(
                  title: l10n.dashboardModeToolsTitle,
                  subtitle: l10n.openLabTools,
                  icon: Icons.science_rounded,
                  accent: toolsInk,
                  isDark: isDark,
                  onTap: _openToolsWorkspace,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity({
    required AppLocalizations l10n,
    required bool isDark,
    required Color voiceInk,
    required Color photoInk,
    required Color calcInk,
    required List<LogEntry> recentLogs,
    required Experiment? activeExperiment,
    required bool isDesktop,
  }) {
    final activities = recentLogs
        .map(
          (log) => _mapActivity(
            l10n: l10n,
            log: log,
            voiceInk: voiceInk,
            photoInk: photoInk,
            calcInk: calcInk,
          ),
        )
        .toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 28 : 20,
        isDesktop ? 24 : 20,
        isDesktop ? 28 : 20,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.dashboardRecentActivity,
                  style: AppTypography.headlineMedium,
                ),
              ),
              if (activeExperiment != null)
                TextButton(
                  onPressed: () => _openActiveLogbook(activeExperiment),
                  child: Text(l10n.dashboardViewAll),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (activities.isEmpty)
            _ActivityItem(
              icon: Icons.auto_awesome_rounded,
              title: l10n.dashboardNoRecentActivity,
              subtitle: l10n.dashboardModeLogbookSubtitle,
              time: '',
              iconInk: AppColors.textMuted,
              isDark: isDark,
            ),
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
    required AppLocalizations l10n,
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
        title: l10n.voiceNote,
        subtitle: subtitle,
        timeLabel: _formatActivityTime(l10n, log.timestamp),
        iconInk: voiceInk,
      );
    }
    if (kind == 'photo' || log.type == 'photo') {
      return _ActivityModel(
        icon: Icons.camera_alt_rounded,
        title: l10n.photo,
        subtitle: subtitle,
        timeLabel: _formatActivityTime(l10n, log.timestamp),
        iconInk: photoInk,
      );
    }
    if (kind == 'calculation' ||
        log.type == 'data_dose' ||
        log.type == 'data_molarity') {
      return _ActivityModel(
        icon: Icons.functions_rounded,
        title: l10n.dashboardActivityCalculation,
        subtitle: subtitle,
        timeLabel: _formatActivityTime(l10n, log.timestamp),
        iconInk: calcInk,
      );
    }
    return _ActivityModel(
      icon: Icons.note_alt_rounded,
      title: l10n.dashboardActivityNote,
      subtitle: subtitle,
      timeLabel: _formatActivityTime(l10n, log.timestamp),
      iconInk: AppColors.textMuted,
    );
  }

  String _formatActivityTime(AppLocalizations l10n, DateTime timestamp) {
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
      return l10n.dashboardYesterday;
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

class _CommandTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
  final bool isDark;

  const _CommandTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
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
                color: Colors.black.withAlpha(7),
                blurRadius: 12,
                offset: const Offset(0, 7),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withAlpha(isDark ? 36 : 24),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withAlpha(isDark ? 58 : 34)),
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTypography.labelLarge, maxLines: 1),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(color: accent),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLogButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDesktop;
  final VoidCallback onTap;

  const _QuickLogButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDesktop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: isDesktop ? 62 : 56),
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 14 : 12),
          decoration: BoxDecoration(
            color: color.withAlpha(28),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(45)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: isDesktop ? 20 : 18),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: isDesktop ? 13 : null,
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
          if (time.isNotEmpty) Text(time, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}

class _RevealSection extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _RevealSection({required this.child, required this.delay});

  @override
  State<_RevealSection> createState() => _RevealSectionState();
}

class _RevealSectionState extends State<_RevealSection> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (!mounted) return;
      setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      opacity: _visible ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        offset: _visible ? Offset.zero : const Offset(0, 0.02),
        child: widget.child,
      ),
    );
  }
}
