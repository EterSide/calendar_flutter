import 'package:fast_app_base/model/calendar.dart';
import 'package:fast_app_base/viewmodel/calendar_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateCalendar extends StatefulWidget {
  final Calendar takeCalendar;
  final DateTime initDate;

  const UpdateCalendar(
      {Key? key, required this.takeCalendar, required this.initDate})
      : super(key: key);

  @override
  State<UpdateCalendar> createState() => _UpdateCalendarState();
}

class _UpdateCalendarState extends State<UpdateCalendar> {
  String? dTitle;

  String? dContent;

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.takeCalendar.day;
    dTitle = widget.takeCalendar.title;
    dContent = widget.takeCalendar.content;
  }

  @override
  Widget build(BuildContext context) {
    final calendarViewModel = Provider.of<CalendarViewModel>(context);
    final calendars = calendarViewModel.calendars;

    final title = TextEditingController(text: widget.takeCalendar.title);
    final content = TextEditingController(text: widget.takeCalendar.content);

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
                  if (selectedDate != null)
                    calendarViewModel.updateCalendar(
                        widget.takeCalendar.key,
                        Calendar(
                            day: selectedDate!,
                            title: title.text,
                            content: content.text));


                  // events.addAll({
                  //   selectedDate!: [Event(title: title.text)]
                  // });
                  print('up ${selectedDate}');
                  Navigator.pop(context, selectedDate);
                },
                child: Text('수정'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedDate != null)
                    calendarViewModel.deleteCalendar(
                      widget.takeCalendar.key, Calendar(day: selectedDate!, title: dTitle!, content: dContent!)
                    );

                  // events.addAll({
                  //   selectedDate!: [Event(title: title.text)]
                  // });

                  Navigator.pop(context, selectedDate);
                },
                child: Text('삭제'),
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
