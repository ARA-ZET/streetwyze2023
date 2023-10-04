class Activity {
  final String name;
  final String type;
  final String location;
  final String address;
  final String priceRange;
  final String duration;
  final String operatingHours;
  final String bookingRequired;
  final String info;
  final String contact;
  final String website;
  final String coordinates;

  Activity({
    required this.name,
    required this.type,
    required this.location,
    required this.address,
    required this.priceRange,
    required this.duration,
    required this.operatingHours,
    required this.bookingRequired,
    required this.info,
    required this.contact,
    required this.website,
    required this.coordinates,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      name: json['name'],
      type: json['type'],
      location: json['location'],
      address: json['address'],
      priceRange: json['Price-range'],
      duration: json['duration'],
      operatingHours: json['Operating hours'],
      bookingRequired: json['Booking required'],
      info: json['info'],
      contact: json['Contact'],
      website: json['Website'],
      coordinates: json['Coordinates'],
    );
  }
}
