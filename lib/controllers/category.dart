import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:moneymanager/controllers/categoryClass.dart';

class CategoryBox {
  late Box categoryBox;
  CategoryBox() {
    openBox();
  }

  openBox() {
    categoryBox = Hive.box('category');
  }

  Future addCategory({required CategoryClass category, Future<int>? id}) async {
    Map<String, Object> val = {'name': category};
    val['id'] = (await categoryBox.add(val));
    await categoryBox.put(val['id'], val);
  }

  printCategoryValues() {
    print('Category value.......................');
    print(categoryBox.values);
    print("Keys");
    print(categoryBox.keys);
    // print(categoryBox.getAt(1));
  }

  clearCategoryBox() {
    categoryBox.clear();
  }

  deleteCategoryItem(int ind) {
    categoryBox.deleteAt(ind);
  }
}
