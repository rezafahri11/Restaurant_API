import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_api/main.dart';

import 'notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
 static BackgroundService? _instance;
 static const String _isolateName = 'isolate';
 static SendPort? _uiSendPort;

 BackgroundService._internal() {
   _instance = this;
 }

 factory BackgroundService() => _instance ?? BackgroundService._internal();

 void initializeIsolate() {
   IsolateNameServer.registerPortWithName(
     port.sendPort,
     _isolateName
   );
 }

 static Future<void> callback() async {
   final NotificationHelper notificationHelper = NotificationHelper();
   notificationHelper.showNotification(flutterLocalNotificationsPlugin);
   print('Alarm fired!');
   _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
   _uiSendPort?.send(null);
 }

 Future<void> someTask() async {
  print('Updated data from the background isolate');
 }
}