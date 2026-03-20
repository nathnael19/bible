import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/bible_reader_cubit.dart';
import '../widgets/scripture_scrubber.dart';
import '../widgets/version_selector_modal.dart';
import '../widgets/verse_card.dart';

/// Redesigned Bible Reader screen with Auto-Center and Chapter Scrubber.
class BibleReaderScreen extends StatefulWidget {
  const BibleReaderScreen({super.key});

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  final Map<int, GlobalKey> _verseKeys = {};
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToVerse(int verseNumber) {
    final key = _verseKeys[verseNumber];
    final context = key?.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        alignment: 0.5, // Center in viewport
      );
    } else {
      // Fallback: Estimate position if not in tree
      final approximateOffset = 200.0 + (verseNumber * 100.0);
      _scrollController
          .animateTo(
            approximateOffset.clamp(0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          )
          .then((_) {
            if (!mounted) return;
            final retryContext = _verseKeys[verseNumber]?.currentContext;
            if (retryContext != null) {
              Scrollable.ensureVisible(
                retryContext,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                alignment: 0.5,
              );
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BibleReaderCubit, BibleReaderState>(
      listenWhen: (prev, curr) {
        if (prev is BibleReaderLoaded && curr is BibleReaderLoaded) {
          // Trigger scroll only if verse selection changed or new chapter loaded
          return prev.activeVerseNumber != curr.activeVerseNumber || 
                 prev.chapter != curr.chapter;
        }
        return curr is BibleReaderLoaded;
      },
      listener: (context, state) {
        if (state is BibleReaderLoaded && state.activeVerseNumber != null) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) _scrollToVerse(state.activeVerseNumber!);
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: SabaColors.surface,
          extendBodyBehindAppBar: true,
          appBar: _CustomReaderAppBar(state: state),
          body: Stack(
            children: [
              _buildSliverContent(context, state),
              // ── Side Floating Buttons ─────────────────────────────────
              Positioned(
                right: 20,
                bottom: 40,
                child: Column(
                  children: [
                    const _FloatingControl(icon: 'TT'),
                    const SizedBox(height: 12),
                    const _FloatingControl(iconData: Icons.dark_mode_outlined),
                    const SizedBox(height: 12),
                    const _FloatingControl(
                      iconData: Icons.share_rounded,
                      isPrimary: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverContent(BuildContext context, BibleReaderState state) {
    if (state is BibleReaderLoading) {
      return const Center(child: CircularProgressIndicator(color: SabaColors.primary));
    }

    if (state is BibleReaderLoaded) {
      // Initialize or update keys for verses
      for (final verse in state.verses) {
        _verseKeys.putIfAbsent(verse.number, () => GlobalKey());
      }

      return CustomScrollView(
        controller: _scrollController,
        cacheExtent: 3000,
        key: ValueKey('reader_${state.book}_${state.chapter}'),
        slivers: [
          const SliverToBoxAdapter(child: _ChapterHeader()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final verse = state.verses[i];
                  return VerseCard(
                    key: _verseKeys[verse.number],
                    verse: verse,
                    isActive: state.activeVerseNumber == verse.number,
                    onTap: () => context.read<BibleReaderCubit>().selectVerse(verse.number),
                  );
                },
                childCount: state.verses.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: _buildScrubber(context, state),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildScrubber(BuildContext context, BibleReaderState state) {
    if (state is BibleReaderLoaded) {
      return ScriptureScrubber(
        key: ValueKey('scrubber_${state.book}_${state.chapter}'),
        totalItems: 50, // Mocked total chapters
        activeIndex: state.chapter,
        isChapterMode: true,
        onItemSelected: (v) => context.read<BibleReaderCubit>().navigateToChapter(v),
      );
    }
    return const SizedBox.shrink();
  }
}

class _ChapterHeader extends StatelessWidget {
  const _ChapterHeader();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight + 20),
          // Ornate Ge'ez numeral icon
          Text(
            '፩',
            style: TextStyle(
              fontSize: 64,
              fontFamily: 'Noto Serif Ethiopic',
              color: SabaColors.secondary.withValues(alpha: 0.2),
              fontWeight: FontWeight.w100,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'ምዕራፍ አንድ',
            style: tt.headlineMedium!.copyWith(
              color: SabaColors.primary,
              fontWeight: FontWeight.bold,
              fontFamily: 'Noto Serif Ethiopic',
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 60,
            height: 1,
            color: SabaColors.outlineVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _CustomReaderAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final BibleReaderState state;
  const _CustomReaderAppBar({required this.state});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: SabaColors.surface.withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: SabaColors.onSurfaceVariant),
        onPressed: () {},
      ),
      title: Column(
        children: [
          Text(
            'ኦሪት ዘፍጥረት ፩',
            style: tt.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'ብሉይ ኪዳን',
            style: tt.labelSmall!.copyWith(
              color: SabaColors.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.compare_arrows_rounded,
            color: SabaColors.onSurfaceVariant,
          ),
          onPressed: () => showVersionSelectorModal(context),
        ),
        IconButton(
          icon: const Icon(Icons.search, color: SabaColors.onSurfaceVariant),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _FloatingControl extends StatelessWidget {
  final String? icon;
  final IconData? iconData;
  final bool isPrimary;

  const _FloatingControl({this.icon, this.iconData, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isPrimary ? SabaColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: icon != null
          ? Text(
              icon!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )
          : Icon(
              iconData,
              color: isPrimary ? Colors.white : SabaColors.onSurface,
              size: 20,
            ),
    );
  }
}
