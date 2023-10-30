import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/dart/extension/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/calendar.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../model/category.dart';

class CategoryViewModel extends ChangeNotifier {
  late Box<Category> _CategoryBox;

  List<Category> _categorys = [];
  List<Category> get categorys => _categorys;


  CategoryViewModel() {
    _openCategoryBox();
  }

  static Future<void> initializeHive() async {
    final appDocumentDir =
    await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(CategoryAdapter());
  }

  Future<void> _openCategoryBox() async {
    await Hive.openBox<Category>('category');
    _CategoryBox = Hive.box<Category>('category');

    await _loadCategory();
  }

  String getColorFromCategoryKey(int key) {
    final category = _CategoryBox.get(key);
    return category!.color;
  }



  Future<void> _loadCategory() async {
    final categoryList = await _CategoryBox.values.toList();

    _categorys = categoryList;


    notifyListeners();
  }

  Future<void> addCategory() async {
    final category = Category(name: 'name', color: "#FFA07A");
    final category1 = Category(name: 'name2', color: "#87CEFA");
    final category2 = Category(name: 'name3', color: "#FFFF00");
    await _CategoryBox.add(category);
    await _CategoryBox.add(category1);
    await _CategoryBox.add(category2);
    await _loadCategory();
  }


}
