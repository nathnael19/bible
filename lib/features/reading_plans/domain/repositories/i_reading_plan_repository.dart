import '../entities/reading_plan.dart';

abstract class IReadingPlanRepository {
  Future<List<ReadingPlan>> getReadingPlans();
  Future<ReadingPlan?> getReadingPlanById(String id);
  Future<List<String>> getCompletedTaskIds(String planId);
  Future<void> toggleTaskCompletion(String planId, String taskId);
  Future<void> clearPlanProgress(String planId);
}
