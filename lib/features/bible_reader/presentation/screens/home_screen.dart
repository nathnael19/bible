import 'package:flutter/material.dart';
import 'package:bible/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/navigation_cubit.dart';
import '../../../reading_plans/presentation/cubit/reading_plan_cubit.dart';
import '../../../reading_plans/domain/entities/reading_plan.dart';
import '../../../../core/di/injection_container.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import '../../../reading_plans/presentation/screens/plan_detail_screen.dart';
import '../../../../core/services/local_storage.dart';
import '../../../reading_plans/data/datasources/scripture_reference_mapper.dart';

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
                _buildSectionHeader(context, l10n.continueReading, l10n.seeAll, () {
                  context.read<NavigationCubit>().setTab(0);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LibraryScreen()));
                }),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildContinueReadingCard(context, l10n),
                ),
                const SizedBox(height: 32),

                // ── Reading Plans ─────────────────────────────────────────
                _buildSectionHeader(context, l10n.readingPlans, l10n.seeAll, () {
                  context.read<NavigationCubit>().setTab(1);
                }),
                const SizedBox(height: 16),
                BlocProvider(
                  create: (context) => sl<ReadingPlanCubit>()..loadPlans(locale: l10n.localeName),
                  child: BlocBuilder<ReadingPlanCubit, ReadingPlanState>(
                    builder: (context, state) {
                      if (state is ReadingPlanLoading) {
                        return const SizedBox(
                          height: 220,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is ReadingPlansLoaded) {
                        return _buildReadingPlans(context, l10n, state);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
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

  Widget _buildReadingPlans(BuildContext context, AppLocalizations l10n, ReadingPlansLoaded state) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: state.plans.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final plan = state.plans[index];
          final progress = state.progressMap[plan.id] ?? 0.0;
          return _ReadingPlanCard(
            plan: plan,
            progress: progress,
          );
        },
      ),
    );
  }

  Widget _buildRecentActivity(AppLocalizations l10n) {
    final storage = sl<LocalStorage>();
    final logs = storage.getActivityLog();
    if (logs.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];
    for (int i = 0; i < logs.length && i < 3; i++) {
      final log = logs[i];
      final type = log['type'];
      final bookId = log['bookId']?.toString() ?? '1';
      final chapter = log['chapter']?.toString() ?? '1';
      final timestampStr = log['timestamp'] as String?;
      final timestamp = timestampStr != null ? DateTime.parse(timestampStr) : DateTime.now();
      
      final bookName = ScriptureReferenceMapper.getLocalizedBookName(bookId, l10n.localeName);
      
      String title = '';
      String subtitle = '';
      IconData icon = Icons.check_circle_rounded;
      Color color = SabaColors.primary;

      if (type == 'bookmark') {
        title = l10n.recordedVerse;
        subtitle = '$bookName - ${log['verse']}';
        icon = Icons.edit_note_rounded;
        color = SabaColors.secondary;
      } else {
        title = l10n.finishedChapter;
        subtitle = '$bookName $chapter';
        icon = Icons.check_circle_rounded;
        color = SabaColors.primary;
      }
      
      children.add(_buildActivityItem(icon, title, subtitle, _formatTimeAgo(timestamp, l10n), color));
      if (i < 2 && i < logs.length - 1) {
        children.add(const SizedBox(height: 12));
      }
    }

    return Column(children: children);
  }

  String _formatTimeAgo(DateTime time, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 5) return l10n.justNow;
    if (diff.inHours < 24 && now.day == time.day) {
      if (diff.inHours >= 1 && diff.inHours <= 3) return l10n.twoHoursAgo;
      return l10n.today;
    }
    if (diff.inDays == 1 || (diff.inHours < 48 && now.day != time.day)) return l10n.yesterday;
    return '${diff.inDays} ${l10n.daysCount(diff.inDays)}';
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
                l10n.continueReadingBook,
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
              l10n.percentCompleted(65),
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
  final ReadingPlan plan;
  final double progress;

  const _ReadingPlanCard({
    required this.plan,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanDetailScreen(planId: plan.id),
          ),
        );
      },
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _getIconForCategory(plan.category),
                color: theme.colorScheme.onSecondaryContainer,
                size: 24,
              ),
            ),
            const Spacer(),
            Text(
              plan.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              plan.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      minHeight: 4,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.percentCompleted((progress * 100).toInt()),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'emotional wellbeing':
        return Icons.spa_rounded;
      case 'foundation':
        return Icons.menu_book_rounded;
      default:
        return Icons.auto_stories_rounded;
    }
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
