import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moneymanager/addTransactions.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/editScreen.dart';
import 'package:moneymanager/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'static.dart' as customcolor;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    NotificationApi.init(context);
    
    tz.initializeTimeZones();
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
    return SafeArea(
      child: (Scaffold(
        appBar: AppBar(toolbarHeight: 0.0),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          elevation: 15,
          backgroundColor: const Color.fromARGB(255, 206, 7, 7),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: ((context) => const AddTransactions())))
              .whenComplete(() async {
            getTotalBalance(await getRawMap());
            setState(() {});
          }),
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<Map>(
            future: getRawMap(),
            builder: (context, snapshot) {
              if (snapshot.error != null) {
                return (const Center(
                  child: Text('Fatal Err,Couldnt Connect to DB'),
                ));
              }
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: ListView(
                      children: [
                        Image.asset('Assets/images/empty.gif'),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 350.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Center(
                            child: ListView(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Hei ${pref.getString('UserName')},Nothing in here yet..',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Arial',
                                        color: Colors.black,
                                        height: 1,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Text(
                                      'Click the add button to get started',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Arial',
                                        color: Colors.black,
                                        height: 1,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
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
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 104, 42, 145)),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.all(12.0),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.print_outlined,
                                  color: Colors.red,
                                  size: 32,
                                ),
                                onPressed: () async {
                                 await NotificationApi.showScheduledNotification(time: const Time(13,59));        
                                },
                              )),
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 15),
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                            customcolor.primaryColor,
                            Colors.blueAccent
                          ]),
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'You have got',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 250.0,
                            height: 42.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                color: const Color.fromARGB(255, 9, 4, 58)),
                            child: Center(
                              child: Text(
                                '$totalBalance ${pref.getString('Currency')}',
                                style: const TextStyle(
                                    fontFamily: 'Arial',
                                    color: Colors.white,
                                    height: 1,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cardIncome(
                                  '$totalIncome ${pref.getString('Currency')}'),
                              cardExpense(
                                  '$totalExpence ${pref.getString('Currency')}')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "Recent Transactions",
                        textAlign: TextAlign.start,
                        style: TextStyle(),
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
                return (const Center(
                  child: Text('End Of list'),
                ));
              }
            }),
      )),
    );
  }

  Widget cardIncome(String value) {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              ' Total Income',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: 150.0,
              height: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.amberAccent),
              child: Center(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Arial',
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              ' Total Expense',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: 150.0,
              height: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.amberAccent),
              child: Center(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Arial',
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
    return Column(
      children: [
        (ListTile(
          minVerticalPadding: 2,
          dense: true,
          selectedColor: Colors.amber,
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
                    title: const Text('Confirm Delete?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            help.removeSingleItem(id);
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"))
                    ],
                  ));
                });
          },
          title: Text(category,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold)),
          leading: const CircleAvatar(
            radius: 30,
            backgroundColor: Color.fromARGB(255, 255, 1, 1),
            child: Icon(
              Icons.arrow_circle_up,
              color: Colors.white,
            ),
          ),
          trailing: Text('-$value ${pref.getString('Currency')}',
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 1, 1),
                  fontWeight: FontWeight.bold)),
          subtitle:
              Text('${dateTime.day}/${dateTime.month}/${(dateTime.year) % 100}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black87,
                  )),
        )),
      ],
    );
  }

  Widget incomeTile(double value, String note, DateTime dateTime, int id,
      String type, String category) {
    Dbhelper help = Dbhelper();
    return Column(
      children: [
        (ListTile(
          dense: true,
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
                    title: const Text('Confirm Delete?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            help.removeSingleItem(id);
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"))
                    ],
                  ));
                });
          },
          title: Text(category,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold)),
          leading: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.arrow_circle_down,
              color: Colors.white,
            ),
          ),
          trailing: Text('+$value ${pref.getString('Currency')}',
              style: const TextStyle(
                  color: Color.fromARGB(255, 4, 112, 8),
                  fontWeight: FontWeight.bold)),
          subtitle:
              Text('${dateTime.day}/${dateTime.month}/${(dateTime.year) % 100}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black87,
                  )),
        )),
      ],
    );
  }
}
