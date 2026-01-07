
import 'package:hive/hive.dart';
import 'dart:async';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {

  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late bool isDone;

  @HiveField(3)
  late int _duration; // Stored in seconds

  @HiveField(4)
  late int _remainingTime; // Stored in seconds

  Timer? timer;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    Duration duration = const Duration(minutes: 25),
  }) {
    this.duration = duration;
    remainingTime = duration;
  }

  Duration get duration => Duration(seconds: _duration);
  set duration(Duration value) {
    _duration = value.inSeconds;
  }

  Duration get remainingTime => Duration(seconds: _remainingTime);
  set remainingTime(Duration value) {
    _remainingTime = value.inSeconds;
  }
}
