import 'package:fast_app_base/model/calendar.dart';
import 'package:fast_app_base/model/category.dart';
import 'package:fast_app_base/viewmodel/calendar_viewmodel.dart';
import 'package:fast_app_base/viewmodel/category_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/common.dart';

class CategoryFragment extends StatefulWidget {
  const CategoryFragment({super.key});
  static const colorList = [
    (Colors.red,'#FF0000'),
    (Colors.orange,'#FFA500'),
    (Colors.yellow,'#FFFF00'),
    (Colors.green,'#008000'),
    (Colors.blue,'#0000FF'),
    (Colors.indigo,'#4B0082'),
    (Colors.purple,'#800080'),
    (Colors.pinkAccent,'#FFC0CB'),
  ];

  @override
  State<CategoryFragment> createState() => _CategoryFragmentState();
}

class _CategoryFragmentState extends State<CategoryFragment> {
  final categoryName = TextEditingController();
  final categoryColor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final calendarViewModel = Provider.of<CalendarViewModel>(context);
    final calendars = calendarViewModel.acalendars;
    final categorys = categoryViewModel.categorys;

    return Scaffold(
      appBar: AppBar(
        title: Text('카테고리 생성'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                //bottom sheet for category create
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (value){
                                categoryName.text=value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 8,
                                children: List.generate(CategoryFragment.colorList.length, (index) {
                                  return GestureDetector(
                                      onTap: (){
                                        // categoryViewModel.category.color=colorList[index].item2;
                                        setState(() {
                                          categoryColor.text=CategoryFragment.colorList[index].$2;
                                          print(categoryColor.text);
                                        });


                                      },
                                      child: categoryColor.text == CategoryFragment.colorList[index].$2 ? Container(
                                        margin: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: CategoryFragment.colorList[index].$1,
                                          shape: BoxShape.circle,
                                        ),
                                      ) : Container(
                                        margin: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: CategoryFragment.colorList[index].$1.withOpacity(0.3),
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                  );
                                }),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  categoryViewModel.addCategory(Category(name: categoryName.text, color: categoryColor.text));
                                  Navigator.pop(context);
                                },
                                child: Text('생성')
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Text('카테고리 생성')),

          Expanded(
            child: ListView.builder(

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
                      SizedBox(
                        width: 5,

                      ),
                      ElevatedButton(
                          onPressed: () {
                            //categoryViewModel.updateCategory(categorys[index].key,categorys[index]);
                            //bottomSheet for update category
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 200,
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: TextEditingController(text: categorys[index].name),
                                          onChanged: (value){
                                            categorys[index].name=value;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            for(int i=0;i<CategoryFragment.colorList.length;i++)
                                              GestureDetector(
                                                onTap: (){
                                                  categorys[index].color=CategoryFragment.colorList[i].$2;
                                                },
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    //DB에 저장된 색상 코드를 가져와서 변환하여 적용
                                                    color: CategoryFragment.colorList[i].$1,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),


                                        ElevatedButton(
                                            onPressed: () {
                                              categoryViewModel.updateCategory(categorys[index].key,categorys[index]);
                                              Navigator.pop(context);
                                            },
                                            child: Text('수정')),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Text('수정')),
                      ElevatedButton(
                          onPressed: () {
                            for(int i=0;i<calendars.length;i++){
                              if(calendars[i].categoryId==categorys[index].key){
                                calendarViewModel.updateCalendar(calendars[i].key,Calendar(
                                    day: calendars[i].day, title: calendars[i].title, content: calendars[i].content, categoryId: -1));
                              }

                            }
                            categoryViewModel.deleteCategory(categorys[index].key);
                          },
                          child: Text('삭제')),
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
