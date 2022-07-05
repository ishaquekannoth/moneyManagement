import 'dart:core';
import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/editScreen.dart';
import 'package:moneymanager/search.dart';

class ViewAllTransactions extends StatefulWidget {
  const ViewAllTransactions({Key? key}) : super(key: key);

  @override
  State<ViewAllTransactions> createState() => _ViewAllTransactionsState();
}

class _ViewAllTransactionsState extends State<ViewAllTransactions> {
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
  bool isSelectedMonthly = true;
  bool isSelectedDated = false;
  bool isSelectedWeekly = false;
  bool isAllHistorySelected = false;

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
    for (var element in myList) {
      if (element['type'] == 'Expense') {
        expenseList.add(element);
      } else {
        incomeList.add(element);
      }
    }
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
    if (start.isAfter(end)) {
      DateTime temp = end;
      end = start;
      start = temp;
    }
    List monthly = [];
    for (var element in myList) {
      if ((element['date'].isAfter(start.subtract(Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(Duration(days: 1))))) {
        monthly.add(element);
      }
    }
    selectiveSortedAll.clear();
    selectiveSortedAll.addAll(monthly);
    monthly.clear();

    for (var element in incomeList) {
      if ((element['date'].isAfter(start.subtract(Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(Duration(days: 1))))) {
        monthly.add(element);
      }
    }
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
        child: SafeArea(
          child: (Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  'Transaction History',
                  style: TextStyle(color: Color.fromARGB(235, 0, 0, 0)),
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  ChoiceChip(
                    elevation: 5,
                    pressElevation: 10,
                    label: Text('All History',
                        style: TextStyle(
                          fontSize: 20,
                          color: isAllHistorySelected
                              ? Colors.white
                              : Colors.black,
                        )),
                    selectedColor: Colors.green,
                    selected: isAllHistorySelected,
                    onSelected: (value) async {
                      if (value == true) {
                        isSelectedMonthly = false;
                        isSelectedWeekly = false;
                        isSelectedDated = false;
                        isAllHistorySelected = true;
                        await selectAPeriod(
                            DateTime.utc(2020),
                            DateTime.now());
                        setState(() {});
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ChoiceChip(
                          elevation: 5,
                          pressElevation: 10,
                          label: Text('Last 30 Days',
                              style: TextStyle(
                                fontSize: 20,
                                color: isSelectedMonthly
                                    ? Colors.white
                                    : Colors.black,
                              )),
                          selectedColor: Colors.green,
                          selected: isSelectedMonthly,
                          onSelected: (value) async {
                            if (value == true) {
                              isSelectedMonthly = true;
                              isSelectedWeekly = false;
                              isSelectedDated = false;
                              isAllHistorySelected = false;
                              await selectAPeriod(
                                  DateTime.now().subtract(Duration(days: 30)),
                                  DateTime.now());

                              setState(() {});
                            }
                          },
                        ),
                        ChoiceChip(
                          elevation: 5,
                          pressElevation: 10,
                          label: Text('B/W Dates',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: isSelectedDated
                                      ? Colors.white
                                      : Colors.black)),
                          selectedColor: Colors.green,
                          selected: isSelectedDated,
                          onSelected: (value) async {
                            if (value == true) {
                              await selectAPeriod(await _selectDate(context),
                                  await _selectDate(context));
                              isSelectedDated = true;
                              isSelectedWeekly = false;
                              isSelectedMonthly = false;
                              isAllHistorySelected = false;
                              setState(() {});
                            }
                          },
                        ),
                        ChoiceChip(
                          elevation: 5,
                          pressElevation: 10,
                          label: Text('Last Week',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: isSelectedWeekly
                                      ? Colors.white
                                      : Colors.black)),
                          selectedColor: Colors.green,
                          selected: isSelectedWeekly,
                          onSelected: (value) async {
                            if (value == true) {
                              isSelectedMonthly = false;
                              isSelectedWeekly = true;
                              isSelectedDated = false;
                              isAllHistorySelected = false;
                              await selectAPeriod(
                                  DateTime.now().subtract(Duration(days: 7)),
                                  DateTime.now());

                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TabBar(
                        indicator: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(25)),
                        labelColor: Color.fromARGB(255, 0, 0, 0),
                        tabs: const [
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
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: selectiveSortedAll.length,
                            itemBuilder: (context, index) {
                              if (selectiveSortedAll[index]['type'] ==
                                  'Expense') {
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
                                      selectiveSortedExpenses[index]
                                          ['category'],
                                      selectiveSortedExpenses[index]['type'],
                                      helper,
                                      context)));
                            }),
                      ],
                    ),
                  ),
                  FloatingActionButton.extended(
                      backgroundColor: Colors.lightBlue,
                      onPressed: () async {
                        showSearch(context: context,delegate: SearchScreen())
                            .whenComplete(() => getRawMap().whenComplete(() =>
                                selectAPeriod(
                                    DateTime.now().subtract(Duration(days: 30)),
                                    DateTime.now())));
                        setState(() {});
                      },
                      label: Icon(Icons.search))
                ],
              ))),
        ));
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
              .whenComplete(() => getRawMap())
              .whenComplete(() {
            selectAPeriod(
                DateTime.now().subtract(Duration(days: 30)), DateTime.now());
            setState(() {});
          });
          super.initState();
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
                        onPressed: () async {
                          dataBase
                              .removeSingleItem(id)
                              .whenComplete(() => getRawMap())
                              .then((value) => selectAPeriod(
                                  DateTime.now().subtract(Duration(days: 30)),
                                  DateTime.now()));
                          Navigator.of(context).pop();
                          setState(() {});
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
                      )),
                  Text('-$value AED',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 170, 20, 9),
                          fontWeight: FontWeight.bold)),
                  Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ))
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
                ]
              ),
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
        onTap: () async {
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
              .whenComplete(() => getRawMap())
              .whenComplete(() {
            selectAPeriod(
                DateTime.now().subtract(Duration(days: 30)), DateTime.now());
            setState(() {
              isSelectedMonthly = true;
              isSelectedWeekly = false;
              isSelectedDated = false;
            });
          });
          super.initState();
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
                              .whenComplete(() => getRawMap())
                              .then((value) => selectAPeriod(
                                  DateTime.now().subtract(Duration(days: 30)),
                                  DateTime.now()));
                          Navigator.of(context).pop();
                          setState(() {});
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
                      )),
                  Text('+$value AED',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 4, 112, 8),
                          fontWeight: FontWeight.bold)),
                  Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ))
                ]
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
