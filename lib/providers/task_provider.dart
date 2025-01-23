import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../serivices/task_services.dart';
import 'package:task_management/models/task.dart';
import '../view_models/task_view_model.dart';

final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService();
});

final taskViewModelProvider = StateNotifierProvider<TaskViewModel, List<Task>>((ref) {
  final taskService = ref.watch(taskServiceProvider);
  return TaskViewModel(taskService);
});
