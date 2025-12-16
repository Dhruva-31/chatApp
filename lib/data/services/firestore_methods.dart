import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_1/data/model/chatroom_model.dart';
import 'package:firebase_auth_1/data/model/message_model.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreMethods {
  final _instance = FirebaseFirestore.instance;

  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      await _instance.collection("users").doc(user.uid).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserOnLogin(String uid) async {
    try {
      final doc = await _instance.collection('users').doc(uid).get();

      if (doc.exists) {
        final data = doc.data();
        final isOnline = data?['isOnline'] ?? false;
        if (!isOnline) {
          await _instance.collection("users").doc(uid).update({
            "isOnline": true,
            "lastSeen": DateTime.now(),
          });
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserFcmToken(String token) async {
    try {
      final myId = FirebaseMethods().currentUser!.uid;
      await _instance.collection('users').doc(myId).update({'fcmToken': token});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserOnSignOut(String uid) async {
    try {
      await _instance.collection('users').doc(uid).update({
        "isOnline": false,
        "lastSeen": DateTime.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserName(String name) async {
    try {
      final uid = FirebaseMethods().currentUser!.uid;
      await _instance.collection('users').doc(uid).update({"name": name});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserTyping(String secondId) async {
    try {
      final uid = FirebaseMethods().currentUser!.uid;
      final doc = await _instance.collection('users').doc(uid).get();
      if (doc['typingTo'] != secondId) {
        await _instance.collection('users').doc(uid).update({
          "typingTo": secondId,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> userExists(String uid) async {
    try {
      final doc = await _instance.collection("users").doc(uid).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  Stream<UserModel> getUserDetail(String uid) {
    try {
      return _instance
          .collection('users')
          .doc(uid)
          .snapshots()
          .map((snapshot) => UserModel.fromMap(snapshot.data()!));
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<UserModel>> getUsers(String currentId) {
    try {
      return _instance
          .collection('users')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => UserModel.fromMap(doc.data()))
                .where(
                  (user) =>
                      user.uid != currentId && user.name != 'deleted user',
                )
                .toList(),
          );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserDetails(String uid) async {
    try {
      await _instance.collection('users').doc(uid).update({
        'isOnline': false,
        'name': 'deleted user',
        'profilePic': '',
      });
    } catch (e) {
      rethrow;
    }
  }

  String generateRoomId(String uid1, String uid2) {
    return (uid1.compareTo(uid2) < 0) ? "${uid1}_$uid2" : "${uid2}_$uid1";
  }

  Future<String> createChatRoomIfNotExists(String uid1, String uid2) async {
    try {
      final roomId = generateRoomId(uid1, uid2);
      final docRef = _instance.collection("chatrooms").doc(roomId);
      final snap = await docRef.get();

      if (!snap.exists) {
        ChatRoomModel room = ChatRoomModel(
          roomId: roomId,
          participants: [uid1, uid2],
          deletedAt: {uid1: null, uid2: null},
          lastDeletedAt: {uid1: null, uid2: null},
          lastMessageFor: {},
          lastMessageAt: DateTime.now().microsecondsSinceEpoch,
          unseenCount: {uid1: 0, uid2: 0},
        );
        await docRef.set(room.toMap());
      }
      return roomId;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ChatRoomModel>> getChatRooms(String uid) {
    try {
      return _instance
          .collection("chatrooms")
          .where("participants", arrayContains: uid)
          .orderBy('lastMessageAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => ChatRoomModel.fromMap(doc.data()))
                .where(
                  (room) =>
                      room.deletedAt[uid] == null && room.lastMessageAt != 0,
                )
                .toList(),
          );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearChatForUser(String roomId, String uid) async {
    final docRef = _instance.collection("chatrooms").doc(roomId);
    final snap = await docRef.get();
    if (!snap.exists) return;

    final now = DateTime.now().millisecondsSinceEpoch;

    await docRef.update({
      "deletedAt.$uid": now,
      "lastDeletedAt.$uid": now,
      'unseenCount.$uid': 0,
    });
  }

  Future<void> sendMessage({
    required String uid1,
    required String text,
    required String uid2,
  }) async {
    try {
      final roomId = await createChatRoomIfNotExists(uid1, uid2);
      final roomRef = _instance.collection("chatrooms").doc(roomId);
      final messageId = roomRef.collection("messages").doc().id;
      final now = DateTime.now();

      final message = MessageModel(
        messageId: messageId,
        senderId: uid1,
        text: text,
        createdAt: now,
      );
      await roomRef
          .collection("messages")
          .doc(message.messageId)
          .set(message.toMap());

      await roomRef.update({
        "lastMessageFor.$uid1": {
          "text": message.text,
          "by": uid1,
          "at": now.millisecondsSinceEpoch,
        },
        "lastMessageFor.$uid2": {
          "text": message.text,
          "by": uid1,
          "at": now.millisecondsSinceEpoch,
        },
        'unseenCount.$uid1': 0,
        'unseenCount.$uid2': FieldValue.increment(1),
        'deletedAt.$uid1': null,
        'deletedAt.$uid2': null,
        'lastMessageAt': DateTime.now().microsecondsSinceEpoch,
      });

      await updateUserTyping('');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markMessageAsSeen(String roomId, String uid) async {
    try {
      final query = await _instance
          .collection("chatrooms")
          .doc(roomId)
          .collection("messages")
          .where("senderId", isEqualTo: uid)
          .where("isSeen", isEqualTo: false)
          .get();

      for (var doc in query.docs) {
        await doc.reference.update({"isSeen": true});
      }
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<MessageModel>> getMessages({
    required String roomId,
    required String uid,
  }) {
    final roomRef = _instance.collection("chatrooms").doc(roomId);

    final roomStream = roomRef.snapshots();
    final messagesStream = roomRef
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();

    return Rx.combineLatest2(roomStream, messagesStream, (roomSnap, msgSnap) {
      if (!roomSnap.exists) return <MessageModel>[];

      final data = roomSnap.data();
      final lastDeletedAtMap = data?['lastDeletedAt'] as Map<String, dynamic>?;
      final lastDeletedAt = lastDeletedAtMap?[uid];
      final deletedTime = lastDeletedAt is int ? lastDeletedAt : 0;

      return msgSnap.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .where(
            (m) =>
                m.createdAt.millisecondsSinceEpoch > deletedTime &&
                !m.deletedFor.contains(uid),
          )
          .toList();
    });
  }

  Future<void> resetUnseenCount(String roomId, String uid) async {
    await _instance.collection("chatrooms").doc(roomId).update({
      "unseenCount.$uid": 0,
    });
  }

  Future<void> deleteMessage({
    required String roomId,
    required String messageId,
    String? deleteForUser,
  }) async {
    try {
      final roomRef = _instance.collection("chatrooms").doc(roomId);
      final msgRef = roomRef.collection('messages').doc(messageId);
      final roomSnap = await roomRef.get();
      final participants = List<String>.from(roomSnap['participants']);

      if (deleteForUser == null) {
        await msgRef.delete();
        for (final uid in participants) {
          await recomputeLastMessageForUser(roomId, uid);
        }
        return;
      }
      await msgRef.update({
        'deletedFor': FieldValue.arrayUnion([deleteForUser]),
      });
      await recomputeLastMessageForUser(roomId, deleteForUser);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> recomputeLastMessageForUser(String roomId, String uid) async {
    final messages = await _instance
        .collection("chatrooms")
        .doc(roomId)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .get();

    for (var doc in messages.docs) {
      final msg = MessageModel.fromMap(doc.data());

      if (!msg.deletedFor.contains(uid)) {
        await _instance.collection("chatrooms").doc(roomId).update({
          "lastMessageFor.$uid": {
            "text": msg.text,
            "by": msg.senderId,
            "at": msg.createdAt.millisecondsSinceEpoch,
          },
        });

        return;
      }
    }
    await _instance.collection("chatrooms").doc(roomId).update({
      "lastMessageFor.$uid": {"text": "", "by": "", "at": 0},
    });
  }
}
