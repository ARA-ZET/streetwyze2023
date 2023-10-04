class FirebaseUser {
  final String? name;
  final String? surname;
  final String? email;
  final String? role;
  final String? uid;

  FirebaseUser(
    this.name,
    this.surname,
    this.email,
    this.role,
    this.uid,
  );

  FirebaseUser.fromJson(Map<String, dynamic>? json)
      : name = json!["name"],
        surname = json["surname"],
        email = json["email"],
        role = json["role"],
        uid = json["uid"];

  Map<String, dynamic> toJson() => {
        "name": name,
        "surname": surname,
        "email": email,
        "role": role,
        "uid": uid,
      };
}
