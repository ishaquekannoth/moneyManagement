import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/editScreen.dart';

class SearchScreen extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Category/Amount/Note/Date to search';

  @override
  ThemeData appBarTheme(BuildContext context) {
    var superThemeData = super.appBarTheme(context);
    return superThemeData.copyWith(
      textTheme: superThemeData.textTheme.copyWith(
        headline6:TextStyle(fontSize: 14),
      ),
    );
  }

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
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: (Icon(Icons.clear)))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(onPressed: () {}, icon: (Icon(Icons.arrow_back)));
  }

  @override
  Widget buildResults(BuildContext context) {
    final List suggestion = myList.where((element) {
      return (element['category']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          element['amount']
              .toString()
              .toLowerCase()
              .startsWith(query.toLowerCase()) ||
          element['note']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()));
    }).toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        final item = suggestion[index];
        String temp = item['type'];
        if (temp == 'Expense') {
          return ((expenseTile(item['amount'], item['note'], item['date'],
              item['id'], item['category'], item['type'], helper, context)));
        } else {
          return ((incomeTile(item['amount'], item['note'], item['date'],
              item['id'], item['category'], item['type'], helper, context)));
        }
      },
      itemCount: suggestion.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List suggestion = myList.where((element) {
      return (element['category']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          element['amount']
              .toString()
              .toLowerCase()
              .startsWith(query.toLowerCase()) ||
          element['note']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())||
            element['date']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())  
              );
    }).toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        final item = suggestion[index];
        String temp = item['type'];
        if (temp == 'Expense') {
          return ((expenseTile(item['amount'], item['note'], item['date'],
              item['id'], item['category'], item['type'], helper, context)));
        } else {
          return ((incomeTile(item['amount'], item['note'], item['date'],
              item['id'], item['category'], item['type'], helper, context)));
        }
      },
      itemCount: suggestion.length,
    );
  }

  Widget expenseTile(int value, String note, DateTime dateTime, int id,
      String category, String type, Dbhelper dataBase, BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          print('You clicked an Expense item ID is');
          print(id);
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => (EditScreen(
                      value: value,
                      note: note,
                      dateTime: dateTime,
                      id: id,
                      type: type,
                      category: category))))
              .whenComplete(() => getRawMap());
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return (AlertDialog(
                  title: Text('Confirm Delete?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Cancel")),
                    ElevatedButton(
                        onPressed: () {
                          dataBase
                              .removeSingleItem(id)
                              .whenComplete(() => getRawMap());
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"))
                  ],
                ));
              });
        },
        child: (Container(
          // padding: EdgeInsets.all(15),
          // margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.arrow_circle_up_outlined,
                    size: 28,
                    color: Colors.red,
                  ),
                  Text("Expense",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                  Text('-$value AED',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 170, 20, 9),
                          fontWeight: FontWeight.bold)),
                  Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Category: $category',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      )),
                  Text('Note: $note',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ))
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget incomeTile(int value, String note, DateTime dateTime, int id,
      String category, String type, Dbhelper dataBase, BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          print('You clicked an Income item.ID is');
          print(id);
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => (EditScreen(
                        value: value,
                        note: note,
                        dateTime: dateTime,
                        id: id,
                        category: category,
                        type: type,
                      ))))
              .whenComplete(() => getRawMap());
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return (AlertDialog(
                  title: Text('Confirm Delete?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Cancel")),
                    ElevatedButton(
                        onPressed: () {
                          dataBase
                              .removeSingleItem(id)
                              .whenComplete(() => getRawMap());
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"))
                  ],
                ));
              });
        },
        child: (Container(
          // padding: EdgeInsets.all(15),
          // margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.arrow_circle_down_outlined,
                    size: 28,
                    color: Color.fromARGB(255, 5, 231, 5),
                  ),
                  Text("Income",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                  Text('+$value AED',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 4, 112, 8),
                          fontWeight: FontWeight.bold)),
                  Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Category: $category',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      )),
                  Text('Note: $note',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ))
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
