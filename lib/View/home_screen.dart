import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_tracker/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

import 'add_tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  final SharedPreferences prefs; // Add SharedPreferences as a parameter

  const HomeScreen({super.key, required this.prefs});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when the HomeScreen initializes
  }

  void _loadTasks() {
    final List<String>? taskStrings = widget.prefs.getStringList('tasks');
    if (taskStrings != null) {
      setState(() {
        _tasks = taskStrings
            .map((taskString) => Task.fromJson(jsonDecode(taskString)))
            .toList();
      });
    }
  }

  void _toggleTaskCompletion(int taskId) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
        _saveTasks(); // Save tasks after updating
      }
    });
  }

  void _deleteTask(int taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
      _saveTasks(); // Save tasks after deleting
    });
  }

  void _addTask(Task newTask) {
    setState(() {
      _tasks.add(newTask);
      _saveTasks(); // Save tasks after adding
    });
  }

  void _saveTasks() {
    final List<String> taskStrings =
        _tasks.map((task) => jsonEncode(task.toJson())).toList().cast<String>();
    widget.prefs.setStringList('tasks', taskStrings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Task Tracker'),
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks available',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.separated(
              itemCount: _tasks.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => _toggleTaskCompletion(task.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTask(task.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTaskScreen(addTaskCallback: _addTask)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
