import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';

class UserRepo {
  final FirestoreMethods firestoreMethods;

  UserRepo({required this.firestoreMethods});

  Stream<UserModel> getUserDetail(String userId) {
    return firestoreMethods.getUserDetail(userId);
  }

  Future<void> updateUserTyping(String typingTo) {
    return firestoreMethods.updateUserTyping(typingTo);
  }

  Future<void> clearTypingStatus() {
    return updateUserTyping('');
  }

  Stream<List<UserModel>> getUsers(String myId) {
    return firestoreMethods.getUsers(myId);
  }

  Future<void> updateUserOnLogin(String myId) async {
    firestoreMethods.updateUserOnLogin(myId);
  }
}
