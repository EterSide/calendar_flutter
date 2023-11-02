import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';

class AlarmFragment extends StatelessWidget {
  const AlarmFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '알람',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 15,
          ),
          Expanded(
            flex: 6,
            child: AnalogClock(
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.black),
                  color: Colors.transparent,
                  shape: BoxShape.circle),
              isLive: true,
              hourHandColor: Colors.black,
              minuteHandColor: Colors.black,
              showSecondHand: true,
              numberColor: Colors.black87,
              showNumbers: true,
              showAllNumbers: true,
              textScaleFactor: 1.4,
              showTicks: true,
              showDigitalClock: true,
              datetime: DateTime.now(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Center(
                child: Text("알람이 없습니다."),
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
