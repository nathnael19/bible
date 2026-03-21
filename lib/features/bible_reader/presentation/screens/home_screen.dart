import 'package:flutter/material.dart';
import 'package:bible/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';

import 'search_screen.dart';

/// Home / Discover screen redesigned to match reference image.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              l10n.appTitle,
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
                // ── 1. Daily Verse ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _DailyVerseCard(),
                ),
                const SizedBox(height: 32),

                // ── 2. Continue Reading ──────────────────────────────
                _buildSectionHeader(context, l10n.continueReading, l10n.seeAll, () {}),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildContinueReadingCard(context, l10n),
                ),
                const SizedBox(height: 32),

                // ── Reading Plans ─────────────────────────────────────────
                _buildSectionHeader(context, l10n.readingPlans, l10n.seeAll, () {}),
                const SizedBox(height: 16),
                _buildReadingPlans(l10n),
                const SizedBox(height: 32),

                // ── Recent Activity ───────────────────────────────────────
                _buildSectionHeader(context, l10n.recentActivity, null, () {}),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildRecentActivity(l10n),
                ),
                const SizedBox(height: 110),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingPlans(AppLocalizations l10n) {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          const SizedBox(width: 20),
          _buildPlanCard(
            l10n.peacePathPlan,
            l10n.peacePathDesc,
            '፰/፲፭',
            SabaColors.secondary,
            Icons.spa_rounded,
          ),
          const SizedBox(width: 16),
          _buildPlanCard(
            l10n.fastingSeasonPlan,
            l10n.fastingSeasonDesc,
            '፪/፵',
            SabaColors.primary,
            Icons.wb_sunny_rounded,
          ),
          const SizedBox(width: 16),
          _buildPlanCard(
            l10n.newPlan,
            'መጽሐፈ ኢዮብ ጥናት',
            '፟፟፟፟፟፟፟፟፟፟፟-፟፟፟፟፟፟፟፟፟፟፟/፵፪',
            Colors.blueGrey,
            Icons.menu_book_rounded,
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(AppLocalizations l10n) {
    return Column(
      children: [
        _buildActivityItem(
          Icons.edit_note_rounded,
          l10n.recordedVerse,
          'መዝሙረ ዳዊት  Get-፱',
          l10n.twoHoursAgo,
          SabaColors.secondary,
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          Icons.check_circle_rounded,
          l10n.finishedChapter,
          'ወንጌል ቅዱስ ዮሐንስ ፫',
          l10n.yesterday,
          SabaColors.primary,
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    IconData icon,
    String title,
    String subtitle,
    String time,
    Color iconColor,
  ) {
    return _ActivityTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      time: time,
      iconColor: iconColor,
    );
  }

  Widget _buildPlanCard(
    String title,
    String description,
    String progress,
    Color color,
    IconData icon,
  ) {
    return _ReadingPlanCard(
      title: title,
      description: description,
      progress: progress,
      color: color,
      icon: icon,
    );
  }
}

// ── Shared Components ──────────────────────────────────────────────────────

Widget _buildSectionHeader(BuildContext context, String title, String? trailingText, VoidCallback? onTrailingTap) {
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
                  trailingText,
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

class _DailyVerseCard extends StatelessWidget {
  const _DailyVerseCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: SabaColors.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: SabaColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.dailyVerse,
                style: SabaTypography.labelSmall().copyWith(
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '«እግዚአብሔር ብርሃኔና መድኃኒቴ ነው፤ የሚያስፈራኝ ማን ነው?»',
            style: SabaTypography.headlineMedium().copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Noto Serif Ethiopic',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'መዝሙረ ዳዊት ፳፯:፩',
            style: SabaTypography.bodyMedium().copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildContinueReadingCard(BuildContext context, AppLocalizations l10n) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          SabaColors.primary,
          SabaColors.primary.withValues(alpha: 0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(32),
      boxShadow: [
        BoxShadow(
          color: SabaColors.primary.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ኦሪት ዘፍጥረት', // This should probably stay in Amharic or be translated list-style
                style: SabaTypography.labelSmall().copyWith(color: Colors.white),
              ),
            ),
            const Spacer(),
            const Icon(Icons.bookmark_added_rounded, color: Colors.white, size: 20),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          '${l10n.chapter} ፩ : ፩-፲',
          style: SabaTypography.headlineMedium().copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: 0.65,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '65% ${l10n.completed}',
              style: SabaTypography.labelSmall().copyWith(color: Colors.white.withValues(alpha: 0.7)),
            ),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
          ],
        ),
      ],
    ),
  );
}


class _ReadingPlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String progress;
  final Color color;
  final IconData icon;

  const _ReadingPlanCard({
    required this.title,
    required this.description,
    required this.progress,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          Text(
            title,
            style: tt.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: SabaColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: tt.bodySmall!.copyWith(
              color: SabaColors.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                progress,
                style: tt.labelSmall!.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color iconColor;

  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SabaColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SabaColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: SabaColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
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
          const SizedBox(width: 12),
          Text(
            time,
            style: tt.labelSmall!.copyWith(
              color: SabaColors.onSurfaceVariant.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
