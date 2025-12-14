class MessageModel {
  final String messageId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final bool isSeen;
  final List<String> deletedFor;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.isSeen = false,
    this.deletedFor = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "senderId": senderId,
      "text": text,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "isSeen": isSeen,
      'deletedFor': deletedFor,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map["messageId"] ?? '',
      senderId: map["senderId"] ?? '',
      text: map["text"] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map["createdAt"]),
      isSeen: map["isSeen"] ?? false,
      deletedFor: List<String>.from(map['deletedFor'] ?? []),
    );
  }
}
