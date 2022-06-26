import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneymanager/displayer.dart';
import 'package:moneymanager/homePage.dart';
import 'package:moneymanager/theme.dart';
import 'package:hive/hive.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('money');
  await Hive.openBox('category');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
       theme: myTheme,
      home: const MainDisplay(),
    );
  }
}
