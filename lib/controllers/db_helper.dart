import 'package:hive/hive.dart';

class Dbhelper {
  late Box moneyBox;
  Dbhelper() {
    openBox();
  }

  openBox() {
    moneyBox = Hive.box('money');
  }

  Future addData(
      {required double  amount,
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

  Future<Map> fetchAllData() {
    if (moneyBox.values.isEmpty) {
      return Future.value({});
    } else {
      return Future.value(moneyBox.toMap());
    }
  }

  Future resetData() async {
    moneyBox.clear();
  }


  Future<void> removeSingleItem(int id) async {
    var desiredkey=-1;
    moneyBox.toMap().forEach((key, value) {
      if (value['id'] == id) {
        desiredkey = key;
      }
    });
    moneyBox.delete(desiredkey);
  }

  Future<void> editSingleItem(
      {required double amount,
      required DateTime date,
      required String note,
      required String type,
      required String category,
      required int id}) async {
    var newValue = {
      'amount': amount,
      'date': date,
      'note': note,
      'type': type,
      'category': category,
      'id':id
    };
    var desiredkey=-1;
    moneyBox.toMap().forEach((key, value) {
      if (value['id'] == id) {
        desiredkey = key;
      }
    });
    moneyBox.put(desiredkey, newValue);
  }

}
