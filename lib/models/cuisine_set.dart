class CuisineSet {
  final String cuisine;
  final int quantity;

  CuisineSet({required this.cuisine, required this.quantity});

  CuisineSet.fromJson(Map<String, dynamic>? json)
      : cuisine = json!["cuisine"]!,
        quantity = json["quantinty"];

  Map<String, dynamic> toJson() => {
        "cuisine": cuisine,
        "quantity": quantity,
      };
}
