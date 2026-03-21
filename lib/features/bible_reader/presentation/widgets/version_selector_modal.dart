import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible/l10n/app_localizations.dart';

import '../../../../core/di/injection_container.dart';
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
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.50,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
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
                    l10n.bibleVersions,
                    style: tt.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Noto Serif Ethiopic',
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),

          // ── Tab Toggle ──────────────────────────────────────────────

          // ── Version List ───────────────────────────────────────────
          Flexible(
            child: BlocBuilder<VersionSelectorCubit, VersionSelectorState>(
              builder: (context, state) {
                if (state is VersionSelectorLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                  );
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
                          final navigator = Navigator.of(context);
                          context.read<VersionSelectorCubit>().selectVersion(
                            version.id,
                          );
                          // Navigate to comparison screen after short delay
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              navigator.pop();
                              navigator.push(
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
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.03),
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
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimary 
                            : Theme.of(context).colorScheme.onSurface,
                        fontFamily: 'Noto Serif Ethiopic',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      version.language,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8) 
                            : Theme.of(context).colorScheme.onSurfaceVariant,
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
                  child: Icon(
                    Icons.check,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
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
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
