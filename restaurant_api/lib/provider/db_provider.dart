import 'package:flutter/material.dart';
import 'package:restaurant_api/data/database/db.dart';
import 'package:restaurant_api/data/model/restaurant_list.dart';

class DbProvider extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  late DatabaseHelper _dbHelper;

  List<Restaurant> get Restaurants => _restaurants;

  DbProvider() {
    _dbHelper = DatabaseHelper();
    _getAllRestaurants();
  }

  void _getAllRestaurants() async {
    _restaurants = await _dbHelper.getRestaurant();
    notifyListeners();
  }

  Future<void> addRestaurant(Restaurant restaurant) async {
    await _dbHelper.insertRestaurant(restaurant);
    _getAllRestaurants();
  }

  void deleteResto(String id) async {
    await _dbHelper.deleteRestaurant(id);
    _getAllRestaurants();
  }
}