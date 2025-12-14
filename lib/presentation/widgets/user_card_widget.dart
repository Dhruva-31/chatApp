import 'package:firebase_auth_1/data/model/chatroom_model.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:flutter/material.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel user;
  final ChatRoomModel? chatroom;

  UserCardWidget({super.key, required this.user, this.chatroom});

  String shrink(String text, int max) {
    if (text.length <= max) return text;
    return "${text.substring(0, max)}...";
  }

  final myId = FirebaseMethods().currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> messageDetails =
        chatroom?.lastMessageFor[myId] ?? {"text": "", "at": 0};
    final String text = messageDetails["text"] ?? "";
    final int at = messageDetails["at"] ?? 0;
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(at);
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: chatroom != null ? 80 : 60,
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: user.profilePic.isNotEmpty
                  ? NetworkImage(user.profilePic)
                  : null,
              child: user.profilePic.isEmpty
                  ? Icon(Icons.person, size: 28, color: Colors.grey.shade700)
                  : null,
            ),
            SizedBox(width: 15),
            Expanded(
              child: chatroom == null
                  ? Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        text.isNotEmpty
                            ? Text(
                                user.typingTo.isEmpty
                                    ? shrink(messageDetails['text'], 25)
                                    : 'typing...',
                                style: TextStyle(color: Colors.grey[700]),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
            ),
            if (chatroom != null)
              Text(
                "${time.hour.toString().padLeft(2, '0')}:"
                "${time.minute.toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }
}
