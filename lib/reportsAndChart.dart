import 'dart:core';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  void initState() {
    getRawMap();
    categoryAdder();
    super.initState();
  }

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
  Dbhelper helper = Dbhelper();
  CategoryBox categories = CategoryBox();
  List<String> incomeCat = [];
  List<String> expenseCat = [];
  Map<String, double> categoryMappedIncomes = {};
  Map<String, double> categoryMappedExpenses = {};
  Map<dynamic, dynamic> sortedMap = {};
  ValueNotifier<List> myList = ValueNotifier([]);
  ValueNotifier<List> incomeList = ValueNotifier([]);
  ValueNotifier<List> expenseList = ValueNotifier([]);
  List<PieChartSectionData> expenseChartData = [];
  List<PieChartSectionData> incomeChartData = [];
  bool isSelectedMonthly = false;
  bool isSelectedDated = false;
  bool isSelectedWeekly = false;
  bool isAllHistorySelected = true;
  List selectiveSortedAll = [];
  List selectiveSortedIncomes = [];
  List selectiveSortedExpenses = [];
  double totalBalance = 0;
  double totalExpence = 0;
  double totalIncome = 0;
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
    await getTotalBalance(myList.value);
    await incomeCategoryMapper(incomeCat, incomeList.value);
    await expenseCategoryMapper(expenseCat, expenseList.value);
    setState(() {
       selectAPeriod(DateTime(2000), DateTime.now());
    });
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
    for (var element in myList.value) {
      if ((element['date'].isAfter(start.subtract(Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(Duration(days: 1))))) {
        monthly.add(element);
      }
    }
    selectiveSortedAll.clear();
    selectiveSortedAll.addAll(monthly);
    monthly.clear();

    for (var element in incomeList.value) {
      if ((element['date'].isAfter(start.subtract(Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(Duration(days: 1))))) {
        monthly.add(element);
      }
    }
    selectiveSortedIncomes.clear();
    selectiveSortedIncomes.addAll(monthly);
    monthly.clear();

    expenseList.value.forEach((element) {
      if ((element['date'].isAfter(start.subtract(Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(Duration(days: 1))))) {
        monthly.add(element);
      }
    });
    selectiveSortedExpenses.clear();
    selectiveSortedExpenses.addAll(monthly);
    setState(() {
      expenseCategoryMapper(expenseCat, selectiveSortedExpenses);
      incomeCategoryMapper(incomeCat, selectiveSortedIncomes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: SafeArea(
          child: (Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  'Analysis And Reports',
                  style: TextStyle(color: Color.fromARGB(235, 0, 0, 0)),
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  ChoiceChip(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    elevation: 5,
                    pressElevation: 10,
                    label: Text('Full History Chart',
                        style: TextStyle(
                          fontSize: 20,
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
                        await selectAPeriod(DateTime.utc(2020), DateTime.now());
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
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          elevation: 5,
                          pressElevation: 10,
                          label: Text('Last Week',
                              style: TextStyle(
                                  fontSize: 20,
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
                                  DateTime.now().subtract(Duration(days: 7)),
                                  DateTime.now());
                              setState(() {});
                            }
                          },
                        ),
                        ChoiceChip(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          elevation: 5,
                          pressElevation: 10,
                          label: Text('Last 30 Days',
                              style: TextStyle(
                                fontSize: 20,
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
                                  DateTime.now().subtract(Duration(days: 30)),
                                  DateTime.now());
                              setState(() {});
                            }
                          },
                        ),
                        ChoiceChip(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          elevation: 5,
                          pressElevation: 10,
                          label: Text('Custom',
                              style: TextStyle(
                                  fontSize: 20,
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
                        unselectedLabelColor: Colors.black,
                        indicator: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(25)),
                        labelColor: Colors.white,
                        tabs: const [
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
                        selectiveSortedIncomes.isNotEmpty
                            ? PieChart(
                                PieChartData(
                                  sections: incomeChartData,
                                ),
                              )
                            : Image.asset('Assets/images/noData.gif'),
                        selectiveSortedExpenses.isNotEmpty
                            ? PieChart(PieChartData(
                                sections: expenseChartData,
                              ))
                            : Image.asset('Assets/images/noData.gif'),
                      ],
                    ),
                  ),
                ],
              ))),
        ));
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
    setState(() {});
  }

  expenseCategoryMapper(List<String> data, List expenses) {
    expenseChartData.clear();
    double totalExp = 0;
    expenses.forEach((element) {
      totalExp = totalExp + element['amount'];
    });
    for (var category in data) {
      double total = 0;
      expenses.forEach((expenseItem) {
        if (expenseItem['category'].toString() == category) {
          total = total + expenseItem['amount'];
        }

        categoryMappedExpenses[category] = (total / totalExp) * 100;
      });

      PieChartSectionData pieChartItem = PieChartSectionData(
        titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        radius: 150,
        value: total,
        title:
            '${category}\n(${categoryMappedExpenses[category]?.toStringAsFixed(2)}%)',
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      );
      expenseChartData.add(pieChartItem);
    }
  }

  incomeCategoryMapper(List<String> data, List incomes) {
    incomeChartData.clear();
    double totalInc = 0;
    incomes.forEach((element) {
      totalInc = totalInc + element['amount'];
    });
    for (var category in data) {
      double total = 0;
      incomes.forEach((incomeItem) {
        if (incomeItem['category'].toString() == category) {
          total = total + incomeItem['amount'];
        }
        categoryMappedIncomes[category] = (total / totalInc) * 100;
      });

      PieChartSectionData pieChartItem = PieChartSectionData(
        titlePositionPercentageOffset: 0.5,
        radius: 150,
        titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        value: total,
        title:
            // category,
            '${category}\n(${categoryMappedIncomes[category]?.toStringAsFixed(2)}%)',
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      );
      incomeChartData.add(pieChartItem);
    }
  }
}
