import 'package:equatable/equatable.dart';

class ReadingPlan extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? imageUrl;
  final int durationDays;
  final List<PlanDay> days;

  const ReadingPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.durationDays,
    required this.days,
  });

  @override
  List<Object?> get props => [id, title, description, category, imageUrl, durationDays, days];
}

class PlanDay extends Equatable {
  final int dayNumber;
  final List<PlanTask> tasks;

  const PlanDay({
    required this.dayNumber,
    required this.tasks,
  });

  @override
  List<Object?> get props => [dayNumber, tasks];
}

class PlanTask extends Equatable {
  final String id;
  final String description;
  final String? reference; // Format: "GEN.1.1-GEN.3.24"

  const PlanTask({
    required this.id,
    required this.description,
    this.reference,
  });

  @override
  List<Object?> get props => [id, description, reference];
}
