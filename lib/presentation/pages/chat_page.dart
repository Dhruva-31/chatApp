// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth_1/data/repository/chat_repo.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth_1/core/utils/chat_settings.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/repository/user_repo.dart';
import 'package:firebase_auth_1/presentation/pages/UserProfilePage.dart';
import 'package:firebase_auth_1/presentation/widgets/message_list_widget.dart';
import 'package:firebase_auth_1/presentation/widgets/textfield_widget.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final UserModel secondUser;
  final String myId;

  const ChatPage({super.key, required this.secondUser, required this.myId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController messageController = TextEditingController();
  late String roomId;
  late ChatRepo chatRepo;
  late UserRepo userRepo;
  StreamSubscription? _messageSubscription;
  bool _isInForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    chatRepo = context.read<ChatRepo>();
    userRepo = context.read<UserRepo>();
    roomId = chatRepo.generateRoomId(widget.myId, widget.secondUser.uid);
    chatRepo.resetUnseenCount(roomId, widget.myId);
    _startListeningForNewMessages();
    messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isInForeground = state == AppLifecycleState.resumed;
    if (_isInForeground) {
      chatRepo.resetUnseenCount(roomId, widget.myId);
    }
  }

  void _startListeningForNewMessages() {
    _messageSubscription = chatRepo
        .getMessages(roomId: roomId, uid: widget.myId)
        .listen((messages) {
          chatRepo.handleMessagesSeen(
            messages: messages,
            roomId: roomId,
            myId: widget.myId,
            otherUserId: widget.secondUser.uid,
            isInForeground: _isInForeground,
          );
        });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageSubscription?.cancel();
    messageController.dispose();
    userRepo.clearTypingStatus();
    super.dispose();
  }

  void _handleSendMessage() {
    chatRepo.handleSendMessage(
      message: messageController.text,
      myId: widget.myId,
      otherUserId: widget.secondUser.uid,
      onMessageSent: () => messageController.clear(),
    );
  }

  void _handleTypingChange(String value) {
    userRepo.updateUserTyping(value.isNotEmpty ? widget.secondUser.uid : '');
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
            stream: userRepo.getUserDetail(userData.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final UserModel data = snapshot.data!;
              final statusText = chatRepo.getStatusText(
                isOnline: data.isOnline,
                typingTo: data.typingTo,
                myId: widget.myId,
                lastSeen: data.lastSeen,
              );
              final isTyping = data.typingTo == widget.myId;
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
                      Text(
                        statusText,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: isTyping ? Colors.green : Colors.white70,
                          fontStyle: isTyping
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
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
                    onChanged: _handleTypingChange,
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
                    onPressed: _handleSendMessage,
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
