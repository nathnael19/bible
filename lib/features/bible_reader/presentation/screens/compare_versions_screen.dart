import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/verse.dart';
import '../../domain/entities/bible_version.dart';
import '../../domain/repositories/i_bible_repository.dart';
import '../cubit/bible_reader_cubit.dart';

/// Side-by-side Bible version comparison screen.
class CompareVersionsScreen extends StatefulWidget {
  const CompareVersionsScreen({super.key});

  @override
  State<CompareVersionsScreen> createState() => _CompareVersionsScreenState();
}

class _CompareVersionsScreenState extends State<CompareVersionsScreen> {
  String _leftVersionId = 'amh_standard';
  String _rightVersionId = 'amh_full';
  
  List<Verse>? _leftVerses;
  List<Verse>? _rightVerses;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAllVerses();
  }

  Future<void> _loadAllVerses() async {
    final readerState = context.read<BibleReaderCubit>().state;
    if (readerState is! BibleReaderLoaded) return;

    setState(() => _isLoading = true);

    try {
      final repository = sl<IBibleRepository>();
      
      final results = await Future.wait([
        repository.getVerses(
          versionId: _leftVersionId,
          book: readerState.book,
          chapter: readerState.chapter,
        ),
        repository.getVerses(
          versionId: _rightVersionId,
          book: readerState.book,
          chapter: readerState.chapter,
        ),
      ]);

      setState(() {
        _leftVerses = results[0];
        _rightVerses = results[1];
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ስህተት: $e')),
        );
      }
    }
  }

  void _showVersionPicker(bool isLeft) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ComparisonVersionSelector(
        onSelected: (version) {
          setState(() {
            if (isLeft) {
              _leftVersionId = version.id;
            } else {
              _rightVersionId = version.id;
            }
          });
          _loadAllVerses();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: BlocBuilder<BibleReaderCubit, BibleReaderState>(
        builder: (context, state) {
          if (state is! BibleReaderLoaded) {
            return const Center(child: CircularProgressIndicator(color: SabaColors.primary));
          }

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator(color: SabaColors.primary));
          }

          return Column(
            children: [
              _buildVersionSelectors('${state.book} ${state.chapter}'),
              Expanded(
                child: _leftVerses == null || _rightVerses == null
                    ? const Center(child: Text('ምንም መረጃ አልተገኘም።'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: _leftVerses!.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _leftVerses!.length) {
                            return const _ComparisonNoteCard();
                          }
                          
                          final leftVerse = _leftVerses![index];
                          // Match by verse number if possible
                          Verse? rightVerseMatch;
                          try {
                            rightVerseMatch = _rightVerses!.firstWhere(
                              (v) => v.number == leftVerse.number,
                            );
                          } catch (_) {
                            // Fallback to index if no match found
                            if (_rightVerses!.length > index) {
                              rightVerseMatch = _rightVerses![index];
                            } else {
                              rightVerseMatch = leftVerse;
                            }
                          }
                          
                          final rightVerse = rightVerseMatch;

                          return _buildVerseRow(
                            number: leftVerse.number.toString(),
                            textLeft: leftVerse.text,
                            textRight: rightVerse.text,
                          );
                        },
                      ),
              ),
            ],
          );
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
    // For now, let's just find names based on IDs
    final leftName = _leftVersionId == 'amh_standard' ? 'አማርኛ መደበኛ' : 'የ1954 ትርጉም (Old)';
    final rightName = _rightVersionId == 'amh_standard' ? 'አማርኛ መደበኛ' : 'የ1954 ትርጉም (Old)';

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
              _VersionSelectorChip(
                label: leftName,
                onTap: () => _showVersionPicker(true),
              ),
              const SizedBox(width: 12),
              _VersionSelectorChip(
                label: rightName,
                onTap: () => _showVersionPicker(false),
              ),
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
  final VoidCallback onTap;
  const _VersionSelectorChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}

class _ComparisonVersionSelector extends StatelessWidget {
  final Function(BibleVersion) onSelected;
  const _ComparisonVersionSelector({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final repository = sl<IBibleRepository>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ትርጉም ይምረጡ',
            style: tt.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Noto Serif Ethiopic',
            ),
          ),
          const SizedBox(height: 24),
          FutureBuilder<List<BibleVersion>>(
            future: repository.getBibleVersions(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              
              return Column(
                children: snapshot.data!.map((v) => ListTile(
                  title: Text(v.name, style: const TextStyle(fontFamily: 'Noto Serif Ethiopic')),
                  subtitle: Text(v.language),
                  onTap: () => onSelected(v),
                )).toList(),
              );
            },
          ),
          const SizedBox(height: 24),
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
