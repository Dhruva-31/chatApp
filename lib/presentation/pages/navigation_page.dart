import 'package:firebase_auth_1/presentation/pages/users_page.dart';
import 'package:firebase_auth_1/presentation/pages/profile_page.dart';
import 'package:firebase_auth_1/presentation/pages/home_page.dart';
import 'package:firebase_auth_1/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationPage extends StatelessWidget {
  NavigationPage({super.key});

  final List<Widget> pages = [HomePage(), UsersPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    int pageIndex = context.watch<SettingsProvider>().pageIndex;
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.read<SettingsProvider>().pageIndex,
        onTap: (value) {
          context.read<SettingsProvider>().setPageIndex(value);
        },
        items: [
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
