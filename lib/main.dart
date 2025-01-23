import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/theme_provider.dart';
import 'screens/add_task_screen.dart';
import 'screens/edit_task_screen.dart';
import 'screens/task_detail_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/toggle_task_screen.dart';

void main() {
  runApp(const ProviderScope(child: TaskManagementApp()));
}

class TaskManagementApp extends ConsumerWidget {
  const TaskManagementApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const TaskListScreen(),
        '/add_task': (context) => const AddTaskScreen(),
        '/edit_task': (context) => EditTaskScreen(taskId: ModalRoute.of(context)!.settings.arguments as int),
        '/task_detail': (context) => TaskDetailScreen(taskId: ModalRoute.of(context)!.settings.arguments as int),
        '/toggle_task': (context) => const ToggleTaskScreen(),
      },
    );
  }
}
