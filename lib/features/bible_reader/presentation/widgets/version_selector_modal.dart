import '../../domain/entities/bible_version.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../core/theme/app_theme.dart';
import '../cubit/version_selector_cubit.dart';

/// Shows the Bible Version Comparison Selector bottom-sheet modal.
/// PRD requirements:
/// - Bottom-sheet sliding from bottom, dimmed background
/// - Header: "Compare Versions" (Noto Serif Ethiopic) + close button
/// - Scrollable list of versions with radio buttons on right
/// - Active state: surface-container-high + 4px burgundy left accent bar
/// - Single-selection via VersionSelectorCubit
void showVersionSelectorModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: SabaColors.onBackground.withValues(alpha: 0.4),
    builder: (_) => BlocProvider(
      create: (_) => sl<VersionSelectorCubit>()..loadVersions(),
      child: const _VersionSelectorSheet(),
    ),
  );
}

class _VersionSelectorSheet extends StatelessWidget {
  const _VersionSelectorSheet();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: SabaColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ───────────────────────────────────────────────
          const _DragHandle(),

          // ── Modal Header ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text('Compare Versions', style: tt.headlineSmall),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: SabaColors.onSurfaceVariant,
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Close',
                ),
              ],
            ),
          ),

          // ── Version List ──────────────────────────────────────────────
          Flexible(
            child: BlocBuilder<VersionSelectorCubit, VersionSelectorState>(
              builder: (context, state) {
                if (state is VersionSelectorLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: SabaColors.primaryContainer,
                      ),
                    ),
                  );
                }

                if (state is VersionSelectorError) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      state.message,
                      style: tt.bodyMedium!.copyWith(color: SabaColors.error),
                    ),
                  );
                }

                if (state is VersionSelectorLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    shrinkWrap: true,
                    itemCount: state.versions.length,
                    itemBuilder: (ctx, i) {
                      final version = state.versions[i];
                      final isSelected = state.selectedId == version.id;
                      return _VersionListTile(
                        version: version,
                        isSelected: isSelected,
                        onTap: () => ctx
                            .read<VersionSelectorCubit>()
                            .selectVersion(version.id),
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

// ── Drag Handle ───────────────────────────────────────────────────────────────

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
          color: SabaColors.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ── Version List Tile ─────────────────────────────────────────────────────────

class _VersionListTile extends StatelessWidget {
  final BibleVersion version;
  final bool isSelected;
  final VoidCallback onTap;

  const _VersionListTile({
    required this.version,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: isSelected
            ? SabaColors.surfaceContainerHigh
            : Colors.transparent,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 4px Burgundy left accent bar (active only) ─────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 4 : 0,
                color: SabaColors.primaryContainer,
              ),

              // ── Version info ────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      // Abbreviation badge
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? SabaColors.primaryContainer
                              : SabaColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          version.abbreviation,
                          style: tt.labelSmall!.copyWith(
                            color: isSelected
                                ? SabaColors.onPrimary
                                : SabaColors.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Name & language
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              version.name,
                              style: tt.bodyMedium!.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              version.language,
                              style: tt.labelSmall!.copyWith(
                                color: SabaColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Radio indicator on the right (per PRD)
                      _RadioIndicator(isSelected: isSelected),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Custom Radio Indicator ────────────────────────────────────────────────────

class _RadioIndicator extends StatelessWidget {
  final bool isSelected;
  const _RadioIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? SabaColors.primaryContainer
              : SabaColors.outlineVariant,
          width: 2,
        ),
        color: isSelected ? SabaColors.primaryContainer : Colors.transparent,
      ),
      child: isSelected
          ? const Center(
              child: Icon(
                Icons.circle,
                size: 8,
                color: SabaColors.surfaceContainerLowest,
              ),
            )
          : null,
    );
  }
}
