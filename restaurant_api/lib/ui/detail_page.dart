import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/provider/detail_provider.dart';
import 'package:restaurant_api/widgets/detail_view.dart';

import '../data/api/api_service.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = "/detail_page";
  final String id;
  const RestaurantDetailPage({required this.id});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<DetailProvider>(
      create: (_) => DetailProvider(apiService: ApiService(), id: id),
          builder: (context, child) {
            return Scaffold(
            appBar: AppBar(
              title: Text("Restaurant"),
            ),
            body: Consumer<DetailProvider>(
              builder: (context, state, _) { 
                if (state.state == fetchDetail.Loading) {
                  return const Center(child: const CircularProgressIndicator());
                } else if (state.state == fetchDetail.NoData) {
                  return const Center(
                    child: Text(
                      "Detail Restoran Tidak Tersedia",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  );
                } else if (state.state == fetchDetail.Error) {
                  return const Center(
                    child: Text(
                      "Gagal Menampilkan Detail Restoran",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  );
                } else if (state.state == fetchDetail.HasData) {
                  final detail = state.result.restaurant;
                  return DetailRestaurantView(restaurantDetail: detail);
                } else {
                  return SizedBox();
                }
              }
                ),
          );
          } 
    );
  }
}