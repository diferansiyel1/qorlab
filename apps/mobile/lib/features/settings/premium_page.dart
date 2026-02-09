import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:premium_access/premium_access.dart';
import 'package:ui_kit/ui_kit.dart';

class PremiumPage extends ConsumerWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(premiumControllerProvider);
    final controller = ref.read(premiumControllerProvider.notifier);

    final statusText = state.isPremium
        ? l10n.premiumStatusPremium
        : state.hasGraceAccess
        ? l10n.premiumStatusGrace
        : l10n.premiumStatusFree;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.premium)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.premium, style: AppTypography.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  l10n.premiumManageSubtitle,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 12),
                Text(
                  statusText,
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  state.hasAccess ? l10n.premiumHasAccess : l10n.premiumNoAccess,
                  style: AppTypography.bodySmall,
                ),
                if (state.graceUntil != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${l10n.premiumGraceUntil}: ${state.graceUntil}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                  ),
                ],
                if (state.error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    state.error!,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.alert),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: state.loading ? null : () => controller.refresh(),
            icon: const Icon(Icons.sync_rounded),
            label: Text(l10n.premiumRefresh),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: state.loading ? null : () => controller.restore(),
            icon: const Icon(Icons.restore_rounded),
            label: Text(l10n.premiumRestore),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: state.loading ? null : () => controller.activateLocalPremium(),
            icon: const Icon(Icons.lock_open_rounded),
            label: Text(l10n.premiumUnlockLocal),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: state.loading ? null : () => controller.startOfflineGrace(),
            icon: const Icon(Icons.schedule_rounded),
            label: Text(l10n.premiumStartGrace),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: state.loading ? null : () => controller.revokePremium(),
            icon: const Icon(Icons.lock_outline_rounded),
            label: Text(l10n.premiumRevoke),
          ),
        ],
      ),
    );
  }
}

