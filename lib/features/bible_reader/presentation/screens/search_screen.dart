import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/verse.dart';
import '../../domain/entities/search_filter.dart';
import '../cubit/search_cubit.dart';
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
  
  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<SearchCubit>().search(_controller.text, filter: _activeFilter);
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
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: SabaColors.surface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: SabaColors.surface,
        elevation: 0,
        title: Text(
          'ወንጌል', // Gospel title as per image
          style: tt.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: SabaColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: SabaColors.onSurfaceVariant),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
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
                  color: Colors.white,
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
                  decoration: const InputDecoration(
                    hintText: 'ፈልግ...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: SabaColors.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
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
                    label: 'ሁሉም', 
                    filter: SearchFilter.all, 
                    activeFilter: _activeFilter, 
                    onSelected: _onFilterSelected,
                  ),
                  _FilterChip(
                    label: 'ብሉይ ኪዳን', 
                    filter: SearchFilter.oldTestament, 
                    activeFilter: _activeFilter, 
                    onSelected: _onFilterSelected,
                  ),
                  _FilterChip(
                    label: 'ሐዲስ ኪዳን', 
                    filter: SearchFilter.newTestament, 
                    activeFilter: _activeFilter, 
                    onSelected: _onFilterSelected,
                  ),
                  _FilterChip(
                    label: 'መዝሙረ ዳዊት', 
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
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(color: SabaColors.primary),
                    ),
                  );
                }

                if (state is SearchLoaded) {
                  final results = state.results;
                  if (results.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: Text('ምንም ውጤት አልተገኘም')),
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
                              'የተገኙ ውጤቶች (${results.length})',
                              style: tt.labelLarge!.copyWith(
                                color: SabaColors.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: SabaColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'አቀማመጥ',
                                  style: tt.labelSmall!.copyWith(
                                    color: SabaColors.primary,
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
                        itemCount: results.length > 20 ? 20 : results.length, // Show top 20 for performance
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
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SabaColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                              ),
                              child: const Text('ተጨማሪ ውጤቶችን አሳይ'),
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
          color: isSelected ? SabaColors.secondaryContainer : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: isSelected
                ? SabaColors.onSecondaryContainer
                : SabaColors.onSurfaceVariant,
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

  const _SearchResultTile({
    required this.verse,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ge'ez number in box
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              verse.number.toString(),
              style: tt.labelLarge!.copyWith(
                color: SabaColors.onSurfaceVariant,
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
                        color: SabaColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${verse.chapter} : ${verse.number}',
                      style: tt.labelSmall!.copyWith(
                        color: SabaColors.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _RichSnippet(text: verse.text, query: query),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _IconLink(Icons.copy_rounded, 'ቅዳ'),
                    const SizedBox(width: 20),
                    _IconLink(Icons.share_outlined, 'አጋራ'),
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

class _FeaturedHighlightCard extends StatelessWidget {
  const _FeaturedHighlightCard();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: SabaColors.surfaceContainerLow,
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
                  color: SabaColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'ተለይቶ የቀረበ',
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
            'የማቴዎስ ወንጌል',
            style: tt.titleLarge!.copyWith(
              color: SabaColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ምዕራፍ ፭ : ቁጥር ፲፬',
            style: tt.labelMedium!.copyWith(color: SabaColors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          _RichSnippet(
            text:
                '"እናንተ የዓለም ብርሃን ናችሁ። በተራራ ላይ ያለች ከተማ ልትሰወር አትችልም::"',
            query: 'ብርሃን',
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
        Icon(icon, size: 14, color: SabaColors.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: SabaColors.onSurfaceVariant,
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
      color: SabaColors.primary,
      fontWeight: FontWeight.bold,
      decoration: isLarge ? TextDecoration.underline : null,
      decorationColor: SabaColors.primary.withValues(alpha: 0.5),
    );

    if (query.trim().isEmpty) {
      return Text(text, style: baseStyle.copyWith(height: 1.6, color: SabaColors.onSurface));
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
      spans.add(TextSpan(
        text: text.substring(indexOfMatch, indexOfMatch + query.length),
        style: highlightStyle,
      ));
      start = indexOfMatch + query.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: baseStyle.copyWith(height: 1.6, color: SabaColors.onSurface),
        children: spans,
      ),
    );
  }
}
