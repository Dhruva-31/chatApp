import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/repository/user_repo.dart';
import 'package:firebase_auth_1/presentation/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

void main() {
  group('UserPage test - ', () {
    testWidgets('When no users', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<UserRepo>.value(value: FakeUserRepoWithNoUsers()),
          ],
          child: MaterialApp(home: UsersPage(myId: '2')),
        ),
      );

      //INITIAL
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      //FINAL
      expect(find.text('No Users yet'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.text('Test1'), findsNothing);
      expect(find.text('Test2'), findsNothing);
    });

    testWidgets('When users exists', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [Provider<UserRepo>.value(value: FakeUserRepoWithUsers())],
          child: MaterialApp(home: UsersPage(myId: '2')),
        ),
      );

      //INITIAL
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      //FINAL
      expect(find.text('No Users yet'), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Test1'), findsOneWidget);
      expect(find.text('Test2'), findsNothing);
    });
  });
}

class FakeUserRepoWithUsers extends Mock implements UserRepo {
  List<UserModel> users = [
    UserModel(
      uid: '1',
      name: 'Test1',
      email: 'test1@gmail.com',
      profilePic: '',
      isOnline: false,
      fcmToken: '',
      lastSeen: DateTime.fromMicrosecondsSinceEpoch(1),
      createdAt: DateTime.fromMicrosecondsSinceEpoch(1),
    ),
    UserModel(
      uid: '2',
      name: 'Test2',
      email: 'test2@gmail.com',
      profilePic: '',
      isOnline: false,
      fcmToken: '',
      lastSeen: DateTime.fromMicrosecondsSinceEpoch(2),
      createdAt: DateTime.fromMicrosecondsSinceEpoch(2),
    ),
  ];
  @override
  Stream<List<UserModel>> getUsers(String currentId) {
    final List<UserModel> finalUser = [];
    for (var temp in users) {
      if (temp.uid != '2') {
        finalUser.add(temp);
      }
    }
    return Stream.value(finalUser);
  }
}

class FakeUserRepoWithNoUsers extends Mock implements UserRepo {
  @override
  Stream<List<UserModel>> getUsers(String currentId) {
    return Stream.value([]);
  }
}
