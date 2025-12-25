import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/presentation/widgets/user_profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('user profile widget test', (tester) async {
    final fakeUser = UserModel(
      uid: '2',
      name: 'test',
      email: 'test@gmail.com',
      profilePic: '',
      isOnline: true,
      fcmToken: '',
      lastSeen: DateTime.fromMicrosecondsSinceEpoch(1),
      createdAt: DateTime.parse('19700101'),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: UserProfileWidget(user: fakeUser, myId: '1'),
      ),
    );

    expect(find.byType(Card), findsOneWidget);
    expect(find.byKey(Key('edit button')), findsNothing);
    expect(find.text('name : test'), findsOneWidget);
    expect(find.text('email : test@gmail.com'), findsOneWidget);
  });
}
