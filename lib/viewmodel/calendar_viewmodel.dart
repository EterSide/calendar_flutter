import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/dart/extension/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/calendar.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class CalendarViewModel extends ChangeNotifier {
  late Box<Calendar> _CalendarBox;

  List<Calendar> _calendars = [];
  List<Calendar> get calendars => _calendars;

  List<Calendar> _acalendars = [];
  List<Calendar> get acalendars => _acalendars;

  List<Calendar> _scalendars = [];
  List<Calendar> get scalendars => _scalendars;

  Map<DateTime, List<Calendar>> _events = {};
  Map<DateTime, List<Calendar>> get events => _events;

  CalendarViewModel() {
    _openCalendarBox();
  }

  static Future<void> initializeHive() async {
    final appDocumentDir =
    await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(CalendarAdapter());
  }

  Future<void> _openCalendarBox() async {
    await Hive.openBox<Calendar>('calendars');
    _CalendarBox = Hive.box<Calendar>('calendars');

    await _loadCalendars();
    await _allCalendarsQ();
    await _loadAllCalendars();
  }

  Future<void> _loadAllCalendars() async {

    final allCalendarList = await _CalendarBox.values.toList();

    _acalendars = allCalendarList;

    notifyListeners();

  }


  Future<void> _loadCalendars() async {
    DateTime now = DateTime.now();
    final calendarList = await _CalendarBox.values
        .where((element) =>
    element.day.year == now.year &&
        element.day.month == now.month &&
        element.day.day == now.day)
        .toList();

    print(calendarList);

    _calendars = calendarList;

    notifyListeners();
  }
  //메모 저장하는 함수

  Future<void> addCalendar(Calendar calendar) async {
    await _CalendarBox.add(Calendar(
        day: DateTime(calendar.day.year, calendar.day.month, calendar.day.day,
            calendar.day.hour, calendar.day.minute),
        title: calendar.title,
        content: calendar.content,
        categoryId: calendar.categoryId));
    print(
        'addCalendar ${calendar.day} + ${calendar.title} + ${calendar.content}');

    await loadSelectedCalendars(calendar.day);
    await _allCalendarsQ();

    await selectCategory(calendar.categoryId);

    notifyListeners();
  }

  //메모 삭제하는 함수
  Future<void> deleteCalendar(int key, Calendar calendar) async {
    await _CalendarBox.delete(key);

    await _allCalendarsQ();

    await loadSelectedCalendars(calendar.day);


    notifyListeners();
  }

  //메모 수정하는 함수

  Future<void> updateCalendar(int key, Calendar calendar) async {
    print('view Up ${calendar.day} + ${calendar.title} + ${calendar.content}');
//업데이트 완료 후, 포커스를 바뀐 날짜로 바꾸던지
//아니면 기존 날짜의 일정을 다시 불러오던지
    await _CalendarBox.put(key, calendar);

    await loadSelectedCalendars(calendar.day);
    await _allCalendarsQ();

    notifyListeners();
  }

  //누른 날짜의 일정 가져오기
  Future<void> loadSelectedCalendars(DateTime day) async {
    final calendarList = await _CalendarBox.values
        .where((element) =>
    element.day.year == day.year &&
        element.day.month == day.month &&
        element.day.day == day.day)
        .toList();
    print('---------loadSelectedCalendars---------');
    print(calendarList);

    final acalendarList = await _CalendarBox.values.toList();
    _acalendars = acalendarList;
    _calendars = calendarList;

    notifyListeners();
  }

  Future<void> _allCalendarsQ() async {
    final calendarList = await _CalendarBox.values.toList();
    Map<DateTime, List<Calendar>> aaa = {};

    for(int i=0;i<calendarList.length;i++){
      print('${i}번 ${calendarList[i].day}');
    }

    for (int i = 0; i < calendarList.length; i++) {
      if (aaa.keysList().contains(DateTime(calendarList[i].day.year,
          calendarList[i].day.month, calendarList[i].day.day))) {
        aaa[DateTime(calendarList[i].day.year, calendarList[i].day.month,
            calendarList[i].day.day)]?.add(calendarList[i]);
      } else {
        aaa[DateTime(calendarList[i].day.year, calendarList[i].day.month,
            calendarList[i].day.day)] = [calendarList[i]];
      }
    }
    print(aaa);
    _events = aaa;
    notifyListeners();
  }

  Future<void> selectCategory(int getCategoryId) async {
    final selectList = await _CalendarBox.values
        .where((element) => element.categoryId == getCategoryId)
        .toList();

    _scalendars = selectList;

    notifyListeners();

  }
}