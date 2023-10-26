import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/calendar/w_addcalendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../model/calendar.dart';
import '../../../../viewmodel/calendar_viewmodel.dart';

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
    final calendarViewModel = Provider.of<CalendarViewModel>(context);
    final calendars = calendarViewModel.calendars;
    print(selectedDay);
    print(focusedDay);

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
              flex: 3,
              child: TableCalendar(
                rowHeight: 42,
                weekNumbersVisible: false,
                locale: 'ko_KR',
                focusedDay: focusedDay,
                firstDay: DateTime.utc(1950, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  setState(() {
                    this.selectedDay = selectedDay;
                    this.focusedDay = focusedDay;
                    calendarViewModel.loadSelectedCalendars(selectedDay);
                    print(selectedDay);
                  });
                },
                selectedDayPredicate: (DateTime day) {
                  return isSameDay(selectedDay, day);
                },
              ),
            ),
            Line(),
            Expanded(
              flex: 2,
              child: Container(
                child: calendars.length == 0 ? Center(child: Text("일정이 없습니다."),):
                ListView.builder(
                  itemBuilder: (BuildContext context, index) {


                          return Card(
                            child: GestureDetector(
                              onTap: () {
                                print(calendars[index].day);
                                print(selectedDay);
                              },
                              child:
                              ListTile(
                                title: Text(calendars[index].title),
                              ),
                            ),
                          );

                  },
                  itemCount: calendars.length,
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await Nav.push(AddCalendarPage(
                  initDate: selectedDay,
                )).then((value) { setState(() {
                  selectedDay = value;
                  calendarViewModel.loadSelectedCalendars(selectedDay);
                });});

                // setState(() {
                //   focusedDay = returnDay;
                //   selectedDay = returnDay;
                //   print('return :  ${focusedDay}');
                //   calendarViewModel.loadSelectedCalendars(focusedDay);
                // });

              },
              icon: Icon(
                Icons.add_circle_rounded,
                size: 50,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 25,),
          ],
        ),
      ),
    );
  }
}
