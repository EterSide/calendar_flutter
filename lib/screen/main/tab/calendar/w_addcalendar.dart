import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/model/calendar.dart';
import 'package:fast_app_base/screen/main/tab/calendar/f_calendar.dart';
import 'package:fast_app_base/viewmodel/calendar_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'event.dart';

class AddCalendarPage extends StatefulWidget {


  final DateTime initDate;
  const AddCalendarPage({super.key, required this.initDate});



  @override
  State<AddCalendarPage> createState() => _AddCalendarPageState();
}

class _AddCalendarPageState extends State<AddCalendarPage> {

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initDate;
  }

  //Map<DateTime, List<Event>> events = {};


  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    final content = TextEditingController();

    final calendarViewModel = Provider.of<CalendarViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '목표 작성',
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: CupertinoDatePicker(
                    minimumYear: DateTime.now().year,
                    maximumYear: DateTime.now().year + 1,
                    initialDateTime: widget.initDate,

                    onDateTimeChanged: (datetime) {
                      setState(() {
                        selectedDate = datetime;
                        print(selectedDate);
                      });
                    },
                    mode: CupertinoDatePickerMode.date,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    children: [
                      TextField(
                        controller: title,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: '제목',
                          hintText: '제목을 작성해주세요',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: TextField(
                  controller: content,
                  maxLines: null,
                  maxLength: 256,
                  decoration: InputDecoration(
                    labelText: '내용',
                    hintText: '내용을 작성해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  expands: true,
                ),
              ),
              ElevatedButton(
                onPressed: () {

                  print('selectedDate = ${selectedDate}');
                  if(selectedDate != null)
                  calendarViewModel.addCalendar(Calendar(
                      day: selectedDate!,
                      title: title.text,
                      content: content.text),);
                  print('목록 = ${calendarViewModel.calendars}');
                  print('selectedDate = ${selectedDate}');

                  // events.addAll({
                  //   selectedDate!: [Event(title: title.text)]
                  // });

                  Navigator.pop(context,selectedDate);



                },
                child: Text('등록'),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
