import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCalendarPage extends StatefulWidget {
  final DateTime initDate;
  const AddCalendarPage({super.key, required this.initDate});

  @override
  State<AddCalendarPage> createState() => _AddCalendarPageState();
}

class _AddCalendarPageState extends State<AddCalendarPage> {
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate;

    int firstDay = 1950;
    int lastDay = 2100;

    List selectYear = [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '목표 작성',
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: CupertinoDatePicker(
                  minimumYear: DateTime.now().year,
                  maximumYear: DateTime.now().year+1,

                  initialDateTime: widget.initDate,
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (datetime){
                    setState(() {
                      selectedDate = datetime;
                      print(selectedDate);
                    });
                  },
                  mode: CupertinoDatePickerMode.date,
                ),
              ),
            ),
            Expanded(flex:9,child: Container(child: Text("asd"),))
          ],
        ),
      ),
    );
  }
}
