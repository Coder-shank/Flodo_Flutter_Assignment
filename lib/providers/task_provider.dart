import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  // ✅ Main task list
  List<Task> tasks = [];

  String filter = "All";
  String searchQuery = "";

  // NEW: reorder tasks
  Future<void> reorderTask(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1; // Fix ReorderableListView behavior
    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);
    await saveTasksToDB(); // Persist the new order
    notifyListeners();
  }

  // ➕ Add Task
  void addTask(Task task) {
    tasks.add(task);
    saveTasksToDB();
    notifyListeners();
  }

  // ❌ Delete Task
  void deleteTask(int index) {
    tasks.removeAt(index);
    saveTasksToDB();
    notifyListeners();
  }

  // 🔄 Update Task
  void updateTask(int index, Task newTask) {
    tasks[index] = newTask;
    saveTasksToDB();
    notifyListeners();
  }

  // 🔍 Search + Filter logic
  List<Task> get filteredTasks {
    return tasks.where((task) {
      final matchSearch = task.title
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchFilter =
          filter == "All" ? true : task.status == filter;

      return matchSearch && matchFilter;
    }).toList();
  }

  // 🔒 Placeholder for saving tasks to DB
  Future<void> saveTasksToDB() async {
    // TODO: Implement persistence logic here
    // e.g., save to Hive, sqflite, Firebase, etc.
  }

  // Optional: load tasks from DB
  Future<void> loadTasksFromDB() async {
    // TODO: Implement loading logic here
    // tasks = await fetchFromDB();
    notifyListeners();
  }
}