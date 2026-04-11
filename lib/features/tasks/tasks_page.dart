import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../crops/crop.dart';
import '../crops/crops_provider.dart';
import 'add_task_sheet.dart';
import 'task.dart';
import 'tasks_provider.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TasksProvider>();
    final crops    = context.watch<CropsProvider>().crops;

    final total   = provider.all.length;
    final done    = provider.done.length;
    final pending = provider.pending.length;
    final overdue = provider.overdue.length;

    final sections = <_Section>[
      if (provider.overdue.isNotEmpty)  _Section('OVERDUE',   provider.overdue,  isOverdue: true),
      if (provider.today.isNotEmpty)    _Section('TODAY',     provider.today),
      if (provider.thisWeek.isNotEmpty) _Section('THIS WEEK', provider.thisWeek),
      if (provider.later.isNotEmpty)    _Section('LATER',     provider.later),
      if (provider.done.isNotEmpty)     _Section('COMPLETED', provider.done,     isDone: true),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2EFE8),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A7C59),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddTaskSheet(),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────
              Container(
                color: const Color(0xFF1C1F16),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 20, right: 20, bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Tasks',
                              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                          Text(DateFormat('EEEE, MMMM d').format(DateTime.now()),
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2D22),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(children: [
                        SizedBox(
                          width: 48, height: 48,
                          child: Stack(alignment: Alignment.center, children: [
                            CircularProgressIndicator(
                              value: total == 0 ? 0 : done / total,
                              strokeWidth: 4,
                              backgroundColor: Colors.white.withValues(alpha: 0.1),
                              valueColor: const AlwaysStoppedAnimation(Color(0xFF4A7C59)),
                            ),
                            Text('$done/$total',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ]),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('$done of $total done',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                            const SizedBox(height: 2),
                            Text(
                              '$pending remaining${overdue > 0 ? ' · $overdue overdue' : ''}',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                            ),
                          ]),
                        ),

                      ]),
                    ),
                  ],
                ),
              ),
        
              // ── Sections ──────────────────────────────────────────
              if (sections.isEmpty)
                SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Text('🌱', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text('No tasks yet', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                    ]),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    children: sections.map((s) => _SectionWidget(section: s, crops: crops)).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _Section {
  final String title;
  final List<Task> tasks;
  final bool isOverdue;
  final bool isDone;
  const _Section(this.title, this.tasks, {this.isOverdue = false, this.isDone = false});
}

class _SectionWidget extends StatelessWidget {
  final _Section section;
  final List<Crop> crops;
  const _SectionWidget({required this.section, required this.crops});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            Text(section.title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: section.isOverdue ? Colors.red.shade400 : Colors.grey.shade500,
                )),
            const SizedBox(width: 8),
            Expanded(child: Divider(color: Colors.grey.shade300, height: 1)),
          ]),
        ),
        ...section.tasks.map((t) => _TaskCard(
          task: t,
          crop: crops.firstWhere((c) => c.id == t.cropId, orElse: () => crops.first),
          isOverdue: section.isOverdue,
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final Task task;
  final Crop crop;
  final bool isOverdue;
  const _TaskCard({required this.task, required this.crop, this.isOverdue = false});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TasksProvider>();

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.delete_outline, color: Colors.red.shade400),
      ),
      onDismissed: (_) => provider.deleteTask(task.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: task.isDone ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isOverdue
              ? Border(left: BorderSide(color: Colors.red.shade400, width: 3))
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => provider.toggleDone(task.id),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Checkbox
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: GestureDetector(
                    onTap: () => provider.toggleDone(task.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        color: task.isDone ? const Color(0xFF4A7C59) : Colors.transparent,
                        border: Border.all(
                          color: task.isDone ? const Color(0xFF4A7C59) : Colors.grey.shade400,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: task.isDone
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      '${task.type.label} ${crop.name}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: task.isDone ? Colors.grey.shade400 : const Color(0xFF1C1F16),
                        decoration: task.isDone ? TextDecoration.lineThrough : null,
                        decorationColor: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(children: [
                      // Crop chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: task.type.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(task.type.icon2, style: const TextStyle(fontSize: 11)),
                          const SizedBox(width: 4),
                          Text(crop.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: task.type.color.darken(),
                                letterSpacing: 0.5,
                              )),
                        ]),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _contextText(),
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                  ]),
                ),

                // Type emoji
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(task.type.icon2, style: const TextStyle(fontSize: 18)),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  String _contextText() {
    if (task.isDone && task.completedAt != null) {
      return 'Done at ${DateFormat('h:mm a').format(task.completedAt!)}';
    }
    final now  = DateTime.now();
    final diff = task.dueDate.difference(DateTime(now.year, now.month, now.day)).inDays;
    final rel  = switch (diff) {
      0           => 'Anytime today',
      -1          => 'Was due yesterday',
      < 0         => '${diff.abs()} days ago',
      1           => 'Tomorrow',
      _           => 'In $diff days',
    };
    return '$rel · ${crop.fieldName}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────

extension ColorDarken on Color {
  Color darken([double amount = 0.3]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}