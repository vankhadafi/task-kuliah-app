import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';
import 'add_task_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;
  String _selectedCourse = 'Semua';

  final List<String> _courses = ['Semua', 'OOP', 'Database', 'Jaringan Komputer', 'AI'];

  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Tugas Proyek Akhir: CRUD API',
      description: 'Gunakan Spring Boot & PostgreSQL',
      course: 'Database',
      type: TaskType.kelompok,
      deadline: DateTime.now().add(const Duration(hours: 6)),
      reminder: ReminderInterval.threeHoursBefore,
      submissionUrl: 'https://github.com/repo',
      subTasks: [
        SubTask(id: 's1', title: 'ERD Database', isCompleted: true),
        SubTask(id: 's2', title: 'Setup Controller', isCompleted: true),
        SubTask(id: 's3', title: 'Testing Endpoint', isCompleted: false),
      ],
    ),
    Task(
      id: '2',
      title: 'Laporan Praktikum Subnetting',
      description: 'Laporan modul 4 format PDF',
      course: 'Jaringan Komputer',
      type: TaskType.praktikum,
      deadline: DateTime.now().add(const Duration(days: 2)),
      reminder: ReminderInterval.hMinus1,
      subTasks: [
        SubTask(id: 's4', title: 'Screenshot Packet Tracer', isCompleted: false),
      ],
    ),
  ];

  Color _getPriorityColor(DateTime deadline, bool isDone) {
    if (isDone) return AppColors.success;
    final diff = deadline.difference(DateTime.now());
    if (diff.inHours <= 24) return AppColors.urgent;
    if (diff.inDays <= 3) return AppColors.warning;
    return AppColors.primary;
  }

  String _formatCountdown(DateTime deadline) {
    final diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return 'Terlambat';
    if (diff.inHours < 24) return 'Sisa ${diff.inHours} jam';
    return 'Sisa ${diff.inDays} hari';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredTasks = _selectedCourse == 'Semua'
        ? _tasks
        : _tasks.where((t) => t.course == _selectedCourse).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, Mahasiswa 👋',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Jadwal & Tugas',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(Icons.notifications_none, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF6366F1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Progres Pekan Ini',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '7 dari 10 Sub-tugas Selesai',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _courses.length,
                  itemBuilder: (context, index) {
                    final course = _courses[index];
                    final isSelected = course == _selectedCourse;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(course),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black86),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        selectedColor: AppColors.primary,
                        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                          ),
                        ),
                        onSelected: (_) => setState(() => _selectedCourse = course),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Text(
                  'Tugas Mendatang (${filteredTasks.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = filteredTasks[index];
                    final priorityColor = _getPriorityColor(task.deadline, task.isDone);
                    final completedCount = task.subTasks.where((s) => s.isCompleted).length;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        task.course,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        task.type.name.toUpperCase(),
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: priorityColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.timer_outlined, size: 12, color: priorityColor),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatCountdown(task.deadline),
                                        style: TextStyle(
                                          color: priorityColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              task.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sub-tugas: $completedCount/${task.subTasks.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                  ),
                                ),
                                Text(
                                  '${(task.progress * 100).toInt()}%',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: task.progress,
                                backgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
                                valueColor: AlwaysStoppedAnimation<Color>(priorityColor),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: filteredTasks.length,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final newTask = await Navigator.push<Task>(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          if (newTask != null) {
            setState(() => _tasks.add(newTask));
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentNavIndex,
        onDestinationSelected: (idx) => setState(() => _currentNavIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), label: 'Jadwal'),
          NavigationDestination(icon: Icon(Icons.timer_outlined), label: 'Fokus'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Pengaturan'),
        ],
      ),
    );
  }
}
