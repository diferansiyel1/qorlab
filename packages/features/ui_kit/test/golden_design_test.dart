import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  testGoldens('GloveButton Design Variants', (tester) async {
    final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 3.5)
      ..addScenario(
        'Primary Button',
        GloveButton(
          label: 'PRIMARY',
          icon: Icons.science,
          onPressed: () {},
        ),
      )
      ..addScenario(
        'Secondary Button',
        GloveButton(
          label: 'SECONDARY',
          icon: Icons.folder_open,
          isPrimary: false,
          onPressed: () {},
        ),
      )
      ..addScenario(
        'Custom Color (Teal/Success)',
        GloveButton(
          label: 'CUSTOM',
          icon: Icons.timer,
          backgroundColor: AppColors.success,
          onPressed: () {},
        ),
      )
      ..addScenario(
        'Warning (Red/Alert)',
        GloveButton(
          label: 'DANGER',
          icon: Icons.warning,
          backgroundColor: AppColors.alert,
          onPressed: () {},
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: materialAppWrapper(
        theme: _createOfflineTheme(Brightness.light),
      ),
      surfaceSize: const Size(800, 600),
    );

    await screenMatchesGolden(tester, 'glove_button_grid');
  });

  testGoldens('Theme Colors Reference', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario(
        'Color Palette',
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
               _colorBox('Primary (Blue)', AppColors.primary),
               _colorBox('Text Main', AppColors.textMain),
               _colorBox('Success (Green)', AppColors.success),
               _colorBox('Glass Border', AppColors.glassBorder),
               _colorBox('Alert (Red)', AppColors.alert),
            ],
          ),
        ),
      );

      await tester.pumpWidgetBuilder(builder.build(), surfaceSize: const Size(600, 400));
      await screenMatchesGolden(tester, 'color_palette');
  });
}

ThemeData _createOfflineTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      secondary: AppColors.success,
      error: AppColors.alert,
      surface: isDark ? AppColors.surface : Colors.white,
    ),
    scaffoldBackgroundColor: isDark ? AppColors.background : Colors.white,
    cardTheme: CardThemeData(
      color: isDark ? AppColors.surface : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.glassBorder : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
    ),
  );
}

Widget _colorBox(String name, Color color) {
  return Container(
    width: 100,
    height: 100,
    color: color,
    alignment: Alignment.center,
    child: Text(
      name, 
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white
      )
    ),
  );
}
