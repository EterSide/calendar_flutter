import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/model/calendar.dart';
import 'package:fast_app_base/screen/main/tab/calendar/f_calendar.dart';
import 'package:fast_app_base/viewmodel/calendar_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodel/category_viewmodel.dart';
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
    final categories = Provider.of<CategoryViewModel>(context);
    final categoryList = categories.categorys;

    final calendarViewModel = Provider.of<CalendarViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '목표 작성',
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
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
                child: Container(
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
                                color: Color(int.parse(categoryList[index].color.replaceFirst("#", ""), radix: 16)).withOpacity(1.0),
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
            Expanded(
              flex:6,
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

                if(selectedDate != null)
                calendarViewModel.addCalendar(Calendar(
                    //day: selectedDate!,
                    day: selectedDate!,
                    title: title.text,
                    content: content.text,
                  categoryId: categoryList[1].key,
                ),);

                // events.addAll({
                //   selectedDate!: [Event(title: title.text)]
                // });

                Navigator.pop(context,selectedDate);

                print('Added C ${DateTime(selectedDate!.year,selectedDate!.month,selectedDate!.day).toUtc()}');



              },
              child: Text('등록'),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
