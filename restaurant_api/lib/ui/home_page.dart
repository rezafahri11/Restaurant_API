import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/data/api/api_service.dart';
import 'package:restaurant_api/provider/scheduling_provider.dart';
import 'package:restaurant_api/ui/detail_page.dart';
import 'package:restaurant_api/ui/list_page.dart';
import 'package:restaurant_api/ui/settings_page.dart';
import 'package:restaurant_api/utils/background_service.dart';
import 'package:restaurant_api/utils/notification_helper.dart';

import '../provider/list_provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final BackgroundService _backgroundService = BackgroundService();
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    port.listen((message) async {
      await _backgroundService.someTask();
    });
    _notificationHelper.configureSelectNotificationSubject(context, RestaurantDetailPage.routeName); // this page need `id` as parameter
    _notificationHelper.configureDidReceiveLocalNotificationSubject(context, RestaurantDetailPage.routeName); // of course this too
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    didReceiveLocalNotificationSubject.close();
    super.dispose();
  }

  // bottom navigation bar
  int _bottomNavIndex = 0;
  static const String _headline = 'Restaurants';
  static const String _settings = 'Settings';

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.restaurant),
      label: _headline
    ),
    const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
      label: _settings
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomNavIndex == 0
      ? ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(apiService: ApiService()),
          child: RestaurantListPage(),
          )
      : ChangeNotifierProvider<SchedulingProvider>(
          create: (_) => SchedulingProvider(),
          child: SettingsPage(),
          ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,),
    );
  }
}
