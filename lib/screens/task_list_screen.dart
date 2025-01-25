import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/providers/task_provider.dart';
import '../providers/theme_provider.dart';


class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskViewModelProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.toggle_on),
            onPressed: () {
              Navigator.pushNamed(context, '/toggle_task');
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              themeNotifier.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add_task');
            },
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks available.'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          if (task.id != null) {
                            Navigator.pushNamed(
                              context,
                              '/edit_task',
                              arguments: task.id!,
                            );
                          } else {
                            // Handle null case, e.g., show a message or log
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid task ID.')),
                            );
                          }
                        },
                      ),
                      Switch(
                        value: task.isCompleted,
                        onChanged: (value) async {
                          if (task.id != null) {
                            await ref
                                .read(taskViewModelProvider.notifier)
                                .toggleCompletion(task.id!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid task ID.')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    if (task.id != null) {
                      Navigator.pushNamed(
                        context,
                        '/task_detail',
                        arguments: task.id!,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid task ID.')),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
