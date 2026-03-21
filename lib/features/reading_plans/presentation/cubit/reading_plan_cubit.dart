import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/reading_plan.dart';
import '../../domain/repositories/i_reading_plan_repository.dart';

abstract class ReadingPlanState extends Equatable {
  const ReadingPlanState();

  @override
  List<Object?> get props => [];
}

class ReadingPlanInitial extends ReadingPlanState {}

class ReadingPlanLoading extends ReadingPlanState {}

class ReadingPlansLoaded extends ReadingPlanState {
  final List<ReadingPlan> plans;
  final Map<String, double> progressMap;

  const ReadingPlansLoaded(this.plans, this.progressMap);

  @override
  List<Object?> get props => [plans, progressMap];
}

class ReadingPlanDetailLoaded extends ReadingPlanState {
  final ReadingPlan plan;
  final List<String> completedTaskIds;

  const ReadingPlanDetailLoaded({
    required this.plan,
    required this.completedTaskIds,
  });

  @override
  List<Object?> get props => [plan, completedTaskIds];
}

class ReadingPlanError extends ReadingPlanState {
  final String message;

  const ReadingPlanError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReadingPlanCubit extends Cubit<ReadingPlanState> {
  final IReadingPlanRepository _repository;

  ReadingPlanCubit(this._repository) : super(ReadingPlanInitial());

  Future<void> loadPlans({String locale = 'en'}) async {
    emit(ReadingPlanLoading());
    try {
      final plans = await _repository.getReadingPlans(locale: locale);
      final progressMap = <String, double>{};
      for (final plan in plans) {
        final completed = await _repository.getCompletedTaskIds(plan.id);
        final totalTasks = plan.days.fold(0, (sum, day) => sum + day.tasks.length);
        progressMap[plan.id] = totalTasks > 0 ? completed.length / totalTasks : 0.0;
      }
      emit(ReadingPlansLoaded(plans, progressMap));
    } catch (e) {
      emit(ReadingPlanError(e.toString()));
    }
  }

  Future<void> loadPlanDetail(String planId, {String locale = 'en'}) async {
    // Current state could be ReadingPlansLoaded or ReadingPlanDetailLoaded
    // We want to preserve the plan if we already have it, or fetch it if not.
    emit(ReadingPlanLoading());
    try {
      final plan = await _repository.getReadingPlanById(planId, locale: locale);
      if (plan != null) {
        final completed = await _repository.getCompletedTaskIds(planId);
        emit(ReadingPlanDetailLoaded(plan: plan, completedTaskIds: completed));
      } else {
        emit(const ReadingPlanError("Plan not found"));
      }
    } catch (e) {
      emit(ReadingPlanError(e.toString()));
    }
  }

  Future<void> toggleTaskCompletion(String planId, String taskId) async {
    try {
      await _repository.toggleTaskCompletion(planId, taskId);
      if (state is ReadingPlanDetailLoaded) {
        final currentState = state as ReadingPlanDetailLoaded;
        final updatedCompleted = List<String>.from(currentState.completedTaskIds);
        if (updatedCompleted.contains(taskId)) {
          updatedCompleted.remove(taskId);
        } else {
          updatedCompleted.add(taskId);
        }
        emit(ReadingPlanDetailLoaded(
          plan: currentState.plan,
          completedTaskIds: updatedCompleted,
        ));
      }
    } catch (e) {
      // Handle error or stay in current state
    }
  }
}
