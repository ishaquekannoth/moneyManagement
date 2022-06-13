import 'package:flutter/material.dart';
import 'package:moneymanager/addTransactions.dart';
import 'static.dart' as customcolor;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return(
      Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: customcolor.PrimaryColor,
        onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder:((context) => AddTransactions()))),
         child: Icon(Icons.add,size: 32.0,),
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(16.0)),),
         )
    );
  }
}