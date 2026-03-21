import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/services/local_storage.dart';
import '../../domain/entities/reading_plan.dart';
import '../../domain/repositories/i_reading_plan_repository.dart';
import '../models/reading_plan_model.dart';

class ReadingPlanRepositoryImpl implements IReadingPlanRepository {
  final LocalStorage _localStorage;

  ReadingPlanRepositoryImpl(this._localStorage);

  @override
  Future<List<ReadingPlan>> getReadingPlans() async {
    final String response = await rootBundle.loadString('assets/bible/reading_plans.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => ReadingPlanModel.fromJson(json)).toList();
  }

  @override
  Future<ReadingPlan?> getReadingPlanById(String id) async {
    final plans = await getReadingPlans();
    return plans.where((p) => p.id == id).firstOrNull;
  }

  @override
  Future<List<String>> getCompletedTaskIds(String planId) async {
    return _localStorage.getCompletedTaskIds(planId);
  }

  @override
  Future<void> toggleTaskCompletion(String planId, String taskId) async {
    await _localStorage.toggleTaskCompletion(planId, taskId);
  }

  @override
  Future<void> clearPlanProgress(String planId) async {
    await _localStorage.clearPlanProgress(planId);
  }
}
