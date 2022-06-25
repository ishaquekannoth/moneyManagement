import 'dart:core';
import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/editScreen.dart';

class ViewAllTransactions extends StatefulWidget {
  const ViewAllTransactions({Key? key}) : super(key: key);

  @override
  State<ViewAllTransactions> createState() => _ViewAllTransactionsState();
}

class _ViewAllTransactionsState extends State<ViewAllTransactions> {
  Dbhelper helper = Dbhelper();
  CategoryBox category = CategoryBox();
  List myList = [];
  @override
  Widget build(BuildContext context) {
    getRawMap();
    return (Scaffold(
        appBar: AppBar(
          title: Text('All Transactions'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //await category.clearCategoryBox();
            await category.printCategoryValues();
            // print(await category.fetchAllCategories());
          },
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: myList.length,
            itemBuilder: (context, index) {
              if (myList[index]['type'] == 'Expense') {
                return (ListTile(
                    title: expenseTile(
                        myList[index]['amount'],
                        myList[index]['note'],
                        myList[index]['date'],
                        myList[index]['id'],
                        myList[index]['category'],
                        myList[index]['type'],
                        helper,context)));
              } else {
                return (ListTile(
                  title: incomeTile(
                      myList[index]['amount'],
                      myList[index]['note'],
                      myList[index]['date'],
                      myList[index]['id'],
                      myList[index]['category'],
                      myList[index]['type'],
                      helper,context),
                ));
              }
            })));
  }

  Future<void> getRawMap() async {
    Map unsorted = await helper.fetchAllData();
    var sortMapByValue = Map.fromEntries(unsorted.entries.toList()
      ..sort((e1, e2) => e2.value['date'].compareTo(e1.value['date'])));
    //print(sortMapByValue);
    List sortedList = [];
    sortMapByValue.forEach((key, value) => sortedList.add(value));
    myList.clear();
    myList.addAll(sortedList);
    setState(() {});
  }
}

Widget expenseTile(
    int value, String note, DateTime dateTime, int id,String category,String type,Dbhelper dataBase,BuildContext context) {
  return GestureDetector(
    onTap: () {
      print('You clicked an Expense item ID is');
      print(id);
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>(EditScreen(value: value,note: note,dateTime: dateTime,id: id,type: type,category: category))));
    },
    onLongPress: (){
    //  dataBase.removeSingleItem(id);
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
                        dataBase.removeSingleItem(id);
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"))
                ],
              ));
            });
    },
    child: (Container(
      // padding: EdgeInsets.all(15),
      // margin: EdgeInsets.all(10),
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
    )),
  );
}

Widget incomeTile(
    int value, String note, DateTime dateTime, int id,String category,String type, Dbhelper dataBase,BuildContext context) {
  return GestureDetector(
    onTap: () {
      print('You clicked an Income item.ID is');
      print(id);
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>(EditScreen(value: value,note: note,dateTime: dateTime,id: id,category: category,type: type,))));
    },
    onLongPress: (){
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
                        dataBase.removeSingleItem(id);
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"))
                ],
              ));
            });
    },
    child: (Container(
      // padding: EdgeInsets.all(15),
      // margin: EdgeInsets.all(10),
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
    )),
  );
}
