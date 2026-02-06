import 'package:flutter/material.dart';

import '../theme/lab_colors.dart';

/// Scaffold that applies lab background and safe areas by default.
class LabScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool useSafeArea;
  final EdgeInsetsGeometry? padding;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final bool ambientBackground;

  const LabScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.useSafeArea = true,
    this.padding,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    this.ambientBackground = true,
  });

  BoxDecoration _ambientDecoration(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = LabColors.backgroundFor(brightness);
    final tint = isDark ? const Color(0xFF0B1220) : const Color(0xFFF7F9FF);
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [base, tint],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    LabColors.setBrightness(brightness);
    final content = padding == null ? body : Padding(padding: padding!, child: body);
    final safeContent = useSafeArea
        ? SafeArea(top: appBar == null, child: content)
        : content;

    return Scaffold(
      backgroundColor: backgroundColor ?? LabColors.background,
      appBar: appBar,
      body: (backgroundColor == null && ambientBackground)
          ? DecoratedBox(
              decoration: _ambientDecoration(brightness),
              child: safeContent,
            )
          : safeContent,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
