import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/calendar.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class CalendarViewModel extends ChangeNotifier {
  late Box<Calendar> _CalendarBox;

  List<Calendar> _calendars = [];

  List<Calendar> get calendars => _calendars;

  CalendarViewModel() {
    _openCalendarBox();
  }

  static Future<void> initializeHive() async {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(CalendarAdapter());

  }

  Future<void> _openCalendarBox() async {

    await Hive.openBox<Calendar>('calendars');
    _CalendarBox = Hive.box<Calendar>('calendars');

    await _loadCalendars();
  }

  Future<void> _loadCalendars() async {
    final calendarList = await _CalendarBox.values.toList();
    // 날짜 역순으로 정렬

    _calendars = calendarList;

    notifyListeners();
  }
  //메모 저장하는 함수

  //메모 삭제하는 함수

  //메모 수정하는 함수

  //누른 날짜의 일정 가져오기



}