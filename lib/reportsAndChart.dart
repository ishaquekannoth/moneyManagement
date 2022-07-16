import 'dart:core';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    "BlackMoney",
    "Business",
    "Interests",
    "Borrow",
    "Salary",
    "Dividends",
    "Others",
  ];
  List<String> defaultExpenses = [
    "Food",
    "Losses",
    "Gifts paid",
    "Clothing",
    "Travel",
    "Lend",
    "Xtras"
  ];
  late SharedPreferences pref;
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
  String? currency;
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
    pref=await SharedPreferences.getInstance();
    currency = pref.getString('Currency').toString();
    setState(() {
      selectAPeriod(DateTime(2000), DateTime.now()); 
    
    });
  
  }

  getTotalBalance(List data) {
    totalBalance = 0;
    totalExpence = 0;
    totalIncome = 0;
    for (var value in data) {
      if (value['type'] == 'Income') {
        totalBalance += value['amount'] as double;
        totalIncome += value['amount'] as double;
      } else {
        totalBalance -= value['amount'] as double;
        totalExpence += value['amount'] as double;
      }
    }
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
      if ((element['date'].isAfter(start.subtract(const Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(const Duration(days: 1))))) {
        monthly.add(element);
      }
    }
    selectiveSortedAll.clear();
    selectiveSortedAll.addAll(monthly);
    monthly.clear();

    for (var element in incomeList.value) {
      if ((element['date'].isAfter(start.subtract(const Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(const Duration(days: 1))))) {
        monthly.add(element);
      }
    }
    selectiveSortedIncomes.clear();
    selectiveSortedIncomes.addAll(monthly);
    monthly.clear();

    for (var element in expenseList.value) {
      if ((element['date'].isAfter(start.subtract(const Duration(days: 1)))) &&
          (element['date'].isBefore(end.add(const Duration(days: 1))))) {
        monthly.add(element);
      }
    }
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
                toolbarHeight: 80,
                elevation: 0,
                backgroundColor: Colors.white,
                title: RichText(
                  text: const TextSpan(
                    text: 'A',
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                          text: 'nalysis',
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
                  ChoiceChip(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    elevation: 5,
                    pressElevation: 10,
                    label: Text('Full History Chart',
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
                              
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 50,
                                  sections: incomeChartData,
                                ),
                              )
                            : Image.asset('Assets/images/noData.gif'),
                        selectiveSortedExpenses.isNotEmpty
                            ? PieChart(PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 50,
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
    for (var element in expenses) {
      totalExp = totalExp + element['amount'];
    }
    for (var category in data) {
      double total = 0;
      for (var expenseItem in expenses) {
        if (expenseItem['category'].toString() == category) {
          total = total + expenseItem['amount'];
        }

        categoryMappedExpenses[category] = (total / totalExp) * 100;
      }

      PieChartSectionData pieChartItem = PieChartSectionData(
        titleStyle:
            const TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
        radius: 120,
        value: total,
        title:
            '$category(${categoryMappedExpenses[category]?.toStringAsFixed(2)}%)\n$total$currency',
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      );
      expenseChartData.add(pieChartItem);
    }
  }

  incomeCategoryMapper(List<String> data, List incomes) {
    incomeChartData.clear();
    double totalInc = 0;
    for (var element in incomes) {
      totalInc = totalInc + element['amount'];
    }
    for (var category in data) {
      double total = 0;
      for (var incomeItem in incomes) {
        if (incomeItem['category'].toString() == category) {
          total = total + incomeItem['amount'];
        }
        categoryMappedIncomes[category] = (total / totalInc) * 100;
      }

      PieChartSectionData pieChartItem = PieChartSectionData(
       titlePositionPercentageOffset: 0.5,
        radius: 120,
        titleStyle:
            const TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
        value: total,
        title:
            '$category(${categoryMappedIncomes[category]?.toStringAsFixed(2)}%)\n$total$currency',
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      );
      incomeChartData.add(pieChartItem);
    }
  }
}
