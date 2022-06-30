import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';

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
      body: ListView(padding: EdgeInsets.all(12.0), children: [
        Row(
         children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),

          SizedBox(width: 15,),

            Text(
              'Update An Existing Item',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
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
                    color: type=='Income'?Color.fromARGB(255, 3, 114, 7):Color.fromARGB(255, 182, 15, 3),
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
                    color: Colors.blueGrey,
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
                    color: Color.fromARGB(255, 226, 6, 116),
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
            SizedBox(
              width: 25,
            ),
            ChoiceChip(
              label: Text('Expense',
                  style: TextStyle(
                    fontSize: 20,
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
             style: ElevatedButton.styleFrom(
              primary: type=='Income'?Colors.green:Colors.red,
            minimumSize: Size(25, 35),
            ),
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
                             
                                addCategoryToDB(category!, type);
                                await expenseCategoryAdder();
                                await incomeCategoryAdder();
                              
                                setState(() {
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
              label: Text("Add an $type Category",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),)
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
                      color: type=='Income'?Colors.green:Colors.red,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                       "${selectedDate.day}${" ${months[selectedDate.month - 1]}"}${" ${selectedDate.year}"}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: type=='Income'?Colors.green:Colors.red),
                    ),
                  ],
                ))),
        SizedBox(
          height: 45,
        ),
        FloatingActionButton.extended(
          label: Text('Confirm Update',style: TextStyle(fontSize: 20),),
          backgroundColor: type=='Income'?Colors.green:Colors.red,
          extendedTextStyle: TextStyle(letterSpacing: 2,color: Colors.white),
          onPressed:() {
              if (_amount.text != null && _note.text.isNotEmpty
                  &&
                  scg != 'Cateogory Not Selected'
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
    });
  }
}
