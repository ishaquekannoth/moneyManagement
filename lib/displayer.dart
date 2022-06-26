import 'package:flutter/material.dart';
import 'package:moneymanager/analysis.dart';
import 'package:moneymanager/controllers/settings.dart';
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
  List<Widget> pages = [HomePage(), ViewAllTransactions(),Analysis(),SettingsMenu()];
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      bottomNavigationBar: BottomNavigationBar(
       selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        selectedFontSize:15,
        iconSize: 35,
        selectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,size: 25,), label: 'Home',),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'History',),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart_rounded   ), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Settings'),
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
