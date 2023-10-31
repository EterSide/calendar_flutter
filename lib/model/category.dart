import 'dart:ui';

import 'package:flutter/src/material/colors.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String color;

  Category({
    required this.name, required this.color,
  });
}
