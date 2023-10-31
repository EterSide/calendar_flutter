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

  Calendar({
    required this.day,
    required this.title,
    required this.content,
    this.categoryId = -1
  });
}
