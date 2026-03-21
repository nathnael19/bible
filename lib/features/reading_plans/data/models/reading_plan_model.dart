import '../../domain/entities/reading_plan.dart';

class ReadingPlanModel extends ReadingPlan {
  const ReadingPlanModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    super.imageUrl,
    required super.durationDays,
    required super.days,
  });

  factory ReadingPlanModel.fromJson(Map<String, dynamic> json) {
    return ReadingPlanModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String?,
      durationDays: json['durationDays'] as int,
      days: (json['days'] as List<dynamic>)
          .map((d) => PlanDayModel.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'durationDays': durationDays,
      'days': days.map((d) => (d as PlanDayModel).toJson()).toList(),
    };
  }
}

class PlanDayModel extends PlanDay {
  const PlanDayModel({
    required super.dayNumber,
    required super.tasks,
  });

  factory PlanDayModel.fromJson(Map<String, dynamic> json) {
    return PlanDayModel(
      dayNumber: json['dayNumber'] as int,
      tasks: (json['tasks'] as List<dynamic>)
          .map((t) => PlanTaskModel.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'tasks': tasks.map((t) => (t as PlanTaskModel).toJson()).toList(),
    };
  }
}

class PlanTaskModel extends PlanTask {
  const PlanTaskModel({
    required super.id,
    required super.description,
    super.reference,
  });

  factory PlanTaskModel.fromJson(Map<String, dynamic> json) {
    return PlanTaskModel(
      id: json['id'] as String,
      description: json['description'] as String,
      reference: json['reference'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'reference': reference,
    };
  }
}
