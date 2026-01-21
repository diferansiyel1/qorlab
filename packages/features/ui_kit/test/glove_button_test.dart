import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  testWidgets('GloveButton adheres to minimum size constraints (56x56)', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: GloveButton(label: 'TEST'),
          ),
        ),
      ),
    );

    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);

    final Size size = tester.getSize(buttonFinder);
    expect(size.height, greaterThanOrEqualTo(56.0));
    expect(size.width, greaterThanOrEqualTo(56.0));
  });

  testWidgets('GloveButton shows label and icon', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: GloveButton(
              label: 'START',
              icon: Icons.play_arrow,
            ),
          ),
        ),
      ),
    );

    expect(find.text('START'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });
}
