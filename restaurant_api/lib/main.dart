import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_api/data/model/restaurant_list.dart';
import 'package:restaurant_api/ui/detail_page.dart';
import 'package:restaurant_api/ui/favorite_page.dart';
import 'package:restaurant_api/ui/home_page.dart';
import 'package:restaurant_api/ui/search_page.dart';
import 'package:restaurant_api/utils/background_service.dart';
import 'package:restaurant_api/utils/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final BackgroundService backgroundService = BackgroundService();
  backgroundService.initializeIsolate();
  AndroidAlarmManager.initialize();

  final NotificationHelper notificationHelper = NotificationHelper();
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  notificationHelper.requestIOSPermissions(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Restaurant App",
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
            id: ModalRoute.of(context)?.settings.arguments as String),
        SearchRestaurantPage.routeName : (context) => SearchRestaurantPage(),
        FavoriteRestaurantPage.routeName: (context) => FavoriteRestaurantPage(
            restaurant: ModalRoute.of(context)?.settings.arguments as List<Restaurant>)
      },
    );
  }
}
