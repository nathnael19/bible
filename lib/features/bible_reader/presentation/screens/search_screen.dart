import 'package:bible/features/bible_reader/domain/entities/search_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible/l10n/app_localizations.dart';

import '../../domain/entities/verse.dart';
import '../../domain/entities/search_filter.dart';
import '../cubit/search_cubit.dart';
import '../cubit/version_selector_cubit.dart';
import '../cubit/bible_reader_cubit.dart' as bible_reader_cubit;
import '../cubit/navigation_cubit.dart' as navigation_cubit;
import '../../../../core/theme/app_theme.dart';

/// Redesigned Search Screen matching the reference image.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  SearchFilter _activeFilter = SearchFilter.all;
  SearchMode _activeMode = SearchMode.contains;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final versionState = context.read<VersionSelectorCubit>().state;
    String? versionId;
    if (versionState is VersionSelectorLoaded) {
      versionId = versionState.selectedId;
    }
    context.read<SearchCubit>().search(
      _controller.text,
      filter: _activeFilter,
      mode: _activeMode,
      versionId: versionId,
    );
  }

  void _toggleSearchMode() {
    setState(() {
      _activeMode = _activeMode == SearchMode.contains
          ? SearchMode.exact
          : SearchMode.contains;
    });
    _onSearchChanged();
  }

  void _onFilterSelected(SearchFilter filter) {
    setState(() {
      _activeFilter = filter;
    });
    _onSearchChanged();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          l10n.appTitle, // Gospel title as per image
          style: tt.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // ── 1. Search Bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: TextButton(
                        onPressed: _toggleSearchMode,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _activeMode == SearchMode.contains
                              ? l10n.contains
                              : l10n.exact,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── 2. Filter Chips ────────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _FilterChip(
                    label: l10n.all,
                    filter: SearchFilter.all,
                    activeFilter: _activeFilter,
                    onSelected: _onFilterSelected,
                  ),
                  _FilterChip(
                    label: l10n.oldTestament,
                    filter: SearchFilter.oldTestament,
                    activeFilter: _activeFilter,
                    onSelected: _onFilterSelected,
                  ),
                  _FilterChip(
                    label: l10n.newTestament,
                    filter: SearchFilter.newTestament,
                    activeFilter: _activeFilter,
                    onSelected: _onFilterSelected,
                  ),
                  _FilterChip(
                    label: l10n.psalms,
                    filter: SearchFilter.psalms,
                    activeFilter: _activeFilter,
                    onSelected: _onFilterSelected,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── 3. Dynamic Results ──────────────────────────────────────
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }

                if (state is SearchLoaded) {
                  final results = state.results;
                  if (results.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(child: Text(l10n.noResults)),
                    );
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${l10n.resultsFound} (${results.length})',
                              style: tt.labelLarge!.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.layout,
                                  style: tt.labelSmall!.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: results.length > 20
                            ? 20
                            : results.length, // Show top 20 for performance
                        itemBuilder: (context, index) {
                          final verse = results[index];
                          return _SearchResultTile(
                            verse: verse,
                            query: _controller.text,
                          );
                        },
                      ),
                      if (results.length > 20)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Loading more results...'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                              ),
                              child: Text(l10n.showMore),
                            ),
                          ),
                        ),
                    ],
                  );
                }

                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: _FeaturedHighlightCard(),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

// ── Components ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final SearchFilter filter;
  final SearchFilter activeFilter;
  final ValueChanged<SearchFilter> onSelected;

  const _FilterChip({
    required this.label,
    required this.filter,
    required this.activeFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = filter == activeFilter;
    return GestureDetector(
      onTap: () => onSelected(filter),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.1),
                ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: isSelected
                ? Theme.of(context).colorScheme.onSecondaryContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final Verse verse;
  final String query;

  const _SearchResultTile({required this.verse, required this.query});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final bibleReaderCubit = context
              .read<bible_reader_cubit.BibleReaderCubit>();
          final navigationCubit = context
              .read<navigation_cubit.NavigationCubit>();
          final navigator = Navigator.of(context);

          final versionState = context.read<VersionSelectorCubit>().state;
          String? versionId;
          if (versionState is VersionSelectorLoaded) {
            versionId = versionState.selectedId;
          }

          bibleReaderCubit.loadBookChapter(
            book: verse.bookName,
            bookId: verse.bookId,
            chapter: verse.chapter,
            targetVerse: verse.number,
            versionId: versionId ?? 'amh_standard',
          );

          navigationCubit.setTab(2);
          navigator.popUntil((route) => route.isFirst);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ge'ez number in box
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  verse.number.toString(),
                  style: tt.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          verse.bookName,
                          style: tt.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${verse.chapter} : ${verse.number}',
                          style: tt.labelSmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _RichSnippet(text: verse.text, query: query),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _IconLink(Icons.copy_rounded, l10n.copy),
                        const SizedBox(width: 20),
                        _IconLink(Icons.share_outlined, l10n.share),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedHighlightCard extends StatelessWidget {
  const _FeaturedHighlightCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l10n.featured,
                  style: tt.labelSmall!.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
              const Icon(
                Icons.star_border_rounded,
                color: SabaColors.secondary,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            l10n.featuredVerseBook,
            style: tt.titleLarge!.copyWith(
              color: SabaColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.featuredVerseReference,
            style: tt.labelMedium!.copyWith(color: SabaColors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          _RichSnippet(
            text: l10n.featuredVerseContent,
            query: l10n.featuredVerseQuery,
            isLarge: true,
          ),
        ],
      ),
    );
  }
}

class _IconLink extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconLink(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RichSnippet extends StatelessWidget {
  final String text;
  final String query;
  final bool isLarge;
  const _RichSnippet({
    required this.text,
    required this.query,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final baseStyle = isLarge ? tt.titleMedium! : tt.bodyMedium!;
    final highlightStyle = baseStyle.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
      decoration: isLarge ? TextDecoration.underline : null,
      decorationColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.5),
    );

    if (query.trim().isEmpty) {
      return Text(
        text,
        style: baseStyle.copyWith(
          height: 1.6,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    List<TextSpan> spans = [];
    int start = 0;
    int indexOfMatch;

    while ((indexOfMatch = lowerText.indexOf(lowerQuery, start)) != -1) {
      if (indexOfMatch > start) {
        spans.add(TextSpan(text: text.substring(start, indexOfMatch)));
      }
      spans.add(
        TextSpan(
          text: text.substring(indexOfMatch, indexOfMatch + query.length),
          style: highlightStyle,
        ),
      );
      start = indexOfMatch + query.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: baseStyle.copyWith(
          height: 1.6,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        children: spans,
      ),
    );
  }
}
