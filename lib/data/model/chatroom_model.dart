class ChatRoomModel {
  final String roomId;
  final List<String> participants;
  final Map<String, dynamic> lastMessageFor;
  final Map<String, int?> deletedAt;
  final Map<String, int?> lastDeletedAt;
  final int lastMessageAt;
  final Map<String, int> unseenCount;

  ChatRoomModel({
    required this.roomId,
    required this.participants,
    required this.lastMessageFor,
    required this.deletedAt,
    required this.lastDeletedAt,
    required this.lastMessageAt,
    required this.unseenCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'participants': participants,
      'lastMessageFor': lastMessageFor,
      'deletedAt': deletedAt,
      'lastDeletedAt': lastDeletedAt,
      'lastMessageAt': lastMessageAt,
      'unseenCount': unseenCount,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      roomId: map['roomId'],
      participants: List<String>.from(map['participants']),
      lastMessageAt: map['lastMessageAt'] ?? 0,
      lastMessageFor: Map<String, dynamic>.from(map['lastMessageFor'] ?? {}),
      deletedAt: Map<String, int?>.from(map['deletedAt'] ?? {}),
      lastDeletedAt: Map<String, int?>.from(map['lastDeletedAt'] ?? {}),
      unseenCount: Map<String, int>.from(map['unseenCount'] ?? {}),
    );
  }
}
