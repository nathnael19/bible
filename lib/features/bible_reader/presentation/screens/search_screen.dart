import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Redesigned Search Screen matching the reference image.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController(text: 'ብርሃን');

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
                  _FilterChip(label: 'ብሉይ ኪዳን', isSelected: true),
                  _FilterChip(label: 'ሐዲስ ኪዳን'),
                  _FilterChip(label: 'መዝሙረ ዳዊት'),
                  _FilterChip(label: 'ትርጉም'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── 3. Results Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'የተገኙ ውጤቶች (124)',
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

            // ── 4. Search Results ──────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _SearchResultTile(
                    number: '፩',
                    title: 'ኦሪት ዘፍጥረት',
                    reference: '፩ : ፫',
                    snippet:
                        'እግዚአብሔርም፦ <highlight>ብርሃን</highlight> ይሁን አለ፤ <highlight>ብርሃንም</highlight> ሆነ።',
                  ),
                  _SearchResultTile(
                    number: '፪',
                    title: 'የዮሐንስ ወንጌል',
                    reference: '፩ : ፱',
                    snippet:
                        'ለጠቢብ ሰው ሁሉ የሚያበራው እውነተኛው <highlight>ብርሃን</highlight> ወደ ዓለም ይመጣ ነበር።',
                  ),
                  _SearchResultTile(
                    number: '፫',
                    title: 'መዝሙረ ዳዊት',
                    reference: '፳፯ : ፩',
                    snippet:
                        'እግዚአብሔር <highlight>ብርሃኔና</highlight> መድኃኒቴ ነው፤ የሚያስፈራኝ ማን ነው?',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── 5. Featured Result Card ───────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _FeaturedHighlightCard(),
            ),
            const SizedBox(height: 32),

            // ── 6. Show More Button ───────────────────────────────────
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
  final bool isSelected;
  const _FilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final String number;
  final String title;
  final String reference;
  final String snippet;

  const _SearchResultTile({
    required this.number,
    required this.title,
    required this.reference,
    required this.snippet,
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
              number,
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
                      title,
                      style: tt.titleMedium!.copyWith(
                        color: SabaColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      reference,
                      style: tt.labelSmall!.copyWith(
                        color: SabaColors.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _RichSnippet(snippet: snippet),
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
            snippet:
                '"እናንተ የዓለም <highlight>ብርሃን</highlight> ናችሁ። በተራራ ላይ ያለች ከተማ ልትሰወር አትችልም::"',
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
  final String snippet;
  final bool isLarge;
  const _RichSnippet({required this.snippet, this.isLarge = false});

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

    final parts = snippet.split(RegExp(r'<highlight>|</highlight>'));
    List<TextSpan> spans = [];

    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 1) {
        spans.add(TextSpan(text: parts[i], style: highlightStyle));
      } else {
        spans.add(TextSpan(text: parts[i]));
      }
    }

    return RichText(
      text: TextSpan(
        style: baseStyle.copyWith(height: 1.6, color: SabaColors.onSurface),
        children: spans,
      ),
    );
  }
}
