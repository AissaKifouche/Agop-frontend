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

}

class Task {
  final String id;
  final TaskType type;
  final DateTime dueDate;
  bool isDone;
  DateTime? completedAt;
  final String cropId;


  Task({
    required this.id,
    required this.type,
    required this.dueDate,
    this.isDone = false,
    required this.cropId,
  });

  bool get isOverdue => ! isDone && dueDate.isBefore(DateTime.now());


}