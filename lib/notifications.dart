import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moneymanager/addTransactions.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/theme.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  NotificationApi() {
    getTotalBalance();
  }
  Dbhelper dbhelper = Dbhelper();
  static List myList = [];
  static double balance=0;
  static final _notifications = FlutterLocalNotificationsPlugin();
  static Future init(BuildContext context) async {
    var androidInitialise =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    final settings =
        InitializationSettings(android: androidInitialise, iOS: ios);
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AddTransactions();
        }));
      },
    );
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails("id", 'num',
            importance: Importance.max, showProgress: true, color: Colors.red),
        iOS: IOSNotificationDetails());
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    await NotificationApi().getTotalBalance();
    return _notifications.show(
      id,
      'Your Current balance is below Zero ($balance)',
      body,
      await _notificationDetails(),
    );
  }
  static Future showScheduledNotification(
      {int id = 0,
      String? title,
      String? body,
      var payload,
      required DateTime scheduleTime}) async {
    return _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleTime, tz.local),
      await _notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  getTotalBalance() async {
    Map unsorted = await dbhelper.fetchAllData();
    myList.clear();
    LinkedHashMap sortMapByValue = LinkedHashMap.fromEntries(
        unsorted.entries.toList()
          ..sort((e1, e2) => e2.value['date'].compareTo(e1.value['date'])));
    sortMapByValue.forEach((key, value) => myList.add(value));
    double totalBalance = 0;
    print(myList.length);
    for (var value in myList) {
      if (value['type'] == 'Income') {
        totalBalance += value['amount'] as double;
      } else {
        totalBalance -= value['amount'] as double;
      }
    }
    balance = totalBalance;
    print(balance);
  }
}
