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
    await _CalendarBox.add(calendar);

    await loadSelectedCalendars(calendar.day);
    await _allCalendarsQ();

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

  Future<void> updateCalendar(int key ,Calendar calendar) async {
    print('${calendar.day} + ${calendar.title} + ${calendar.content}');

    await _CalendarBox.put(key, calendar);

    await loadSelectedCalendars(calendar.day);

    await _allCalendarsQ();

    notifyListeners();

  }

  //누른 날짜의 일정 가져오기
  Future<void> loadSelectedCalendars(DateTime day) async {
    final calendarList = await _CalendarBox.values
        .where((element) => element.day == day)
        .toList();

    final acalendarList = await _CalendarBox.values.toList();
    _acalendars = acalendarList;
    _calendars = calendarList;

    notifyListeners();
  }

  Future<void> _allCalendarsQ() async {

    final calendarList = await _CalendarBox.values.toList();
    Map<DateTime, List<Calendar>> aaa = {};

    for (int i = 0; i < calendarList.length; i++) {
      if(aaa.keysList().contains(calendarList[i].day)){
        aaa[calendarList[i].day]?.add(calendarList[i]);
      }else{
        aaa[calendarList[i].day] = [calendarList[i]];
      }

    }
    _events = aaa;
    notifyListeners();


  }


}
