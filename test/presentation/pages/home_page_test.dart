import 'package:firebase_auth_1/data/model/chatroom_model.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomePage test - ', () {
    const fakeUid = 'test-uid';
    testWidgets('when no chats', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(
            firestoreMethods: FakeFirestoreNoChats(),
            myId: fakeUid,
          ),
        ),
      );

      //INITIAL
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      //FINAL
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('No chats yet'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });
    testWidgets('When chats exists', (tester) async {
      const fakeUid = 'test-uid';
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(
            firestoreMethods: FakeFirestoreWithChats(),
            myId: fakeUid,
          ),
        ),
      );

      //INITIAL
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      //FINAL
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('No chats yet'), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}

class FakeFirestoreNoChats extends Fake implements FirestoreMethods {
  @override
  Stream<List<ChatRoomModel>> getChatRooms(String uid) {
    return Stream.value([]);
  }

  @override
  Stream<UserModel> getUserDetail(String uid) {
    return Stream.value(_fakeUser(uid));
  }
}

class FakeFirestoreWithChats extends Fake implements FirestoreMethods {
  @override
  Stream<List<ChatRoomModel>> getChatRooms(String uid) {
    return Stream.value([
      ChatRoomModel(
        roomId: '1',
        participants: ['test-uid', 'B'],
        lastMessageFor: {'test-uid': 1},
        deletedAt: {},
        lastDeletedAt: {},
        lastMessageAt: 4,
        unseenCount: {'test-uid': 0},
      ),
    ]);
  }

  @override
  Stream<UserModel> getUserDetail(String uid) {
    return Stream.value(_fakeUser(uid));
  }
}

UserModel _fakeUser(String uid) => UserModel(
  uid: uid,
  name: 'Test User',
  email: 'test@test.com',
  profilePic: '',
  isOnline: true,
  fcmToken: '',
  lastSeen: DateTime.now(),
  createdAt: DateTime.now(),
);
