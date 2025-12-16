import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:firebase_auth_1/presentation/providers/settings_provider.dart';
import 'package:firebase_auth_1/presentation/widgets/alert_widget.dart';
import 'package:firebase_auth_1/presentation/widgets/switch_widget.dart';
import 'package:firebase_auth_1/presentation/widgets/user_profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/pages/auth_pages/delete_acc_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final bool mute = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = FirestoreMethods().getUserDetail(
      FirebaseMethods().currentUser!.uid,
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
          stream: userDetails,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final user = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  UserProfileWidget(user: user!),
                  SizedBox(height: 10),
                  Card(
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            SwitchWidget(
                              text: 'Dark theme',
                              onChanged: () {
                                context.read<SettingsProvider>().toggleDark(
                                  !context.read<SettingsProvider>().dark,
                                );
                              },
                              value: context.read<SettingsProvider>().dark,
                            ),
                            // SwitchWidget(
                            //   text: 'Mute notifications',
                            //   onChanged: () {
                            //     setState(() {
                            //       mute = !mute;
                            //     });
                            //   },
                            //   value: mute,
                            // ),
                          ],
                        ),
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
                                                  DeleteAccPage(),
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
