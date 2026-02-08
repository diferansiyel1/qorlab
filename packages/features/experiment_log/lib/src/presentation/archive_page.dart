import 'dart:typed_data';
import 'dart:ui';

import 'package:experiment_log/src/application/archive_controller.dart';
import 'package:experiment_log/src/presentation/archive_password_dialog.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ui_kit/ui_kit.dart';

import 'archive_reader_page.dart';

class ArchivePage extends ConsumerStatefulWidget {
  const ArchivePage({super.key});

  @override
  ConsumerState<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends ConsumerState<ArchivePage> {
  String? _busyLabel;

  Future<void> _run(BuildContext context, Future<void> Function() fn) async {
    final controller = ref.read(archiveControllerProvider.notifier);
    if (controller.isBusy) return;
    try {
      await fn();
    } finally {
      if (mounted) {
        setState(() {
          _busyLabel = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final archiveController = ref.watch(archiveControllerProvider);
    final busy = archiveController.isLoading;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.archive)),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.archiveSubtitle,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.archiveExportSection,
                      style: AppTypography.labelUppercase,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.archiveExportDescription,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: busy ? null : () => _exportAll(context),
                        icon: const Icon(Icons.lock_outline_rounded),
                        label: Text(l10n.archiveExportAll),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.archiveImportSection,
                      style: AppTypography.labelUppercase,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.archiveImportDescription,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: busy ? null : () => _importAsCopy(context),
                        icon: const Icon(Icons.file_open_rounded),
                        label: Text(l10n.archiveImportAsCopy),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: busy
                            ? null
                            : () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const ArchiveReaderPage(),
                                ),
                              ),
                        icon: const Icon(Icons.visibility_outlined),
                        label: Text(l10n.archiveReaderOpen),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: busy
                            ? null
                            : () => _importReplacingDeviceData(context),
                        icon: const Icon(Icons.warning_amber_rounded),
                        label: Text(l10n.archiveImportReplaceDevice),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (busy)
            Positioned.fill(
              child: Container(
                color: AppColors.background.withValues(alpha: 0.58),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text(
                        _busyLabel ?? l10n.archiveWorking,
                        style: AppTypography.labelMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _exportAll(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final password = await showArchivePasswordDialog(
      context,
      title: l10n.archiveExportAll,
      requireConfirmation: true,
    );
    if (password == null) return;

    await _run(context, () async {
      setState(() => _busyLabel = l10n.archiveExporting);
      try {
        final result = await ref
            .read(archiveControllerProvider.notifier)
            .exportAll(password: password);
        await Share.shareXFiles(
          [result.file],
          subject: l10n.archiveShareSubject,
          text: l10n.archiveShareText,
          sharePositionOrigin: _defaultSharePositionOrigin(context),
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.archiveExported)));
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.archiveExportFailed(e.toString()))),
        );
      }
    });
  }

  Future<void> _importAsCopy(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final typeGroup = XTypeGroup(
      label: l10n.archiveFileTypeLabel,
      extensions: const ['ql'],
    );
    final xfile = await openFile(acceptedTypeGroups: [typeGroup]);
    if (xfile == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.archiveNoFileSelected)));
      return;
    }

    final password = await showArchivePasswordDialog(
      context,
      title: l10n.archiveImportAsCopy,
      requireConfirmation: false,
    );
    if (password == null) return;

    await _run(context, () async {
      setState(() => _busyLabel = l10n.archiveImporting);
      try {
        final bytes = Uint8List.fromList(await xfile.readAsBytes());
        final result = await ref
            .read(archiveControllerProvider.notifier)
            .importAsCopy(qlBytes: bytes, password: password);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.archiveImportedSummary(
                result.experimentsImported,
                result.logEntriesImported,
                result.blobsImported,
              ),
            ),
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.archiveImportFailed(e.toString()))),
        );
      }
    });
  }

  Future<void> _importReplacingDeviceData(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final typeGroup = XTypeGroup(
      label: l10n.archiveFileTypeLabel,
      extensions: const ['ql'],
    );
    final xfile = await openFile(acceptedTypeGroups: [typeGroup]);
    if (xfile == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.archiveNoFileSelected)));
      return;
    }

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text(
              l10n.archiveReplaceWarningTitle,
              style: AppTypography.headlineMedium,
            ),
            content: Text(
              l10n.archiveReplaceWarningBody,
              style: AppTypography.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.archiveImportReplaceDevice),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;

    final password = await showArchivePasswordDialog(
      context,
      title: l10n.archiveImportReplaceDevice,
      requireConfirmation: false,
    );
    if (password == null) return;

    await _run(context, () async {
      setState(() => _busyLabel = l10n.archiveImporting);
      try {
        final bytes = Uint8List.fromList(await xfile.readAsBytes());
        final result = await ref
            .read(archiveControllerProvider.notifier)
            .importReplacingDeviceData(qlBytes: bytes, password: password);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.archiveImportedSummary(
                result.experimentsImported,
                result.logEntriesImported,
                result.blobsImported,
              ),
            ),
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.archiveImportFailed(e.toString()))),
        );
      }
    });
  }

  Rect _defaultSharePositionOrigin(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 2,
      height: 2,
    );
  }
}
