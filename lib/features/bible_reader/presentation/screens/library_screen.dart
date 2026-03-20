import 'package:flutter/material.dart';

import '../screens/chapter_selection_screen.dart';
import '../../../../core/theme/app_theme.dart';

/// Redesigned Library/Books screen with Testament grids and reflection card.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA),
      appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'ብሉይ ኪዳን',
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
              delegate: SliverChildListDelegate([
                _BookCard(
                  number: '01',
                  title: 'ኦሪት ዘፍጥረት',
                  subtitle: 'GENESIS',
                  onTap: () => _navigateToChapters(context, 'ኦሪት ዘፍጥረት'),
                ),
                _BookCard(
                  number: '02',
                  title: 'ኦሪት ዘጸአት',
                  subtitle: 'EXODUS',
                  onTap: () => _navigateToChapters(context, 'ኦሪት ዘጸአት'),
                ),
                _BookCard(
                  number: '03',
                  title: 'ኦሪት ዘሌዋውያን',
                  subtitle: 'LEVITICUS',
                  isActive: true,
                  onTap: () => _navigateToChapters(context, 'ኦሪት ዘሌዋውያን'),
                ),
                _BookCard(
                  number: '04',
                  title: 'ኦሪት ዘኍል፲',
                  subtitle: 'NUMBERS',
                  onTap: () => _navigateToChapters(context, 'ኦሪት ዘኍል፲'),
                ),
                _BookCard(
                  number: '05',
                  title: 'ኦሪት ዘዳግም',
                  subtitle: 'DEUTERONOMY',
                  onTap: () => _navigateToChapters(context, 'ኦሪት ዘዳግም'),
                ),
                const _PlaceholderCard(),
              ]),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(24, 40, 24, 16),
            sliver: SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'ሐዲስ ኪዳን',
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
              delegate: SliverChildListDelegate([
                _BookCard(
                  number: '01',
                  title: 'የማቴዎስ ወንጌል',
                  subtitle: 'MATTHEW',
                  onTap: () => _navigateToChapters(context, 'የማቴዎስ ወንጌል'),
                ),
                _BookCard(
                  number: '02',
                  title: 'የማርቆስ ወንጌል',
                  subtitle: 'MARK',
                  onTap: () => _navigateToChapters(context, 'የማርቆስ ወንጌል'),
                ),
                _BookCard(
                  number: '03',
                  title: 'የሉቃስ ወንጌል',
                  subtitle: 'LUKE',
                  onTap: () => _navigateToChapters(context, 'የሉቃስ ወንጌል'),
                ),
                _BookCard(
                  number: '04',
                  title: 'የዮሐንስ ወንጌል',
                  subtitle: 'JOHN',
                  onTap: () => _navigateToChapters(context, 'የዮሐንስ ወንጌል'),
                ),
              ]),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            sliver: SliverToBoxAdapter(child: _DailyReflectionCard()),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  void _navigateToChapters(BuildContext context, String bookName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChapterSelectionScreen(bookName: bookName),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFDFBFA),
      elevation: 0,
      centerTitle: true,
      leading: const Icon(Icons.menu_rounded, color: Colors.black54),
      title: const Text(
        'መጻሕፍት',
        style: TextStyle(
          color: SabaColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          fontFamily: 'Noto Serif Ethiopic',
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(Icons.search_rounded, color: Colors.black54),
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
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: SabaColors.secondary,
                fontFamily: 'Noto Serif Ethiopic',
              ),
            ),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black26,
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
          color: SabaColors.primary.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final bool isActive;
  final VoidCallback onTap;

  const _BookCard({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F2F1),
          borderRadius: BorderRadius.circular(16),
          border: isActive ? Border(left: BorderSide(color: SabaColors.primary, width: 4)) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black26,
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
              style: const TextStyle(
                fontSize: 9,
                color: Colors.black38,
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

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F2F1).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: const Text(
        '...',
        style: TextStyle(color: Colors.black12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _DailyReflectionCard extends StatelessWidget {
  const _DailyReflectionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: SabaColors.primary,
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage('https://www.transparenttextures.com/patterns/cubes.png'),
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
            child: const Text(
              'DAILY REFLECTION',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '"ቃልም በመጀመሪያ ነበረ..."',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Noto Serif Ethiopic',
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Text(
                '— ዮሐንስ 1:1',
                style: TextStyle(
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('አንብብ', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
