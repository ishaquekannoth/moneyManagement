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
    categoryAdder();
    incomeCategoryMapper(incomeCat);
    expenseCategoryMapper(expenseCat);
    super.initState();
  }

  CategoryBox categories = CategoryBox();
  double totalBalance = 0;
  double totalExpence = 0;
  double totalIncome = 0;
  List<String> defaultIncomes = [
    'BlackMoney',
    "Business Income",
    "Capital Gains",
    "Donations/Gifts",
    "Salary",
    "Won Lottery",
    "Misc Income",
  ];
  List<String> defaultExpenses = [
    "Business Expense",
    "Capital Loss",
    "Donations/Gifts paid",
    "Lost Lottery",
    "Life Expenses",
    "Misc Expense",
    "Xtras"
  ];
  List<String> incomeCat = [];
  List<String> expenseCat = [];
  Map<String, double> categoryMappedIncomes = {};
  Map<String, double> categoryMappedExpenses = {};
  //ValueNotifier<Map<dynamic, dynamic>> sortedMap = ValueNotifier({});
  Map<dynamic, dynamic> sortedMap = {};
  Dbhelper helper = Dbhelper();
  CategoryBox category = CategoryBox();
  ValueNotifier<List> myList = ValueNotifier([]);
  ValueNotifier<List> incomeList = ValueNotifier([]);
  ValueNotifier<List> expenseList = ValueNotifier([]);

  Future<void> getRawMap() async {
    Map unsorted = await helper.fetchAllData();
    var sortMapByValue = Map.fromEntries(unsorted.entries.toList()
      ..sort((e1, e2) => e2.value['date'].compareTo(e1.value['date'])));
    List sortedList = [];
    sortedMap = sortMapByValue;
    sortMapByValue.forEach((key, value) => sortedList.add(value));
    myList.value.clear();
    myList.value.addAll(sortedList);
    incomeList.value.clear();
    expenseList.value.clear();
    for (var element in myList.value) {
      if (element['type'] == 'Expense') {
        expenseList.value.add(element);
      } else {
        incomeList.value.add(element);
      }
    }
    myList.notifyListeners();
    expenseList.notifyListeners();
    incomeList.notifyListeners();
    incomeCategoryMapper(incomeCat);
    expenseCategoryMapper(expenseCat);
  }

  getTotalBalance(List data) {
    totalBalance = 0;
    totalExpence = 0;
    totalIncome = 0;
    data.forEach((value) {
      if (value['type'] == 'Income') {
        totalBalance += value['amount'] as double;
        totalIncome += value['amount'] as double;
      } else {
        totalBalance -= value['amount'] as double;
        totalExpence += value['amount'] as double;
      }
    });
    print('$totalBalance,$totalIncome,$totalExpence');
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
            bottom: TabBar(
                indicator: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(25)),
                isScrollable: true,
                labelColor: Color.fromARGB(255, 0, 0, 0),
                tabs: const [
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
              //await category.printCategoryValues();
              // getTotalBalance(myList.value);
              expenseCategoryMapper(expenseCat);
              print(categoryMappedExpenses.values);
              incomeCategoryMapper(incomeCat);
              print(categoryMappedIncomes.values);
            },
          ),
          body: Padding(
            padding: EdgeInsets.all(15),
            child: TabBarView(
              children: [
                ValueListenableBuilder(
                    valueListenable: myList,
                    builder: (BuildContext context, List myLocalList, widget) {
                      return (ListView.builder(
                          shrinkWrap: true,
                          itemCount: myLocalList.length,
                          itemBuilder: (context, index) {
                            if (myList.value[index]['type'] == 'Expense') {
                              return (ListTile(
                                  title: expenseTile(
                                      myList.value[index]['amount'],
                                      myList.value[index]['note'],
                                      myList.value[index]['date'],
                                      myList.value[index]['id'],
                                      myList.value[index]['category'],
                                      myList.value[index]['type'],
                                      helper,
                                      context)));
                            } else {
                              return (ListTile(
                                title: incomeTile(
                                    myList.value[index]['amount'],
                                    myList.value[index]['note'],
                                    myList.value[index]['date'],
                                    myList.value[index]['id'],
                                    myList.value[index]['category'],
                                    myList.value[index]['type'],
                                    helper,
                                    context),
                              ));
                            }
                          }));
                    }),
                ValueListenableBuilder(
                    valueListenable: incomeList,
                    builder: (BuildContext context, List myLocalList, widget) {
                      return (ListView.builder(
                          itemCount: incomeList.value.length,
                          itemBuilder: (context, index) {
                            return (ListTile(
                                title: incomeTile(
                                    incomeList.value[index]['amount'],
                                    incomeList.value[index]['note'],
                                    incomeList.value[index]['date'],
                                    incomeList.value[index]['id'],
                                    incomeList.value[index]['category'],
                                    incomeList.value[index]['type'],
                                    helper,
                                    context)));
                          }));
                    }),
                ValueListenableBuilder(
                    valueListenable: incomeList,
                    builder: (BuildContext context, List myLocalList, widget) {
                      return (ListView.builder(
                          shrinkWrap: true,
                          itemCount: expenseList.value.length,
                          itemBuilder: (context, index) {
                            return (ListTile(
                                title: expenseTile(
                                    expenseList.value[index]['amount'],
                                    expenseList.value[index]['note'],
                                    expenseList.value[index]['date'],
                                    expenseList.value[index]['id'],
                                    expenseList.value[index]['category'],
                                    expenseList.value[index]['type'],
                                    helper,
                                    context)));
                          }));
                    }),
              ],
            ),
          ))),
    );
  }

  Widget expenseTile(double value, String note, DateTime dateTime, int id,
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
                  Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
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

  Widget incomeTile(double value, String note, DateTime dateTime, int id,
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
                  Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
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

  categoryAdder() async {
    incomeCat.clear();
    expenseCat.clear();
    List<dynamic> income = await categories.fetchIncomeCategory();
    List<String> dropDown = [];

    for (int i = 0; i < income.length; i++) {
      String val = income[i]['name'].toString();
      dropDown.add(val);
    }
    incomeCat.addAll(defaultIncomes);
    incomeCat.addAll(dropDown);
   
    dropDown.clear();
    List<dynamic> expenses = await categories.fetchExpenseCategory();
    for (int i = 0; i < expenses.length; i++) {
      String val = expenses[i]['name'].toString();
      dropDown.add(val);
    }
      expenseCat.addAll(defaultExpenses);
      expenseCat.addAll(dropDown);
       setState(() {
    });
  }

  expenseCategoryMapper(List<String> data) {
    for (var category in data) {
      double total = 0;
      expenseList.value.forEach((expenseItem) {
        if (expenseItem['category'].toString() == category) {
          total = total + expenseItem['amount'];
        }
      });
      categoryMappedExpenses[category] = total;
    }
  }

  incomeCategoryMapper(List<String> data) {
    for (var category in data) {
      double total = 0;
      incomeList.value.forEach((incomeItem) {
        if (incomeItem['category'].toString() == category) {
          total = total + incomeItem['amount'];
        }
      });
      categoryMappedIncomes[category] = total;
    }
  }
}
