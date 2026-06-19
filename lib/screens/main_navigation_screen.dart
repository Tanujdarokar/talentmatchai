import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'jobs/jobs_list_screen.dart';
import 'candidates/candidates_list_screen.dart';
import 'ranking/ranking_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const JobsListScreen(),
    const CandidatesListScreen(),
    const RankingScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: NavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              height: 65,
              destinations: [
                _buildNavItem(context, Icons.dashboard_outlined, Icons.dashboard_rounded, 'Home'),
                _buildNavItem(context, Icons.work_outline_rounded, Icons.work_rounded, 'Jobs'),
                _buildNavItem(context, Icons.people_outline_rounded, Icons.people_rounded, 'Talent'),
                _buildNavItem(context, Icons.auto_awesome_outlined, Icons.auto_awesome_rounded, 'Rank'),
                _buildNavItem(context, Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  NavigationDestination _buildNavItem(BuildContext context, IconData icon, IconData selectedIcon, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return NavigationDestination(
      icon: Icon(icon, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
      selectedIcon: Icon(selectedIcon, color: Theme.of(context).colorScheme.primary),
      label: label,
    );
  }
}
