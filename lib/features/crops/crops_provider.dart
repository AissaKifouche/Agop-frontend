import 'package:flutter/material.dart';
import 'crop.dart';

class CropsProvider extends ChangeNotifier{
  final List<Crop> _crops = [];

  List<Crop> get crops => List.unmodifiable(_crops);

  void addCrop(Crop crop){
    _crops.add(crop);
    notifyListeners();
  }

  void deleteCrop(int index){
    _crops.removeAt(index);
    notifyListeners();
  }

  void updateCrop(int index, Crop updated){
    _crops[index] = updated;
    notifyListeners();
  }
}
