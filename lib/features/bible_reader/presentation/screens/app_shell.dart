import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';

import '../cubit/navigation_cubit.dart';

import '../screens/home_screen.dart';
import '../screens/bible_reader_screen.dart';
import '../screens/library_screen.dart';
import '../screens/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {

  static const List<Widget> _pages = [
    HomeScreen(),
    BibleReaderScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          body: IndexedStack(index: selectedIndex, children: _pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (idx) =>
                context.read<NavigationCubit>().setTab(idx),
            backgroundColor: SabaColors.surfaceContainerLowest,
            indicatorColor: SabaColors.primary,
            surfaceTintColor: Colors.transparent,
            elevation: 10,
            height: 80,
            destinations: [
              _navDestination(Icons.home_outlined, Icons.home_filled, 'መነሻ'),
              _navDestination(
                Icons.menu_book_outlined,
                Icons.menu_book_rounded,
                'ንባብ',
              ),
              _navDestination(
                Icons.collections_bookmark_outlined,
                Icons.collections_bookmark_rounded,
                'መጽሐፍ',
              ),
              _navDestination(
                Icons.person_outline_rounded,
                Icons.person_rounded,
                'መገለጫ',
              ),
            ],
          ),
          floatingActionButton: selectedIndex == 0
              ? FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: SabaColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  mini: true,
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  NavigationDestination _navDestination(
    IconData icon,
    IconData selectedIcon,
    String label,
  ) {
    return NavigationDestination(
      icon: Icon(icon, color: SabaColors.onSurfaceVariant),
      selectedIcon: Icon(selectedIcon, color: Colors.white),
      label: label,
    );
  }
}
