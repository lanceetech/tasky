
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskListItem extends StatefulWidget {
  final Task task;

  const TaskListItem({required this.task, super.key});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.task.timer != null) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.startTimer(widget.task.id);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _pauseTimer() {
    Provider.of<TaskProvider>(context, listen: false).pauseTimer(widget.task.id);
    _timer?.cancel();
    _timer = null;
  }

  void _resetTimer() {
    Provider.of<TaskProvider>(context, listen: false).resetTimer(widget.task.id);
  }

  String _formatDuration(Duration duration) {
    final format = DateFormat('mm:ss', 'en_US');
    return format.format(DateTime(0).add(duration));
  }

  void _showEditTaskDialog() {
    final TextEditingController titleController = TextEditingController(text: widget.task.title);
    final TextEditingController durationController =
        TextEditingController(text: widget.task.duration.inMinutes.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
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
                Provider.of<TaskProvider>(context, listen: false).editTask(
                  widget.task.id,
                  titleController.text,
                  Duration(minutes: duration),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final bool isTimerRunning = widget.task.timer != null;
    final double progress = widget.task.duration.inSeconds > 0
        ? widget.task.remainingTime.inSeconds / widget.task.duration.inSeconds
        : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          Positioned.fill(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(
                ColorTween(
                  begin: Colors.green,
                  end: Colors.red,
                ).transform(1 - progress) ?? Colors.green,
              ),
            ).animate(target: isTimerRunning ? 1 : 0).fadeIn(duration: 500.ms).then().blur(end: 10).fadeOut(duration: 250.ms),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Checkbox(
              value: widget.task.isDone,
              onChanged: (value) => taskProvider.toggleTaskStatus(widget.task.id),
            ),
            title: Text(
              widget.task.title,
              style: TextStyle(
                decoration: widget.task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${_formatDuration(widget.task.remainingTime)} / ${_formatDuration(widget.task.duration)}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                if (!widget.task.isDone)
                  const SizedBox(height: 8),
                if (!widget.task.isDone)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(isTimerRunning ? Icons.pause : Icons.play_arrow),
                        onPressed: isTimerRunning ? _pauseTimer : _startTimer,
                        tooltip: isTimerRunning ? 'Pause' : 'Start',
                      ).animate(target: isTimerRunning ? 1 : 0).shake(),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _resetTimer,
                        tooltip: 'Reset',
                      ).animate().rotate(),
                    ],
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _showEditTaskDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => taskProvider.deleteTask(widget.task.id),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 500.ms).slideX();
  }
}
