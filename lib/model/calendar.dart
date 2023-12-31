import 'package:hive/hive.dart';

part 'calendar.g.dart';

@HiveType(typeId: 0)
class Calendar extends HiveObject {
  @HiveField(0)
  DateTime day;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  int categoryId;

  @HiveField(4)
  bool isDone = false;

  @HiveField(5)
  bool isAlarm = false;

  @HiveField(6)
  int durationDay = 0;

  @HiveField(7)
  int notificationId = -1;

  @HiveField(8)
  int alarmId = -1;

  Calendar({
    required this.day,
    required this.title,
    required this.content,
    this.categoryId = -1
  });
}
