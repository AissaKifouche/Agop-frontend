/*import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'crop.dart';

class CropsProvider extends ChangeNotifier{
  final List<Crop> _crops = [];

  List<Crop> get crops => List.unmodifiable(_crops);

  void addCrop(Crop crop){
    _crops.add(crop);
    notifyListeners();
  }

  void deleteCrop(int cropId){
    _crops.removeWhere((crop) => crop.id == cropId);
    notifyListeners();
  }

  void updateCrop(Crop updated){
    final index = _crops.indexWhere((crop) => crop.id == updated.id);
    if (index != -1) {
      _crops[index] = updated;
      notifyListeners();
    }
  }


  Future<void> loadCrops(int farmerId) async {
    final data = await ApiService.getCrops(farmerId);
    _crops.clear();
    _crops.addAll(data.map((json) => Crop.fromJson(json)));
    notifyListeners();
  }

}
*/