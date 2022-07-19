import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/data/model/restaurant_list.dart';
import 'package:restaurant_api/provider/list_provider.dart';
import 'package:restaurant_api/ui/detail_page.dart';
import 'package:restaurant_api/ui/favorite_page.dart';
import 'package:restaurant_api/ui/search_page.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({Key? key}) : super(key: key);

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {

  late List<Restaurant> _restaurant;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, FavoriteRestaurantPage.routeName, arguments: _restaurant);
              },
              icon: const Icon(Icons.favorite_sharp)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchRestaurantPage.routeName);
              },
              icon: const Icon(Icons.search_sharp)),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, state, _) {
          _restaurant = state.Restaurants;
        if (state.state == ResultState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: state.result.count,
              itemBuilder: (context, index) {
                return ModuleTile(
                    restaurant: state.result.restaurants[index],
                    isFavorite: Provider.of<RestaurantProvider>(context,
                            listen: false)
                        .getRestaurantById(state.result.restaurants[index].id),
                    onClick: Provider.of<RestaurantProvider>(context,
                                listen: false)
                            .getRestaurantById(
                                state.result.restaurants[index].id)
                        ? () {
                            setState(() {
                              Provider.of<RestaurantProvider>(context,
                                      listen: false)
                                  .deleteResto(
                                      state.result.restaurants[index].id);
                            });
                          }
                        : () {
                            setState(() {
                              Provider.of<RestaurantProvider>(context,
                                      listen: false)
                                  .addRestaurant(
                                      state.result.restaurants[index]);
                            });
                          });
              });
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text(""));
        }
      }),
    );
  }
}

class ModuleTile extends StatelessWidget {
  final Restaurant restaurant;
  final bool isFavorite;
  final Function() onClick;

  const ModuleTile({
    Key? key,
    required this.restaurant,
    required this.isFavorite,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      trailing: IconButton(
        onPressed: onClick, 
        icon: const Icon(Icons.favorite_sharp),
        color: isFavorite ? Colors.lightGreenAccent : Colors.grey,),
      leading: Hero(
        tag:
            "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
        child: Image.network(
          "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
          width: 100,
        ),
      ),
      title: Text(restaurant.name),
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
        Navigator.pushNamed(context, RestaurantDetailPage.routeName,
            arguments: restaurant.id);
      },
    );
  }
}
