import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'crop_library.dart';
import 'crop_template.dart';
import 'crops_provider.dart';

class AddCropSheet extends StatefulWidget {
  const AddCropSheet({super.key});

  @override
  State<AddCropSheet> createState() => _AddCropSheetState();
}

class _AddCropSheetState extends State<AddCropSheet> {
  CropTemplate? _selectedTemplate;
  final _fieldNameController = TextEditingController();
  final _areaController = TextEditingController();
  String _selectedSoilType = "Clay";
  DateTime _plantingDate = DateTime.now();

  final List<String> _soilTypes = ["Clay", "Sandy", "Loamy", "Silty", "Chalky"];

  @override
  void dispose() {
    _fieldNameController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _submit() {
    // basic validation
    if (_selectedTemplate == null ||
        _fieldNameController.text.isEmpty ||
        _areaController.text.isEmpty) {
      return;
    }

    final crop = _selectedTemplate!.toCrop(
      fieldName: _fieldNameController.text,
      soilType: _selectedSoilType,
      area: double.tryParse(_areaController.text) ?? 0,
      plantingDate: _plantingDate,
    );

    context.read<CropsProvider>().addCrop(crop);
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _plantingDate,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            surface: Colors.green,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _plantingDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            // handle bar
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
        
            const Text(
              "Add a crop",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontFamily: "InstrumentSerif",
              ),
            ),
            const SizedBox(height: 20),
        
            // crop type dropdown
            _label("Crop type"),
            DropdownButtonFormField<CropTemplate>(
              dropdownColor: Colors.green,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration("Select crop"),
              items: CropLibrary.crops.map((t) => DropdownMenuItem(
                value: t,
                child: Text("${t.emoji}  ${t.name}"),
              )).toList(),
              onChanged: (val) => setState(() => _selectedTemplate = val),
            ),
            const SizedBox(height: 14),
        
            // field name
            _label("Field name"),
            TextField(
              controller: _fieldNameController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration("e.g. Field A"),
            ),
            const SizedBox(height: 14),
        
            // soil type + area on the same row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Soil type"),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedSoilType,
                        dropdownColor: Colors.green,
                        style: const TextStyle(color: Colors.black),
                        decoration: _inputDecoration(""),
                        items: _soilTypes.map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s),
                        )).toList(),
                        onChanged: (val) => setState(() => _selectedSoilType = val!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Area (ha)"),
                      TextField(
                        controller: _areaController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                        decoration: _inputDecoration("e.g. 2.5"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
        
            // planting date
            _label("Planting date"),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_plantingDate.day}/${_plantingDate.month}/${_plantingDate.year}",
                      style: const TextStyle(color: Colors.black),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
        
            // submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7A52),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Add crop",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 24,),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  side: BorderSide(
                    color: Colors.grey,
                    width: 1
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(color: Colors.grey, fontSize: 12),
    ),
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey[400]),
    filled: true,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey)
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green)
    )
  );
}