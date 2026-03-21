import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bible/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../bible_reader/presentation/cubit/bible_reader_cubit.dart';
import '../../../bible_reader/presentation/cubit/navigation_cubit.dart';
import '../../domain/entities/reading_plan.dart';
import '../cubit/reading_plan_cubit.dart';
import '../../data/datasources/scripture_reference_mapper.dart';

class PlanDetailScreen extends StatefulWidget {
  final String planId;

  const PlanDetailScreen({super.key, required this.planId});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  int _selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => sl<ReadingPlanCubit>()..loadPlanDetail(widget.planId, locale: l10n.localeName),
      child: Scaffold(
        body: BlocBuilder<ReadingPlanCubit, ReadingPlanState>(
          builder: (context, state) {
            if (state is ReadingPlanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReadingPlanError) {
              return Center(child: Text(state.message));
            } else if (state is ReadingPlanDetailLoaded) {
              final plan = state.plan;
              final completed = state.completedTaskIds;
              final totalTasks = plan.days.fold(0, (sum, day) => sum + day.tasks.length);
              final progress = totalTasks > 0 ? completed.length / totalTasks : 0.0;
              final selectedDay = plan.days[_selectedDayIndex];

              return CustomScrollView(
                slivers: [
                  _buildAppBar(context, plan, progress),
                  SliverToBoxAdapter(
                    child: _buildDaySelector(plan),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = selectedDay.tasks[index];
                          return _TaskCard(
                            planId: widget.planId,
                            task: task,
                            isDone: completed.contains(task.id),
                          );
                        },
                        childCount: selectedDay.tasks.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ReadingPlan plan, double progress) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      stretch: true,
      backgroundColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SabaColors.primary,
                    SabaColors.secondary,
                  ],
                ),
              ),
            ),
            // Subtle Pattern or Overlay
            Positioned(
              right: -50,
              top: -50,
              child: Icon(
                Icons.auto_stories,
                size: 250,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        plan.category.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      plan.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildProgressInfo(theme, l10n, progress, plan.durationDays),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressInfo(ThemeData theme, AppLocalizations l10n, double progress, int totalDays) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.overallProgress,
              style: theme.textTheme.labelMedium?.copyWith(color: Colors.white70),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildDaySelector(ReadingPlan plan) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: plan.days.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = _selectedDayIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedDayIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 70,
              decoration: BoxDecoration(
                color: isSelected 
                    ? SabaColors.primary 
                    : Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: SabaColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ] : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.dayAbbreviation,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white70 : Colors.grey,
                    ),
                  ),
                  Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final String planId;
  final dynamic task;
  final bool isDone;

  const _TaskCard({
    required this.planId,
    required this.task,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDone 
              ? theme.colorScheme.primary.withValues(alpha: 0.2)
              : theme.colorScheme.outlineVariant.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CheckboxListTile(
              title: Text(
                task.description,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  color: isDone ? theme.colorScheme.onSurfaceVariant : null,
                ),
              ),
              subtitle: task.reference != null 
                  ? Text(
                      task.reference!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : null,
              value: isDone,
              onChanged: (val) {
                context.read<ReadingPlanCubit>().toggleTaskCompletion(planId, task.id);
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: theme.colorScheme.primary,
              checkboxShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              secondary: task.reference != null 
                  ? IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 18,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      onPressed: () => _navigateToReader(context),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToReader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ref = task.reference!;
    final parts = ref.split('-')[0].split('.');
    if (parts.length >= 2) {
      final bookAbbr = parts[0];
      final chapter = int.tryParse(parts[1]) ?? 1;
      final verse = parts.length > 2 ? int.tryParse(parts[2]) : null;
      
      final bookName = ScriptureReferenceMapper.getName(bookAbbr, locale: l10n.localeName) ?? bookAbbr;
      final bookId = ScriptureReferenceMapper.getId(bookAbbr);
      
      if (bookName != null) {
        context.read<BibleReaderCubit>().loadBookChapter(
          book: bookName,
          chapter: chapter,
          bookId: bookId,
          targetVerse: verse,
        );
        context.read<NavigationCubit>().setTab(2);
        Navigator.pop(context);
      }
    }
  }
}
