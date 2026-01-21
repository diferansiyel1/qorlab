import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
        'Custom Color (Teal)',
        GloveButton(
          label: 'CUSTOM',
          icon: Icons.timer,
          backgroundColor: AppColors.tealScience,
          onPressed: () {},
        ),
      )
      ..addScenario(
        'Warning (Red)',
        GloveButton(
          label: 'DANGER',
          icon: Icons.warning,
          backgroundColor: AppColors.biohazardRed,
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
               _colorBox('Deep Lab Blue', AppColors.deepLabBlue),
               _colorBox('Sterile White', AppColors.sterileWhite),
               _colorBox('Teal Science', AppColors.tealScience),
               _colorBox('Border Dark', AppColors.borderDark),
               _colorBox('Biohazard Red', AppColors.biohazardRed),
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
      seedColor: AppColors.deepLabBlue,
      brightness: brightness,
      primary: AppColors.deepLabBlue,
      secondary: AppColors.tealScience,
      error: AppColors.biohazardRed,
      surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
    ),
    scaffoldBackgroundColor: isDark ? AppColors.oledBlack : AppColors.sterileWhite,
    cardTheme: CardThemeData(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
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
