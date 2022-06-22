// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'static.dart' as customcolor;

class AddTransactions extends StatefulWidget {
  const AddTransactions({Key? key}) : super(key: key);

  @override
  State<AddTransactions> createState() => _AddTransactionsState();
}

class _AddTransactionsState extends State<AddTransactions> {
  int? amount;
  String note = "Some Notes";
  String type = "Income";
  DateTime selectedDate = DateTime.now();
  String? temp;
  CategoryBox categoryBox = CategoryBox();
  String? category;
  String selectedCategory = 'Unspecified';
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  List<DropdownMenuItem<String>> incomeCategory = [
    DropdownMenuItem(
      value: 'BlackMoney',
      child: Text(
        'BlackMoney',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ),
    DropdownMenuItem(
      value: "Business Income",
      child: Text('Business Income',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    ),
    DropdownMenuItem(
      value: "Capital Gains",
      child: Text('Capital Gains',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    ),
    DropdownMenuItem(
      value: "Donations/Gifts Recieved",
      child: Text('Donations/Gifts',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    ),
    DropdownMenuItem(
      value: "Salary",
      child: Text('Salary Income',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    ),
    DropdownMenuItem(
      value: "Winning Lotteries",
      child: Text('Winning Lotteries',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    ),
    DropdownMenuItem(
      value: "Miscallaneous Income",
      child: Text('Miscallaneous Income',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    ),
  ];
  List<DropdownMenuItem<String>> expenseCategory = [
    DropdownMenuItem(
      value: 'Business Expense',
      child: Text(
        'Business Expense',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ),
    DropdownMenuItem(
      value: "Capital Losses Paid",
      child: Text('Capital Losses Paid',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    ),
    DropdownMenuItem(
      value: "Donations/Gifts paid",
      child: Text('Donations/Gifts',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    ),
    DropdownMenuItem(
      value: "Lost bets",
      child: Text('Losing Lotteries',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    ),
    DropdownMenuItem(
      value: "Life Expenses",
      child: Text('Normal Life Exp',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    ),
    DropdownMenuItem(
      value: "Miscallaneous Expense",
      child: Text('Miscallaneous Expense',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    ),
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: ListView(padding: EdgeInsets.all(12.0), children: [
        Text(
          'Add Transactions',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: customcolor.PrimaryColor,
                    borderRadius: BorderRadius.circular(16.0)),
                child: Icon(
                  Icons.attach_money,
                  size: 24.0,
                  color: Colors.white,
                )),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  try {
                    amount = int.parse(value);
                  } catch (e) {
                    Text("only numbers permitted");
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Put The Amount', border: InputBorder.none),
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: customcolor.PrimaryColor,
                    borderRadius: BorderRadius.circular(16.0)),
                child: Icon(
                  Icons.description,
                  size: 24.0,
                  color: Colors.white,
                )),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                    hintText: 'Description', border: InputBorder.none),
                style: const TextStyle(fontSize: 24.0),
                onChanged: (value) {
                  note = value;
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: customcolor.PrimaryColor,
                    borderRadius: BorderRadius.circular(16.0)),
                child: Icon(
                  Icons.moving_sharp,
                  size: 24.0,
                  color: Colors.white,
                )),
            SizedBox(
              width: 15,
            ),
            ChoiceChip(
              label: Text(
                'Income',
                style: TextStyle(
                    fontSize: 20,
                    color: type == 'Income' ? Colors.white : Colors.black),
              ),
              selectedColor: customcolor.PrimaryColor,
              selected: type == 'Income' ? true : false,
              onSelected: (value) {
                if (value == true) {
                  setState(() {
                    temp = null;
                    type = 'Income';
                    selectedCategory = 'Unspecified';
                  });
                }
              },
            ),
            SizedBox(
              width: 25,
            ),
            ChoiceChip(
              label: Text('Expense',
                  style: TextStyle(
                    fontSize: 20,
                    color: type == 'Expense' ? Colors.white : Colors.black,
                  )),
              selectedColor: customcolor.PrimaryColor,
              selected: type == 'Expense' ? true : false,
              onSelected: (value) {
                if (value == true) {
                  setState(() {
                    type = 'Expense';
                    temp = null;
                    selectedCategory = 'Unspecified';
                  });
                }
              },
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'Choose a category of $type',
          style: TextStyle(fontSize: 20),
        ),
        Container(
          padding: EdgeInsets.only(top: 15),
          child: DropdownButton(
            items: type == 'Income' ? incomeCategory : expenseCategory,
            hint: (Text(
              temp == null ? 'No value Selected' : selectedCategory,
              style: TextStyle(fontSize: 20),
            )),
            onChanged: (String? value) {
              print(value);
              setState(() {
                temp = value!;
                selectedCategory = value;
              });
            },
            isExpanded: true,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text('Category Not Listed?', style: TextStyle(fontSize: 24.0)),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
            child: TextField(
                decoration: InputDecoration(
                    hintText: 'Enter the Category', border: InputBorder.none),
                style: TextStyle(fontSize: 24.0),
                onChanged: (cat) {
                  if (cat != '') {
                    category = cat.toString();
                    setState(() {});
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                ],
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences),
          ),
          ElevatedButton.icon(
              onPressed: () {
                addCategory(category!, type);
                print('${category},${type}');
              },
              icon: (Icon(Icons.add)),
              label: Text("Add"))
        ]),
        SizedBox(
            height: 50,
            child: TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 30.0,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "${selectedDate.day}${" ${months[selectedDate.month - 1]}"}${" ${selectedDate.year}"}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ))),
        SizedBox(
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  if (amount != null &&
                      note.isNotEmpty &&
                      selectedCategory != 'Unspecified') {
                    Dbhelper dbhelper = Dbhelper();
                    dbhelper.addData(
                        amount: amount!,
                        date: selectedDate,
                        note: note,
                        type: type,
                        category: selectedCategory);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                        margin: EdgeInsets.all(15),
                        backgroundColor: Colors.red,
                        content: Text('All fields are required',
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center)));
                  }
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide()))),
                child: Text(
                  'Add Data',
                  style: TextStyle(fontSize: 30),
                )))
      ]),
    ));
  }

  addCategory(String newCategory, String type) {
    categoryBox.addCategory(category: newCategory, type: type);
  }
}
