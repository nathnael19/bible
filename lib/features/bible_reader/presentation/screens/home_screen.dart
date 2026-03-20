import 'package:flutter/material.dart';

import 'search_screen.dart';

/// Home / Discover screen redesigned to match reference image.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ─────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            title: Text(
              'መጽሐፍ ቅዱስ',
              style: tt.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                    children: [
                      _ContinueReadingCard(
                        book: 'ዘፍጥረት',
                        chapter: 'ምዕራፍ ፫',
                        progress: 0.45,
                        iconColor: Theme.of(
                          context,
                        ).colorScheme.secondaryContainer,
                        icon: Icons.menu_book_rounded,
                      ),
                      _ContinueReadingCard(
                        book: 'መዝሙረ ዳዊት',
                        chapter: 'ምዕራፍ ፩',
                        progress: 0.15,
                        iconColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
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
                const SizedBox(height: 110),
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
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: tt.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
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
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.05),
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
                  color: theme.colorScheme.secondaryContainer.withValues(
                    alpha: 0.9,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'የዕለቱ ጥቅስ',
                  style: tt.labelSmall!.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Verse Text
              Text(
                '"እግዚአብሔር ብርሃኔና መድኃኒቴ ነው፤ የሚያስፈራኝ ማን ነው? እግዚአብሔር ለሕይወቴ መታመኛዋ ነው፤ የሚያስደነግጠኝ ማን ነው?"',
                style: tt.headlineSmall!.copyWith(
                  color: theme.colorScheme.onPrimary,
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
                      color: theme.colorScheme.secondaryContainer,
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
        ),
      ),
      child: Icon(icon, color: theme.colorScheme.onPrimary, size: 18),
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
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
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
                child: Icon(icon, color: theme.colorScheme.onPrimary, size: 20),
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
                      color: theme.colorScheme.onSurfaceVariant,
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
                  backgroundColor: theme.colorScheme.onSurface.withValues(
                    alpha: 0.05,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
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
                    color: theme.colorScheme.onSurfaceVariant,
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
    final theme = Theme.of(context);
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            theme.colorScheme.onSurface.withValues(alpha: 0.4),
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
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge!,
                  style: tt.labelSmall!.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 10,
                  ),
                ),
              ),
            Text(
              title,
              style: tt.headlineSmall!.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: tt.bodySmall!.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
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
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 24),
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
                    color: theme.colorScheme.onSurfaceVariant,
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
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
