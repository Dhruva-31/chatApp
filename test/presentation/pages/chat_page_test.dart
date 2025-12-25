import 'package:firebase_auth_1/data/model/message_model.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/pages/chat_page.dart';
import 'package:firebase_auth_1/presentation/widgets/message_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('chat Page test - ', () {
    testWidgets('When messages exists', (tester) async {
      final secondUser = UserModel(
        uid: '2',
        name: 'Test2',
        email: 'test2@gmail.com',
        profilePic: '',
        isOnline: false,
        fcmToken: '',
        lastSeen: DateTime.fromMicrosecondsSinceEpoch(2),
        createdAt: DateTime.fromMicrosecondsSinceEpoch(2),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: ChatPage(
            secondUser: secondUser,
            firestoreMethods: FakeFirestoreMethodsWithMessages(),
            myId: '1',
          ),
        ),
      );

      //INTIAL
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));

      await tester.pump();

      //FINAL
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(MessageListWidget), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('when no messages', (tester) async {
      final secondUser = UserModel(
        uid: '2',
        name: 'Test2',
        email: 'test2@gmail.com',
        profilePic: '',
        isOnline: false,
        fcmToken: '',
        lastSeen: DateTime.fromMicrosecondsSinceEpoch(2),
        createdAt: DateTime.fromMicrosecondsSinceEpoch(2),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: ChatPage(
            secondUser: secondUser,
            firestoreMethods: FakeFirestoreMethodsWithNoMessages(),
            myId: '1',
          ),
        ),
      );

      //INTIAL
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));

      await tester.pump();

      //FINAL
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(MessageListWidget), findsOneWidget);
      expect(find.text('Hello'), findsNothing);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });
  });
}

class FakeFirestoreMethodsWithNoMessages extends Fake
    implements FirestoreMethods {
  final fakeMessages = [
    MessageModel(
      messageId: '1',
      text: 'Hello',
      senderId: 'me',
      isSeen: true,
      createdAt: DateTime.now(),
    ),
  ];

  final fakeUser = UserModel(
    uid: '1',
    name: 'Test1',
    email: 'test1@gmail.com',
    profilePic: '',
    isOnline: false,
    fcmToken: '',
    lastSeen: DateTime.fromMicrosecondsSinceEpoch(1),
    createdAt: DateTime.fromMicrosecondsSinceEpoch(1),
  );

  @override
  String generateRoomId(String uid1, String uid2) {
    return 'fake_room_id';
  }

  @override
  Stream<List<MessageModel>> getMessages({
    required String roomId,
    required String uid,
  }) {
    return Stream.value([]);
  }

  @override
  Stream<UserModel> getUserDetail(String uid) {
    return Stream.value(fakeUser);
  }

  @override
  Future<void> resetUnseenCount(String roomId, String myId) async {
    // do nothing
  }

  @override
  Future<void> markMessageAsSeen(String roomId, String uid) async {
    // do nothing
  }

  @override
  Future<void> updateUserTyping(String uid) async {
    // do nothing
  }
}

class FakeFirestoreMethodsWithMessages extends Fake
    implements FirestoreMethods {
  final fakeMessages = [
    MessageModel(
      messageId: '1',
      text: 'Hello',
      senderId: 'me',
      isSeen: true,
      createdAt: DateTime.now(),
    ),
  ];

  final fakeUser = UserModel(
    uid: '1',
    name: 'Test1',
    email: 'test1@gmail.com',
    profilePic: '',
    isOnline: false,
    fcmToken: '',
    lastSeen: DateTime.fromMicrosecondsSinceEpoch(1),
    createdAt: DateTime.fromMicrosecondsSinceEpoch(1),
  );

  @override
  String generateRoomId(String uid1, String uid2) {
    return 'fake_room_id';
  }

  @override
  Stream<List<MessageModel>> getMessages({
    required String roomId,
    required String uid,
  }) {
    return Stream.value(fakeMessages);
  }

  @override
  Stream<UserModel> getUserDetail(String uid) {
    return Stream.value(fakeUser);
  }

  @override
  Future<void> resetUnseenCount(String roomId, String myId) async {
    // do nothing
  }

  @override
  Future<void> markMessageAsSeen(String roomId, String uid) async {
    // do nothing
  }

  @override
  Future<void> updateUserTyping(String uid) async {
    // do nothing
  }
}
