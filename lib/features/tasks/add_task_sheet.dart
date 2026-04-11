import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../crops/crops_provider.dart';
import 'task.dart';
import 'tasks_provider.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});
  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  TaskType _type = TaskType.watering;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedCropId;




  bool get _isValid => _selectedCropId != null;

  void _submit() {
    if (_selectedCropId == null) return;
    context.read<TasksProvider>().addTask(Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: _type,
      dueDate: _dueDate,
      cropId: _selectedCropId!,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final crops = context.watch<CropsProvider>().crops;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: theme.colorScheme.outlineVariant, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('New Task', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
      
            // Task type chips
            Text('Task type', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: TaskType.values.map((t) => ChoiceChip(
                avatar: Icon(t.icon, size: 16, color: _type == t ? Colors.white : t.color),
                label: Text(t.label),
                selected: _type == t,
                selectedColor: t.color,
                onSelected: (_) => setState(() => _type = t),
              )).toList(),
            ),
            const SizedBox(height: 20),
      
            // Link toggle
            Text('Crop', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedCropId,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Select crop'),
              items: crops.map((c) => DropdownMenuItem(value: c.id, child: Text('${c.name}  ·  ${c.fieldName}'))).toList(),
              onChanged: (v) => setState(() => _selectedCropId = v),
            ),


            const SizedBox(height: 20),
      
            // Due date
            Text('Due date', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _dueDate = picked);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(border: Border.all(color: theme.colorScheme.outline), borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  Icon(Icons.calendar_today_outlined, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Text('${_dueDate.day}/${_dueDate.month}/${_dueDate.year}', style: theme.textTheme.bodyLarge),
                ]),
              ),
            ),
            const SizedBox(height: 28),
      


            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isValid ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7A52),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Add task",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20,),

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
}