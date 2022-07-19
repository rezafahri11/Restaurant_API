import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_api/utils/background_service.dart';
import 'package:restaurant_api/utils/datetime_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledRestaurants(bool value) async {
    _isScheduled = value;
    if(_isScheduled) {
      print('Pengingat Dinyalakan');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        0,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true
      );
    } else {
      print('Pengingat Dimatikan');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}