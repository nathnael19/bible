import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/bible_version.dart';
import '../cubit/version_selector_cubit.dart';
import '../screens/compare_versions_screen.dart';

/// Shows the redesigned Bible Version Comparison Selector bottom-sheet modal.
void showVersionSelectorModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (_) => BlocProvider(
      create: (_) => sl<VersionSelectorCubit>()..loadVersions(),
      child: const _VersionSelectorSheet(),
    ),
  );
}

class _VersionSelectorSheet extends StatefulWidget {
  const _VersionSelectorSheet();

  @override
  State<_VersionSelectorSheet> createState() => _VersionSelectorSheetState();
}

class _VersionSelectorSheetState extends State<_VersionSelectorSheet> {
  int _activeTab = 0; // 0: Versions, 1: By Language

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _DragHandle(),
          
          // ── Header ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'የመጽሐፍ ቅዱስ ቅጂዎች',
                    style: tt.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Noto Serif Ethiopic',
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: Colors.black54,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),

          // ── Tab Toggle ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _TabButton(
                    label: 'የመጽሐፍ ቅዱስ ቅጂዎች',
                    isActive: _activeTab == 0,
                    onTap: () => setState(() => _activeTab = 0),
                  ),
                  _TabButton(
                    label: 'በቋንቋ',
                    isActive: _activeTab == 1,
                    onTap: () => setState(() => _activeTab = 1),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Version List ───────────────────────────────────────────
          Flexible(
            child: BlocBuilder<VersionSelectorCubit, VersionSelectorState>(
              builder: (context, state) {
                if (state is VersionSelectorLoading) {
                  return const Center(child: CircularProgressIndicator(color: SabaColors.primary));
                }

                if (state is VersionSelectorLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                    itemCount: state.versions.length,
                    itemBuilder: (context, i) {
                      final version = state.versions[i];
                      final isSelected = state.selectedId == version.id;
                      return _VersionCard(
                        version: version,
                        isSelected: isSelected,
                        onTap: () {
                          context.read<VersionSelectorCubit>().selectVersion(version.id);
                          // Navigate to comparison screen after short delay
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CompareVersionsScreen(),
                                ),
                              );
                            }
                          });
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? Colors.black87 : Colors.black45,
              fontFamily: 'Noto Serif Ethiopic',
            ),
          ),
        ),
      ),
    );
  }
}

class _VersionCard extends StatelessWidget {
  final BibleVersion version;
  final bool isSelected;
  final VoidCallback onTap;

  const _VersionCard({
    required this.version,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? SabaColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      version.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                        fontFamily: 'Noto Serif Ethiopic',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      version.language,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white70 : Colors.black38,
                        fontFamily: 'Noto Serif Ethiopic',
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD700), // Gold
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: SabaColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
