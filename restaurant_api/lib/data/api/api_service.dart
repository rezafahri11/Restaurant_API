import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:restaurant_api/data/model/restaurant_list.dart';
import 'package:restaurant_api/data/model/restaurant_search.dart';

import '../model/restaurant_detail.dart';

class ApiService {
  Client? client;
  ApiService({this.client}) {
    client ??= Client();
  }

  static final String baseUrl = 'https://restaurant-api.dicoding.dev/';
  static final String list = 'list';

  Future<RestaurantList> getRestaurants() async {
    final response = await client!.get(Uri.parse(baseUrl+list));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Memuat List Restaurant');
    }
  }

  Future<RestaurantDetail> getDetail(String id) async {
    final response = await client!.get(Uri.parse("${baseUrl}detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Memuat Detail Restaurant');
    }
  }

  Future<RestaurantSearch> getSearch(String text) async {
    final response = await client!.get(Uri.parse("${baseUrl}search?q=$text"));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Memuat Detail Restaurant');
    }
  }
}
