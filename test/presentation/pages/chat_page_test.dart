import 'package:firebase_auth_1/data/model/message_model.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/repository/chat_repo.dart';
import 'package:firebase_auth_1/data/repository/user_repo.dart';
import 'package:firebase_auth_1/presentation/pages/chat_page.dart';
import 'package:firebase_auth_1/presentation/widgets/message_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

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
        MultiProvider(
          providers: [
            Provider<UserRepo>.value(value: FakeUserRepo()),
            Provider<ChatRepo>.value(value: FakeChatRepoWithMessages()),
          ],
          child: MaterialApp(
            home: ChatPage(secondUser: secondUser, myId: '1'),
          ),
        ),
      );

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
        MultiProvider(
          providers: [
            Provider<UserRepo>.value(value: FakeUserRepo()),
            Provider<ChatRepo>.value(value: FakeChatRepoWithNoMessages()),
          ],
          child: MaterialApp(
            home: ChatPage(secondUser: secondUser, myId: '1'),
          ),
        ),
      );

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

class FakeChatRepoWithNoMessages extends Fake implements ChatRepo {
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
  Future<void> resetUnseenCount(String roomId, String userId) async {
    return;
  }

  @override
  void handleSendMessage({
    required String message,
    required String myId,
    required String otherUserId,
    required void Function() onMessageSent,
  }) {}

  @override
  void handleMessagesSeen({
    required List<MessageModel> messages,
    required String roomId,
    required String myId,
    required String otherUserId,
    required bool isInForeground,
  }) {}

  @override
  String getStatusText({
    required bool isOnline,
    required String typingTo,
    required String myId,
    required DateTime lastSeen,
  }) {
    return '';
  }

  @override
  String formatMessageTime(DateTime timestamp) {
    return '';
  }
}

class FakeUserRepo extends Fake implements UserRepo {
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
  Stream<UserModel> getUserDetail(String uid) {
    return Stream.value(fakeUser);
  }

  @override
  Future<void> clearTypingStatus() async {
    return;
  }
}

class FakeChatRepoWithMessages extends Fake implements ChatRepo {
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
  Future<void> resetUnseenCount(String roomId, String userId) async {
    return;
  }

  @override
  void handleSendMessage({
    required String message,
    required String myId,
    required String otherUserId,
    required void Function() onMessageSent,
  }) {}

  @override
  void handleMessagesSeen({
    required List<MessageModel> messages,
    required String roomId,
    required String myId,
    required String otherUserId,
    required bool isInForeground,
  }) {}

  @override
  String getStatusText({
    required bool isOnline,
    required String typingTo,
    required String myId,
    required DateTime lastSeen,
  }) {
    return '';
  }

  @override
  String formatMessageTime(DateTime timestamp) {
    return '';
  }
}
