import 'package:flutter/material.dart';

class Crop {

  //for the user to provide
  final String name;
  final String fieldName;
  final String soilType;
  final double area;

  late final DateTime plantingDate;

  //to get from the library
  final DateTime? lastWateredDate;
  final DateTime? lastFertilizedDate;
  final String statusMessage;
  final Color statusColor;
  final Color progressBarColor;

  Crop({
    required this.name,
    required this.fieldName,
    required this.soilType,
    required this.area,
    this.lastWateredDate,
    this.lastFertilizedDate,
    required this.statusMessage,
    required this.statusColor,
    required this.progressBarColor,
    required this.plantingDate,
});

  bool get needsImmediateAction => daysSinceWatered >= 3 || daysSinceFertilized >= 10;

  int get daysSincePlanting => DateTime.now().difference(plantingDate).inDays + 1;

  int get daysSinceWatered {
    if (lastWateredDate == null) return daysSincePlanting;
    return DateTime.now().difference(lastWateredDate!).inDays;
  }

  int get daysSinceFertilized {
    if (lastFertilizedDate == null) return daysSincePlanting;
    return DateTime.now().difference(lastFertilizedDate!).inDays;
  }

}