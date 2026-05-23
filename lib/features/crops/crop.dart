import 'package:flutter/material.dart';

import 'crop_library.dart';

class Crop {


  final int id;
  final int farmerId;
  final String growthStage;
  //for the user to provide
  final String name;
  final String fieldName;
  final String soilType;
  final double area;

  final DateTime plantingDate;

  //to get from the library
  final DateTime? lastWateredDate;
  final DateTime? lastFertilizedDate;



  Crop({
    required this.name,
    required this.fieldName,
    required this.soilType,
    required this.area,
    this.lastWateredDate,
    this.lastFertilizedDate,
    required this.plantingDate,
    required this.id,
    required this.farmerId,
    required this.growthStage,
});

  bool get needsImmediateAction => daysSinceWatered >= 3 || daysSinceFertilized >= 14;

  int get daysSincePlanting => DateTime.now().difference(plantingDate).inDays + 1;

  int get daysSinceWatered {
    if (lastWateredDate == null) return daysSincePlanting;
    return DateTime.now().difference(lastWateredDate!).inDays;
  }

  int get daysSinceFertilized {
    if (lastFertilizedDate == null) return daysSincePlanting;
    return DateTime.now().difference(lastFertilizedDate!).inDays;
  }


  bool get isHarvestReady {
    final template = CropLibrary.findByName(name);
    return template?.isHarvestReady(this) ?? false;
  }


  String get statusMessage {
    if (isHarvestReady) return "Ready for Harvest";
    if (needsImmediateAction) return "Needs Attention";
    return "Healthy Growth";
  }

  Color get statusColor => CropLibrary.findByName(name)?.defaultStatusColor ?? Colors.grey;
  Color get progressBarColor => CropLibrary.findByName(name)?.defaultProgressColor ?? Colors.green;


  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json["id"],
      farmerId: json["farmer_id"],
      name: json["crop_name"],
      fieldName: json["field_name"],
      soilType: json["soil_type"],
      area: (json["area"] as num).toDouble(),
      growthStage: json["growth_stage"],
      plantingDate: DateTime.parse(json["planting_date"]),
      lastWateredDate: json["last_watered_date"] != null
          ? DateTime.parse(json["last_watered_date"])
          : null,
      lastFertilizedDate: json["last_fertilized_date"] != null
          ? DateTime.parse(json["last_fertilized_date"])
          : null,
    );
  }



}