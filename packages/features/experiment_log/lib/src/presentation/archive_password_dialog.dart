import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:ui_kit/ui_kit.dart';

Future<String?> showArchivePasswordDialog(
  BuildContext context, {
  required String title,
  required bool requireConfirmation,
}) {
  return showDialog<String?>(
    context: context,
    barrierDismissible: true,
    builder: (context) => _ArchivePasswordDialog(
      title: title,
      requireConfirmation: requireConfirmation,
    ),
  );
}

class _ArchivePasswordDialog extends StatefulWidget {
  final String title;
  final bool requireConfirmation;

  const _ArchivePasswordDialog({
    required this.title,
    required this.requireConfirmation,
  });

  @override
  State<_ArchivePasswordDialog> createState() => _ArchivePasswordDialogState();
}

class _ArchivePasswordDialogState extends State<_ArchivePasswordDialog> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (password.trim().isEmpty) {
      setState(() => _error = l10n.archivePasswordRequired);
      return;
    }
    if (password.length < 8) {
      setState(() => _error = l10n.archivePasswordTooShort);
      return;
    }
    if (widget.requireConfirmation && password != confirm) {
      setState(() => _error = l10n.archivePasswordMismatch);
      return;
    }
    Navigator.of(context).pop(password);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(widget.title, style: AppTypography.headlineMedium),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _passwordController,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: l10n.archivePassword,
              errorText: _error,
            ),
            onSubmitted: (_) => _submit(),
          ),
          if (widget.requireConfirmation) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _confirmController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: l10n.archiveConfirmPassword,
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: !_obscure,
                onChanged: (v) => setState(() => _obscure = !(v ?? false)),
              ),
              Text(l10n.archiveShowPassword, style: AppTypography.labelMedium),
            ],
          ),
          Text(
            l10n.archivePasswordHint,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

