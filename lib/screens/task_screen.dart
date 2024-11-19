import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_setter_app/hive/task_model.dart'; // Import the Task model

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late Box<Task> _taskBox; // Box to store tasks
  TextEditingController _taskController = TextEditingController();
  List<Task> _tasks = []; // To hold the list of tasks

  @override
  void initState() {
    super.initState();
    _openTaskBox();
  }

  // Open the task box and fetch tasks
  void _openTaskBox() async {
    _taskBox = await Hive.openBox<Task>('taskBox');
    _loadTasks(); // Load tasks once the box is opened
  }

  // Load tasks from the Hive box
  void _loadTasks() {
    final List<Task> taskList =
        _taskBox.values.toList(); // Get tasks from the box
    setState(() {
      _tasks = taskList;
    });
  }

  // Add a new task
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      final task = Task(title: _taskController.text);
      _taskBox.add(task); // Add the task to the box
      _taskController.clear(); // Clear the input field
      _loadTasks(); // Reload the tasks list after adding a new task
    }
  }

  // Mark the task as completed (cross out)
  void _toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
    task.save(); // Save the updated task state
    _loadTasks(); // Reload tasks to reflect the change
  }

  // Delete the task
  void _deleteTask(Task task) {
    task.delete(); // Delete the task from the box
    _loadTasks(); // Reload tasks after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Setter'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'New Task',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addTask,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue)),
            child: Text('Add Task'),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Text('No tasks available',
                        style: TextStyle(color: Colors.white)))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];

                      return ListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: Colors.white,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(task),
                        ),
                        onTap: () => _toggleTaskCompletion(task),
                      );
                    },
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.black, // Set background to black
    );
  }
}
