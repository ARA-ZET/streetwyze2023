class Place {
  final double lat;
  final double lng;
  final String formattedAddress;

  Place({required this.lat, required this.lng, required this.formattedAddress});

  Place.fromJson(Map<String, dynamic>? json)
      : lat = json!["lat"]!,
        lng = json["lng"],
        formattedAddress = json["formattedAddress"];

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
        "formattedAddress": formattedAddress,
      };
}
