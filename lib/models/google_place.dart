class GoogleSearchedPlace {
  final String place;
  final String address;
  final String placeId;

  GoogleSearchedPlace(
    this.place,
    this.address,
    this.placeId,
  );

  GoogleSearchedPlace.fromJson(Map<String, dynamic>? json)
      : place = json!["place"],
        address = json["address"],
        placeId = json["name"];

  Map<String, dynamic> toJson() => {
        "place": place,
        "Address": address,
        "name": placeId,
      };
}
