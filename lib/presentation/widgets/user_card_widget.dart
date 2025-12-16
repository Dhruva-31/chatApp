import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth_1/data/model/chatroom_model.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:flutter/material.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel user;
  final ChatRoomModel? chatroom;

  const UserCardWidget({super.key, required this.user, this.chatroom});

  String shrink(String text, int max) {
    if (text.length <= max) return text;
    return "${text.substring(0, max)}...";
  }

  @override
  Widget build(BuildContext context) {
    final myId = FirebaseMethods().currentUser!.uid;
    final Map<String, dynamic> messageDetails =
        chatroom?.lastMessageFor[myId] ?? {"text": "", "at": 0};
    final String text = messageDetails["text"] ?? "";
    final int at = messageDetails["at"] ?? 0;
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(at);
    final int count = chatroom?.unseenCount[myId] ?? 0;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: chatroom != null ? 80 : 60,
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: user.profilePic,
              placeholder: (context, url) =>
                  CircleAvatar(radius: 25, child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey.shade300,
                child: Icon(
                  Icons.person,
                  size: 28,
                  color: Colors.grey.shade700,
                ),
              ),
              imageBuilder: (context, imageProvider) =>
                  CircleAvatar(radius: 25, backgroundImage: imageProvider),
            ),
            SizedBox(width: 15),
            Expanded(
              child: chatroom == null
                  ? Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 4),
                        user.typingTo == myId
                            ? Text(
                                'typing...',
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: Colors.green,
                                      fontStyle: FontStyle.italic,
                                    ),
                              )
                            : text.isNotEmpty
                            ? Text(
                                text,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
            ),
            if (chatroom != null) ...[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (count > 0)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  Text(
                    "${time.hour.toString().padLeft(2, '0')}:"
                    "${time.minute.toString().padLeft(2, '0')}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ] else ...[
              Text(
                user.isOnline
                    ? 'online'
                    : 'last seen at ${user.lastSeen.hour.toString().padLeft(2, '0')}:${user.lastSeen.minute.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: user.isOnline
                      ? const Color.fromARGB(255, 5, 253, 13)
                      : Colors.white70,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
