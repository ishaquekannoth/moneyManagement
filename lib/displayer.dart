import 'dart:math';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/viewAllTransactions.dart';
import 'package:moneymanager/controllers/settings.dart';
import 'package:moneymanager/homePage.dart';
import 'package:moneymanager/reportsAndChart.dart';

class MainDisplay extends StatefulWidget {
  const MainDisplay({Key? key}) : super(key: key);

  @override
  State<MainDisplay> createState() => _MainDisplayState();
}

class _MainDisplayState extends State<MainDisplay> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    const HomePage(),
    const ViewAllTransactions(),
    const Reports(),
    const SettingsMenu()
  ];
  @override
  Widget build(BuildContext context) {
    
    return (Scaffold(
      backgroundColor: Colors.white,
       bottomNavigationBar:
     CurvedNavigationBar(
          height: 60,
    backgroundColor:  Colors.primaries[Random().nextInt(Colors.primaries.length)],
    buttonBackgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
    animationCurve: Curves.easeInOutQuad,
    items:  <Widget>[
      Icon(Icons.home,size: 30,color:_selectedIndex==0?Colors.white:Colors.black,),
      Icon(Icons.history,size: 30,color:_selectedIndex==1?Colors.white:Colors.black,),
      Icon(Icons.pie_chart, size: 30,color:_selectedIndex==2?Colors.white:Colors.black,),
      Icon(Icons.settings,size: 30,color:_selectedIndex==3?Colors.white:Colors.black,),
    ],
    onTap: (ind) {
            setState(() {
              _selectedIndex = ind;
            });
          }
  ),

        body: pages[_selectedIndex]));
  }
}
