import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restaurant_api/data/database/db.dart';
import 'package:restaurant_api/data/model/restaurant_list.dart';
import '../data/api/api_service.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  List<Restaurant> _restaurants = [];
  late DatabaseHelper _dbHelper;

  RestaurantProvider({required this.apiService}) {
    fetchAllRestaurant();

    _dbHelper = DatabaseHelper();
    _getAllRestaurants();
  }

  late RestaurantList _restaurantList;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  RestaurantList get result => _restaurantList;
  ResultState get state => _state;

  Future<dynamic> fetchAllRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurants();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantList = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Gagal Menampilkan List Restoran.';
    }
  }

  List<Restaurant> get Restaurants => _restaurants;

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

  getRestaurantById (String id) {
    return _restaurants.map((item) => item.id).contains(id);
  }
}