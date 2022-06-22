import 'package:flutter/material.dart';
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
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 65,),
                    Text('About Us', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                    
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
                    
                    children: const [
                      Icon(Icons.restart_alt_outlined),
                       SizedBox(width: 65,),
                      Text('Reset the App', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                      
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
                    children: const [
                      Icon(Icons.share ),
                       SizedBox(width: 65,),
                      Text('Share with friends', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                      
                    ]),
              )
            ],
          )),
    ));
  }
}
