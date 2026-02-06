import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ui_kit/ui_kit.dart';

/// Settings page with app preferences
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String _weightUnit = 'g';
  String _volumeUnit = 'mL';
  String _tempUnit = '°C';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Settings',
              style: AppTypography.headlineLarge,
            ),
            const SizedBox(height: 24),

            // Display section
            Text(
              'DISPLAY',
              style: AppTypography.labelUppercase,
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.color_lens_outlined,
              title: 'Theme',
              subtitle: 'Light, dark, or system default',
              trailing: _ThemeModeToggle(
                selected: ref.watch(themeModeProvider),
                onChanged: (mode) {
                  ref.read(themeModeProvider.notifier).state = mode;
                },
              ),
            ),

            const SizedBox(height: 24),

            // Units section
            Text(
              'UNITS',
              style: AppTypography.labelUppercase,
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.scale_rounded,
              title: 'Weight',
              subtitle: 'Default weight unit',
              trailing: _UnitToggle(
                options: const ['mg', 'g', 'kg'],
                selected: _weightUnit,
                onChanged: (val) => setState(() => _weightUnit = val),
              ),
            ),
            const SizedBox(height: 8),
            _SettingsTile(
              icon: Icons.water_drop_rounded,
              title: 'Volume',
              subtitle: 'Default volume unit',
              trailing: _UnitToggle(
                options: const ['µL', 'mL', 'L'],
                selected: _volumeUnit,
                onChanged: (val) => setState(() => _volumeUnit = val),
              ),
            ),
            const SizedBox(height: 8),
            _SettingsTile(
              icon: Icons.thermostat_rounded,
              title: 'Temperature',
              subtitle: 'Default temperature unit',
              trailing: _UnitToggle(
                options: const ['°C', '°F'],
                selected: _tempUnit,
                onChanged: (val) => setState(() => _tempUnit = val),
              ),
            ),

            const SizedBox(height: 24),

            // Data section
            Text(
              'DATA',
              style: AppTypography.labelUppercase,
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.cloud_upload_rounded,
              title: 'Export All Data',
              subtitle: 'Download experiments as CSV',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
              onTap: () => _showExportDialog(),
            ),
            const SizedBox(height: 8),
            _SettingsTile(
              icon: Icons.delete_outline_rounded,
              title: 'Clear Cache',
              subtitle: 'Free up storage space',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
              onTap: () => _showClearCacheDialog(),
            ),

            const SizedBox(height: 24),

            // About section
            Text(
              'ABOUT',
              style: AppTypography.labelUppercase,
            ),
            const SizedBox(height: 12),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final version = snapshot.data?.version ?? '1.0.0';
                final buildNumber = snapshot.data?.buildNumber ?? '1';
                return _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'QorLab',
                  subtitle: 'Version $version ($buildNumber)',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'BETA',
                      style: AppTypography.statusBadge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 100), // Bottom padding for nav bar
          ],
        ),
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Export Data',
          style: AppTypography.headlineMedium,
        ),
        content: Text(
          'This will export all experiment data as CSV files.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export started...')),
              );
            },
            child: const Text('EXPORT'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Clear Cache',
          style: AppTypography.headlineMedium,
        ),
        content: Text(
          'This will clear temporary files and cached data.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alert,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared')),
              );
            },
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLarge,
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _ThemeModeToggle extends StatelessWidget {
  final ThemeMode selected;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeModeToggle({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(value: ThemeMode.system, label: Text('System')),
        ButtonSegment(value: ThemeMode.light, label: Text('Light')),
        ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
      ],
      selected: {selected},
      onSelectionChanged: (value) => onChanged(value.first),
      style: SegmentedButton.styleFrom(
        minimumSize: const Size(64, 40),
        backgroundColor: AppColors.background,
        selectedBackgroundColor: AppColors.primary.withValues(alpha: 0.15),
        selectedForegroundColor: AppColors.primary,
        foregroundColor: AppColors.textMuted,
        side: BorderSide(color: AppColors.glassBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _UnitToggle extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  const _UnitToggle({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option == selected;
          return GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                option,
                style: AppTypography.labelSmall.copyWith(
                  color: isSelected ? AppColors.background : AppColors.textMuted,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
