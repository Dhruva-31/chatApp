import 'package:firebase_auth_1/data/model/chatroom_model.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/pages/home_page.dart';
import 'package:firebase_auth_1/presentation/pages/navigation_page.dart';
import 'package:firebase_auth_1/presentation/pages/profile_page.dart';
import 'package:firebase_auth_1/presentation/pages/users_page.dart';
import 'package:firebase_auth_1/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('NavigationPage test', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<SettingsProvider>(
        create: (_) => FakeSettingsProvider(),
        child: MaterialApp(
          home: NavigationPage(
            myId: '1',
            firestoreMethods: FakeFireStoreMethods(),
          ),
        ),
      ),
    );

    // Initial page (Chats)
    expect(find.byIcon(FontAwesomeIcons.solidMessage), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);

    // Tap "New"
    await tester.tap(find.text('New'));
    await tester.pump();

    expect(find.byType(UsersPage), findsOneWidget);

    // Tap "Profile"
    await tester.tap(find.text('Profile'));
    await tester.pump();

    expect(find.byType(ProfilePage), findsOneWidget);

    // Tap "Chats"
    await tester.tap(find.text('Chats'));
    await tester.pump();

    expect(find.byType(HomePage), findsOneWidget);
  });
}

class FakeFireStoreMethods extends Fake implements FirestoreMethods {
  List<ChatRoomModel> chats = [
    ChatRoomModel(
      roomId: '1',
      participants: ['A', 'B'],
      lastMessageFor: {'A': 1},
      deletedAt: {'A': 2},
      lastDeletedAt: {'B': 2},
      lastMessageAt: 4,
      unseenCount: {'A': 0, 'B': 0},
    ),
    ChatRoomModel(
      roomId: '2',
      participants: ['A', 'B'],
      lastMessageFor: {'B': 1},
      deletedAt: {'B': 2},
      lastDeletedAt: {'A': 2},
      lastMessageAt: 4,
      unseenCount: {'A': 0, 'B': 0},
    ),
  ];

  @override
  Stream<List<ChatRoomModel>> getChatRooms(String uid) {
    return Stream.value([]);
  }

  @override
  Stream<UserModel> getUserDetail(String uid) {
    return Stream.value(
      UserModel(
        uid: uid,
        name: 'Test User',
        email: 'test@test.com',
        profilePic: '',
        isOnline: true,
        fcmToken: '',
        lastSeen: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    );
  }

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
    return Stream.value([]);
  }
}

class FakeSettingsProvider extends ChangeNotifier implements SettingsProvider {
  int _pageIndex = 0;

  @override
  int get pageIndex => _pageIndex;

  @override
  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  @override
  bool get dark => false;

  @override
  Future<void> toggleDark(bool value) async {}
}
