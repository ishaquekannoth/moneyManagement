import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/editScreen.dart';

class Analysis extends StatefulWidget {
  const Analysis({Key? key}) : super(key: key);

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  @override
  void initState() {
    getRawMap().then((value) => selectAPeriod(
        DateTime.now().subtract(Duration(days: 30)), DateTime.now()));
    super.initState();
  }

  Dbhelper helper = Dbhelper();
  CategoryBox category = CategoryBox();
  List myList = [];
  List incomeList = [];
  List expenseList = [];
  List selectiveSortedAll = [];
  List selectiveSortedIncomes = [];
  List selectiveSortedExpenses = [];
  bool isSelected = true;

  Future<void> getRawMap() async {
    Map unsorted = await helper.fetchAllData();
    var sortMapByValue = Map.fromEntries(unsorted.entries.toList()
      ..sort((e1, e2) => e2.value['date'].compareTo(e1.value['date'])));
    List sortedList = [];
    sortMapByValue.forEach((key, value) => sortedList.add(value));
    myList.clear();
    myList.addAll(sortedList);
    incomeList.clear();
    expenseList.clear();
    myList.forEach(
      (element) {
        if (element['type'] == 'Expense') {
          expenseList.add(element);
        } else {
          incomeList.add(element);
        }
      },
    );
    print('Length of IncomeList and ExpenseList');
    print(incomeList.length);
    print(incomeList.length);
    setState(() {});
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    if (picked != null && picked != DateTime.now()) {
      setState(() {});
    }
    return Future.value(picked);
  }

  selectAPeriod(DateTime start, DateTime end) async {
    List monthly = [];
    myList.forEach((element) {
      print(DateTimeRange(start: start, end: end));
      if ((element['date'].isAfter(start.subtract(Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(Duration(days: 1))))) {
        monthly.add(element);
      }
    });
    selectiveSortedAll.clear();
    selectiveSortedAll.addAll(monthly);
    monthly.clear();

    incomeList.forEach((element) {
      if ((element['date'].isAfter(start.subtract(Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(Duration(days: 1))))) {
        monthly.add(element);
      }
    });
    selectiveSortedIncomes.clear();
    selectiveSortedIncomes.addAll(monthly);
    monthly.clear();

    expenseList.forEach((element) {
      if ((element['date'].isAfter(start.subtract(Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(Duration(days: 1))))) {
        monthly.add(element);
      }
    });
    selectiveSortedExpenses.clear();
    selectiveSortedExpenses.addAll(monthly);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: (Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.android_rounded))
            ],
            backgroundColor: Color.fromARGB(223, 255, 255, 255),
            title: Text(
              'Sort The Data',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            
            bottom:

                TabBar(labelColor: Color.fromARGB(255, 0, 0, 0), tabs: const [
              Tab(
                text: 'ALL',
              ),
              Tab(
                text: 'Incomes',
              ),
              Tab(
                text: 'Expenses',
              ),
            ]),
          ),
          floatingActionButton: Container(
            child: FloatingActionButton.extended(
              isExtended: true,
              backgroundColor: Colors.red,
              onPressed: () async {
                await selectAPeriod(
                    await _selectDate(context), await _selectDate(context));
              },
              label: Text(
                'Select Dates',
                softWrap: true,
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ChoiceChip(
                          label: Text('Last 30 Days',
                              style: TextStyle(
                                fontSize: 20,
                              )),
                          selectedColor: Colors.green,
                          selected: isSelected,
                          onSelected: (value) async{
                            if (value == true) {
                              isSelected = true;
                                await selectAPeriod(
                                  DateTime.now().subtract(Duration(days: 30)),
                                  DateTime.now());
                              setState(() {});
                            }
                          },
                        ),
                        ChoiceChip(
                          label: Text('Last Week',
                              style: TextStyle(
                                fontSize: 20,
                              )),
                          selectedColor: Colors.green,
                          selected: !isSelected,
                          onSelected: (value) async {
                            if (value == true) {
                              isSelected = false;
                              await selectAPeriod(
                                  DateTime.now().subtract(Duration(days: 7)),
                                  DateTime.now());
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: selectiveSortedAll.length,
                        itemBuilder: (context, index) {
                          if (selectiveSortedAll[index]['type'] == 'Expense') {
                            return (ListTile(
                                title: expenseTile(
                                    selectiveSortedAll[index]['amount'],
                                    selectiveSortedAll[index]['note'],
                                    selectiveSortedAll[index]['date'],
                                    selectiveSortedAll[index]['id'],
                                    selectiveSortedAll[index]['category'],
                                    selectiveSortedAll[index]['type'],
                                    helper,
                                    context)));
                          } else {
                            return (ListTile(
                              title: incomeTile(
                                  selectiveSortedAll[index]['amount'],
                                  selectiveSortedAll[index]['note'],
                                  selectiveSortedAll[index]['date'],
                                  selectiveSortedAll[index]['id'],
                                  selectiveSortedAll[index]['category'],
                                  selectiveSortedAll[index]['type'],
                                  helper,
                                  context),
                            ));
                          }
                        }),
                  ],
                ),
              ),
              ListView.builder(
                  itemCount: selectiveSortedIncomes.length,
                  itemBuilder: (context, index) {
                    return (ListTile(
                        title: incomeTile(
                            selectiveSortedIncomes[index]['amount'],
                            selectiveSortedIncomes[index]['note'],
                            selectiveSortedIncomes[index]['date'],
                            selectiveSortedIncomes[index]['id'],
                            selectiveSortedIncomes[index]['category'],
                            selectiveSortedIncomes[index]['type'],
                            helper,
                            context)));
                  }),
              ListView.builder(
                  itemCount: selectiveSortedExpenses.length,
                  itemBuilder: (context, index) {
                    return (ListTile(
                        title: expenseTile(
                            selectiveSortedExpenses[index]['amount'],
                            selectiveSortedExpenses[index]['note'],
                            selectiveSortedExpenses[index]['date'],
                            selectiveSortedExpenses[index]['id'],
                            selectiveSortedExpenses[index]['category'],
                            selectiveSortedExpenses[index]['type'],
                            helper,
                            context)));
                  }),
            ],
          ))),
    );
  }

  Widget expenseTile(int value, String note, DateTime dateTime, int id,
      String category, String type, Dbhelper dataBase, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('You clicked an Expense item ID is');
        print(id);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => (EditScreen(
                value: value,
                note: note,
                dateTime: dateTime,
                id: id,
                type: type,
                category: category))));
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
    );
  }

  Widget incomeTile(int value, String note, DateTime dateTime, int id,
      String category, String type, Dbhelper dataBase, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('You clicked an Income item.ID is');
        print(id);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => (EditScreen(
                  value: value,
                  note: note,
                  dateTime: dateTime,
                  id: id,
                  category: category,
                  type: type,
                ))));
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
    );
  }
}
