import 'package:bible/features/bible_reader/presentation/screens/audio_player_screen.dart';
import 'package:bible/features/bible_reader/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/bible_reader_cubit.dart';
import '../cubit/navigation_cubit.dart';
import '../cubit/theme_cubit.dart';
import 'library_screen.dart';
import '../widgets/scripture_scrubber.dart';
import '../widgets/version_selector_modal.dart';
import '../widgets/verse_card.dart';

/// Redesigned Bible Reader screen with stable tree management and auto-scrolling.
class BibleReaderScreen extends StatefulWidget {
  const BibleReaderScreen({super.key});

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  // Use a map that we clear on chapter changes to avoid stale key issues
  final Map<int, GlobalKey> _verseKeys = {};
  late ScrollController _scrollController;

  // Track current book/chapter to detect transitions
  String? _currentBook;
  int? _currentChapter;

  double _fontSizeFactor = 1.0;
  double _baseFontSizeFactor = 1.0;

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

    if (context != null && context.mounted) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        alignment: 0.5,
      );
    } else {
      // Fallback: Estimate position to bring into view if not yet built
      final approximateOffset = 200.0 + (verseNumber * 110.0);
      if (_scrollController.hasClients) {
        _scrollController
            .animateTo(
              approximateOffset.clamp(
                0,
                _scrollController.position.maxScrollExtent,
              ),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            )
            .then((_) {
              if (!mounted) return;
              final retryContext = _verseKeys[verseNumber]?.currentContext;
              if (retryContext != null && retryContext.mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BibleReaderCubit, BibleReaderState>(
      listenWhen: (prev, curr) {
        if (prev is BibleReaderLoaded && curr is BibleReaderLoaded) {
          // Scroll if verse changed OR if it's the same chapter initial load
          return prev.activeVerseNumber != curr.activeVerseNumber ||
              prev.chapter != curr.chapter;
        }
        return curr is BibleReaderLoaded;
      },
      listener: (context, state) {
        if (state is BibleReaderLoaded) {
          // If chapter/book changed, clear keys to prevent element tree corruption
          if (state.book != _currentBook || state.chapter != _currentChapter) {
            _verseKeys.clear();
            _currentBook = state.book;
            _currentChapter = state.chapter;
          }

          if (state.activeVerseNumber != null) {
            // Wait for builder to finish before scrolling
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _scrollToVerse(state.activeVerseNumber!);
            });
          } else if (state.book != _currentBook || state.chapter != _currentChapter) {
            // Scroll to top on chapter change if no verse targeted
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _scrollController.hasClients) {
                _scrollController.jumpTo(0);
              }
            });
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          extendBodyBehindAppBar: true,
          appBar: _CustomReaderAppBar(state: state),
          body: GestureDetector(
            onScaleStart: (details) {
              _baseFontSizeFactor = _fontSizeFactor;
            },
            onScaleUpdate: (details) {
              setState(() {
                _fontSizeFactor = (_baseFontSizeFactor * details.scale).clamp(
                  0.8,
                  3.0,
                );
              });
            },
            child: Stack(
              children: [
                _buildContent(context, state),
                // ── Side Floating Buttons ─────────────────────────────────
                BlocBuilder<NavigationCubit, NavigationState>(
                  builder: (context, navState) {
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      right: 20,
                      bottom: navState.isBottomNavVisible ? 105 : 40,
                      child: Column(
                        children: [
                          _FloatingControl(
                            iconData: Icons.play_arrow,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AudioPlayerScreen(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _FloatingControl(
                            iconData: Icons.dark_mode_outlined,
                            onTap: () =>
                                context.read<ThemeCubit>().toggleTheme(),
                          ),
                          const SizedBox(height: 12),
                          const _FloatingControl(
                            iconData: Icons.share_rounded,
                            isPrimary: true,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // ── Verse Action Toolbar ──────────────────────────────────
                if (state is BibleReaderLoaded &&
                    state.activeVerseNumber != null)
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 30, // Above bottom nav if visible?
                    child: _VerseActionToolbar(
                      verseNumber: state.activeVerseNumber!,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, BibleReaderState state) {
    if (state is BibleReaderLoading) {
      return const Center(
        child: CircularProgressIndicator(color: SabaColors.primary),
      );
    }

    if (state is BibleReaderLoaded) {
      // Ensure keys are initialized for the current list
      for (final verse in state.verses) {
        _verseKeys.putIfAbsent(verse.number, () => GlobalKey());
      }

      return CustomScrollView(
        controller: _scrollController,
        cacheExtent: 4000,
        // Using a key that changes with book/chapter forces a fresh tree for the list
        key: PageStorageKey('reader_${state.book}_${state.chapter}'),
        slivers: [
          SliverToBoxAdapter(
            child: _ChapterHeader(
              state: state,
              fontSizeFactor: _fontSizeFactor,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final verse = state.verses[i];
                  final isBookmarked = state.bookmarks.contains(verse.number);
                  final highlightColorValue = state.highlights[verse.number];
                  final highlightColor = highlightColorValue != null
                      ? Color(highlightColorValue)
                      : null;

                  return VerseCard(
                    key: _verseKeys[verse.number],
                    verse: verse,
                    isActive: state.activeVerseNumber == verse.number,
                    fontSizeFactor: _fontSizeFactor,
                    isBookmarked: isBookmarked,
                    highlightColor: highlightColor,
                    onTap: () => context.read<BibleReaderCubit>().selectVerse(
                      state.activeVerseNumber == verse.number ? null : verse.number,
                    ),
                    onDoubleTap: () => context.read<BibleReaderCubit>().selectVerse(null),
                  );
                },
                childCount: state.verses.length,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
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
        totalItems: state.chapterCount,
        activeIndex: state.chapter,
        isChapterMode: true,
        onItemSelected: (v) =>
            context.read<BibleReaderCubit>().navigateToChapter(v),
      );
    }
    return const SizedBox.shrink();
  }
}

class _ChapterHeader extends StatelessWidget {
  final BibleReaderLoaded state;
  final double fontSizeFactor;
  const _ChapterHeader({required this.state, this.fontSizeFactor = 1.0});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight + 20),
          Text(
            '${state.chapter}',
            style: TextStyle(
              fontSize: 64 * fontSizeFactor,
              fontFamily: 'Noto Serif Ethiopic',
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.2),
              fontWeight: FontWeight.w100,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'ምዕራፍ ${state.chapter}',
            style: tt.headlineMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontFamily: 'Noto Serif Ethiopic',
              letterSpacing: 1.2,
              fontSize: (tt.headlineMedium?.fontSize ?? 28) * fontSizeFactor,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 60,
            height: 1,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
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
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return AppBar(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu, color: theme.colorScheme.onSurfaceVariant),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LibraryScreen()),
        ),
      ),
      title: state is BibleReaderLoaded
          ? Builder(
              builder: (context) {
                final loaded = state as BibleReaderLoaded;
                return Column(
                  children: [
                    Text(
                      '${loaded.book} ${loaded.chapter}',
                      style: tt.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      int.parse(loaded.bookId) <= 39 ? 'ብሉይ ኪዳን' : 'ሐዲስ ኪዳን',
                      style: tt.labelSmall!.copyWith(
                        color: SabaColors.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                );
              },
            )
          : const Text('...'),
      actions: [
        IconButton(
          icon: Icon(
            Icons.compare_arrows_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          onPressed: () => showVersionSelectorModal(context),
        ),
        IconButton(
          icon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          ),
        ),
      ],
    );
  }
}

class _FloatingControl extends StatelessWidget {
  final IconData? iconData;
  final bool isPrimary;
  final VoidCallback? onTap;

  const _FloatingControl({
    this.iconData,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isPrimary
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
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
        child: Icon(
          iconData,
          color: isPrimary
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
          size: 20,
        ),
      ),
    );
  }
}

class _VerseActionToolbar extends StatelessWidget {
  final int verseNumber;

  const _VerseActionToolbar({required this.verseNumber});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<BibleReaderCubit>();
    final state = cubit.state as BibleReaderLoaded;
    final isBookmarked = state.bookmarks.contains(verseNumber);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ActionButton(
            icon: isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_outline_rounded,
            label: 'መዝግብ',
            isActive: isBookmarked,
            onTap: () => cubit.toggleBookmark(verseNumber),
          ),
          _divider(theme),
          _ActionButton(
            icon: Icons.format_color_fill_rounded,
            label: 'ቀለም',
            onTap: () {
              final currentHighlight = state.highlights[verseNumber];
              if (currentHighlight != null) {
                cubit.setHighlight(verseNumber, null);
              } else {
                cubit.setHighlight(
                  verseNumber,
                  theme.colorScheme.primary.withValues(alpha: 0.2).toARGB32(),
                );
              }
            },
          ),
          _divider(theme),
          _ActionButton(
            icon: Icons.copy_rounded,
            label: 'ቅዳ',
            onTap: () {
              // Copy logic would go here
              cubit.selectVerse(null);
            },
          ),
          _divider(theme),
          _ActionButton(
            icon: Icons.close_rounded,
            label: 'ዝጋ',
            onTap: () => cubit.selectVerse(null),
          ),
        ],
      ),
    );
  }

  Widget _divider(ThemeData theme) {
    return Container(
      height: 24,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: theme.colorScheme.outline.withValues(alpha: 0.1),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall!.copyWith(
                fontSize: 9,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
