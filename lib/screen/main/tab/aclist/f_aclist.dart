import 'package:fast_app_base/viewmodel/calendar_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/common.dart';
import '../calendar/w_updatecalendar.dart';

class ACFragment extends StatelessWidget {
  const ACFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarViewModel = Provider.of<CalendarViewModel>(context);
    final calendars = calendarViewModel.acalendars;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '목록',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              child: calendars.length == 0
                  ? Center(
                      child: Text("일정이 없습니다."),
                    )
                  : ListView.builder(
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                          child: GestureDetector(
                            onTap: () {
                              Nav.push(UpdateCalendar(
                                takeCalendar: calendars[index],
                                initDate: calendars[index].day,
                              ));
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
    );
  }
}
