import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'categoryClass.g.dart';

@HiveType(typeId: 1)
class CategoryClass {
  @HiveField(0)
  List<DropdownMenuItem<String>>? item;
  @HiveField(1)
  String name;
  CategoryClass({required this.name});
}
