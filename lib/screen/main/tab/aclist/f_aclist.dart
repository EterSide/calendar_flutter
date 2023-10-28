import 'package:flutter/material.dart';

class ACFragment extends StatelessWidget {
  const ACFragment({super.key});

  @override
  Widget build(BuildContext context) {
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
            flex: 8,
            child: Container(
              child: Center(
                child: Text("일정이 없습니다."),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              onPressed: () async {

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
          ),
        ],
      ),
    );
  }
}
