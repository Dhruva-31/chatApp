import 'package:flutter/material.dart';

import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/presentation/pages/UserProfilePage.dart';
import 'package:firebase_auth_1/presentation/pages/chat_page.dart';
import 'package:firebase_auth_1/presentation/widgets/option_widget.dart';

void showUserOptions(BuildContext context, UserModel user, String myId) {
  showModalBottomSheet(
    context: context,
    builder: (context) => userOptions(context, user, myId),
  );
}

Widget userOptions(BuildContext context, UserModel user, String myId) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        SizedBox(height: 20),
        OptionWidget(
          icon: Icons.person,
          label: 'Profile',
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserProfilePage(user: user, myId: myId),
              ),
            );
          },
        ),
        OptionWidget(
          icon: Icons.chat,
          label: 'message',
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatPage(secondUser: user, myId: myId),
              ),
            );
          },
        ),
        OptionWidget(
          icon: Icons.cancel,
          label: "cancel",
          onTap: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(height: 10),
      ],
    ),
  );
}
