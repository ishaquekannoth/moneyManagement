import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/editScreen.dart';
import 'package:moneymanager/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewAllTransactions extends StatefulWidget {
  const ViewAllTransactions({Key? key}) : super(key: key);

  @override
  State<ViewAllTransactions> createState() => _ViewAllTransactionsState();
}

class _ViewAllTransactionsState extends State<ViewAllTransactions> {
  @override
  void initState() {
    getRawMap()
        .then((value) => selectAPeriod(DateTime.utc(2020), DateTime.now()));
    super.initState();
  }

  late SharedPreferences pref;
  Dbhelper helper = Dbhelper();
  CategoryBox category = CategoryBox();
  List myList = [];
  List incomeList = [];
  List expenseList = [];
  List selectiveSortedAll = [];
  List selectiveSortedIncomes = [];
  List selectiveSortedExpenses = [];
  bool isSelectedMonthly = false;
  bool isSelectedDated = false;
  bool isSelectedWeekly = false;
  bool isAllHistorySelected = true;

  Future<void> getRawMap() async {
    Map unsorted = await helper.fetchAllData();
    pref = await SharedPreferences.getInstance();
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
      if ((element['date'].isAfter(start.subtract(const Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(const Duration(days: 1))))) {
        monthly.add(element);
      }
    }
    selectiveSortedAll.clear();
    selectiveSortedAll.addAll(monthly);
    monthly.clear();

    for (var element in incomeList) {
      if ((element['date'].isAfter(start.subtract(const Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(const Duration(days: 1))))) {
        monthly.add(element);
      }
    }
    selectiveSortedIncomes.clear();
    selectiveSortedIncomes.addAll(monthly);
    monthly.clear();

    for (var element in expenseList) {
      if ((element['date'].isAfter(start.subtract(const Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(const Duration(days: 1))))) {
        monthly.add(element);
      }
    }
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
                toolbarHeight: 60,
                elevation: 0,
                backgroundColor: Colors.white,
                title: RichText(
                  text: const TextSpan(
                    text: 'T',
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                          text: 'ransaction History',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Center(
                    child: ChoiceChip(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      elevation: 5,
                      pressElevation: 10,
                      label: Text('Complete History',
                          style: TextStyle(
                            color: isAllHistorySelected
                                ? Colors.white
                                : Colors.black,
                          )),
                      selectedColor: Colors.purple,
                      selected: isAllHistorySelected,
                      onSelected: (value) async {
                        if (value == true) {
                          isSelectedMonthly = false;
                          isSelectedWeekly = false;
                          isSelectedDated = false;
                          isAllHistorySelected = true;
                          await selectAPeriod(
                              DateTime.utc(2020), DateTime.now());
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ChoiceChip(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          elevation: 5,
                          pressElevation: 10,
                          label: Text('Last Week',
                              style: TextStyle(
                                  color: isSelectedWeekly
                                      ? Colors.white
                                      : Colors.black)),
                          selectedColor: Colors.purple,
                          selected: isSelectedWeekly,
                          onSelected: (value) async {
                            if (value == true) {
                              isSelectedMonthly = false;
                              isSelectedWeekly = true;
                              isSelectedDated = false;
                              isAllHistorySelected = false;
                              await selectAPeriod(
                                  DateTime.now()
                                      .subtract(const Duration(days: 7)),
                                  DateTime.now());

                              setState(() {});
                            }
                          },
                        ),
                        ChoiceChip(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          elevation: 5,
                          pressElevation: 10,
                          label: Text('Last 30 Days',
                              style: TextStyle(
                                color: isSelectedMonthly
                                    ? Colors.white
                                    : Colors.black,
                              )),
                          selectedColor: Colors.purple,
                          selected: isSelectedMonthly,
                          onSelected: (value) async {
                            if (value == true) {
                              isSelectedMonthly = true;
                              isSelectedWeekly = false;
                              isSelectedDated = false;
                              isAllHistorySelected = false;
                              await selectAPeriod(
                                  DateTime.now()
                                      .subtract(const Duration(days: 30)),
                                  DateTime.now());

                              setState(() {});
                            }
                          },
                        ),
                        ChoiceChip(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          elevation: 5,
                          pressElevation: 10,
                          label: Text('Custom',
                              style: TextStyle(
                                  color: isSelectedDated
                                      ? Colors.white
                                      : Colors.black)),
                          selectedColor: Colors.purple,
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TabBar(
                        indicator: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(25)),
                        labelColor: const Color.fromARGB(255, 0, 0, 0),
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
                      child: Stack(
                    alignment: const Alignment(0.9, 0.9),
                    children: [
                      TabBarView(
                        children: [
                          selectiveSortedAll.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: selectiveSortedAll.length,
                                  itemBuilder: (context, index) {
                                    if (selectiveSortedAll[index]['type'] ==
                                        'Expense') {
                                      return (Container(
                                          child: expenseTile(
                                              selectiveSortedAll[index]
                                                  ['amount'],
                                              selectiveSortedAll[index]['note'],
                                              selectiveSortedAll[index]['date'],
                                              selectiveSortedAll[index]['id'],
                                              selectiveSortedAll[index]
                                                  ['category'],
                                              selectiveSortedAll[index]['type'],
                                              helper,
                                              context)));
                                    } else {
                                      return (Container(
                                        child: incomeTile(
                                            selectiveSortedAll[index]['amount'],
                                            selectiveSortedAll[index]['note'],
                                            selectiveSortedAll[index]['date'],
                                            selectiveSortedAll[index]['id'],
                                            selectiveSortedAll[index]
                                                ['category'],
                                            selectiveSortedAll[index]['type'],
                                            helper,
                                            context),
                                      ));
                                    }
                                  })
                              : Image.asset('Assets/images/noData.gif'),
                          selectiveSortedIncomes.isNotEmpty
                              ? ListView.builder(
                                  itemCount: selectiveSortedIncomes.length,
                                  itemBuilder: (context, index) {
                                    return (Container(
                                      
                                        child: incomeTile(
                                            selectiveSortedIncomes[index]
                                                ['amount'],
                                            selectiveSortedIncomes[index]
                                                ['note'],
                                            selectiveSortedIncomes[index]
                                                ['date'],
                                            selectiveSortedIncomes[index]['id'],
                                            selectiveSortedIncomes[index]
                                                ['category'],
                                            selectiveSortedIncomes[index]
                                                ['type'],
                                            helper,
                                            context)));
                                  })
                              : Image.asset(
                                  'Assets/images/noData.gif',
                                ),
                          selectiveSortedExpenses.isNotEmpty
                              ? ListView.builder(
                                  itemCount: selectiveSortedExpenses.length,
                                  itemBuilder: (context, index) {
                                    return (Container(
                                        child: expenseTile(
                                            selectiveSortedExpenses[index]
                                                ['amount'],
                                            selectiveSortedExpenses[index]
                                                ['note'],
                                            selectiveSortedExpenses[index]
                                                ['date'],
                                            selectiveSortedExpenses[index]
                                                ['id'],
                                            selectiveSortedExpenses[index]
                                                ['category'],
                                            selectiveSortedExpenses[index]
                                                ['type'],
                                            helper,
                                            context)));
                                  })
                              : Image.asset('Assets/images/noData.gif'),
                        ],
                      ),
                      FloatingActionButton(
                        backgroundColor: const Color.fromARGB(255, 206, 7, 7),
                        onPressed: () async {
                          myList.isNotEmpty
                              ? showSearch(
                                      context: context,
                                      delegate: SearchScreen())
                                  .whenComplete(() => getRawMap().whenComplete(
                                      () => selectAPeriod(
                                          DateTime.now().subtract(
                                              const Duration(days: 30)),
                                          DateTime.now())))
                              : Image.asset('Assets/images/noData.gif');
                          setState(() {});
                        },
                        child: const Icon(Icons.search),
                      )
                    ],
                  )),
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
            selectAPeriod(DateTime.now().subtract(const Duration(days: 30)),
                DateTime.now());
            setState(() {});
          });
          super.initState();
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return (AlertDialog(
                  title: const Text('Confirm Delete?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel")),
                    ElevatedButton(
                        onPressed: () async {
                          dataBase
                              .removeSingleItem(id)
                              .whenComplete(() => getRawMap())
                              .then((value) => selectAPeriod(
                                  DateTime.utc(2020), DateTime.now()));
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: const Text("OK"))
                  ],
                ));
              });
        },
        child: (Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Expense",
                      style: TextStyle(
                        color: Colors.black87,
                      )),
                  Text('-$value ${pref.getString('Currency')}',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 170, 20, 9),
                          fontWeight: FontWeight.bold)),
                  Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
                      style: const TextStyle(
                        color: Colors.black87,
                      ))
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Category: $category',
                    style: const TextStyle(
                      color: Colors.black87,
                    )),
                Text('Note: $note',
                    style: const TextStyle(
                      color: Colors.black87,
                    ))
              ]),
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
            selectAPeriod(DateTime.now().subtract(const Duration(days: 30)),
                DateTime.now());
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
                  title: const Text('Confirm Delete?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel")),
                    ElevatedButton(
                        onPressed: () {
                          dataBase
                              .removeSingleItem(id)
                              .whenComplete(() => getRawMap())
                              .then((value) => selectAPeriod(
                                  DateTime.utc(2020), DateTime.now()));
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: const Text("OK"))
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Income",
                    style: TextStyle(
                      color: Colors.black87,
                    )),
                Text('+$value ${pref.getString('Currency')}',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 4, 112, 8),
                        fontWeight: FontWeight.bold)),
                Text('${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
                    style: const TextStyle(
                      color: Colors.black87,
                    ))
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Category: $category',
                      style: const TextStyle(
                        color: Colors.black87,
                      )),
                  Text('Note: $note',
                      style: const TextStyle(
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
