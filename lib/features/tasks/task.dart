import 'package:flutter/material.dart';

enum TaskType{
  watering, fertilizing, harvesting;

  String get label => switch (this) {
    TaskType.watering => "Watering",
    TaskType.fertilizing => "Fertilizing",
    TaskType.harvesting => "Harvesting",
  };

  IconData get icon => switch (this){
    TaskType.watering => Icons.water_drop_outlined,
    TaskType.fertilizing => Icons.science_outlined,
    TaskType.harvesting => Icons.grass_outlined,
  };

  String get icon2 => switch (this) {
    TaskType.watering    => '💧',
    TaskType.fertilizing => '🪴',
    TaskType.harvesting  => '🌾',
  };




  Color get color => switch (this){
    TaskType.watering => Color(0xFF4FC3F7),
    TaskType.fertilizing => Color(0xFFAED581),
    TaskType.harvesting  => Color(0xFFFFB74D),
  };


  static TaskType fromDescription(String description) {
    final lower = description.toLowerCase();
    if (lower.contains("water")) return TaskType.watering;
    if (lower.contains("fertili")) return TaskType.fertilizing;
    if (lower.contains("harvest")) return TaskType.harvesting;
    return TaskType.watering; // default fallback
  }



}

class Task {
  final int id;
  final TaskType type;
  final DateTime dueDate;
  bool isDone;
  DateTime? completedAt;
  final int cropId;
  final String description;



  Task({
    required this.id,
    required this.type,
    required this.dueDate,
    this.isDone = false,
    required this.cropId,
    required this.description,
  });

  bool get isOverdue => ! isDone && dueDate.isBefore(DateTime.now());


  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      cropId: json["crop_id"],
      description: json["description"],
      dueDate: DateTime.parse(json["due_date"]),
      isDone: json["is_done"],
      type: TaskType.fromDescription(json["description"]),
    );
  }


}