import 'dart:convert';
import 'dart:ffi';
class RestaurantList {
    RestaurantList({
        required this.error,
        required this.message,
        required this.count,
        required this.restaurants,
    });

    late bool error;
    String message;
    int count;
    List<Restaurant> restaurants;

    factory RestaurantList.fromJson(Map<String, dynamic> json) => RestaurantList(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
    );
}

class Restaurant {
    Restaurant({
        required this.id,
        required this.name,
        required this.description,
        required this.pictureId,
        required this.city,
        required this.rating,
    });

    late String id;
    late String name;
    late String description;
    late String pictureId;
    late String city;
    late double rating;

    factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
    );

    Restaurant.fromMap(Map<String, dynamic> map) {
      id = map["id"];
      name = map["name"];
      description = map["description"];
      pictureId = map["pictureId"];
      city = map["city"];
      rating = map["rating"]; //double.parse();
    }

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating.toString(),//.toDouble(),
  };
}
