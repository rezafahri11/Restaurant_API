import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:restaurant_api/data/model/restaurant_search.dart';
import 'package:restaurant_api/ui/detail_page.dart';

class SearchRestaurantView extends StatelessWidget {

  final Restaurant restaurant;

  const SearchRestaurantView({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
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
                color: Colors.grey,
                size: 20,
              ),
              Text(restaurant.city)
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.grey,
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
