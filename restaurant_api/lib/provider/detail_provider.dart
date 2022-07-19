import 'package:flutter/foundation.dart';
import 'package:restaurant_api/data/api/api_service.dart';
import 'package:restaurant_api/data/model/restaurant_detail.dart';

enum fetchDetail { Loading, NoData, HasData, Error }

class DetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  DetailProvider({required this.apiService, required this.id}) {
    listenDetail();
  }

  late RestaurantDetail _restaurantDetail;
  late fetchDetail _state;
  String _message = '';

  String get message => _message;

  RestaurantDetail get result => _restaurantDetail;

  fetchDetail get state => _state;

  Future<dynamic> listenDetail() async {
    try {
      _state = fetchDetail.Loading;
      notifyListeners();
      final getDetail = await apiService.getDetail(id);
      if (getDetail.restaurant.id.isEmpty) {
        _state = fetchDetail.NoData;
        notifyListeners();
        return _message = 'Data Kosong';
      } else {
        _state = fetchDetail.HasData;
        notifyListeners();
        return _restaurantDetail = getDetail;
      }
    } catch (e) {
      _state = fetchDetail.Error;
      notifyListeners();
      return _message = 'Gagal Menampilkan Detail Restoran';
    }
  }
}