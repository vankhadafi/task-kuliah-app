import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _linkController = TextEditingController();
  final _subTaskInputController = TextEditingController();

  String _selectedCourse = 'OOP';
  TaskType _selectedType = TaskType.individu;
  ReminderInterval _selectedReminder = ReminderInterval.hMinus1;

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 23, minute: 59);

  final List<String> _courses = ['OOP', 'Database', 'Jaringan Komputer', 'AI'];
  final List<SubTask> _subTasks = [];

  void _addSubTask() {
    final text = _subTaskInputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _subTasks.add(SubTask(id: DateTime.now().toIso8601String(), title: text));
      _subTaskInputController.clear();
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final deadline = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      course: _selectedCourse,
      type: _selectedType,
      deadline: deadline,
      reminder: _selectedReminder,
      subTasks: _subTasks,
      submissionUrl: _linkController.text.trim(),
    );

    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tugas Baru', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul Tugas',
                hintText: 'Misal: Implementasi Polymorphism',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Petunjuk tugas, format file, dll.',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCourse,
                    decoration: InputDecoration(
                      labelText: 'Mata Kuliah',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _courses.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _selectedCourse = v!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<TaskType>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'Tipe',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: TaskType.values.map((t) {
                      return DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedType = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Batas Pengumpulan (Deadline)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(_selectedTime.format(context)),
                    onPressed: () async {
                      final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                      if (picked != null) setState(() => _selectedTime = picked);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Pengingat Notifikasi', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('H-3'),
                  selected: _selectedReminder == ReminderInterval.hMinus3,
                  onSelected: (_) => setState(() => _selectedReminder = ReminderInterval.hMinus3),
                ),
                ChoiceChip(
                  label: const Text('H-1'),
                  selected: _selectedReminder == ReminderInterval.hMinus1,
                  onSelected: (_) => setState(() => _selectedReminder = ReminderInterval.hMinus1),
                ),
                ChoiceChip(
                  label: const Text('3 Jam Sebelum'),
                  selected: _selectedReminder == ReminderInterval.threeHoursBefore,
                  onSelected: (_) => setState(() => _selectedReminder = ReminderInterval.threeHoursBefore),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Checklist Sub-tugas', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subTaskInputController,
                    decoration: InputDecoration(
                      hintText: 'Tambah langkah pengerjaan...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addSubTask,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._subTasks.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle_outline, color: AppColors.primary),
                title: Text(item.title),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => _subTasks.removeAt(idx)),
                ),
              );
            }),
            const SizedBox(height: 16),
            TextFormField(
              controller: _linkController,
              decoration: InputDecoration(
                labelText: 'Tautan Pengumpulan (Google Drive / GitHub / LMS)',
                hintText: 'https://...',
                prefixIcon: const Icon(Icons.link),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Simpan Tugas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
