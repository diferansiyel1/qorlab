import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/files/files_page.dart';
import 'features/tools/lab_tools_page.dart';
import 'features/settings/settings_page.dart';

/// Main home page with bottom navigation matching stich design
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentIndex: _currentIndex,
      onTabTapped: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      onFabPressed: () {
        // "Quick Calc" - Navigate to free mode / scratchpad
        context.push('/free-mode');
      },
      onFabLongPressed: () {
        // "Big Bang" - Start New Experiment
        context.push('/experiment/new');
      },
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const DashboardPage(),
          const FilesPage(),
          const LabToolsPage(),
          const SettingsPage(),
        ],
      ),
    );
  }

}
