import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/calendar/w_addcalendar.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../model/calendar.dart';

class CalendarFragment extends StatefulWidget {
  const CalendarFragment({super.key});

  @override
  State<CalendarFragment> createState() => _CalendarFragmentState();
}

class _CalendarFragmentState extends State<CalendarFragment> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();
  late List<Calendar> calData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '달력',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TableCalendar(
                weekNumbersVisible: false,
                locale: 'ko_KR',
                focusedDay: focusedDay,
                firstDay: DateTime.utc(1950, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  setState(() {
                    this.selectedDay = selectedDay;
                    this.focusedDay = focusedDay;

                  });
                },
                selectedDayPredicate: (DateTime day) {
                  return isSameDay(selectedDay, day);
                },
              ),
            ),
            IconButton(
              onPressed: () {
                Nav.push(AddCalendarPage(initDate: selectedDay,));
              },
              icon: Icon(
                Icons.add_circle_rounded,
                size: 80,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }
}
