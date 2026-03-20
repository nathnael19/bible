import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';

import '../cubit/navigation_cubit.dart';

import '../screens/home_screen.dart';
import '../screens/bible_reader_screen.dart';
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
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          body: NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification) {
              final cubit = context.read<NavigationCubit>();
              final delta = notification.scrollDelta ?? 0;

              // Hide on scroll down (content up)
              if (delta > 2.0 && cubit.state.isBottomNavVisible) {
                cubit.setBottomNavVisible(false);
              }
              // Show on scroll up (content down) OR "hard scroll" down
              else if (delta < -15.0 && !cubit.state.isBottomNavVisible) {
                cubit.setBottomNavVisible(true);
              }
              return false;
            },
            child: IndexedStack(index: state.selectedIndex, children: _pages),
          ),
          bottomNavigationBar: AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            offset: state.isBottomNavVisible ? Offset.zero : const Offset(0, 1),
            child: _CustomBottomBar(
              selectedIndex: state.selectedIndex,
              onTap: (idx) => context.read<NavigationCubit>().setTab(idx),
            ),
          ),
        );
      },
    );
  }
}

class _CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const _CustomBottomBar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'መጀመሪያ',
              isSelected: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.auto_stories_rounded,
              label: 'ንባብ',
              isSelected: selectedIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: 'መገለጫ',
              isSelected: selectedIndex == 2,
              onTap: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? SabaColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : SabaColors.primary.withValues(alpha: 0.8),
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: SabaColors.primary.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Noto Serif Ethiopic',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
