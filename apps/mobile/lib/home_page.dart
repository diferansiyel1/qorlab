import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'features/dashboard/dashboard_page.dart';

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
        // "Big Bang" - Start New Experiment
        // For now, navigate to experiment/1 or similar
        // Ideally show a modal or create a new one.
        context.push('/experiment/2'); // Simulate new experiment
      },
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const DashboardPage(),
          const Center(child: Text("Lab Tools (Coming Soon)", style: TextStyle(color: Colors.white))),
          const Center(child: Text("Settings (Coming Soon)", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
