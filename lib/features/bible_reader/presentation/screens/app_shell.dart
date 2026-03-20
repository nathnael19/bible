import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

import '../screens/audio_player_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(), // Placeholder for 'ንባብ' list
    AudioPlayerScreen(), // Placeholder for 'መጽሐፍ' list
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        backgroundColor: SabaColors.surfaceContainerLowest,
        indicatorColor: SabaColors.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 10,
        height: 80,
        destinations: [
          _navDestination(Icons.home_outlined, Icons.home_filled, 'መነሻ'),
          _navDestination(Icons.menu_book_outlined, Icons.menu_book_rounded, 'ንባብ'),
          _navDestination(Icons.collections_bookmark_outlined, Icons.collections_bookmark_rounded, 'መጽሐፍ'),
          _navDestination(Icons.person_outline_rounded, Icons.person_rounded, 'መገለጫ'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: SabaColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              mini: true,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  NavigationDestination _navDestination(IconData icon, IconData selectedIcon, String label) {
    return NavigationDestination(
      icon: Icon(icon, color: SabaColors.onSurfaceVariant),
      selectedIcon: Icon(selectedIcon, color: Colors.white),
      label: label,
    );
  }
}
