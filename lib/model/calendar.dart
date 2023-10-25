import 'package:hive/hive.dart';

part 'calendar.g.dart';

@HiveType(typeId: 0)
class Calendar extends HiveObject {
  @HiveField(0)
  String year;

  @HiveField(1)
  String month;

  @HiveField(2)
  DateTime day;

  @HiveField(3)
  String title;

  @HiveField(4)
  String content;

  Calendar({
    required this.year,
    required this.month,
    required this.day,
    required this.title,
    required this.content,
  });
}
