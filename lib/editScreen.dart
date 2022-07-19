
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/notifications.dart';

class EditScreen extends StatefulWidget {
  final double value;
  final String note;
  final DateTime dateTime;
  final int id;
  final String category;
 final  String type;
  const EditScreen(
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

  @override
  void initState() {
    super.initState();
    incomeCategoryAdder();
    expenseCategoryAdder();

    _amount.text = widget.value.toString();
    _note.text = widget.note.toString();
    _dateTime.text = widget.dateTime.toString();
  }

  late String type = widget.type;
  late DateTime selectedDate = widget.dateTime;
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
    return (Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: ListView(padding: const EdgeInsets.all(12.0), children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(
              width: 15,
            ),
            const Text(
              'Update An Existing Item',
              textAlign: TextAlign.justify,
              style: TextStyle( fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: type == 'Income'
                        ? const Color.fromARGB(255, 3, 114, 7)
                        : const Color.fromARGB(255, 182, 15, 3),
                    borderRadius: BorderRadius.circular(16.0)),
                child: const Icon(
                  Icons.attach_money,
                  size: 24.0,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: _amount,
                inputFormatters: [
                   LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Put The Amount', border: InputBorder.none),
                style: const TextStyle(),
             
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(16.0)),
                child: const Icon(
                  Icons.description,
                  size: 24.0,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: _note,
                 inputFormatters: [
                   LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                ],
                decoration: const InputDecoration(
                    hintText: 'Description', border: InputBorder.none),
                style: const TextStyle(),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 6, 116),
                    borderRadius: BorderRadius.circular(16.0)),
                child: const Icon(
                  Icons.moving_sharp,
                  size: 24.0,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 10,
            ),
            ChoiceChip(
              label: Text(
                'Income',
                style: TextStyle(
                    
                    color: type == 'Income' ? Colors.white : Colors.black),
              ),
              selectedColor: Colors.green,
              selected: type == 'Income' ? true : false,
              onSelected: (value) {
                if (value == true) {
                  setState(() {
                    type = 'Income';
                    scg = 'Cateogory Not Selected';
                  });
                }
              },
            ),
            const SizedBox(
              width: 25,
            ),
            ChoiceChip(
              label: Text('Expense',
                  style: TextStyle(
                    
                    color: type == 'Expense' ? Colors.white : Colors.black,
                  )),
              selectedColor: Colors.red,
              selected: type == 'Expense' ? true : false,
              onSelected: (value) {
                if (value == true) {
                  setState(() {
                    type = 'Expense';
                    scg = 'Cateogory Not Selected';
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          'Choose a category of $type',
          style: const TextStyle(),
        ),
        Container(
          padding: const EdgeInsets.only(top: 15),
          child: DropdownButton(
            menuMaxHeight: 200,
            items: type == 'Income' ? incomeCat : expenseCat,
            hint: Text(scg),
            onChanged: (String? value) {
              setState(() {
                scg = value!;
              });
            },
            isExpanded: true,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Category Not Listed?',
          style: TextStyle(
            color: type == 'Income' ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: type == 'Income' ? Colors.green : Colors.red,
              minimumSize: const Size(25, 35),
            ),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return (AlertDialog(
                      title: const Text('Enter the category to add'),
                      actions: [
                        TextField(
                            decoration: const InputDecoration(
                                hintText: 'Category Name',
                                border: InputBorder.none),
                            style: const TextStyle(),
                            onChanged: (cat) {
                              category = cat.toString();
                              setState(() {});
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z]"))
                            ],
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences),
                        TextButton(
                            onPressed: () async {
                              addCategoryToDB(category!, type);
                              await expenseCategoryAdder();
                              await incomeCategoryAdder();

                              setState(() {});
                                  if (!mounted) return;
                               Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Add Category'),
                                IconButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: (const Icon(Icons.close_outlined)))
                              ],
                            )),
                      ],
                    ));
                  });
              setState(() {});
            },
            icon: (const Icon(Icons.add)),
            label: Text("Add an $type Category",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          )
        ]),
        const SizedBox(
          height: 10,
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
                      color: type == 'Income' ? Colors.green : Colors.red,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "${selectedDate.day}${" ${months[selectedDate.month - 1]}"}${" ${selectedDate.year}"}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                         
                          color: type == 'Income' ? Colors.green : Colors.red),
                    ),
                  ],
                ))),
        const SizedBox(
          height: 35,
        ),
        FloatingActionButton.extended(
          label: const Text(
            'Confirm Update',
            style: TextStyle(),
          ),
          backgroundColor: type == 'Income' ? Colors.green : Colors.red,
          extendedTextStyle: const TextStyle(letterSpacing: 2, color: Colors.white),
          onPressed: () async {
            if (_note.text.isNotEmpty &&
                double.parse(_amount.text) > 0.0 &&
                scg != 'Cateogory Not Selected') {
              Dbhelper dbhelper = Dbhelper();
              dbhelper.editSingleItem(
                  amount: double.parse(_amount.text),
                  date: selectedDate,
                  note: _note.text,
                  type: type,
                  category: scg,
                  id: widget.id);
              Navigator.of(context).pop();
              await NotificationApi().getTotalBalance();
              if(NotificationApi.balance<0) {
                await NotificationApi.showNotification(
                  body:
                      'Click here to Add an Income item',
                  payload: 'Data');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                  margin: EdgeInsets.all(15),
                  backgroundColor: Colors.red,
                  content: Text('All fields are required',
                      style: TextStyle(),
                      textAlign: TextAlign.center)));
            }
          },
        ),
      ]),
    ));
  }

  addCategoryToDB(String newCategory, String type) {
    categoryBox.addCategory(category: newCategory, type: type);
  }

  incomeCategoryAdder() async {
    incomeCat.clear();
    List<DropdownMenuItem<String>> defaultIncomeCategory = [
          const DropdownMenuItem(
        value: 'BlackMoney',
        child: Text(
          'BlackMoney',
          style: TextStyle(fontWeight: FontWeight.bold, ),
        ),
      ),
      const DropdownMenuItem(
        value: "Borrow",
        child: Text('Borrowing',
            style: TextStyle(fontWeight: FontWeight.bold,)),
      ),
      const DropdownMenuItem(
        value: "Business",
        child: Text('Business Income',
            style: TextStyle(fontWeight: FontWeight.bold,)),
      ),
      const DropdownMenuItem(
        value: "Dividends",
        child: Text('Dividends',
            style: TextStyle(fontWeight: FontWeight.bold, )),
      ),
      const DropdownMenuItem(
        value: "Interests",
        child: Text('Interests',
            style: TextStyle(fontWeight: FontWeight.bold,)),
      ),
      const DropdownMenuItem(
        value: "Others",
        child: Text('Others',
            style: TextStyle(fontWeight: FontWeight.bold, )),
      ),
      const DropdownMenuItem(
        value: "Salary",
        child: Text('Salary Income',
            style: TextStyle(fontWeight: FontWeight.bold,)),
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
            style: const TextStyle(fontWeight: FontWeight.bold, ),
          ));
      dropDown.add(item);
    }
    setState(() {
      incomeCat.addAll(defaultIncomeCategory);
      incomeCat.addAll(dropDown);
    });
  }

  expenseCategoryAdder() async {
    expenseCat.clear();
    List<DropdownMenuItem<String>> defaultExpenseCategory = [
     const DropdownMenuItem(
        value: "Clothing",
        child: Text('Clothing',
            style: TextStyle(fontWeight: FontWeight.bold, )),
      ),
      const DropdownMenuItem(
        value: "Food",
        child: Text(
          'Food Expense',
          style: TextStyle(fontWeight: FontWeight.bold, ),
        ),
      ),
      const DropdownMenuItem(
        value: "Gifts paid",
        child: Text('Gifts/Donations',
            style: TextStyle(fontWeight: FontWeight.bold, )),
      ),
      const DropdownMenuItem(
        value: "Lend",
        child: Text('Lend to friends',
            style: TextStyle(fontWeight: FontWeight.bold,)),
      ),
      const DropdownMenuItem(
        value: "Losses",
        child: Text('Losses Incured',
            style: TextStyle(fontWeight: FontWeight.bold, )),
      ),
      const DropdownMenuItem(
        value: "Travel",
        child: Text('Travelling',
            style: TextStyle(fontWeight: FontWeight.bold, )),
      ),
      const DropdownMenuItem(
        value: "Xtras",
        child: Text('Xtras',
            style: TextStyle(fontWeight: FontWeight.bold, )),
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
            style: const TextStyle(fontWeight: FontWeight.bold,),
          ));
      dropDown.add(item);
    }
    setState(() {
      expenseCat.addAll(defaultExpenseCategory);
      expenseCat.addAll(dropDown);
    });
  }
}
