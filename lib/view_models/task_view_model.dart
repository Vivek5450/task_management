import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task.dart';
import '../serivices/task_services.dart';

class TaskViewModel extends StateNotifier<List<Task>> {
  final TaskService taskService;

  TaskViewModel(this.taskService) : super([]);

  Future<void> loadTasks() async {
    state = await taskService.getTasks();
  }

  Future<void> addTask(Task task) async {
    await taskService.insertTask(task);
    loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await taskService.updateTask(task);
    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await taskService.deleteTask(id);
    loadTasks();
  }

  Future<void> toggleCompletion(int id) async {
    await taskService.toggleTaskCompletion(id);
    loadTasks();
  }

  Future<Task> getTaskById(int id) async {
    return await taskService.getTaskById(id);
  }
}
