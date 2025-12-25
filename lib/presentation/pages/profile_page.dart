// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:firebase_auth_1/presentation/pages/auth_pages/delete_acc_page.dart';
import 'package:firebase_auth_1/presentation/providers/settings_provider.dart';
import 'package:firebase_auth_1/presentation/widgets/alert_widget.dart';
import 'package:firebase_auth_1/presentation/widgets/switch_widget.dart';
import 'package:firebase_auth_1/presentation/widgets/user_profile_widget.dart';

class ProfilePage extends StatefulWidget {
  final FirestoreMethods firestoreMethods;
  final String myId;

  const ProfilePage({
    super.key,
    required this.firestoreMethods,
    required this.myId,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final Stream _userStream;
  dynamic _cachedUser;

  @override
  void initState() {
    super.initState();
    _userStream = widget.firestoreMethods.getUserDetail(widget.myId);
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.select<SettingsProvider, bool>(
      (provider) => provider.dark,
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Profile',
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: _userStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _cachedUser = snapshot.data;
            }

            if (_cachedUser == null) {
              return SizedBox.shrink();
            }
            final user = _cachedUser;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  UserProfileWidget(user: user, myId: widget.myId),
                  SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SwitchWidget(
                            text: 'Dark theme',
                            onChanged: () {
                              context.read<SettingsProvider>().toggleDark(
                                !dark,
                              );
                            },
                            value: dark,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    child: SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertWidget(
                                        title: 'Log Out',
                                        content:
                                            'Are you sure you want to log out?',
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context.read<AuthBloc>().add(
                                            LogOutButtonClickedEvent(),
                                          );
                                          context
                                              .read<SettingsProvider>()
                                              .setPageIndex(0);
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'Log Out',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertWidget(
                                        title: 'Delete Account',
                                        content:
                                            'Are you sure you want to delete your account?',
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const DeleteAccPage(),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'Delete Account',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
