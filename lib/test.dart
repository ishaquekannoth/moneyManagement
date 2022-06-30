
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/db_helper.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  Dbhelper helper = Dbhelper();
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(title: Text('Using FutureBuilder'),centerTitle: true,),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getRawMap(),
      ),
      body: FutureBuilder<List>(
          future: getRawMap(),
          builder: (context, snapshot) {
            if (snapshot.error != null) {
              return (Center(
                child: Text('unExpected Err'),
              ));
            }

            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Text('NO Value in the SortedMap');
              }
            }
            return (ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, item) {
                  List?  MySortedMap = snapshot.data;
                  if (MySortedMap![item]['type'] == 'Expense') {
                    // return (Text(MySortedMap![item]['date'].toString()));
                    return expenseTile(MySortedMap[item]['amount'],
                        MySortedMap[item]['note'], MySortedMap[item]['date']);
                  }
                  else{
                        return 
                        incomeTile(MySortedMap[item]['amount'],
                        MySortedMap[item]['note'], MySortedMap[item]['date']);

                  }

                }));
          }),
    ));
  }

  Future<List> getRawMap() async {
    Map unsorted = await helper.fetchAllData();
    var sortMapByValue = Map.fromEntries(unsorted.entries.toList()
      ..sort((e1, e2) => e2.value['date'].compareTo(e1.value['date'])));
    //print(sortMapByValue);
    List myList = [];
    sortMapByValue.forEach((key, value) => myList.add(value));
  
    return myList;
    //return sortMapByValue;
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
}