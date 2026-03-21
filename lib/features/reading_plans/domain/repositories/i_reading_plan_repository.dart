import '../entities/reading_plan.dart';

abstract class IReadingPlanRepository {
  Future<List<ReadingPlan>> getReadingPlans({String locale = 'en'});
  Future<ReadingPlan?> getReadingPlanById(String id, {String locale = 'en'});
  Future<List<String>> getCompletedTaskIds(String planId);
  Future<void> toggleTaskCompletion(String planId, String taskId);
  Future<void> clearPlanProgress(String planId);
}
