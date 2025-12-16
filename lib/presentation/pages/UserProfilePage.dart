// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth_1/presentation/widgets/user_profile_widget.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth_1/data/model/user_model.dart';

class UserProfilePage extends StatelessWidget {
  final UserModel user;
  const UserProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        titleSpacing: 10,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Profile',
            style: TextStyle(fontSize: 26, color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: UserProfileWidget(user: user),
      ),
    );
  }
}
