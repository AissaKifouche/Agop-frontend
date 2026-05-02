import 'package:agop/features/crops/crop.dart';
import 'package:flutter/material.dart';


//the class to be used to make instances in the crop library and use them to make crops later

class CropTemplate {
  final String name;
  final String emoji;
  final List<String> stages;        // ordered list of growth stages
  final List<int> stageDurations;   // days per stage, matching index
  final Color defaultStatusColor;
  final Color defaultProgressColor;

  const CropTemplate({
    required this.name,
    required this.emoji,
    required this.stages,
    required this.stageDurations,
    required this.defaultStatusColor,
    required this.defaultProgressColor,
  });

  int get totalDays => stageDurations.reduce((a, b) => a + b);

  // given how many days since planting, returns the current stage name
  String stageAtDay(int day) {
    int accumulated = 0;
    for (int i = 0; i < stages.length; i++) {
      accumulated += stageDurations[i];
      if (day <= accumulated) return stages[i];
    }
    return stages.last;
  }

  // days elapsed within the current stage
  int daysInCurrentStage(int daysSincePlanting) {
    int accumulated = 0;
    for (int i = 0; i < stages.length; i++) {
      int stageEnd = accumulated + stageDurations[i];
      if (daysSincePlanting <= stageEnd) {
        return daysSincePlanting - accumulated;
      }
      accumulated = stageEnd;
    }
    return stageDurations.last;
  }

  int totalStageDaysAt(int daysSincePlanting) {
    int accumulated = 0;
    for (int i = 0; i < stages.length; i++) {
      accumulated += stageDurations[i];
      if (daysSincePlanting <= accumulated) return stageDurations[i];
    }
    return stageDurations.last;
  }

  String currentStage(Crop crop) => stageAtDay(crop.daysSincePlanting);

  int currentDay(Crop crop) => daysInCurrentStage(crop.daysSincePlanting);

  int totalStageDays(Crop crop) => totalStageDaysAt(crop.daysSincePlanting);

  double progressPercentage(Crop crop) => currentDay(crop) / totalStageDays(crop);

  bool isHarvestReady(Crop crop) => crop.daysSincePlanting >= totalDays;


  Map<String, dynamic> toJson({
    required String fieldName,
    required String soilType,
    required double area,
    required DateTime plantingDate,
  }) {
    final daysSince = DateTime.now().difference(plantingDate).inDays + 1;
    return {
      "crop_name": name,
      "field_name": fieldName,
      "soil_type": soilType,
      "area": area,
      "growth_stage": stageAtDay(daysSince),
      "planting_date": plantingDate.toIso8601String(),
    };
  }



  /*Crop toCrop({
    required String fieldName,
    required String soilType,
    required double area,
    required DateTime plantingDate
  }){
    return Crop(
      name: name,
      fieldName: fieldName,
      soilType: soilType,
      area: area,
      plantingDate: plantingDate,
      lastWateredDate: null,
      lastFertilizedDate: null, id: null, farmerId: null, growthStage: '',
    );
  }*/
  
  

}