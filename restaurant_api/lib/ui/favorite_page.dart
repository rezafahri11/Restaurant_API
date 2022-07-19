import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:restaurant_api/data/model/restaurant_list.dart';
import 'package:restaurant_api/ui/detail_page.dart';

class FavoriteRestaurantPage extends StatelessWidget {
  static const routeName = '\favorite_page';
  final List<Restaurant> restaurant;
  const FavoriteRestaurantPage({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Page"),
      ),
      body: ListView.builder(
        itemCount: restaurant.length,
        itemBuilder: (context, index) {
          return _buildFavoriteItem(context, restaurant[index]);
        },
      ),
    );
  }

  Widget _buildFavoriteItem(BuildContext context, Restaurant restaurant) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: Hero(
        tag: 'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
        child: Image.network(
          'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
          width: 100,
        ),
      ),
      title: Text(
          restaurant.name
      ),
      subtitle: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_pin,
                color: Colors.lightGreenAccent,
                size: 20,
              ),
              Text(restaurant.city)
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.lightGreenAccent,
                size: 20,
              ),
              Text(restaurant.rating.toString())
            ],
          )
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, RestaurantDetailPage.routeName, arguments: restaurant.id);
      },
    );
  }
}
