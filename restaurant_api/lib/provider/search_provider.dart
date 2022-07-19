import 'package:flutter/foundation.dart';
import 'package:restaurant_api/data/api/api_service.dart';
import 'package:restaurant_api/data/model/restaurant_search.dart';

enum fetchSearch { Loading, NoData, HasData, Error }

class SearchProvider extends ChangeNotifier {

  SearchProvider(){
    _state = fetchSearch.Loading;
  }

  final apiService = ApiService();

  late RestaurantSearch _restaurantSearch;
  late fetchSearch _state;
  String _message = '';

  String get message => _message;
  RestaurantSearch get result => _restaurantSearch;
  fetchSearch get state => _state;

  Future<dynamic> _fetchByQuery(String searchString) async {
    try {
      _state = fetchSearch.Loading;
      notifyListeners();
      final searchResult = await apiService.getSearch(searchString);
      if (searchResult.restaurants.isEmpty) {
        _state = fetchSearch.NoData;
        notifyListeners();
        return _message = 'Data Kosong';
      } else {
        _state = fetchSearch.HasData;
        notifyListeners();
        return _restaurantSearch = searchResult;
      }
    } catch (e) {
      _state = fetchSearch.Error;
      notifyListeners();
      return _message = 'Mohon maaf. Gagal mendapatkan data.';
    }
  }

  void searchRestaurant (String searchString) {
    _fetchByQuery(searchString);
    notifyListeners();
  }
}