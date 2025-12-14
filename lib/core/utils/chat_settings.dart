import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/widgets/option_widget.dart';
import 'package:flutter/material.dart';

void showChatOptions(BuildContext context, String roomId, String uid) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.blueGrey,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => chatSettings(context, roomId, uid),
  );
}

Widget chatSettings(BuildContext context, String roomId, String uid) {
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
          onTap: () {
            Navigator.pop(context);
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
            FirestoreMethods().deleteChatForUser(roomId, uid);
            Navigator.pop(context);
          },
        ),
        SizedBox(height: 10),
      ],
    ),
  );
}
