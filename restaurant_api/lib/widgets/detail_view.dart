import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:restaurant_api/data/model/restaurant_detail.dart';

class DetailRestaurantView extends StatelessWidget {
  late final Restaurant restaurantDetail;

  DetailRestaurantView({required this.restaurantDetail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'https://restaurant-api.dicoding.dev/images/large/${restaurantDetail.pictureId}',
              child: Image.network('https://restaurant-api.dicoding.dev/images/small/${restaurantDetail.pictureId}')),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurantDetail.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.lightGreenAccent,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.pin_drop, color: Colors.green,),
                            Text(restaurantDetail.city)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.star, color: Colors.green,),
                            Text(restaurantDetail.rating.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.lightGreenAccent,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(10), //apply padding to all four sides

                    child: Text("Description",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      restaurantDetail.description,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Foods List: ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: restaurantDetail.menus.foods.length,
                            itemBuilder: (context, index) {
                              return Text(''
                                  '${index+1}. ${restaurantDetail.menus.foods[index].name}');
                            }),
                      ),
                      Text(
                        "Drinks List: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: restaurantDetail.menus.drinks.length,
                            itemBuilder: (context, index) {
                              return Text(''
                                  '${index+1}. ${restaurantDetail.menus.drinks[index].name}');
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
