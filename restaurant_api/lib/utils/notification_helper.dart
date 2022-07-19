import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_api/data/model/restaurant_list.dart';
import 'package:restaurant_api/data/model/restaurant_detail.dart';
import 'package:restaurant_api/utils/receive_notification.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

final selectNotificationSubject = BehaviorSubject<String?>();
final didReceiveLocalNotificationSubject = BehaviorSubject<ReceiveNotification>();
final List<String> restoList = [
  "rqdv5juczeskfw1e867", "s1knt6za9kkfw1e867",
  "w9pga3s2tubkfw1e867", "uewq1zg2zlskfw1e867",
  "ygewwl55ktckfw1e867", "fnfn8mytkpmkfw1e867",
  "dwg2wt3is19kfw1e867", "6u9lf7okjh9kfw1e867",
  "zvf11c0sukfw1e867", "ughslf146iqkfw1e867",
  "w7jca3irwykfw1e867", "8maika7giinkfw1e867",
  "e1elb86snf8kfw1e867", "69ahsy71a5gkfw1e867",
  "ateyf7m737ekfw1e867", "02hfwn4bh8uzkfw1e867",
  "p06p0wr8eedkfw1e867", "uqzwm2m981kfw1e867",
  "dy62fuwe6w8kfw1e867", "vfsqv0t48jkfw1e867"
];

class NotificationHelper {
  static const _channelId = '01';
  static const _channelName = "new resto";
  static const _channelDesc = "Notifikasi untuk menujukkan new resto";
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
      ) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
      (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationSubject.add(ReceiveNotification(
            id: id, title: title, body: body, payload: payload
        ));
      });

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          print('notification payload : $payload');
        }
        selectNotificationSubject.add(payload ?? 'empty payload');
      });
  }

  void requestIOSPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
      ) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation
        <IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true
    );
  }

  void configureDidReceiveLocalNotificationSubject(
      BuildContext context, String route
      ) {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceiveNotification receiveNotification) async {
          await showDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: receiveNotification.title != null
                    ? Text(receiveNotification.title!)
                    : null,
                content: receiveNotification.body != null
                  ? Text(receiveNotification.body!)
                    : null,
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text('ok'),
                    onPressed: () async {
                      Navigator.of(context, rootNavigator: true).pop();
                      await Navigator.pushNamed(context, route, arguments: receiveNotification);
                      // receiveNotification need to be change because of restaurant detail need id not that one
                    },
                  )
                ]
              )
          );
    });
  }

  void configureSelectNotificationSubject(BuildContext context, String route) {
    selectNotificationSubject.stream.listen((String? payload) async {
      await Navigator.pushNamed(context, route,
          arguments: payload);
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
      ) async {

    // get resto detail
    const String baseUrl = 'https://restaurant-api.dicoding.dev/';
    final response = await http.get(Uri.parse('${baseUrl}detail/${restoList[_getRandomNumber()]}'));
    RestaurantDetail restaurantDetail = RestaurantDetail.fromJson(jsonDecode(response.body));

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        _channelId, _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      restaurantDetail.restaurant.name,
      'Lokasi ${restaurantDetail.restaurant.city}',
      platformChannelSpecifics,
      payload: restaurantDetail.restaurant.id,
    );
  }

  Future<void> scheduleNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
      ) async {

    // get resto detail
    const String baseUrl = 'https://restaurant-api.dicoding.dev/';
    final response = await http.get(Uri.parse('${baseUrl}detail/${restoList[_getRandomNumber()]}'));
    RestaurantDetail restaurantDetail = RestaurantDetail.fromJson(jsonDecode(response.body));

    // temp. this should be here as a helper in case i missed something about date
    // tz.initializeTimeZones();
    // var dateTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));
    // print('Date type format $dateTime');
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName,
      channelDescription: _channelDesc,
      icon: 'app_icon',
      // largeIcon:
      vibrationPattern: vibrationPattern,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500
    );
    var iOSPlatformSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformSpecifics
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      restaurantDetail.restaurant.name, //'tes',//
      restaurantDetail.restaurant.city, //'tes',//
      _nextDate(),
      platformChannelSpecifics,
      payload: restaurantDetail.restaurant.id, // 'tes',//
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  tz.TZDateTime _nextDate() {
    tz.initializeTimeZones();
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, 11 // 11 means at 5 pm
    );

    if (scheduleDate.isBefore(now)) {
      scheduleDate.add(const Duration(days: 1));
    }

    return scheduleDate;
  }

  int _getRandomNumber() {
    Random random = Random();
    return random.nextInt(20);
  }
}