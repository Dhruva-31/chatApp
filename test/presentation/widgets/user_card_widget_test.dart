import 'package:firebase_auth_1/data/model/chatroom_model.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/presentation/widgets/user_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('user card widget testing', (tester) async {
    final fakeUser = UserModel(
      uid: '1',
      name: 'test',
      email: 'test@gmail.com',
      profilePic: '',
      isOnline: true,
      fcmToken: '',
      lastSeen: DateTime.fromMicrosecondsSinceEpoch(1),
      createdAt: DateTime.parse('19700101'),
    );
    final fakeChatRoom = ChatRoomModel(
      roomId: 'room1',
      participants: ['1', '2'],
      lastMessageFor: {
        '2': {'text': 'hi', 'at': DateTime.now().millisecondsSinceEpoch},
        '1': {'text': 'hello', 'at': DateTime.now().millisecondsSinceEpoch},
      },
      deletedAt: {},
      lastDeletedAt: {},
      lastMessageAt: DateTime.now().millisecondsSinceEpoch,
      unseenCount: {'1': 0, '2': 2},
    );

    await tester.pumpWidget(
      MaterialApp(
        home: UserCardWidget(myId: '2', user: fakeUser, chatroom: fakeChatRoom),
      ),
    );

    expect(find.byType(Card), findsOneWidget);
    expect(find.text('test'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('hi'), findsOneWidget);
    expect(find.byKey(Key('lastMessageTime')), findsOne);
  });
}
