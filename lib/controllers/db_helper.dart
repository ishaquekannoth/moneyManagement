import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class Dbhelper {
  late Box box;
  late AsyncSnapshot data;
  Dbhelper() {
    openBox();
  }

  openBox() {
    box = Hive.box('money');
  }

  Future addData(
      {required int amount,
      required DateTime date,
      required String note,
      required String type,
      required String category,
      Future<int>? id}) async {
    var value = {
      'amount': amount,
      'date': date,
      'note': note,
      'type': type,
      'category':category,
    };
    value['id'] = await box.add(value);
    box.put(value['id'], value);
  }

  Future<Map> fetchData() {
    if (box.values.isEmpty) {
      return Future.value({});
    } else {
      return Future.value(box.toMap());
    }
  }

  Future resetData() async {
    print(box.values);
    box.clear();
  }

  Future<void> fetchSingleItem(int id) async {
    var result = await Future.value(box.get(id));
    print(result);
  }

  printKeys() {
    print(box.values);
  }
}
