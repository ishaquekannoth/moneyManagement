import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/editScreen.dart';

class SearchScreen extends SearchDelegate<String> {
  Dbhelper helper = Dbhelper();
  CategoryBox category = CategoryBox();
  List myList = [];
  Future<void> getRawMap() async {
    Map unsorted = await helper.fetchAllData();
    var sortMapByValue = Map.fromEntries(unsorted.entries.toList()
      ..sort((e1, e2) => e2.value['date'].compareTo(e1.value['date'])));
    List sortedList = [];
    sortMapByValue.forEach((key, value) => sortedList.add(value));
    myList.clear();
    myList.addAll(sortedList);
  }

  SearchScreen() {
    getRawMap();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () {}, icon: (Icon(Icons.clear)))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(onPressed: () {}, icon: (Icon(Icons.arrow_back)));
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = myList[index];
        return (ListTile(
          leading: Text(item['category']),
        ));
      },
      itemCount: myList.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
   
    return ListView.builder(   
      itemBuilder: (context, index) {
         final item = myList[index];
        return (ListTile(
          leading: Text(item['category']),
        ));
      },
      itemCount: myList.length,
    );
  }
}
