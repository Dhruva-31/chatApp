import 'package:firebase_auth_1/presentation/pages/users_page.dart';
import 'package:firebase_auth_1/presentation/pages/profile_page.dart';
import 'package:firebase_auth_1/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final List<Widget> pages = [HomePage(), UsersPage(), ProfilePage()];
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
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
