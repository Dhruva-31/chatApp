// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_auth_1/presentation/pages/home_page.dart';
import 'package:firebase_auth_1/presentation/pages/profile_page.dart';
import 'package:firebase_auth_1/presentation/pages/users_page.dart';
import 'package:firebase_auth_1/presentation/providers/settings_provider.dart';

class NavigationPage extends StatelessWidget {
  final String myId;
  const NavigationPage({super.key, required this.myId});

  @override
  Widget build(BuildContext context) {
    int pageIndex = context.watch<SettingsProvider>().pageIndex;
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: [
          HomePage(myId: myId),
          UsersPage(myId: myId),
          ProfilePage(myId: myId),
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
