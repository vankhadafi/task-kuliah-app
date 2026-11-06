enum TaskType { individu, kelompok, praktikum }
enum ReminderInterval { hMinus3, hMinus1, threeHoursBefore }

class SubTask {
  String id;
  String title;
  bool isCompleted;

  SubTask({required this.id, required this.title, this.isCompleted = false});
}

class Task {
  String id;
  String title;
  String description;
  String course;
  TaskType type;
  DateTime deadline;
  ReminderInterval reminder;
  List<SubTask> subTasks;
  String submissionUrl;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.course,
    required this.type,
    required this.deadline,
    required this.reminder,
    required this.subTasks,
    this.submissionUrl = '',
    this.isDone = false,
  });

  double get progress {
    if (subTasks.isEmpty) return isDone ? 1.0 : 0.0;
    final done = subTasks.where((s) => s.isCompleted).length;
    return done / subTasks.length;
  }
}
