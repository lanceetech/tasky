
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list_item.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addTask(String title, Duration duration) {
    Provider.of<TaskProvider>(context, listen: false).addTask(title, duration);
    _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Duration (minutes)', hintText: 'e.g., 30'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final duration = int.tryParse(durationController.text) ?? 25;
                _addTask(titleController.text, Duration(minutes: duration));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<Task> tasks = _getTasksForCurrentTab(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: tasks.length,
        itemBuilder: (context, index, animation) {
          final task = tasks[index];
          return SizeTransition(
            sizeFactor: animation,
            child: TaskListItem(key: ValueKey(task.id), task: task),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ).animate().scale(),
    );
  }

  List<Task> _getTasksForCurrentTab(TaskProvider taskProvider) {
    switch (_tabController.index) {
      case 1:
        return taskProvider.pendingTasks;
      case 2:
        return taskProvider.completedTasks;
      default:
        return taskProvider.tasks;
    }
  }
}
