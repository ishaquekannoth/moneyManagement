import 'dart:core';
import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/editScreen.dart';

class ViewAllTransactions extends StatefulWidget {
  const ViewAllTransactions({Key? key}) : super(key: key);

  @override
  State<ViewAllTransactions> createState() => _ViewAllTransactionsState();
}

class _ViewAllTransactionsState extends State<ViewAllTransactions> {
  @override
  void initState() {
    getRawMap();
    super.initState();
  }

  Dbhelper helper = Dbhelper();
  CategoryBox category = CategoryBox();
  List myList = [];
  List incomeList = [];
  List expenseList = [];

  Future<void> getRawMap() async {
    Map unsorted = await helper.fetchAllData();
    var sortMapByValue = Map.fromEntries(unsorted.entries.toList()
      ..sort((e1, e2) => e2.value['date'].compareTo(e1.value['date'])));
    //print(sortMapByValue);
    List sortedList = [];
    sortMapByValue.forEach((key, value) => sortedList.add(value));
    myList.clear();
    myList.addAll(sortedList);
    incomeList.clear();
    expenseList.clear();
    for (var element in myList) {
        if (element['type'] == 'Expense') {
          expenseList.add(element);
        } else {
          incomeList.add(element);
        }
      }


    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: (Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(225, 255, 255, 255),
            title: Text(
              'All Transactions',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            bottom:
                TabBar(labelColor: Color.fromARGB(255, 0, 0, 0), tabs: const [
              Tab(text: 'All List'),
              Tab(
                text: 'Incomes',
              ),
              Tab(
                text: 'Expenses',
              ),
            ]),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await category.printCategoryValues();
              // print(await category.fetchAllCategories());
            },
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: myList.length,
                  itemBuilder: (context, index) {
                    if (myList[index]['type'] == 'Expense') {
                      return (ListTile(
                          title: expenseTile(
                              myList[index]['amount'],
                              myList[index]['note'],
                              myList[index]['date'],
                              myList[index]['id'],
                              myList[index]['category'],
                              myList[index]['type'],
                              helper,
                              context)));
                    } else {
                      return (ListTile(
                        title: incomeTile(
                            myList[index]['amount'],
                            myList[index]['note'],
                            myList[index]['date'],
                            myList[index]['id'],
                            myList[index]['category'],
                            myList[index]['type'],
                            helper,
                            context),
                      ));
                    }
                  }),
                  ListView.builder(
                  itemCount: incomeList.length,
                  itemBuilder: (context, index) {
                    return (ListTile(
                        title: incomeTile(
                            incomeList[index]['amount'],
                            incomeList[index]['note'],
                            incomeList[index]['date'],
                            incomeList[index]['id'],
                            incomeList[index]['category'],
                            incomeList[index]['type'],
                            helper,
                            context)));
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: expenseList.length,
                  itemBuilder: (context, index) {
                    return (ListTile(
                        title: expenseTile(
                            expenseList[index]['amount'],
                            expenseList[index]['note'],
                            expenseList[index]['date'],
                            expenseList[index]['id'],
                            expenseList[index]['category'],
                            expenseList[index]['type'],
                            helper,
                            context)));
                  }),
            ],
          ))),
    );
  }

  Widget expenseTile(int value, String note, DateTime dateTime, int id,
      String category, String type, Dbhelper dataBase, BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
      
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
                  Text('${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Text(category,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ))
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
                  Text('${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Text(category,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  )),
            ],
          ),
        )),
      ),
    );
  }
}
