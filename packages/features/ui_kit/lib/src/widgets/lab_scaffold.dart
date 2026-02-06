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
  });

  @override
  Widget build(BuildContext context) {
    LabColors.setBrightness(Theme.of(context).brightness);
    final content = padding == null ? body : Padding(padding: padding!, child: body);
    final safeContent = useSafeArea
        ? SafeArea(top: appBar == null, child: content)
        : content;

    return Scaffold(
      backgroundColor: backgroundColor ?? LabColors.background,
      appBar: appBar,
      body: safeContent,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
