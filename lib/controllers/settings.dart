
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/notifications.dart';
import 'package:moneymanager/splash.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({Key? key}) : super(key: key);
  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  @override
  void initState() {
    setSwitchValue();
    super.initState();
  }

  setSwitchValue() async {
    if (NotificationApi.pref.getBool('isOn') == null) {
      NotificationApi.pref.setBool('isOn', false);
      isSwitchOn = false;
    } else {
      setState(() {
        isSwitchOn = NotificationApi.pref.getBool('isOn')!;
      });
    }
  }

  Dbhelper db = Dbhelper();
  static late bool isSwitchOn;
  CategoryBox cat = CategoryBox();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        isSwitchOn = true;
      });
      await NotificationApi.showScheduledNotification(
          time: Time(picked.hour, picked.minute));

      DateTime tempDate = DateFormat("hh:mm")
          .parse("${selectedTime.hour}:${selectedTime.minute}");
      var dateFormat = DateFormat("h:mm a");

      NotificationApi.pref.setBool('isOn', isSwitchOn);
       if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(15),
          backgroundColor: const Color.fromARGB(255, 16, 141, 58),
          content: Text('Reminder Set at  ${dateFormat.format(tempDate)}',
              textAlign: TextAlign.center)));
    } else {
      NotificationApi.cancelDailyotification(1);
      setState(() {
        isSwitchOn = false;
      });
      NotificationApi.pref.setBool('isOn', isSwitchOn);
    }
  }

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
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                  text: 'ettings',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700)),
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
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return (AlertDialog(
                            title: const Text('Are you sure to Reset the App?'),
                            actions: [
                              ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Cancel')),
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    db.resetData();
                                    cat.clearCategoryBox();
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    await pref.clear();
                                        if (!mounted) return;
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SplashScreen()),
                                        (route) => false);
                                  },
                                  icon:
                                      const Icon(Icons.delete_forever_outlined),
                                  label: const Text('Confirm')),
                            ],
                          ));
                        });
                  }),
            ),
            ListTile(
              leading: const Icon(
                Icons.alarm,
                color: Colors.red,
              ),
              title: const Text('Set a Reminder'),
              trailing: Switch(
                  value: isSwitchOn,
                  onChanged: (value) async {
                    {
                      if (value == true) {
                        await selectTime(context);
                      } else {
                        setState(() {
                          isSwitchOn = false;
                          NotificationApi.cancelDailyotification(1);
                          NotificationApi.pref.setBool('isOn', false);
                        });
                      }
                    }
                  }),
            ),
            const Divider(
              thickness: 1,
            ),
            const ListTile(
              leading: Text('communicate'),
            ),
            ListTile(
              leading: const Icon(
                Icons.mail_outline,
                color: Colors.red,
              ),
              title: const Text('Contact Me'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return (AlertDialog(
                        actions: [
                          TextButton(
                              onPressed: (() => Navigator.of(context).pop()),
                              child: const Text("OK"))
                        ],
                        title: const Text('Contact Me'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: const [
                                Text(
                                'Devoloped by',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Ishaque Muhammed kannoth',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                               Text('Email',style: TextStyle(fontWeight: FontWeight.bold),),
                              Text('ishaque.kannoth@gmail.com'),
                              Divider(
                                thickness: 1,
                              ),
                              Text('Github',style: TextStyle(fontWeight: FontWeight.bold),),
                              Text('https://github.com/ishaquekannoth'),
                              Divider(
                                thickness: 1,
                              ),
                              Text('Phone/Whatsapp',style: TextStyle(fontWeight: FontWeight.bold),),
                              Text('+91-9747344535'),
                              Divider(
                                thickness: 1,
                              ),
                              Text('\nSpecial thanks to Shees&Rabeeh'),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          ),
                        ),
                      ));
                    });
              },
            ),
            const Divider(
              thickness: 1,
            ),
            const ListTile(
              leading: Text('Info'),
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: Colors.red,
              ),
              title: const Text('About the App'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return (AlertDialog(
                        actions: [
                          TextButton(
                              onPressed: (() => Navigator.of(context).pop()),
                              child: const Text("OK"))
                        ],
                        title: const Text('About the App'),
                        content: const SingleChildScrollView(
                            child: Text(
                                'This Application has been devoloped for keeping your day today expenses and incomes on track.Though I have made a lot of efforts to make the app bug free,its still a lot likely to be filled with bugs since it has not been specifically gone through any testing phase..Please click on the Contact me button to report a bug or suggest your valuable opinions and suggestions...')),
                      ));
                    });
              },
            ),
            const Divider(
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.share,
                color: Colors.red,
              ),
              title: const Text('Share with Friends'),
              onTap: () async {
                Share.share(
                    'https://play.google.com/store/apps/details?id=com.fouvty.MoneyIsh');
              },
            ),
          ],
        ),
      ),
    );
  }
}
