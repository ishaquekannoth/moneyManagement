import 'dart:collection';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/db_helper.dart';

class ViewAllTransactions extends StatefulWidget {
  const ViewAllTransactions({Key? key}) : super(key: key);

  @override
  State<ViewAllTransactions> createState() => _ViewAllTransactionsState();
}

class _ViewAllTransactionsState extends State<ViewAllTransactions> {
  Dbhelper helper = Dbhelper();
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(title: Text('All Transactions')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getRawMap(),
      ),
      
      body:
       FutureBuilder<List>(
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
                  List? MySortedMap = snapshot.data;
                  return (Text(MySortedMap![item]['date'].toString()));
                }));
          }),
    ));
  }

  Future<List> getRawMap() async {
    Map unsorted = await helper.fetchData();
    var sortMapByValue = Map.fromEntries(unsorted.entries.toList()
      ..sort((e1, e2) => e2.value['date'].compareTo(e1.value['date'])));
    //print(sortMapByValue);
    List myList = [];
    sortMapByValue.forEach((key, value) => myList.add(value));
    print(myList);
    return myList;
    //return sortMapByValue;
  }
}
