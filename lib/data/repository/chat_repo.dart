import 'package:firebase_auth_1/data/model/chatroom_model.dart';
import 'package:firebase_auth_1/data/model/message_model.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';

class ChatRepo {
  final FirestoreMethods firestoreMethods;

  ChatRepo({required this.firestoreMethods});

  Stream<List<ChatRoomModel>> getChatRooms(String userId) {
    return firestoreMethods.getChatRooms(userId);
  }

  String getOtherParticipantId(String myId, List<String> participants) {
    return (myId == participants[0]) ? participants[1] : participants[0];
  }

  bool hasChatRooms(List<dynamic>? chatRooms) {
    return chatRooms != null && chatRooms.isNotEmpty;
  }

  String generateRoomId(String uid1, String uid2) {
    final sortedIds = [uid1, uid2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  void clearChatForUser(String roomId, String uid) {
    firestoreMethods.clearChatForUser(roomId, uid);
  }

  Stream<List<MessageModel>> getMessages({
    required String roomId,
    required String uid,
  }) {
    return firestoreMethods.getMessages(roomId: roomId, uid: uid);
  }

  Future<void> sendMessage({
    required String text,
    required String uid1,
    required String uid2,
  }) {
    return firestoreMethods.sendMessage(text: text, uid1: uid1, uid2: uid2);
  }

  Future<void> markMessageAsSeen(String roomId, String senderId) {
    return firestoreMethods.markMessageAsSeen(roomId, senderId);
  }

  Future<void> resetUnseenCount(String roomId, String userId) {
    return firestoreMethods.resetUnseenCount(roomId, userId);
  }

  List<MessageModel> getUnseenMessages(
    List<MessageModel> messages,
    String otherUserId,
  ) {
    return messages
        .where((m) => m.senderId == otherUserId && !m.isSeen)
        .toList();
  }

  bool checkDayChanged(DateTime dateTime) {
    return DateTime.now().day != dateTime.day;
  }

  String formatLastSeen(DateTime lastSeen) {
    final hour = lastSeen.hour.toString().padLeft(2, '0');
    final minute = lastSeen.minute.toString().padLeft(2, '0');
    final dayChanged = checkDayChanged(lastSeen);
    final dayPart = dayChanged ? ' on ${lastSeen.day}' : ' today';

    return 'last seen $hour:$minute$dayPart';
  }

  String getStatusText({
    required bool isOnline,
    required String typingTo,
    required String myId,
    required DateTime lastSeen,
  }) {
    if (typingTo == myId) {
      return 'typing...';
    }
    if (isOnline) {
      return 'online';
    }
    return formatLastSeen(lastSeen);
  }

  bool isMessageValid(String message) {
    return message.trim().isNotEmpty;
  }

  void handleSendMessage({
    required String message,
    required String myId,
    required String otherUserId,
    required void Function() onMessageSent,
  }) {
    if (!isMessageValid(message)) return;

    sendMessage(text: message.trim(), uid1: myId, uid2: otherUserId);

    onMessageSent();
  }

  void handleMessagesSeen({
    required List<MessageModel> messages,
    required String roomId,
    required String myId,
    required String otherUserId,
    required bool isInForeground,
  }) {
    if (!isInForeground) return;

    resetUnseenCount(roomId, myId);

    final unseenMessages = getUnseenMessages(messages, otherUserId);

    if (unseenMessages.isNotEmpty) {
      markMessageAsSeen(roomId, otherUserId);
    }
  }

  String formatMessageTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void deleteMessage({
    required String roomId,
    required String messageId,
    String? deleteForUser,
  }) {
    firestoreMethods.deleteMessage(roomId: roomId, messageId: messageId);
  }
}
