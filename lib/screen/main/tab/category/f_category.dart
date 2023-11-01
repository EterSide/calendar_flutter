import 'package:fast_app_base/screen/main/tab/calendar/f_calendar.dart';
import 'package:fast_app_base/viewmodel/calendar_viewmodel.dart';
import 'package:fast_app_base/viewmodel/category_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/common.dart';

class CategoryFragment extends StatelessWidget {
  const CategoryFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final categorys = categoryViewModel.categorys;

    final calendarViewModel = Provider.of<CalendarViewModel>(context);
    final calendars = calendarViewModel.scalendars;

    return Scaffold(
      appBar: AppBar(
        title: Text('카테고리 생성'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                categoryViewModel.addCategory();
              },
              child: Text('카테고리 생성')),
          ElevatedButton(
              onPressed: () {
                calendarViewModel.selectCategory(-1);
                print(calendars);
              },
              child: Text('카테고리 출력')),


          Container(
            height: 50,
            child: ListView.builder(

              scrollDirection: Axis.horizontal,
              itemCount: categorys.length,
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
                              categorys[index]
                                  .color
                                  .replaceFirst("#", ""),
                              radix: 16))
                              .withOpacity(1.0),
                          shape: BoxShape.circle,
                        ),
                        child: GestureDetector(
                          onTap: (){
                            print(categorys[index].key);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(categorys[index].name),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
