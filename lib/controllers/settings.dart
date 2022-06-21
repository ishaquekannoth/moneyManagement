import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';

class SettingsMenu extends StatelessWidget {
  SettingsMenu({Key? key}) : super(key: key);
  Dbhelper db = Dbhelper();
  CategoryBox cat = CategoryBox();

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text('Settings Menu'),
        centerTitle: true,
      ),
      body: Container(
           padding: EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  print('About Us Clicked');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text('About Us', style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold)),
                    Icon(Icons.person)
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  print('Reset button clicked');
                  db.resetData();
                  cat.clearCategoryBox();
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Reset the App', style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold)),
                      Icon(Icons.restart_alt_outlined)
                    ]),
              ),
                  SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  print('Reset button clicked');
                  // db.resetData();
                  // cat.clearCategoryBox();
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Share with friends', style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold)),
                      Icon(Icons.share )
                    ]),
              )
            ],
          )),
    ));
  }
}
