import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/bible_reader_cubit.dart';
import '../cubit/navigation_cubit.dart';

class ChapterSelectionScreen extends StatefulWidget {
  final String bookName;
  const ChapterSelectionScreen({super.key, required this.bookName});

  @override
  State<ChapterSelectionScreen> createState() => _ChapterSelectionScreenState();
}

class _ChapterSelectionScreenState extends State<ChapterSelectionScreen> {
  int? _selectedChapter;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // ── Header ──────────────────────────────────────────────────
            Text(
              'THE FIRST BOOK OF MOSES',
              style: tt.labelSmall!.copyWith(
                color: Colors.brown.withValues(alpha: 0.6),
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ምዕራፍ ይምረጡ',
              style: tt.headlineMedium!.copyWith(
                color: SabaColors.primary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Noto Serif Ethiopic',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'የሚፈልጉትን ምዕራፍ በመንካት ንባብዎን ይጀምሩ።',
              style: tt.bodySmall!.copyWith(
                color: Colors.black38,
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
              itemCount: 50,
              itemBuilder: (context, i) {
                final index = i + 1;
                final isActive = _selectedChapter == index;
                return _ChapterButton(
                  index: index,
                  isActive: isActive,
                  onTap: () async {
                    setState(() => _selectedChapter = index);

                    // Tiny delay to show the selection state
                    await Future.delayed(const Duration(milliseconds: 50));

                    if (!mounted) return;

                    // 1. Load the book and chapter
                    context.read<BibleReaderCubit>().loadBookChapter(
                      book: widget.bookName,
                      chapter: index,
                    );

                    // 2. Switch to Reader Tab (index 1)
                    context.read<NavigationCubit>().setTab(1);

                    // 3. Pop selection screen AND library screen to get back to shell
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                );
              },
            ),

            const SizedBox(height: 60),

            // ── About Book Card ─────────────────────────────────────────
            _AboutBookCard(bookName: widget.bookName),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFDFBFA),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: SabaColors.secondary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.bookName,
        style: const TextStyle(
          color: SabaColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: 'Noto Serif Ethiopic',
        ),
      ),
      actions: const [
        Icon(Icons.search_rounded, color: Colors.black54),
        SizedBox(width: 16),
        Icon(Icons.more_vert_rounded, color: Colors.black54),
        SizedBox(width: 16),
      ],
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

  String _toGeez(int n) {
    const geez = ['፩', '፪', '፫', '፬', '፭', '፮', '፯', '፰', '፱', '፲'];
    if (n >= 1 && n <= 10) return geez[n - 1];
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive
              ? SabaColors.primary
              : const Color(0xFFF4F2F1).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: isActive ? Border.all(color: Colors.black12, width: 2) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          _toGeez(index),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : Colors.black38,
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F2F1).withValues(alpha: 0.5),
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
              decoration: const BoxDecoration(
                color: SabaColors.primary,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ስለ $bookName',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: SabaColors.secondary,
                    fontFamily: 'Noto Serif Ethiopic',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'ኦሪት ዘፍጥረት የመጽሐፍ ቅዱስ የመጀመሪያው መጽሐፍ ሲሆን የዓለምን መፈጠር፣ የሰውን ልጅ መጀመሪያ እና የእግዚአብሔርን ከሰው ልጆች ጋር ያለውን የመጀመሪያ ኪዳን ይተርካል።',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black54,
                    fontFamily: 'Noto Serif Ethiopic',
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    _KeywordChip(label: 'ፍጥረት'),
                    _KeywordChip(label: 'ኖኅ'),
                    _KeywordChip(label: 'አብርሃም'),
                    _KeywordChip(label: 'ይስሐቅ'),
                    _KeywordChip(label: 'ያዕቆብ'),
                    _KeywordChip(label: 'ዮሴፍ'),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black54,
          fontFamily: 'Noto Serif Ethiopic',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
