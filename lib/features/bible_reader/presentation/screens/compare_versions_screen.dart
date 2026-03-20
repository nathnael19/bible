import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bible_reader_cubit.dart';
import '../../../../core/theme/app_theme.dart';

/// Side-by-side Bible version comparison screen.
class CompareVersionsScreen extends StatelessWidget {
  const CompareVersionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: BlocBuilder<BibleReaderCubit, BibleReaderState>(
        builder: (context, state) {
          if (state is BibleReaderLoading) {
            return const Center(child: CircularProgressIndicator(color: SabaColors.primary));
          }

          if (state is BibleReaderError) {
            return Center(child: Text('ስህተት ተፈጥሯል: ${state.message}'));
          }

          if (state is BibleReaderLoaded) {
            return Column(
              children: [
                _buildVersionSelectors('${state.book} ${state.chapter}'),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: state.verses.length + 1, // +1 for the note card
                    itemBuilder: (context, index) {
                      if (index == state.verses.length) {
                        return const _ComparisonNoteCard();
                      }
                      
                      final verse = state.verses[index];
                      // Simulating a second version's text until a secondary JSON is provided
                      final mockedRightText = verse.text; 

                      return _buildVerseRow(
                        number: verse.number.toString(),
                        textLeft: verse.text,
                        textRight: mockedRightText,
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'ማነጻጸሪያ',
        style: TextStyle(
          color: SabaColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          fontFamily: 'Noto Serif Ethiopic',
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.black54),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildVersionSelectors(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.compare_arrows_rounded, color: Colors.black26, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontFamily: 'Noto Serif Ethiopic',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _VersionSelectorChip(label: 'የ1954 ትርጉም (Old)'),
              const SizedBox(width: 12),
              _VersionSelectorChip(label: 'አዲሱ መደበኛ ትርጉም'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerseRow({
    required String number,
    required String textLeft,
    required String textRight,
    bool isActive = false,
    bool isFavorite = false,
    bool hasNote = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
      decoration: BoxDecoration(
        color: isActive ? SabaColors.primary.withValues(alpha: 0.05) : Colors.transparent,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Accent Bar
            if (isActive)
              Container(width: 4, color: SabaColors.primary),
            
            // Left Column
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.black.withValues(alpha: 0.05), width: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          number,
                          style: const TextStyle(
                            color: SabaColors.secondary,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Noto Serif Ethiopic',
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      textLeft,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        fontFamily: 'Noto Serif Ethiopic',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right Column
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          number,
                          style: const TextStyle(
                            color: SabaColors.secondary,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Noto Serif Ethiopic',
                          ),
                        ),
                        const Spacer(),
                        if (isFavorite)
                          const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
                        if (hasNote)
                          const Icon(Icons.chat_bubble_outline_rounded, color: Colors.black26, size: 14),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      textRight,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        fontFamily: 'Noto Serif Ethiopic',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VersionSelectorChip extends StatelessWidget {
  final String label;
  const _VersionSelectorChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.black45),
        ],
      ),
    );
  }
}

class _ComparisonNoteCard extends StatelessWidget {
  const _ComparisonNoteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: SabaColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.lightbulb_outline_rounded, color: SabaColors.primary, size: 20),
              ),
              const SizedBox(width: 16),
              const Text(
                'የንጽጽር ማስታወሻ',
                style: TextStyle(
                  color: SabaColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Noto Serif Ethiopic',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'በዚህ ሁኔታ ቃላት ትርጉሞች መካከል "ቃል" (Logos) የሚለው ቃል አጠቃቀም ተመሳሳይ ቢሆንም በአረፍተ ነገር በኩታ ሰንሰለት በያዘው መንገድ በአዲሱ መደበኛ ትርጉም ተቀይሮዋል።',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.black54,
              fontFamily: 'Noto Serif Ethiopic',
            ),
          ),
        ],
      ),
    );
  }
}
