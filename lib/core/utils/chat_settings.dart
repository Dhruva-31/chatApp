import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/pages/UserProfilePage.dart';
import 'package:firebase_auth_1/presentation/widgets/alert_widget.dart';
import 'package:firebase_auth_1/presentation/widgets/option_widget.dart';
import 'package:flutter/material.dart';

void showChatOptions(
  BuildContext context,
  String roomId,
  String myId,
  String uid2,
) {
  showModalBottomSheet(
    context: context,

    builder: (context) => chatSettings(context, roomId, myId, uid2),
  );
}

Widget chatSettings(
  BuildContext context,
  String roomId,
  String uid1,
  String uid2,
) {
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
          label: "View Profile",
          onTap: () async {
            Navigator.pop(context);
            UserModel user = await FirestoreMethods().getUserDetail(uid2).first;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserProfilePage(user: user, myId: uid1),
              ),
            );
          },
        ),
        OptionWidget(
          icon: Icons.notifications,
          label: "Mute Notifications",
          onTap: () {
            Navigator.pop(context);
          },
        ),
        OptionWidget(
          icon: Icons.delete,
          label: "Delete Chat",
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertWidget(
                  title: 'Delete Chat',
                  content: 'Are you sure you want to delete this chat?',
                  onPressed: () {
                    Navigator.pop(context);
                    FirestoreMethods().clearChatForUser(roomId, uid1);
                    Navigator.pop(context);
                  },
                );
              },
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
