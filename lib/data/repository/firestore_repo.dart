import 'package:firebase_auth_1/data/model/chatroom_model.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';

class FirestoreRepo {
  final _firestore = FirestoreMethods();

  Stream<List<ChatRoomModel>> chatRoomsData(String uid) {
    try {
      Stream<List<ChatRoomModel>> chatData = _firestore.getChatRooms(uid);
      return chatData;
    } catch (e) {
      rethrow;
    }
  }
}
