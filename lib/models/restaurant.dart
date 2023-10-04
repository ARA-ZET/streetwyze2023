class Restaurant {
  final String name;
  final String location;
  final String cuisine;
  final String about;
  final String restaurantInfo;
  final String website;
  final String parking;
  final String price;
  final String coordinates;

  Restaurant({
    required this.name,
    required this.location,
    required this.cuisine,
    required this.about,
    required this.restaurantInfo,
    required this.website,
    required this.parking,
    required this.price,
    required this.coordinates,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['Name'],
      location: json['Location'],
      cuisine: json['Cuisine'],
      about: json['About'],
      restaurantInfo: json['Restaurant info'],
      website: json['website'],
      parking: json['Parking'],
      price: json['Price'],
      coordinates: json['Coordinates'],
    );
  }
}
