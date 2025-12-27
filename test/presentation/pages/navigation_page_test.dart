import 'package:firebase_auth_1/data/model/chatroom_model.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/repository/chat_repo.dart';
import 'package:firebase_auth_1/data/repository/user_repo.dart';
import 'package:firebase_auth_1/presentation/pages/home_page.dart';
import 'package:firebase_auth_1/presentation/pages/navigation_page.dart';
import 'package:firebase_auth_1/presentation/pages/profile_page.dart';
import 'package:firebase_auth_1/presentation/pages/users_page.dart';
import 'package:firebase_auth_1/presentation/providers/settings_provider.dart';
import 'package:firebase_auth_1/presentation/widgets/user_profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('NavigationPage test', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ChatRepo>.value(value: FakeChatRepo()),
          Provider<UserRepo>.value(value: FakeUserRepo()),
          ChangeNotifierProvider<SettingsProvider>.value(
            value: FakeSettingsProvider(),
          ),
        ],
        child: MaterialApp(home: NavigationPage(myId: '1')),
      ),
    );

    // Initial page (Chats)
    expect(find.byIcon(FontAwesomeIcons.solidMessage), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);

    // Tap "New"
    await tester.tap(find.text('New'));
    await tester.pump();

    expect(find.byType(UsersPage), findsOneWidget);
    expect(find.text('Users'), findsOneWidget);

    // Tap "Profile"
    await tester.tap(find.text('Profile'));
    await tester.pump();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.byType(UserProfileWidget), findsOneWidget);

    // Tap "Chats"
    await tester.tap(find.text('Chats'));
    await tester.pump();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('No chats yet'), findsOneWidget);
  });
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

class FakeChatRepo extends Fake implements ChatRepo {
  @override
  Stream<List<ChatRoomModel>> getChatRooms(String uid) {
    return Stream.value([]);
  }
}

class FakeUserRepo extends Fake implements UserRepo {
  @override
  Stream<List<UserModel>> getUsers(String currentId) {
    return Stream.value([]);
  }

  @override
  Stream<UserModel> getUserDetail(String currentId) {
    return Stream.value(
      UserModel(
        uid: currentId,
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
}
