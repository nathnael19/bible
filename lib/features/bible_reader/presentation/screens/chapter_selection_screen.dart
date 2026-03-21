import 'package:bible/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bible_reader_cubit.dart';
import '../cubit/navigation_cubit.dart';

class ChapterSelectionScreen extends StatefulWidget {
  final String bookName;
  final String bookId;
  final String englishName;
  final int chapterCount;
  const ChapterSelectionScreen({
    super.key,
    required this.bookName,
    required this.bookId,
    required this.englishName,
    required this.chapterCount,
  });

  @override
  State<ChapterSelectionScreen> createState() => _ChapterSelectionScreenState();
}

class _ChapterSelectionScreenState extends State<ChapterSelectionScreen> {
  int? _selectedChapter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(context, theme),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // ── Header ──────────────────────────────────────────────────
            Text(
              widget.englishName.toUpperCase(),
              style: tt.labelSmall!.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.selectChapter,
              style: tt.headlineMedium!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Noto Serif Ethiopic',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.selectChapterDesc,
              style: tt.bodySmall!.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'Noto Serif Ethiopic',
              ),
            ),
            const SizedBox(height: 40),

            // ── Chapter Grid ────────────────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: widget.chapterCount,
              itemBuilder: (context, i) {
                final index = i + 1;
                final isActive = _selectedChapter == index;
                return _ChapterButton(
                  index: index,
                  isActive: isActive,
                  onTap: () async {
                    setState(() => _selectedChapter = index);

                    final bibleReaderCubit = context.read<BibleReaderCubit>();
                    final navigationCubit = context.read<NavigationCubit>();
                    final navigator = Navigator.of(context);

                    // Tiny delay to show the selection state
                    await Future.delayed(const Duration(milliseconds: 50));

                    if (!mounted) return;

                    // 1. Load the book and chapter
                    bibleReaderCubit.loadBookChapter(
                      book: widget.bookName,
                      bookId: widget.bookId,
                      chapter: index,
                    );

                    // 2. Switch to Reader Tab (index 2)
                    navigationCubit.setTab(2);

                    // 3. Pop selection screen AND library screen to get back to shell
                    navigator.popUntil((route) => route.isFirst);
                  },
                );
              },
            ),

            const SizedBox(height: 40),

            // ── About Book Card ─────────────────────────────────────────
            if (widget.bookId == '1') _AboutBookCard(bookName: widget.bookName),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: theme.colorScheme.secondary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.bookName,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: 'Noto Serif Ethiopic',
        ),
      ),
    );
  }
}

class _ChapterButton extends StatelessWidget {
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const _ChapterButton({
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? null
              : Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
        ),
        alignment: Alignment.center,
        child: Text(
          index.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isActive
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontFamily: 'Noto Serif Ethiopic',
          ),
        ),
      ),
    );
  }
}

class _AboutBookCard extends StatelessWidget {
  final String bookName;
  const _AboutBookCard({required this.bookName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aboutBook(bookName),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                    fontFamily: 'Noto Serif Ethiopic',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.genesisDescription,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'Noto Serif Ethiopic',
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _KeywordChip(label: l10n.keywordCreation),
                    _KeywordChip(label: l10n.keywordNoah),
                    _KeywordChip(label: l10n.keywordAbraham),
                    _KeywordChip(label: l10n.keywordIsaac),
                    _KeywordChip(label: l10n.keywordJacob),
                    _KeywordChip(label: l10n.keywordJoseph),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  final String label;
  const _KeywordChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: theme.colorScheme.onSurface,
          fontFamily: 'Noto Serif Ethiopic',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
