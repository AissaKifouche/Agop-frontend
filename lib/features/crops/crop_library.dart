import 'package:flutter/material.dart';
import 'crop_template.dart';

class CropLibrary {
  static const List<CropTemplate> crops = [
    CropTemplate(
      name: "Wheat",
      emoji: "🌾",
      stages: ["Germination", "Tellering", "Stem Extension", "Heading", "Ripening"],
      stageDurations: [10, 20, 25, 15, 30],      // total: 100 days
      defaultStatusColor: Color(0xFF2E7A52),
      defaultProgressColor: Color(0xFF5BBF86),
    ),
    CropTemplate(
      name: "Tomato",
      emoji: "🍅",
      stages: ["Germination", "Seedling", "Vegetative", "Flowering", "Fruiting"],
      stageDurations: [8, 20, 25, 15, 42],       // total: 110 days
      defaultStatusColor: Color(0xFF2E7A52),
      defaultProgressColor: Color(0xFFE8734A),
    ),
    CropTemplate(
      name: "Potato",
      emoji: "🥔",
      stages: ["Sprouting", "Vegetative", "Tuber Initiation", "Bulking", "Maturation"],
      stageDurations: [20, 30, 20, 40, 10],      // total: 120 days
      defaultStatusColor: Color(0xFF2E7A52),
      defaultProgressColor: Color(0xFFB8926A),
    ),
    CropTemplate(
      name: "Olive",
      emoji: "🫒",
      stages: ["Budding", "Flowering", "Fruit Set", "Growth", "Ripening"],
      stageDurations: [25, 15, 20, 90, 30],      // total: 180 days
      defaultStatusColor: Color(0xFF2E7A52),
      defaultProgressColor: Color(0xFF7A9E5F),
    ),
    CropTemplate(
      name: "Onion",
      emoji: "🧅",
      stages: ["Germination", "Seedling", "Bulb Formation", "Maturation"],
      stageDurations: [12, 25, 50, 33],          // total: 120 days
      defaultStatusColor: Color(0xFF2E7A52),
      defaultProgressColor: Color(0xFFD4A84B),
    ),
    CropTemplate(
      name: "Watermelon",
      emoji: "🍉",
      stages: ["Germination", "Vine Growth", "Flowering", "Fruit Development", "Ripening"],
      stageDurations: [8, 25, 15, 30, 12],       // total: 90 days
      defaultStatusColor: Color(0xFF2E7A52),
      defaultProgressColor: Color(0xFF5BBF86),
    ),
    CropTemplate(
      name: "Pepper",
      emoji: "🌶️",
      stages: ["Germination", "Seedling", "Vegetative", "Flowering", "Fruiting"],
      stageDurations: [12, 20, 30, 18, 30],      // total: 110 days
      defaultStatusColor: Color(0xFF2E7A52),
      defaultProgressColor: Color(0xFFD94F3D),
    ),
    CropTemplate(
      name: "Sunflower",
      emoji: "🌻",
      stages: ["Germination", "Vegetative", "Budding", "Flowering", "Seed Fill"],
      stageDurations: [8, 35, 12, 15, 25],       // total: 95 days
      defaultStatusColor: Color(0xFF2E7A52),
      defaultProgressColor: Color(0xFFE8B84B),
    ),
  ];

  static CropTemplate? findByName(String name) {
    try {
      return crops.firstWhere((c) => c.name == name);
    } catch (_) {
      return null;
    }
  }
}