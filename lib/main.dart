import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/scheduler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get the application's document directory
  final appDocumentDirectory = await getApplicationDocumentsDirectory();

  // Initialize Hive
  Hive.init(appDocumentDirectory.path);

  // Open a box for storing theme preferences
  await Hive.openBox('settings');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;
  late Box settingsBox;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    settingsBox = Hive.box('settings');

    // Check for saved theme preference
    if (settingsBox.containsKey('isDarkMode')) {
      isDarkMode = settingsBox.get('isDarkMode');
    } else {
      // Use system theme as default
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      isDarkMode = brightness == Brightness.dark;
      await settingsBox.put(
          'isDarkMode', isDarkMode); // Save default preference
    }
    setState(() {});
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    settingsBox.put('isDarkMode', isDarkMode); // Save preference
  }

  @override
  Widget build(BuildContext context) {
    if (!settingsBox.isOpen) {
      // Prevent build before Hive is initialized
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Setter App',
      theme: isDarkMode
          ? ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              primarySwatch: const MaterialColor(
                0xFFE60737,
                <int, Color>{
                  50: Color(0xFFE60737),
                  100: Color(0xFFE60737),
                  200: Color(0xFFE60737),
                  300: Color(0xFFE60737),
                  400: Color(0xFFE60737),
                  500: Color(0xFFE60737),
                  600: Color(0xFFE60737),
                  700: Color(0xFFE60737),
                  800: Color(0xFFE60737),
                  900: Color(0xFFE60737),
                },
              ),
            )
          : ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Colors.blue,
              textTheme: TextTheme(
                bodyLarge: TextStyle(
                    color: Colors.black), // Use bodyLarge for light mode text
              ),
            ),
      home: TaskScreen(toggleTheme: toggleTheme),
    );
  }
}

class TaskScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  TaskScreen({required this.toggleTheme});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late Box _taskBox;
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _openTaskBox();
  }

  Future<void> _openTaskBox() async {
    _taskBox = await Hive.openBox('tasks');
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      tasks = _taskBox.keys
          .map((key) => {
                'key': key,
                'task': _taskBox.get(key)['task'],
                'completed': _taskBox.get(key)['completed'] ?? false,
              })
          .toList();
    });
  }

  Future<void> _toggleTaskCompletion(int index) async {
    final key = tasks[index]['key'];
    final completed = !(tasks[index]['completed'] ?? false);
    await _taskBox
        .put(key, {'task': tasks[index]['task'], 'completed': completed});
    _loadTasks();
  }

  Future<void> _addTask(String task) async {
    await _taskBox.add({'task': task, 'completed': false});
    _loadTasks();
  }

  Future<void> _deleteTask(int index) async {
    final key = tasks[index]['key'];
    await _taskBox.delete(key);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Setter App"),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                'No tasks yet. Add a task!',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: GestureDetector(
                    onTap: () => _toggleTaskCompletion(index),
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        decoration: task['completed']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationThickness: task['completed'] ? 3.0 : 0.0,
                        color: task['completed']
                            ? Colors.grey
                            : Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors
                                    .black, // Adjust text color based on mode
                      ),
                      child: Text(task['task']),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(Icons.add),
        onPressed: () async {
          String? newTask = await _showAddTaskDialog();
          if (newTask != null && newTask.isNotEmpty) {
            _addTask(newTask);
          }
        },
      ),
    );
  }

  Future<String?> _showAddTaskDialog() async {
    String newTask = '';
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: TextField(
            onChanged: (value) => newTask = value,
            decoration: InputDecoration(hintText: 'Enter your task'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(newTask),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
