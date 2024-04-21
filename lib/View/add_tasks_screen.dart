import 'package:flutter/material.dart';
import 'package:task_tracker/model/task.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(Task) addTaskCallback;

  const AddTaskScreen({super.key, required this.addTaskCallback});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: null,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(250, 30)
                ),
                onPressed: () {
                  _addTask();
                },
                child: const Text('Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTask() {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty) {
      Task newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch, // Unique ID for each task
        title: title,
        description: description,
      );

      widget.addTaskCallback(newTask);

      Navigator.of(context).pop();
    } else {
      String message = '';
      if (title.isEmpty && description.isEmpty) {
        message = 'Please enter a title and description';
      } else if (title.isEmpty) {
        message = 'Please enter a title';
      } else {
        message = 'Please enter a description';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
