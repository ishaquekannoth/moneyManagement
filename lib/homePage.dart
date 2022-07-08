import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moneymanager/addTransactions.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/editScreen.dart';
import 'package:moneymanager/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'static.dart' as customcolor;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _notifications = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    NotificationApi.init(context);
    super.initState();
  }

  late SharedPreferences pref;
  List tempList = [];
  Dbhelper dbhelper = Dbhelper();
  double totalBalance = 0;
  double totalExpence = 0;
  double totalIncome = 0;
  getTotalBalance(Map data) {
    totalBalance = 0;
    totalExpence = 0;
    totalIncome = 0;
    data.forEach((key, value) {
      if (value['type'] == 'Income') {
        totalBalance += value['amount'] as double;
        totalIncome += value['amount'] as double;
      } else {
        totalBalance -= value['amount'] as double;
        totalExpence += value['amount'] as double;
      }
    });
  }

  Future<Map> getRawMap() async {
    Map unsorted = await dbhelper.fetchAllData();
    LinkedHashMap sortMapByValue = LinkedHashMap.fromEntries(
        unsorted.entries.toList()
          ..sort((e1, e2) => e2.value['date'].compareTo(e1.value['date'])));
    List myList = [];
    sortMapByValue.forEach((key, value) => myList.add(value));
    tempList.clear();
    tempList.addAll(myList);
    pref = await SharedPreferences.getInstance();
    setState(() {});
    return (sortMapByValue);
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 15,
        backgroundColor: Colors.red,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => AddTransactions())))
            .whenComplete(() async {
          getTotalBalance(await getRawMap());
          setState(() {});
        }),
        label: Text("ADD"),
      ),
      body: FutureBuilder<Map>(
          future: getRawMap(),
          builder: (context, snapshot) {
            if (snapshot.error != null) {
              return (Center(
                child: Text('Fatal Err,Couldnt Connect to DB'),
              ));
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Image.asset('Assets/images/empty.gif'),
                      SizedBox(
                        height: 45,
                      ),
                      Container(
                        width: 350.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          //color: Colors.blue.shade200
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Hei ${pref.getString('UserName')} ,Nothing in here yet..',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Arial',
                                  fontSize: 25,
                                  color: Colors.black,
                                  height: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Click the add button to get started',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Arial',
                                  fontSize: 25,
                                  color: Colors.black,
                                  height: 1,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              getTotalBalance(snapshot.data!);
              return (ListView(children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.asset(
                              "Assets/images/face.jpeg",
                              fit: BoxFit.contain,
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                        Text(
                          ('Hello ${pref.getString('UserName').toString()}'),
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.all(12.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.print_outlined,
                                color: Colors.red,
                                size: 32,
                              ),
                              onPressed: () async {
                                await dbhelper.printKeys();
                                setState(() {});
                              },
                            )),
                      ]),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 10, right: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: const [
                          customcolor.primaryColor,
                          Colors.blueAccent
                        ]),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    padding: EdgeInsets.symmetric(
                      vertical: 30,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'You have got',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 250.0,
                          height: 42.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              color: Color.fromARGB(255, 9, 4, 58)),
                          child: Center(
                            child: Text(
                              '$totalBalance AED',
                              style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 22,
                                  color: Colors.white,
                                  height: 1,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            cardIncome('$totalIncome AED'),
                            cardExpense('$totalExpence AED')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                    padding: EdgeInsets.all(1),
                    child: Text(
                      "Recent Transactions",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        snapshot.data!.length < 4 ? snapshot.data!.length : 4,
                    itemBuilder: (context, index) {
                      if (tempList[index]['type'] == 'Expense') {
                        return expenseTile(
                            tempList[index]['amount'],
                            tempList[index]['note'],
                            tempList[index]['date'],
                            tempList[index]['id'],
                            tempList[index]['type'],
                            tempList[index]['category']);
                      } else {
                        return incomeTile(
                            tempList[index]['amount'],
                            tempList[index]['note'],
                            tempList[index]['date'],
                            tempList[index]['id'],
                            tempList[index]['type'],
                            tempList[index]['category']);
                      }
                    }),
              ]));
            } else {
              return (Center(
                child: Text('End Of list'),
              ));
            }
          }),
    ));
  }

  Widget cardIncome(String value) {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Container(
        //   padding: EdgeInsets.all(15),
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(30), color: Colors.white),
        //   margin: EdgeInsets.only(right: 10),
        //   child: Icon(
        //     Icons.arrow_downward,
        //     color: Colors.blue,
        //   ),
        // ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '          Total Income',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            // Text(
            //   value,
            //   style: TextStyle(
            //       fontSize: 20,
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold),
            // ),
            Container(
              width: 175.0,
              height: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.amberAccent),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 18,
                    color: Colors.black,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        )
      ],
    ));
  }

  Widget cardExpense(String value) {
    return (Row(
      children: [
        // Container(
        //   padding: EdgeInsets.all(15),
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(30), color: Colors.white),
        //   margin: EdgeInsets.only(right: 10),
        //   child: Icon(
        //     Icons.arrow_upward,
        //     color: Color.fromARGB(255, 216, 11, 11),
        //   ),
        // ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '          Total Expense',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 175.0,
              height: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.amberAccent),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 18,
                    color: Colors.black,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }

  Widget expenseTile(double value, String note, DateTime dateTime, int id,
      String type, String category) {
    Dbhelper help = Dbhelper();
    return Card(
      child: GestureDetector(
        onTap: () {
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
                          help.removeSingleItem(id);
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"))
                  ],
                ));
              });
        },
        child: (Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
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
                  Text(
                      '${dateTime.day}/${dateTime.month}/${(dateTime.year) % 100}',
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
      ),
    );
  }

  Widget incomeTile(double value, String note, DateTime dateTime, int id,
      String type, String category) {
    Dbhelper help = Dbhelper();
    return Card(
      child: GestureDetector(
        onTap: () {
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
                          help.removeSingleItem(id);
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"))
                  ],
                ));
              });
        },
        child: (Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
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
                  Text(
                      '${dateTime.day}/${dateTime.month}/${(dateTime.year) % 100}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}
