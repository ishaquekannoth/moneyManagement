import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:moneymanager/addTransactions.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'static.dart' as customcolor;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List tempList = [];
  Dbhelper dbhelper = Dbhelper();
  int totalBalance = 0;
  int totalExpence = 0;
  int totalIncome = 0;
  getTotalBalance(Map data) {
    totalBalance = 0;
    totalExpence = 0;
    totalIncome = 0;
    data.forEach((key, value) {
      if (value['type'] == 'Income') {
        totalBalance += value['amount'] as int;
        totalIncome += value['amount'] as int;
      } else {
        totalBalance -= value['amount'] as int;
        totalExpence += value['amount'] as int;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 2, 58, 5),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => AddTransactions())))
            .whenComplete(() {
          setState(() {});
        }),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Icon(
          Icons.add,
          size: 32.0,
        ),
      ),
      body: FutureBuilder<Map>(
          future: sortedMap(),
          builder: (context, snapshot) {
            if (snapshot.error != null) {
              return (Center(
                child: Text('unExpected Err'),
              ));
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text('OOps..No Data found..did you reset the data Recently?',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
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
                              width: 50,height: 50,
                            ),
                          ),
                        ),
                        Text(
                          "Hello User",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: customcolor.PrimaryColor),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.all(12.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.settings,
                                color: Colors.green,
                                size: 32,
                              ),
                              onPressed: () {
                                setState(() {});
                              },
                            )),
                      ]),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(left: 10, right: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: const [
                          customcolor.PrimaryColor,
                          Colors.blueAccent
                        ]),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    padding: EdgeInsets.symmetric(
                      vertical: 30,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total Balance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Text(
                          '$totalBalance AED',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cardIncome('$totalIncome AED'),
                              cardExpense('$totalExpence AED')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                    padding: EdgeInsets.all(1),
                    child: Text(
                      "Recent Transactions",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        snapshot.data!.length < 4 ? snapshot.data!.length : 4,
                    itemBuilder: (context, index) {
                      Map data = snapshot.data![index];

                      if (tempList[index]['type'] == 'Expense') {
                        return expenseTile(tempList[index]['amount'],
                            tempList[index]['note'], tempList[index]['date']);
                      } else {
                        return incomeTile(tempList[index]['amount'],
                            tempList[index]['note'], tempList[index]['date']);
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
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: Colors.white),
          margin: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.arrow_downward,
            color: Colors.green,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    ));
  }

  Widget cardExpense(String value) {
    return (Row(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: Colors.white),
          margin: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.arrow_upward,
            color: Color.fromARGB(255, 216, 11, 11),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    ));
  }

  Widget expenseTile(int value, String note, DateTime dateTime) {
    return (Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 218, 226, 226)),
      child: Column(
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
              Text('$value AED',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 170, 20, 9),
                      fontWeight: FontWeight.bold)),
              Text('${dateTime.day}/${dateTime.month}/${dateTime.year}',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    ));
  }

  Widget incomeTile(int value, String note, DateTime dateTime) {
    return (Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 218, 226, 226)),
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
              Text('$value AED',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 4, 112, 8),
                      fontWeight: FontWeight.bold)),
              Text('${dateTime.day}/${dateTime.month}/${dateTime.year}',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    ));
  }

  Future<Map> sortedMap() async {
    Map unsorted = await dbhelper.fetchData();
    LinkedHashMap sortMapByValue = LinkedHashMap.fromEntries(
        unsorted.entries.toList()
          ..sort((e1, e2) => e2.value['date'].compareTo(e1.value['date'])));
    List myList = [];
    sortMapByValue.forEach((key, value) => myList.add(value));
    tempList.clear();
    tempList.addAll(myList);
      setState(() {
      });
    return (sortMapByValue);
  }
}
