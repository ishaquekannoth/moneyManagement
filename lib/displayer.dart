import 'package:flutter/material.dart';
import 'package:moneymanager/analysis.dart';
import 'package:moneymanager/homePage.dart';
import 'package:moneymanager/test.dart';
import 'package:moneymanager/viewAllTransactions.dart';

class MainDisplay extends StatefulWidget {
  const MainDisplay({Key? key}) : super(key: key);

  @override
  State<MainDisplay> createState() => _MainDisplayState();
}

class _MainDisplayState extends State<MainDisplay> {
  int _selectedIndex = 0;
  List<Widget> pages = [HomePage(), ViewAllTransactions(),Analysis()];
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,size: 25,), label: 'Home',),
          BottomNavigationBarItem(
              icon: Icon(Icons.note_add_sharp), label: 'All Transactions',),
          BottomNavigationBarItem(icon: Icon(Icons.pages), label: 'Reports'),
        ],
        onTap: (ind) {
          setState(() {
            _selectedIndex = ind;
          });
        },
      ),
      body:pages[_selectedIndex]
    )
    
    );
  }
}
