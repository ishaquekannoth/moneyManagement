import 'package:hive/hive.dart';

class CategoryBox {
  late Box categoryBox;
  CategoryBox() {
    openBox();
  }

  openBox() {
    categoryBox = Hive.box('category');
  }

  Future addCategory(
      {required String category, required String type, Future<int>? id}) async {
    Map<String, Object> val = {'name': category, 'type': type};
    val['id'] = (await categoryBox.add(val));
    await categoryBox.put(val['id'], val);
  }

  printCategoryValues() {
  
  }

  clearCategoryBox() {
    categoryBox.clear();
  }

  deleteCategoryItem(int id) {
    categoryBox.delete([id]);
  }

  Future<List<dynamic>> fetchAllCategories() {
    return Future.value(categoryBox.values.toList());
  }

 Future<List<dynamic>> fetchIncomeCategory() {
    List tempList = [];
    var item = categoryBox.toMap();
    item.forEach((key, value) {
      if (value['type'] == 'Income') {
        tempList.add(value);
      }
    });
    return Future.value(tempList);
  }
    Future<List<dynamic>> fetchExpenseCategory() {
    List tempList = [];
    var item = categoryBox.toMap();
    item.forEach((key, value) {
      if (value['type'] == 'Expense') {
        tempList.add(value);
      }
    });
    return Future.value(tempList);
  }
}
