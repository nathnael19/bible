import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/bible_reader_cubit.dart';
import 'bible_reader_screen.dart';

/// Home / Discover screen — editorial tonal layout
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: SabaColors.surface,
      body: CustomScrollView(
        slivers: [
          // ── Glassmorphic App Bar ────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: SabaColors.surface.withValues(alpha: 0.9),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 32, bottom: 16),
              title: Text('መጽሐፍ ቅዱስ', style: tt.headlineMedium),
              background: Container(color: SabaColors.surfaceContainerLow),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(32, 24, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Daily Verse Card ─────────────────────────────────────
                _DailyVerseCard(tt: tt, cs: cs),
                const SizedBox(height: 28),

                // ── Continue Reading ─────────────────────────────────────
                Text('Continue Reading', style: tt.titleMedium),
                const SizedBox(height: 12),
                _ContinueReadingCard(tt: tt, cs: cs),
                const SizedBox(height: 28),

                // ── Testament navigation chips ────────────────────────────
                Text('Explore', style: tt.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _TestamentChip(label: 'Old Testament'),
                    _TestamentChip(label: 'New Testament'),
                    _TestamentChip(label: 'Psalms ዘማሪያት'),
                    _TestamentChip(label: 'Proverbs'),
                    _TestamentChip(label: 'Gospels'),
                  ],
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyVerseCard extends StatelessWidget {
  const _DailyVerseCard({required this.tt, required this.cs});
  final TextTheme tt;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: SabaColors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny_outlined,
                  color: SabaColors.secondaryContainer, size: 16),
              const SizedBox(width: 8),
              Text('Daily Verse',
                  style: tt.labelSmall!
                      .copyWith(color: SabaColors.secondaryContainer)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"In the beginning, God created the heavens and the earth."',
            style: tt.bodyLarge!.copyWith(
              color: SabaColors.onPrimary,
              fontStyle: FontStyle.italic,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Genesis 1:1 • ዘፍጥረት ፩:፩',
            style: tt.labelSmall!
                .copyWith(color: SabaColors.secondaryContainer),
          ),
        ],
      ),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  const _ContinueReadingCard({required this.tt, required this.cs});
  final TextTheme tt;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<BibleReaderCubit>()..loadVerses(),
            child: const BibleReaderScreen(),
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: SabaColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [SabaColors.primary, SabaColors.primaryContainer],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.menu_book, color: SabaColors.onPrimary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ዘፍጥረት • Genesis', style: tt.titleSmall),
                  const SizedBox(height: 4),
                  Text('Chapter 1 • Verse 3',
                      style: tt.bodySmall!
                          .copyWith(color: SabaColors.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: SabaColors.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

class _TestamentChip extends StatelessWidget {
  final String label;
  const _TestamentChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      onSelected: (_) {},
      selected: false,
    );
  }
}
