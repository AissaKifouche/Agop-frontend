import 'dart:convert';

import 'package:agop/features/crops/crop.dart';
import 'package:agop/features/crops/crop_library.dart';
//import 'package:agop/features/crops/crops_provider.dart';
import 'package:agop/services/api_service.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_crop_sheet.dart';

class CropsPage extends StatefulWidget {
  const CropsPage({super.key});

  @override
  State<CropsPage> createState() => CropsPageState();
}

class CropsPageState extends State<CropsPage> {

  int? farmerId;
  List<Crop> crops = [];


  Future<void> loadCrops() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('user_id');
      if (id == null) return;
      final result = await ApiService.getCrops(id);
      setState(() {
        farmerId = id;
        crops = result.map((json) => Crop.fromJson(json)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load crops."), backgroundColor: Colors.redAccent),
      );
    }
  }




  
  
  //a function to add crops
  void _showAddCropSheet(BuildContext context){
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(24)),
      ),
      context: context, 
      builder: (_) => AddCropSheet(),
    ).whenComplete(() => loadCrops());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCrops();
  }






  //to add later
  /*final filtered = _selectedFilter == 0
        ? crops
        : crops.where((c) {
            final template = CropLibrary.findByName(c.name)!;
            if (_selectedFilter == 1) return !template.isHarvestReady(c);
            if (_selectedFilter == 2) return template.isHarvestReady(c);
            return true;
          }).toList();*/









  @override
  Widget build(BuildContext context) {

    //to get the crops the user add using the adding sheet



    int needActions = crops.where((c) => c.needsImmediateAction).length;
    double totalHectars = crops.fold(0, (sum, c) => sum + c.area);


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          
          
          //the top green area
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF1A3D2B),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 10,),

                    Container(
                      padding: EdgeInsets.only(left: 20, bottom: 20),
                      child: Text(
                        "My Crops",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: "InstrumentSerif",
                        ),
                      ),
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.white.withValues(alpha: 0.2),
                            child: Column(
                              children: [
                                Text(
                                  "${crops.length}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: "InstrumentSerif",
                                  ),
                                ),
                                SizedBox(height: 4,),

                                Text(
                                  "ACTIVE CROPS",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withValues(alpha: 0.45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),

                        Expanded(
                          child: Card(
                            color: Colors.white.withValues(alpha: 0.2),
                            child: Column(
                              children: [
                                Text(
                                  "$totalHectars",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: "InstrumentSerif",
                                  ),
                                ),
                                SizedBox(height: 4,),

                                Text(
                                  "HECTARS ",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withValues(alpha: 0.45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),

                        Expanded(
                          child: Card(
                            color: Colors.white.withValues(alpha: 0.2),
                            child: Column(
                              children: [
                                Text(
                                  "$needActions",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: "InstrumentSerif",
                                  ),
                                ),
                                SizedBox(height: 4,),

                                Text(
                                  "NEED ACTIONS",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withValues(alpha: 0.45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

              ),



              //now the list of crops
              //

              Container(
                color: Color(0xFFF2EDE3),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: crops.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const Text("🌱", style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 12),
                      Text(
                        "No crops yet",
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.5),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Tap + to add your first crop",
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.3),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
                :ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: crops.length,
                  separatorBuilder: (_,__) => SizedBox(height: 12,),
                  itemBuilder: (context, i) {
                    final crop = crops[i];
                    final template = CropLibrary.findByName(crop.name);

                    return Card(

                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [

                          // main content
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // top row: emoji + name + status dot
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0F4FF),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(template!.emoji,
                                          style: const TextStyle(fontSize: 30)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            crop.name,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontFamily: "InstrumentSerif",
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "${crop.fieldName} · ${crop.soilType} soil",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // status dot
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: crop.needsImmediateAction
                                            ? Colors.red
                                            : const Color(0xFF2E7A52),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // stage row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "🌸 ${template.currentStage(crop)} stage",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "Day ${template.currentDay(crop)} / ${template.totalStageDays(crop)}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.brown.shade400,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // progress bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: template.progressPercentage(crop),
                                    backgroundColor: Colors.brown.shade100,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        crop.progressBarColor),
                                    minHeight: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // divider
                          Divider(height: 1, color: Colors.grey.shade200),

                          // stats row
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                _cropStat(
                                  "${crop.daysSinceWatered} days",
                                  "SINCE WATERED",
                                  crop.daysSinceWatered >= 3 ? Colors.red : Colors.black,
                                ),
                                VerticalDivider(width: 1, color: Colors.grey.shade200),
                                _cropStat(
                                  "${crop.daysSinceFertilized} days",
                                  "SINCE FERTILIZED",
                                  crop.daysSinceFertilized >= 10
                                      ? Colors.orange
                                      : Colors.black,
                                ),
                                VerticalDivider(width: 1, color: Colors.grey.shade200),
                                _cropStat(
                                  "${crop.area} ha",
                                  "AREA",
                                  Colors.black,
                                ),
                              ],
                            ),
                          ),

                          // alert banner — only shown when action needed
                          if (crop.daysSinceWatered >= 3) ...[
                            Divider(height: 1, color: Colors.grey.shade200),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDE8E8),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Text(
                                "💧 Water needed today — ${(crop.area * 3600).toStringAsFixed(0)} L required",
                                style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );

                  },
                ),
              ),




            ],
          ),
        ),
      ),
      
      //a button to add crops
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1A3D2B),
        onPressed: () {
          _showAddCropSheet(context);
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
Widget _cropStat(String value, String label, Color valueColor) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    ),
  );
}