class UxFeedback {
  final String? user;
  final DateTime time;
  final String status;
  final String message;

  UxFeedback(this.user, this.time, this.status, this.message);

  UxFeedback.fromJson(Map<String, dynamic>? json)
      : user = json!["user"],
        time = json["time"],
        status = json["status"],
        message = json["message"];

  Map<String, dynamic> toJson() => {
        "user": user,
        "time": time,
        "status": status,
        "message": message,
      };
}
