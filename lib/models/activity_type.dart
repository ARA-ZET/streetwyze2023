class TypeSet {
  final String type;
  final int quantity;

  TypeSet({required this.type, required this.quantity});

  TypeSet.fromJson(Map<String, dynamic>? json)
      : type = json!["type"]!,
        quantity = json["quantinty"];

  Map<String, dynamic> toJson() => {
        "type": type,
        "quantity": quantity,
      };
}
