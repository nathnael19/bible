import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/reading_plan_cubit.dart';
import '../../domain/entities/reading_plan.dart';
import 'plan_detail_screen.dart';

class ReadingPlansScreen extends StatelessWidget {
  const ReadingPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocProvider(
      create: (context) => sl<ReadingPlanCubit>()..loadPlans(locale: l10n.localeName),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.readingPlans),
        ),
        body: BlocBuilder<ReadingPlanCubit, ReadingPlanState>(
          builder: (context, state) {
            if (state is ReadingPlanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReadingPlanError) {
              return Center(child: Text(state.message));
            } else if (state is ReadingPlansLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.plans.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final plan = state.plans[index];
                  final progress = state.progressMap[plan.id] ?? 0.0;
                  return _ReadingPlanCard(plan: plan, progress: progress);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ReadingPlanCard extends StatelessWidget {
  final ReadingPlan plan;
  final double progress;

  const _ReadingPlanCard({required this.plan, required this.progress});

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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    plan.category,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.daysCount(plan.durationDays),
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              plan.title,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              plan.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.percentCompleted((progress * 100).toInt()),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
