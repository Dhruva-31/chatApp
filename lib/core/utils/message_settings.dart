import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/widgets/alert_widget.dart';
import 'package:firebase_auth_1/presentation/widgets/option_widget.dart';
import 'package:flutter/material.dart';

void showMessageSettings(
  BuildContext context,
  String roomId,
  String messageId,
  String uid1,
  String uid2,
  String senderId,
) {
  showModalBottomSheet(
    context: context,
    builder: (context) =>
        messageSettings(context, roomId, messageId, uid1, uid2, senderId),
  );
}

Widget messageSettings(
  BuildContext context,
  String roomId,
  String messageId,
  String uid1,
  String uid2,
  String senderId,
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
          icon: Icons.delete,
          label: "Delete for you",
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertWidget(
                  title: 'Delete Message',
                  content: 'Are you sure you want to delete this message?',
                  onPressed: () {
                    Navigator.pop(context);
                    FirestoreMethods().deleteMessage(
                      roomId: roomId,
                      messageId: messageId,
                      deleteForUser: uid1,
                    );
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),

        if (senderId == uid1)
          OptionWidget(
            icon: Icons.delete_forever,
            label: "Delete for everyone",
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertWidget(
                    title: 'Delete Message',
                    content: 'Are you sure you want to delete this message?',
                    onPressed: () {
                      Navigator.pop(context);
                      FirestoreMethods().deleteMessage(
                        roomId: roomId,
                        messageId: messageId,
                      );
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
