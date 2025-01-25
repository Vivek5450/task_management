import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/providers/task_provider.dart';

class TaskDetailScreen extends ConsumerWidget {
  final int taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsyncValue = ref.watch(taskViewModelProvider).firstWhere((task) => task.id == taskId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/edit_task', arguments: taskId);
            },
          ),
        ],
      ),
      body: taskAsyncValue == null
          ? const Center(child: Text("Task not found"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskAsyncValue.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Text(taskAsyncValue.description),
                  const SizedBox(height: 16.0),
                  Text("Completion Status: ${taskAsyncValue.isCompleted ? 'Completed' : 'Pending'}"),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/toggle_task');
                    },
                    child: const Text('Toggle Completion'),
                  ),
                ],
              ),
            ),
    );
  }
}
