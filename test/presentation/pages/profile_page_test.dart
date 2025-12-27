import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/repository/user_repo.dart';
import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:firebase_auth_1/presentation/pages/profile_page.dart';
import 'package:firebase_auth_1/presentation/providers/settings_provider.dart';
import 'package:firebase_auth_1/presentation/widgets/user_profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('profile page test', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsProvider>(
            create: (_) => FakeSettingsProvider(),
          ),
          BlocProvider<AuthBloc>(create: (_) => FakeAuthBloc()),
          Provider<UserRepo>.value(value: FakeUserRepo()),
        ],
        child: MaterialApp(home: ProfilePage(myId: '1')),
      ),
    );

    await tester.pump();

    //FINAL
    expect(find.byType(UserProfileWidget), findsOneWidget);
    expect(find.text('Dark theme'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
    expect(find.text('Delete Account'), findsOneWidget);
  });
}

class FakeUserRepo extends Fake implements UserRepo {
  final user = UserModel(
    uid: '2',
    name: 'Test1',
    email: 'test1@gmail.com',
    profilePic: '',
    isOnline: false,
    fcmToken: '',
    lastSeen: DateTime.fromMicrosecondsSinceEpoch(1),
    createdAt: DateTime.fromMicrosecondsSinceEpoch(1),
  );
  @override
  Stream<UserModel> getUserDetail(String currentId) {
    return Stream.value(user);
  }
}

class FakeAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class FakeSettingsProvider extends ChangeNotifier implements SettingsProvider {
  bool _dark = false;

  @override
  bool get dark => _dark;

  @override
  Future<void> toggleDark(bool value) async {
    _dark = value;
    notifyListeners();
  }

  @override
  void setPageIndex(int index) {}

  @override
  int get pageIndex => throw UnimplementedError();
}
