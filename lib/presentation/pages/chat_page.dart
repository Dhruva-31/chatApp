// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth_1/presentation/widgets/message_list_widget.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth_1/core/utils/chat_settings.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/pages/UserProfilePage.dart';
import 'package:firebase_auth_1/presentation/widgets/textfield_widget.dart';

class ChatPage extends StatefulWidget {
  final UserModel secondUser;
  final String myId;
  final FirestoreMethods firestoreMethods;
  const ChatPage({
    super.key,
    required this.secondUser,
    required this.myId,
    required this.firestoreMethods,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController messageController = TextEditingController();
  late String roomId;
  StreamSubscription? _messageSubscription;
  bool _isInForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    roomId = widget.firestoreMethods.generateRoomId(
      widget.myId,
      widget.secondUser.uid,
    );
    widget.firestoreMethods.resetUnseenCount(roomId, widget.myId);
    _startListeningForNewMessages();
    messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isInForeground = state == AppLifecycleState.resumed;
    if (_isInForeground) {
      widget.firestoreMethods.resetUnseenCount(roomId, widget.myId);
    }
  }

  void _startListeningForNewMessages() {
    _messageSubscription = widget.firestoreMethods
        .getMessages(roomId: roomId, uid: widget.myId)
        .listen((messages) {
          if (!_isInForeground) return;

          widget.firestoreMethods.resetUnseenCount(roomId, widget.myId);
          final unseenMessages = messages.where(
            (m) => m.senderId == widget.secondUser.uid && !m.isSeen,
          );
          if (unseenMessages.isNotEmpty) {
            widget.firestoreMethods.markMessageAsSeen(
              roomId,
              widget.secondUser.uid,
            );
          }
        });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageSubscription?.cancel();
    messageController.dispose();
    widget.firestoreMethods.updateUserTyping('');
    super.dispose();
  }

  bool checkDayChanged(int day) {
    if (DateTime.now().day != day) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.secondUser;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        titleSpacing: 0,
        toolbarHeight: 60,
        title: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  UserProfilePage(user: userData, myId: widget.myId),
            ),
          ),
          child: StreamBuilder(
            stream: widget.firestoreMethods.getUserDetail(userData.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!;
              final isOnline = data.isOnline;
              final lastSeen = data.lastSeen;
              final name = data.name;
              final profilePic = data.profilePic;

              return Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: profilePic,
                    placeholder: (context, url) => CircleAvatar(
                      radius: 18,
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey.shade300,
                      child: Icon(
                        Icons.person,
                        size: 18,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 18,
                      backgroundImage: imageProvider,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      data.typingTo == widget.myId
                          ? Text(
                              'typing...',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: Colors.green,
                                    fontStyle: FontStyle.italic,
                                  ),
                            )
                          : Text(
                              isOnline
                                  ? 'online'
                                  : 'last seen ${lastSeen.hour.toString().padLeft(2, '0')}:${lastSeen.minute.toString().padLeft(2, '0')} ${checkDayChanged(lastSeen.day) ? 'on ${lastSeen.day}' : 'today'}',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(color: Colors.white70),
                            ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () =>
                showChatOptions(context, roomId, widget.myId, userData.uid),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: MessageListWidget(
                firestoreMethods: widget.firestoreMethods,
                roomId: roomId,
                myId: widget.myId,
                otherUserId: userData.uid,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextfieldWidget(
                    controller: messageController,
                    maxLines: 5,
                    minLines: 1,
                    borderRaidus: 20,
                    onChanged: (value) {
                      widget.firestoreMethods.updateUserTyping(
                        value.isNotEmpty ? userData.uid : '',
                      );
                    },
                  ),
                ),

                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: messageController.text.isEmpty
                        ? const Color.fromARGB(255, 169, 168, 169)
                        : const Color(0xFF6C63FF),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (messageController.text.trim().isEmpty) return;
                      widget.firestoreMethods.sendMessage(
                        text: messageController.text.trim(),
                        uid1: widget.myId,
                        uid2: userData.uid,
                      );
                      messageController.clear();
                    },
                    icon: Icon(Icons.send, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
