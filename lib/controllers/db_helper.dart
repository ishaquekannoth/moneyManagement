import 'package:hive/hive.dart';
import 'package:moneymanager/controllers/category.dart';

class Dbhelper {
  late Box moneyBox;
  Dbhelper() {
    openBox();
  }

  openBox() {
    moneyBox = Hive.box('money');
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
      'category': category,
    };
    value['id'] = await moneyBox.add(value);
    moneyBox.put(value['id'], value);
  }

  Future<Map> fetchData() {
    if (moneyBox.values.isEmpty) {
      return Future.value({});
    } else {
      return Future.value(moneyBox.toMap());
    }
  }

  Future resetData() async {
    print(moneyBox.values);
    moneyBox.clear();
  }

  Future<void> fetchSingleItem(int id) async {
    var result = await Future.value(moneyBox.get(id));
    print(result);
  }

  printKeys() {
    CategoryBox category = CategoryBox();
    print('ALL keys AND VALUES in DB');
    print(moneyBox.values);
  }

  Future<void> removeSingleItem(int id) async {
    var desiredkey;
    moneyBox.toMap().forEach((key, value) {
      if(value['id']==id){
        desiredkey=key;
      }
    });
    print(desiredkey);
    moneyBox.delete(desiredkey);
    }
  }

