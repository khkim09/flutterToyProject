import 'package:hive/hive.dart';

part 'todo_adapter.dart';

@HiveType(typeId: 0)
class TodoBox extends HiveObject {
  @HiveField(0)
  String text = "";

  @HiveField(1)
  DateTime startDate = DateTime.now();

  @HiveField(2)
  DateTime finishDate = DateTime.now();

  @HiveField(3)
  DateTime startTime = DateTime.now();

  @HiveField(4)
  DateTime finishTime = DateTime.now();

  @HiveField(5)
  String memo = "";

  @HiveField(6)
  bool isCompleted = false;
}