import 'package:flutter/material.dart';
import 'package:moneymanager/homePage.dart';
import 'package:moneymanager/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      theme:myTheme,
      home: const HomePage(),
    );
  }
}

