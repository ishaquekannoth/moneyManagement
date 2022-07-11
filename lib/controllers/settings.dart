import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
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
          text: const TextSpan(
            text: 'S',
            style: TextStyle(
              fontSize: 23,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
            children: [
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
                  leading: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                  title: const Text('Reset Everything'),
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (context) {
                          return (AlertDialog(
                            title: const Text('Are you sure to Reset the App?'),
                            actions: [ ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.cancel ),
                                  label: const Text('Cancel')),
                                  
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    db.resetData();
                                    cat.clearCategoryBox();
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    await pref.clear();
                                     Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const SplashScreen()),
                        (route) => false);
                                  },
                                  icon: const Icon(Icons.delete_forever_outlined),
                                  label: const Text('Confirm')),
                             
                            ],
                          ));
                        });
                  }),
            ),
            const Divider(
              thickness: 1,
            ),
            const ListTile(
              leading: Text('communicate'),
            ),
            const ListTile(
              leading: Icon(
                Icons.mail_outline,
                color: Colors.red,
              ),
              title: Text('Contact us'),
            ),
            const ListTile(
              leading: Icon(
                Icons.feedback_outlined,
                color: Colors.red,
              ),
              title: Text('Feedback'),
            ),
            const Divider(
              thickness: 1,
            ),
            const ListTile(
              leading: Text('Info'),
            ),
            const ListTile(
              leading: Icon(
                Icons.privacy_tip_outlined,
                color: Colors.red,
              ),
              title: Text('Privacy policy'),
            ),
            const ListTile(
              leading: Icon(
                Icons.share_outlined,
                color: Colors.red,
              ),
              title: Text('Share'),
            ),
            const ListTile(
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
