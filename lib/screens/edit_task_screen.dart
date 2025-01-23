import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/providers/task_provider.dart';
import '../models/task.dart';
import '../view_models/task_view_model.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final int taskId;

  const EditTaskScreen({super.key, required this.taskId});

  @override
  EditTaskScreenState createState() => EditTaskScreenState();
}

class EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadTaskDetails();
  }

  Future<void> _loadTaskDetails() async {
    final task = await ref.read(taskViewModelProvider.notifier).getTaskById(widget.taskId);
    setState(() {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _isCompleted = task.isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Task Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Mark as Completed'),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateTask() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedTask = Task(
        id: widget.taskId,
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: _isCompleted,
        date: DateTime.now(),
      );

      ref.read(taskViewModelProvider.notifier).updateTask(updatedTask);
      Navigator.pop(context);
    }
  }
}
