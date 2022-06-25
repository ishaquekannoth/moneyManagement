import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'static.dart' as customcolor;

class EditScreen extends StatefulWidget {
  final int value;
  final String note;
  final DateTime dateTime;
  final int id;
  final String category;
  String type;
  EditScreen(
      {Key? key,
      required this.value,
      required this.note,
      required this.dateTime,
      required this.id,
      required this.category,
      required this.type})
      : super(key: key);
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late String scg = widget.category;
  final _amount = TextEditingController();
  final _note = TextEditingController();
  final _dateTime = TextEditingController();
  final _category = TextEditingController();

  @override
  void initState() {
    super.initState();
    incomeCategoryAdder();
    expenseCategoryAdder();

    _amount.text = widget.value.toString();
    _note.text = widget.note.toString();
    _dateTime.text = widget.dateTime.toString();
  }

  // int? amount;
  //late String note = widget.note;
  late String type = widget.type;
  DateTime selectedDate = DateTime.now();

  // String? temp;
  CategoryBox categoryBox = CategoryBox();
  List<DropdownMenuItem<String>> incomeCat = [];
  List<DropdownMenuItem<String>> expenseCat = [];
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
    String temp = widget.category;
    return (Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: ListView(padding: EdgeInsets.all(12.0), children: [
        Text(
          'Update a Transaction',
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
                controller: _amount,
                // onChanged: (value) {
                //   try {
                //     _amount.text = int.parse(value).toString();
                //   } catch (e) {
                //     Text("only numbers permitted");
                //   }
                // },
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
                controller: _note,
                decoration: const InputDecoration(
                    hintText: 'Description', border: InputBorder.none),
                style: const TextStyle(fontSize: 24.0),
                // onChanged: (value) {
                //   note = value;
                // },
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
                    // temp = null;
                    type = 'Income';
                    scg = 'Unspecified';
                    //selectedCategory = widget.category;
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
                    scg = 'Unspecified';
                    // temp = null;
                    //selectedCategory = 'Unspecified';
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
            //value: widget.category,
            menuMaxHeight: 200,
            items: type == 'Income' ? incomeCat : expenseCat,
            hint: Text(scg)
            //  (Text(
            //   selectedCategory,
            //   temp == null ? 'No value Selected' : selectedCategory,
            //   style: TextStyle(fontSize: 20),
            // ))
            ,
            onChanged: (String? value) {
              print(value);
              setState(() {
                scg = value!;
                temp = value;
                selectedCategory = value;
              });
            },
            isExpanded: true,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Category Not Listed?',
          style: TextStyle(
              fontSize: 18.0, color: Colors.red, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton.icon(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return (AlertDialog(
                        title: Text('Enter the category to add'),
                        actions: [
                          TextField(
                              decoration: InputDecoration(
                                  hintText: 'Category Name',
                                  border: InputBorder.none),
                              style: TextStyle(fontSize: 24.0),
                              onChanged: (cat) {
                                if (cat != null) {
                                  category = cat.toString();
                                  setState(() {});
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z]"))
                              ],
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences),
                          TextButton(
                              onPressed: () async {
                                print('About to print');
                                addCategoryToDB(category!, type);
                                await expenseCategoryAdder();
                                await incomeCategoryAdder();
                                print('${category},${type}');
                                setState(() {
                                  category = null;
                                });
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Add Category'),
                                  IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: (Icon(Icons.close_outlined)))
                                ],
                              )),
                        ],
                      ));
                    });
                setState(() {});
              },
              icon: (Icon(Icons.add)),
              label: Text("Add an $type Category"))
        ]),
        SizedBox(
          height: 20,
        ),
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
                      "${widget.dateTime.day}${" ${months[widget.dateTime.month - 1]}"}${" ${widget.dateTime.year}"}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ))),
        SizedBox(
          height: 45,
        ),
        SizedBox(
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  if (_amount.text != null && _note.text.isNotEmpty
                      &&
                      scg != 'Unspecified'
                      ) {
                    Dbhelper dbhelper = Dbhelper();
                    dbhelper.editSingleItem(
                        amount: int.parse(_amount.text),
                        date: selectedDate,
                        note: _note.text,
                        type: type,
                        category: scg,
                        id: widget.id);
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
                  'Confirm Update',
                  style: TextStyle(fontSize: 18),
                )))
      ]),
    ));
  }

  addCategoryToDB(String newCategory, String type) {
    categoryBox.addCategory(category: newCategory, type: type);
  }

  incomeCategoryAdder() async {
    incomeCat.clear();
    List<DropdownMenuItem<String>> defaultIncomeCategory = [
      DropdownMenuItem(
        value: 'BlackMoney',
        child: Text(
          'BlackMoney',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      DropdownMenuItem(
        value: "Business Income",
        child: Text('Business Income',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      DropdownMenuItem(
        value: "Capital Gains",
        child: Text('Capital Gains',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      DropdownMenuItem(
        value: "Donations/Gifts Recieved",
        child: Text('Donations/Gifts',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      DropdownMenuItem(
        value: "Salary",
        child: Text('Salary Income',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      DropdownMenuItem(
        value: "Winning Lotteries",
        child: Text('Winning Lotteries',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      DropdownMenuItem(
        value: "Miscallaneous Income",
        child: Text('Miscallaneous Income',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    ];
    List<dynamic> income = await categoryBox.fetchIncomeCategory();
    List<DropdownMenuItem<String>> dropDown = [];

    for (int i = 0; i < income.length; i++) {
      String val = income[i]['name'].toString();
      DropdownMenuItem<String> item = DropdownMenuItem(
          value: val,
          child: Text(
            val,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ));
      dropDown.add(item);
    }
    setState(() {
      incomeCat.addAll(defaultIncomeCategory);
      incomeCat.addAll(dropDown);
      print('Length of Income category ${incomeCat.length}');
    });
  }

  expenseCategoryAdder() async {
    expenseCat.clear();
    List<DropdownMenuItem<String>> defaultExpenseCategory = [
      DropdownMenuItem(
        value: 'Business Expense',
        child: Text(
          'Business Expense',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      DropdownMenuItem(
        value: "Capital Losses Incured",
        child: Text('Capital Losses Incured',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      DropdownMenuItem(
        value: "Donations/Gifts paid",
        child: Text('Donations/Gifts',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      DropdownMenuItem(
        value: "Lost bets",
        child: Text('Losing Lotteries',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      DropdownMenuItem(
        value: "Life Expenses",
        child: Text('Normal Life Exp',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      DropdownMenuItem(
        value: "Miscallaneous Expense",
        child: Text('Miscallaneous Expense',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      DropdownMenuItem(
        value: "Xtras",
        child: Text('Xtras',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    ];
    List<dynamic> expenses = await categoryBox.fetchExpenseCategory();
    List<DropdownMenuItem<String>> dropDown = [];

    for (int i = 0; i < expenses.length; i++) {
      String val = expenses[i]['name'].toString();
      DropdownMenuItem<String> item = DropdownMenuItem(
          value: val,
          child: Text(
            val,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ));
      dropDown.add(item);
    }
    setState(() {
      expenseCat.addAll(defaultExpenseCategory);
      expenseCat.addAll(dropDown);
      print('Length of expense category ${expenseCat.length}');
    });
  }
}
