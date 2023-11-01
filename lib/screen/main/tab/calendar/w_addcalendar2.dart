import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/model/calendar.dart';
import 'package:fast_app_base/screen/main/tab/calendar/f_calendar.dart';
import 'package:fast_app_base/viewmodel/calendar_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodel/category_viewmodel.dart';
import 'event.dart';

class AddCalendarPage2 extends StatefulWidget {
  final DateTime initDate;
  const AddCalendarPage2({super.key, required this.initDate});

  @override
  State<AddCalendarPage2> createState() => _AddCalendarPage2State();
}

class _AddCalendarPage2State extends State<AddCalendarPage2> {
  DateTime? selectedDate;
  int? selectKey;
  Colors? selectColor;
  //카테고리를 변경할 때 마다, 이것도 다시 빌드 되면서, 텍스트가 사라지기 때문에, 위로 올렸음
  final title = TextEditingController();
  final content = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initDate;
  }

  //Map<DateTime, List<Event>> events = {};

  @override
  Widget build(BuildContext context) {

    final categories = Provider.of<CategoryViewModel>(context);
    final categoryList = categories.categorys;
    final calendarViewModel = Provider.of<CalendarViewModel>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text(
          '목표 작성',
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 75,
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
              SizedBox(height: 10,),
              Container(
                height: 80,
                child: TextField(
                  controller: title,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: '제목',
                    hintText: '제목을 작성해주세요',
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: false,
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              //3항 연산자 써서 색깔 바꾸기
                              color: selectKey == categoryList[index].key ? Colors.grey.shade400 : Colors.grey.shade200,
                            ),
                            child: GestureDetector(
                              onTap: (){
                                // setState를 써야, 버튼을 누를떄 마다, 다시 빌드가 되면서, 컬러부분의 색상이 변경된다.
                            setState(() {
                              selectKey = categoryList[index].key;
                              title.text = title.text;
                            });

                            print(selectKey);

                            },
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 30,
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
                            ),
                          ),

                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 300,
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
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedDate != null && selectKey != null) {
                      calendarViewModel.addCalendar(
                        Calendar(
                          //day: selectedDate!,
                          day: selectedDate!,
                          title: title.text,
                          content: content.text,
                          categoryId: categoryList[selectKey!].key,
                        ),
                      );
                    } else {
                      calendarViewModel.addCalendar(
                        Calendar(
                          //day: selectedDate!,
                          day: selectedDate!,
                          title: title.text,
                          content: content.text,
                        ),
                      );
                    }

                    // events.addAll({
                    //   selectedDate!: [Event(title: title.text)]
                    // });

                    Navigator.pop(context, selectedDate);

                    print(
                        'Added C ${DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day).toUtc()}');
                  },
                  child: Text('등록'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}