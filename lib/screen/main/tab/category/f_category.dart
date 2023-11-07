import 'package:fast_app_base/common/widget/w_round_button.dart';
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
    (Colors.red, '#FF8AB3'),
    (Colors.orange, '#FFB38A'),
    (Colors.yellow, '#FF8AE4'),
    (Colors.green, '#8AB3FF'),
    (Colors.blue, '#8AFFB3'),
    (Colors.white, '#B38AFF'),
    (Colors.purple, '#FFE08A'),
    (Colors.pinkAccent, '#E08AFF'),
  ];

  @override
  State<CategoryFragment> createState() => _CategoryFragmentState();
}

class _CategoryFragmentState extends State<CategoryFragment> {
  final categoryName = TextEditingController();
  final categoryColor = TextEditingController();

  void _updateColor(String color) {
    setState(() {
      categoryColor.text = color;
    });
  }

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
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: IconButton(
          onPressed: () async {
            showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, bottomSheetState) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      // mediaquery.of(context).size.height 를 쓰면 화면크기대로 조절가능함
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                categoryName.text = value;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GridView.count(
                            key: UniqueKey(),
                            shrinkWrap: true,
                            crossAxisCount: 8,
                            children: List.generate(
                                CategoryFragment.colorList.length, (index) {
                              return GestureDetector(
                                  onTap: () {
                                    // categoryViewModel.category.color=colorList[index].item2;
                                    bottomSheetState(() {
                                      setState(() {
                                        categoryColor.text = CategoryFragment
                                            .colorList[index].$2;
                                        print(categoryColor.text);
                                      });
                                    });
                                  },
                                  child: categoryColor.text ==
                                          CategoryFragment.colorList[index].$2
                                      ? Container(
                                          margin: EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(
                                                    CategoryFragment
                                                        .colorList[index].$2
                                                        .replaceFirst("#", ""),
                                                    radix: 16))
                                                .withOpacity(1.0),
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(
                                                CategoryFragment
                                                    .colorList[index].$2
                                                    .replaceFirst("#", ""),
                                                radix: 16))
                                                .withOpacity(0.3),
                                            shape: BoxShape.circle,
                                          ),
                                        ));
                            }),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: RoundButton(
                                text: "카테고리 생성",
                                bgColor: Colors.green,
                                onTap: () {
                                  categoryViewModel.addCategory(Category(
                                      name: categoryName.text,
                                      color: categoryColor.text));
                                  categoryColor.clear();
                                  Navigator.pop(context);
                                }),
                          ),

                        ],
                      ),
                    );
                  });
                });
          },
          icon: Icon(
            Icons.add_circle_rounded,
            size: 60,
            color: Colors.blue,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categorys.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                              onTap: () {
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
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context,bottomSheetState){
                                          return Container(
                                            height: MediaQuery.of(context).size.height / 2.5,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller: TextEditingController(
                                                        text: categorys[index].name),
                                                    onChanged: (value) {
                                                      categorys[index].name = value;
                                                    },
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   height: 10,
                                                // ),
                                                // Row(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.spaceEvenly,
                                                //   children: [
                                                //     for (int i = 0;
                                                //         i <
                                                //             CategoryFragment
                                                //                 .colorList.length;
                                                //         i++)
                                                //       GestureDetector(
                                                //         onTap: () {
                                                //           categorys[index].color =
                                                //               CategoryFragment
                                                //                   .colorList[i].$2;
                                                //         },
                                                //         child: Container(
                                                //           width: 20,
                                                //           height: 20,
                                                //           decoration: BoxDecoration(
                                                //             //DB에 저장된 색상 코드를 가져와서 변환하여 적용
                                                //             color: CategoryFragment
                                                //                 .colorList[i].$1,
                                                //             shape: BoxShape.circle,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //   ],
                                                // ),

                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GridView.count(
                                                  key: UniqueKey(),
                                                  shrinkWrap: true,
                                                  crossAxisCount: 8,
                                                  children: List.generate(
                                                      CategoryFragment.colorList.length, (idx) {
                                                        //.text=categorys[index].color;
                                                    return GestureDetector(
                                                        onTap: () {
                                                          // categoryViewModel.category.color=colorList[index].item2;
                                                          bottomSheetState(() {
                                                            setState(() {
                                                              categoryColor.text = CategoryFragment
                                                                  .colorList[idx].$2;
                                                              print(categoryColor.text);
                                                            });
                                                          });
                                                        },
                                                        child: categoryColor.text ==
                                                            CategoryFragment.colorList[idx].$2
                                                            ? Container(
                                                          margin: EdgeInsets.all(1),
                                                          decoration: BoxDecoration(
                                                            color: Color(int.parse(
                                                                CategoryFragment
                                                                    .colorList[idx].$2
                                                                    .replaceFirst("#", ""),
                                                                radix: 16))
                                                                .withOpacity(1.0),
                                                            shape: BoxShape.circle,
                                                          ),
                                                        )
                                                            : Container(
                                                          margin: EdgeInsets.all(1),
                                                          decoration: BoxDecoration(
                                                            color: Color(int.parse(
                                                                CategoryFragment
                                                                    .colorList[idx].$2
                                                                    .replaceFirst("#", ""),
                                                                radix: 16))
                                                                .withOpacity(0.3),
                                                            shape: BoxShape.circle,
                                                          ),
                                                        ));
                                                  }),
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      categoryViewModel
                                                          .updateCategory(
                                                              categorys[index].key,
                                                              Category(name: categorys[index].name, color: categoryColor.text));
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('수정')),
                                              ],
                                            ),
                                          );
                                        }
                                      );
                                    });
                              },
                              child: Text('수정')),
                          ElevatedButton(
                              onPressed: () {

                                //해당 카테고리를 가진 모든 일정을 카테고리 아이디 -1로 변경
                                for (int i = 0; i < calendars.length; i++) {
                                  if (calendars[i].categoryId ==
                                      categorys[index].key) {
                                    calendarViewModel.updateCalendar(
                                        calendars[i].key,
                                        Calendar(
                                            day: calendars[i].day,
                                            title: calendars[i].title,
                                            content: calendars[i].content,
                                            categoryId: -1));
                                  }
                                }
                                categoryViewModel
                                    .deleteCategory(categorys[index].key);
                              },
                              child: Text('삭제')),
                        ],
                      ),
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
