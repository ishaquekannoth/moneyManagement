import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/notifications.dart';

class AddTransactions extends StatefulWidget {
  const AddTransactions({Key? key}) : super(key: key);

  @override
  State<AddTransactions> createState() => _AddTransactionsState();
}

class _AddTransactionsState extends State<AddTransactions> {
  @override
  void initState() {
    super.initState();
    incomeCategoryAdder();
    expenseCategoryAdder();
  }

  double? amount;
  String note = "None";
  String type = "Income";
  DateTime selectedDate = DateTime.now();
  String? temp;
  String? category;
  String selectedCategory = 'Unspecified';
  CategoryBox categoryBox = CategoryBox();
  List<DropdownMenuItem<String>> incomeCat = [];
  List<DropdownMenuItem<String>> expenseCat = [];

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
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
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
              'Add a new Transaction',
              textAlign: TextAlign.justify,
              style: TextStyle( fontWeight: FontWeight.w500),
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
                    color: type == 'Income' ? Colors.green : Colors.red,
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
                onChanged: (value) {
                  try {
                    amount = double.parse(value);
                  } catch (e) {
                    const Text("only numbers permitted");
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Put The Amount', border: InputBorder.none),
                
              ),
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
                decoration: const InputDecoration(
                    hintText: 'Short Note', border: InputBorder.none),
               
                onChanged: (value) {
                  note = value;
                },
              ),
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
                    color: const Color.fromARGB(255, 226, 6, 116),
                    borderRadius: BorderRadius.circular(16.0)),
                child: const Icon(
                  Icons.moving_sharp,
                  size: 24.0,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 15,
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
                    temp = null;
                    type = 'Income';
                    selectedCategory = 'Unspecified';
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
                    temp = null;
                    selectedCategory = 'Unspecified';
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
      
        ),
        Container(
          padding: const EdgeInsets.only(top: 15),
          child: DropdownButton(
            menuMaxHeight: 200,
            items: type == 'Income' ? incomeCat : expenseCat,
            hint: (Text(
              temp == null ? 'No Category Selected' : selectedCategory,
             
            )),
            onChanged: (String? value) {
              setState(() {
                temp = value!;
                selectedCategory = value;
              });
            },
            isExpanded: true,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Category Not Listed?',
          style: TextStyle(
              
              color: type == 'Income' ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 15,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                                  category = null;
                                });
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
              label: Text("Add an $type Category"))
        ]),
        const SizedBox(
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
          height: 45,
        ),
        SizedBox(
            height: 50,
            child: FloatingActionButton.extended(
              label: const Text("Add Data"),
        
              backgroundColor: (type == 'Income' ? Colors.green : Colors.red),
              onPressed: () async {
                if (amount != null &&
                    amount! > 0.0 &&
                    note.isNotEmpty &&
                    selectedCategory != 'Unspecified') {
                  Dbhelper dbhelper = Dbhelper();
                  dbhelper.addData(
                      amount: amount!,
                      date: selectedDate,
                      note: note,
                      type: type,
                      category: selectedCategory);
                  await NotificationApi().getTotalBalance();
                  if (NotificationApi.balance < 0) {
                    await NotificationApi.showNotification(
                        body:
                            'Click here to Add an Income item',
                        payload: 'Data');
                  }
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 1),
                      margin: EdgeInsets.all(15),
                      backgroundColor: Colors.red,
                      content: Text('All fields are required',
                       
                          textAlign: TextAlign.center)));
                }
              },
            ))
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
      incomeCat.sort((a, b) => a.value!.toLowerCase().compareTo(b.value!.toLowerCase()),);
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
            style: const TextStyle(fontWeight: FontWeight.bold, ),
          ));
      dropDown.add(item);
    }
    setState(() {
      expenseCat.addAll(defaultExpenseCategory);
      expenseCat.addAll(dropDown);
      expenseCat.sort((a, b) => a.value!.toLowerCase().compareTo(b.value!.toLowerCase()),);
    });
  }
}
