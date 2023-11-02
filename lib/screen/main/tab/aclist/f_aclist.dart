import 'package:fast_app_base/model/calendar.dart';
import 'package:fast_app_base/viewmodel/calendar_viewmodel.dart';
import 'package:fast_app_base/viewmodel/category_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/common.dart';
import '../calendar/w_updatecalendar.dart';

class ACFragment extends StatefulWidget {
  const ACFragment({super.key});

  @override
  State<ACFragment> createState() => _ACFragmentState();
}

class _ACFragmentState extends State<ACFragment> {
  int? selectKey;
  List<Calendar> selectedList = [];
  bool selectall = false;

  @override
  Widget build(BuildContext context) {
    final calendarViewModel = Provider.of<CalendarViewModel>(context);
    final acalendars = calendarViewModel.acalendars;
    final scalendars = calendarViewModel.scalendars;
    final categories = Provider.of<CategoryViewModel>(context);
    final categoryList = categories.categorys;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '카테고리 별 목록',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    //3항 연산자 써서 색깔 바꾸기
                    color: selectKey == categoryList[index].key
                        ? Colors.grey.shade400
                        : Colors.grey.shade200,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // setState를 써야, 버튼을 누를떄 마다, 다시 빌드가 되면서, 컬러부분의 색상이 변경된다.
                      setState(() {

                        if(categoryList[index].key == selectKey){
                          selectKey = null;
                        }
                        else{
                          selectKey = categoryList[index].key;
                          calendarViewModel.selectCategory(selectKey!);
                          selectedList = calendarViewModel.scalendars;
                        }

                      });

                      print(selectKey);
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
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

                );
              },
            ),
          ),

          Expanded(
            child: Container(
              child: acalendars.length == null
                  ? Center(
                      child: Text("일정이 없습니다."),
                    )
                  : (selectKey == null)
                      ? ListView.builder(
                          itemBuilder: (BuildContext context, index) {
                            return Card(
                              color: acalendars[index].categoryId == -1
                                  ? Colors.white
                                  : Color(int.parse(
                                  categories
                                      .getColorFromCategoryKey(
                                      acalendars[index].categoryId)
                                      .replaceFirst("#", ""),
                                  radix: 16))
                                  .withOpacity(1.0),
                              child: GestureDetector(
                                onTap: () {
                                  Nav.push(updateCalendar(
                                    takeCalendar: acalendars[index],
                                    initDate: acalendars[index].day,
                                  ));
                                },
                                child: ListTile(
                                  title: Text(acalendars[index].title),
                                ),
                              ),
                            );
                          },
                          itemCount: acalendars.length,
                        )
                      : ListView.builder(
                          itemCount: scalendars.length,
                          itemBuilder: (BuildContext context, index) {
                            return Card(
                              color: scalendars[index].categoryId == -1
                                  ? Colors.white
                                  : Color(int.parse(
                                  categories
                                      .getColorFromCategoryKey(
                                      scalendars[index].categoryId)
                                      .replaceFirst("#", ""),
                                  radix: 16))
                                  .withOpacity(1.0),
                              child: GestureDetector(
                                onTap: () {
                                  Nav.push(updateCalendar(
                                    takeCalendar: scalendars[index],
                                    initDate: scalendars[index].day,
                                  ));
                                },
                                child: ListTile(
                                  title: Text(scalendars[index].title),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
