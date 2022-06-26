import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';

class SettingsMenu extends StatelessWidget {
  SettingsMenu({Key? key}) : super(key: key);
  Dbhelper db = Dbhelper();
  CategoryBox cat = CategoryBox();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        title: RichText(
          text: TextSpan(
            text: 'S',
            style: TextStyle(
              fontSize: 23,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
            children: const [
              TextSpan(
                  text: 'ettings',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            GestureDetector(
              child: ListTile(
                  leading: Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                  title: Text('Reset Everything'),
                  onTap: () async {
                    db.resetData();
                    cat.clearCategoryBox();
                    //Navigator.of(context).pop();
                  }),
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              leading: Text('communicate'),
            ),
            ListTile(
              leading: Icon(
                Icons.mail_outline,
                color: Colors.red,
              ),
              title: Text('Contact us'),
            ),
            ListTile(
              leading: Icon(
                Icons.feedback_outlined,
                color: Colors.red,
              ),
              title: Text('Feedback'),
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              leading: Text('Info'),
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip_outlined,
                color: Colors.red,
              ),
              title: Text('Privacy policy'),
            ),
            ListTile(
              leading: Icon(
                Icons.share_outlined,
                color: Colors.red,
              ),
              title: Text('Share'),
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Colors.red,
              ),
              title: Text('About'),
            ),
          ],
        ),
      ),
    );
  }
}
