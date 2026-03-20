import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'search_screen.dart';

/// Home / Discover screen redesigned to match reference image.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: SabaColors.surface,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ─────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            backgroundColor: SabaColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: SabaColors.onSurfaceVariant),
              onPressed: () {},
            ),
            title: Text(
              'መጽሐፍ ቅዱስ',
              style: tt.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: SabaColors.onSurface,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: SabaColors.onSurfaceVariant,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── 1. Daily Verse Card ───────────────────────────────
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _DailyVerseCard(),
                ),
                const SizedBox(height: 32),

                // ── 2. Continue Reading ──────────────────────────────
                _SectionHeader(
                  title: 'ንባብዎን ይቀጥሉ',
                  trailingText: 'ሁሉንም ይመልከቱ',
                  onTrailingTap: () {},
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120, // Height for horizontal cards
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: const [
                      _ContinueReadingCard(
                        book: 'ዘፍጥረት',
                        chapter: 'ምዕራፍ ፫',
                        progress: 0.45,
                        iconColor: SabaColors.secondaryContainer,
                        icon: Icons.menu_book_rounded,
                      ),
                      _ContinueReadingCard(
                        book: 'መዝሙረ ዳዊት',
                        chapter: 'ምዕራፍ ፩',
                        progress: 0.15,
                        iconColor: SabaColors.primaryContainer,
                        icon: Icons.auto_stories_rounded,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── 3. Reading Plans ──────────────────────────────────
                const _SectionHeader(title: 'የንባብ ዕቅዶች'),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _ReadingPlanCard(
                    title: 'የሰላም መንገድ',
                    description: 'በዕለታዊ ጊዜ የሚደረጉ መጽሐፍ ቅዱሳዊ ምክሮችና ጸሎቶች ለ፲፭ ቀናት።',
                    badge: 'አዲስ ዕቅድ',
                    // Placeholder for image
                    imageUrl:
                        'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=800',
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _ReadingPlanCard(
                    title: 'የጾም ወቅት',
                    description: 'ለአርባ ቀን የሚቆይ የንባብ ዕቅድ',
                    // Placeholder for image
                    imageUrl:
                        'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=800',
                    isCrossCard: true,
                  ),
                ),
                const SizedBox(height: 32),

                // ── 4. Recent Activity ───────────────────────────────
                const _SectionHeader(title: 'የቅርብ ጊዜ እንቅስቃሴ'),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _ActivityTile(
                        icon: Icons.bookmark_border_rounded,
                        title: 'ጥቅስ መዝግበዋል',
                        subtitle: '"እግዚአብሔር ፍቅር ነው..." - ፩ ዮሐንስ ፬:፰',
                        time: '2 ሰአት',
                      ),
                      SizedBox(height: 12),
                      _ActivityTile(
                        icon: Icons.check_circle_outline_rounded,
                        title: 'ምዕራፍ አጠናቀዋል',
                        subtitle: 'ዮሐንስ ወንጌል ምዕራፍ ፫',
                        time: 'ትናንት',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared Components ──────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailingText;
  final VoidCallback? onTrailingTap;

  const _SectionHeader({
    required this.title,
    this.trailingText,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: tt.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: SabaColors.primary,
            ),
          ),
          if (trailingText != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: Row(
                children: [
                  Text(
                    trailingText!,
                    style: tt.labelSmall!.copyWith(
                      color: SabaColors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: SabaColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DailyVerseCard extends StatelessWidget {
  const _DailyVerseCard();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: SabaColors.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: SabaColors.primary.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtile watermark icon
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.menu_book_rounded,
              size: 120,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: SabaColors.secondaryContainer.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'የዕለቱ ጥቅስ',
                  style: tt.labelSmall!.copyWith(
                    color: SabaColors.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Verse Text
              Text(
                '"እግዚአብሔር ብርሃኔና መድኃኒቴ ነው፤ የሚያስፈራኝ ማን ነው? እግዚአብሔር ለሕይወቴ መታመኛዋ ነው፤ የሚያስደነግጠኝ ማን ነው?"',
                style: tt.headlineSmall!.copyWith(
                  color: Colors.white,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '— መዝሙር ፳፯:፩',
                    style: tt.titleSmall!.copyWith(
                      color: SabaColors.secondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      _SocialIcon(icon: Icons.share_outlined),
                      const SizedBox(width: 12),
                      _SocialIcon(icon: Icons.bookmark_border_rounded),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  final String book;
  final String chapter;
  final double progress;
  final Color iconColor;
  final IconData icon;

  const _ContinueReadingCard({
    required this.book,
    required this.chapter,
    required this.progress,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SabaColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book,
                    style: tt.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    chapter,
                    style: tt.labelSmall!.copyWith(
                      color: SabaColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.black.withValues(alpha: 0.05),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    SabaColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(progress * 100).toInt()}% ተጠናቋል',
                  style: tt.labelSmall!.copyWith(
                    fontSize: 10,
                    color: SabaColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadingPlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String? badge;
  final String imageUrl;
  final bool isCrossCard;

  const _ReadingPlanCard({
    required this.title,
    required this.description,
    this.badge,
    required this.imageUrl,
    this.isCrossCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge!,
                  style: tt.labelSmall!.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            Text(
              title,
              style: tt.headlineSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: tt.bodySmall!.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SabaColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SabaColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: SabaColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: tt.bodySmall!.copyWith(
                    color: SabaColors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: tt.labelSmall!.copyWith(
              color: SabaColors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
