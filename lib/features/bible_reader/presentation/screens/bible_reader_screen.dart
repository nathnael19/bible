import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/bible_reader_cubit.dart';
import '../widgets/scripture_scrubber.dart';
import '../widgets/version_selector_modal.dart';
import '../widgets/verse_card.dart';

class BibleReaderScreen extends StatelessWidget {
  const BibleReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleReaderCubit, BibleReaderState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: SabaColors.surface,
          extendBodyBehindAppBar: true,
          appBar: _GlassmorphicAppBar(state: state),
          body: _buildBody(context, state),
          floatingActionButton: _CompareVersionsButton(state: state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BibleReaderState state) {
    if (state is BibleReaderLoading) {
      return const Center(
        child: CircularProgressIndicator(color: SabaColors.primaryContainer),
      );
    }

    if (state is BibleReaderError) {
      return Center(
        child: Text(state.message,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: SabaColors.error)),
      );
    }

    if (state is BibleReaderLoaded) {
      return Column(
        children: [
          // ── Scripture Scrubber ─────────────────────────────────────────
          Container(
            color: SabaColors.surfaceContainerLow,
            padding: const EdgeInsets.only(top: kToolbarHeight + 28),
            child: ScriptureScrubber(
              totalChapters: 50,
              activeChapter: state.chapter,
              onChapterSelected: (ch) =>
                  context.read<BibleReaderCubit>().navigateToChapter(ch),
            ),
          ),
          // ── Verse List ─────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(32, 24, 16, 100),
              itemCount: state.verses.length,
              itemBuilder: (_, i) {
                final verse = state.verses[i];
                return VerseCard(
                  verse: verse,
                  isActive: state.activeVerseNumber == verse.number,
                  onTap: () => context
                      .read<BibleReaderCubit>()
                      .selectVerse(verse.number),
                );
              },
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

/// Glassmorphic app bar — surface 80% opacity + 20px backdrop blur (DESIGN.md)
class _GlassmorphicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final BibleReaderState state;
  const _GlassmorphicAppBar({required this.state});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    String title = 'ዘፍጥረት';
    String subtitle = 'Chapter 1';
    if (state is BibleReaderLoaded) {
      final s = state as BibleReaderLoaded;
      title = s.book;
      subtitle = 'Chapter ${s.chapter}';
    }

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AppBar(
          backgroundColor: SabaColors.surface.withValues(alpha: 0.8),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: const BackButton(color: SabaColors.onSurface),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: tt.titleMedium),
              Text(subtitle,
                  style: tt.labelSmall!
                      .copyWith(color: SabaColors.onSurfaceVariant)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_border_outlined),
              color: SabaColors.onSurfaceVariant,
              onPressed: () {},
              tooltip: 'Bookmark',
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined),
              color: SabaColors.onSurfaceVariant,
              onPressed: () {},
              tooltip: 'Share',
            ),
          ],
        ),
      ),
    );
  }
}

/// "Compare Versions" pill button — triggers the PRD modal
class _CompareVersionsButton extends StatelessWidget {
  final BibleReaderState state;
  const _CompareVersionsButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton.icon(
        onPressed: () => showVersionSelectorModal(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          elevation: 0,
          shape: const StadiumBorder(),
        ).copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
        ),
        icon: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SabaColors.primary, SabaColors.primaryContainer],
            ),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.compare_arrows_rounded,
                  color: SabaColors.onPrimary, size: 18),
              const SizedBox(width: 8),
              Text(
                'COMPARE VERSIONS',
                style: tt.labelMedium!.copyWith(
                    color: SabaColors.onPrimary, letterSpacing: 0.8),
              ),
            ],
          ),
        ),
        label: const SizedBox.shrink(),
      ),
    );
  }
}
