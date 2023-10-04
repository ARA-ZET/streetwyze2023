class Message {
  final String content;
  final DateTime sentTime;
  final MessageType messageType;
  final String senderId;
  final String receiverId;
  final String adminId;

  const Message({
    required this.content,
    required this.sentTime,
    required this.messageType,
    required this.senderId,
    required this.receiverId,
    required this.adminId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        content: json['content'],
        sentTime: json['sentTime'].toDate(),
        messageType: MessageType.fromJson(json['messageType']),
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        adminId: json['adminId'],
      );

  Map<String, dynamic> toJson() => {
        'content': content,
        'sentTime': sentTime,
        'messageType': messageType.toJson(),
        'senderId': senderId,
        'receiverId': receiverId,
        'adminId': adminId,
      };
}

enum MessageType {
  text,
  image;

  String toJson() => name;

  factory MessageType.fromJson(String json) => values.byName(json);
}
