import 'package:hive/hive.dart';

class Dbhelper {
  late Box box;

  Dbhelper() {
    openBox();
  }

  openBox() {
    box = Hive.box('money');
  }

  Future addData(int amount, DateTime date, String note, String type) async {
    var value = {
      'amount': amount,
      'date': date,
      'note': note,
      'type': type,
    };
    box.add(value);
  }

  Future<Map> fetchData() {
    if (box.values.isEmpty) {
      return Future.value({});
    } else {
      return Future.value(box.toMap());
    }
  
  }
}
