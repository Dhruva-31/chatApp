// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/pages/home_page.dart';
import 'package:firebase_auth_1/presentation/pages/profile_page.dart';
import 'package:firebase_auth_1/presentation/pages/users_page.dart';
import 'package:firebase_auth_1/presentation/providers/settings_provider.dart';

class NavigationPage extends StatelessWidget {
  final FirestoreMethods firestoreMethods;
  final String myId;
  const NavigationPage({
    super.key,
    required this.firestoreMethods,
    required this.myId,
  });

  @override
  Widget build(BuildContext context) {
    int pageIndex = context.watch<SettingsProvider>().pageIndex;
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: [
          HomePage(myId: myId, firestoreMethods: firestoreMethods),
          UsersPage(myId: myId, firestoreMethods: firestoreMethods),
          ProfilePage(myId: myId, firestoreMethods: firestoreMethods),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) {
          context.read<SettingsProvider>().setPageIndex(value);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidMessage),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.plus),
            label: "New",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userNinja),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
