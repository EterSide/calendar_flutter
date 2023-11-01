import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/calendar/w_addcalendar.dart';
import 'package:fast_app_base/screen/main/tab/calendar/w_addcalendar2.dart';
import 'package:fast_app_base/screen/main/tab/calendar/w_updatecalendar.dart';
import 'package:fast_app_base/viewmodel/category_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../model/calendar.dart';
import '../../../../model/category.dart';
import '../../../../viewmodel/calendar_viewmodel.dart';
import 'event.dart';

class CalendarFragment extends StatefulWidget {
  const CalendarFragment({super.key});

  @override
  State<CalendarFragment> createState() => _CalendarFragmentState();
}

class _CalendarFragmentState extends State<CalendarFragment> {
  Map<DateTime, List<Calendar>> events = {};
  //late final ValueNotifier<List<Event>> selectedEvents;

  // List<Object> _getCalendarsForDay(DateTime day){
  //    return events[day] ?? [];
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // List<Event> getEventsForDay(DateTime day) {
  //   return events[day] ?? [];
  // }

  List<Calendar> _getCalendarsForDay(DateTime day) {
    return events[day] ?? [];
  }

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
    final categories = Provider.of<CategoryViewModel>(context);
    final categoryList = categories.categorys;

    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () async {
          await Nav.push(AddCalendarPage2(
            initDate: selectedDay,
          )).then((value) {
            setState(() {
              selectedDay = value;
              calendarViewModel.loadSelectedCalendars(selectedDay);
            });
          });
        },
        icon: Icon(
          Icons.add_circle_rounded,
          size: 50,
          color: Colors.blue,
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //horizontal scroll view

              TableCalendar(
                calendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.lightBlue.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: Colors.red),
                  defaultTextStyle: TextStyle(color: Colors.black),
                  outsideTextStyle: TextStyle(color: Colors.grey),
                  outsideDaysVisible: false,
                  canMarkersOverflow: true,
                ),
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
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                ),

                eventLoader: (day) {
                  return calendarViewModel
                          .events[DateTime(day.year, day.month, day.day)] ??
                      [];
                },
                //eventLoader: _getCalendarsForDay,
              ),
              Line(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                //DB에 저장된 색상 코드를 가져와서 변환하여 적용
                                color: Color(int.parse(
                                        categoryList[index]
                                            .color
                                            .replaceFirst("#", ""),
                                        radix: 16))
                                    .withOpacity(1.0),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(categoryList[index].name),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              Flexible(
                child: Container(
                  child: calendars.length == 0
                      ? Center(
                          child: Text("일정이 없습니다."),
                        )
                      : ListView.builder(
                          itemBuilder: (BuildContext context, index) {
                            return Card(
                              color: calendars[index].categoryId == -1
                                  ? Colors.white
                                  : Color(int.parse(
                                          categories
                                              .getColorFromCategoryKey(
                                                  calendars[index].categoryId)
                                              .replaceFirst("#", ""),
                                          radix: 16))
                                      .withOpacity(1.0),
                              child: GestureDetector(
                                onTap: () async {
                                  await Nav.push(UpdateCalendar(
                                    takeCalendar: calendars[index],
                                    initDate: selectedDay,
                                  )).then((value) {
                                    setState(() {
                                      selectedDay = value;
                                    });
                                  });
                                },
                                child: ListTile(
                                  title: Text(calendars[index].title),
                                ),
                              ),
                            );
                          },
                          itemCount: calendars.length,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
