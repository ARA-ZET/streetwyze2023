class StreetWyzeUser {
  final String? displayName;
  final String? email;
  final String uid;

  StreetWyzeUser(
    this.displayName,
    this.email,
    this.uid,
  );

  StreetWyzeUser.fromJson(Map<String, dynamic>? json)
      : displayName = json!["displayName"],
        email = json["email"],
        uid = json["uid"];

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "email": email,
        "uid": uid,
      };
}
