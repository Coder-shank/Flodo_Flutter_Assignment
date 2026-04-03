class Task {
  String title;
  String description;
  DateTime dueDate;
  String status; // "To-Do", "In Progress", "Done"
  String? blockedBy; // optional

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.blockedBy,
  });
}