import 'package:bible/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/library_cubit.dart';
import '../../domain/entities/book.dart';
import '../screens/chapter_selection_screen.dart';
import '../../../../core/theme/app_theme.dart';

/// Redesigned Library/Books screen with Testament grids and reflection card.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context, l10n),
      body: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          if (state is LibraryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LibraryError) {
            return Center(child: Text(state.message));
          }
          if (state is LibraryLoaded) {
            final oldTestament = state.books
                .where((b) => int.parse(b.id) <= 39)
                .toList();
            final newTestament = state.books
                .where((b) => int.parse(b.id) > 39)
                .toList();

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  sliver: SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: l10n.oldTestament,
                      subtitle: 'Old Testament',
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.4,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final book = oldTestament[index];
                        return _BookCard(
                          number: book.id.padLeft(2, '0'),
                          title: book.name,
                          subtitle: _getEnglishName(int.parse(book.id)),
                          onTap: () => _navigateToChapters(context, book),
                        );
                      },
                      childCount: oldTestament.length,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
                  sliver: SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: l10n.newTestament,
                      subtitle: 'New Testament',
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.4,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final book = newTestament[index];
                        return _BookCard(
                          number: book.id.padLeft(2, '0'),
                          title: book.name,
                          subtitle: _getEnglishName(int.parse(book.id)),
                          onTap: () => _navigateToChapters(context, book),
                        );
                      },
                      childCount: newTestament.length,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  sliver: const SliverToBoxAdapter(child: _DailyReflectionCard()),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _navigateToChapters(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChapterSelectionScreen(
          bookName: book.name,
          bookId: book.id,
          englishName: book.englishName,
          chapterCount: book.chapterCount,
        ),
      ),
    );
  }

  String _getEnglishName(int id) {
    final names = {
      1: 'GENESIS',
      2: 'EXODUS',
      3: 'LEVITICUS',
      4: 'NUMBERS',
      5: 'DEUTERONOMY',
      6: 'JOSHUA',
      7: 'JUDGES',
      8: 'RUTH',
      9: '1 SAMUEL',
      10: '2 SAMUEL',
      11: '1 KINGS',
      12: '2 KINGS',
      13: '1 CHRONICLES',
      14: '2 CHRONICLES',
      15: 'EZRA',
      16: 'NEHEMIAH',
      17: 'ESTHER',
      18: 'JOB',
      19: 'PSALMS',
      20: 'PROVERBS',
      21: 'ECCLESIASTES',
      22: 'SONG OF SOLOMON',
      23: 'ISAIAH',
      24: 'JEREMIAH',
      25: 'LAMENTATIONS',
      26: 'EZEKIEL',
      27: 'DANIEL',
      28: 'HOSEA',
      29: 'JOEL',
      30: 'AMOS',
      31: 'OBADIAH',
      32: 'JONAH',
      33: 'MICAH',
      34: 'NAHUM',
      35: 'HABAKKUK',
      36: 'ZEPHANIAH',
      37: 'HAGGAI',
      38: 'ZECHARIAH',
      39: 'MALACHI',
      40: 'MATTHEW',
      41: 'MARK',
      42: 'LUKE',
      43: 'JOHN',
      44: 'ACTS',
      45: 'ROMANS',
      46: '1 CORINTHIANS',
      47: '2 CORINTHIANS',
      48: 'GALATIANS',
      49: 'EPHESIANS',
      50: 'PHILIPPIANS',
      51: 'COLOSSIANS',
      52: '1 THESSALONIANS',
      53: '2 THESSALONIANS',
      54: '1 TIMOTHY',
      55: '2 TIMOTHY',
      56: 'TITUS',
      57: 'PHILEMON',
      58: 'HEBREWS',
      59: 'JAMES',
      60: '1 PETER',
      61: '2 PETER',
      62: '1 JOHN',
      63: '2 JOHN',
      64: '3 JOHN',
      65: 'JUDE',
      66: 'REVELATION',
    };
    return names[id] ?? 'BOOK $id';
  }


  PreferredSizeWidget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      title: Text(
        l10n.books,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          fontFamily: 'Noto Serif Ethiopic',
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Icon(Icons.search_rounded, color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
                fontFamily: 'Noto Serif Ethiopic',
              ),
            ),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 2,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _BookCard({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Noto Serif Ethiopic',
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyReflectionCard extends StatelessWidget {
  const _DailyReflectionCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
            'https://www.transparenttextures.com/patterns/cubes.png',
          ),
          opacity: 0.05,
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              l10n.dailyReflection.toUpperCase(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.dailyReflectionQuote,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Noto Serif Ethiopic',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                l10n.dailyReflectionReference,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Noto Serif Ethiopic',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700).withValues(alpha: 0.8),
              foregroundColor: SabaColors.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(
              l10n.read,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
