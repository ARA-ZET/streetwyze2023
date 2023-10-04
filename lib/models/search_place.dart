class SearchedPlace {
  final String name;
  final String address;
  final String place;
  final List<double> location;

  SearchedPlace(this.name, this.address, this.place, this.location);

  SearchedPlace.fromJson(Map<String, dynamic>? json)
      : name = json!["name"],
        address = json["address"],
        place = json["place"],
        location = json["location"];

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "place": place,
        "location": location,
      };
}
