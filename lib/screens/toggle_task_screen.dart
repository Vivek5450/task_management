import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/providers/task_provider.dart';
import '../view_models/task_view_model.dart';

class ToggleTaskScreen extends ConsumerWidget {
  const ToggleTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toggle Task Completion'),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks available.'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: Switch(
                    value: task.isCompleted,
                    onChanged: (value) async {
                      if (task.id != null) {
                        await ref
                            .read(taskViewModelProvider.notifier)
                            .toggleCompletion(task.id!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid task ID.'),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
