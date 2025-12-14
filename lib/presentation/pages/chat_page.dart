import 'dart:async';
import 'package:firebase_auth_1/core/utils/chat_settings.dart';
import 'package:firebase_auth_1/core/utils/message_settings.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final UserModel secondUser;
  const ChatPage({super.key, required this.secondUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController messageController = TextEditingController();
  final myId = FirebaseMethods().currentUser!.uid;
  late String roomId;
  StreamSubscription? _messageSubscription;
  bool _isInForeground = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    roomId = FirestoreMethods().generateRoomId(myId, widget.secondUser.uid);
    FirestoreMethods().markMessageAsSeen(roomId, widget.secondUser.uid);
    _startListeningForNewMessages();
    messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isInForeground = state == AppLifecycleState.resumed;

    if (_isInForeground) {
      FirestoreMethods().markMessageAsSeen(roomId, widget.secondUser.uid);
    }
  }

  void _startListeningForNewMessages() {
    _messageSubscription = FirestoreMethods()
        .getMessages(roomId: roomId, uid: myId)
        .listen((messages) {
          if (_isInForeground) {
            final unseenMessages = messages
                .where((m) => m.senderId == widget.secondUser.uid && !m.isSeen)
                .toList();

            if (unseenMessages.isNotEmpty) {
              FirestoreMethods().markMessageAsSeen(
                roomId,
                widget.secondUser.uid,
              );
            }
          }
        });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageSubscription?.cancel();
    messageController.dispose();
    FirestoreMethods().updateUserTyping('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.secondUser;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 40),
        child: StreamBuilder(
          stream: FirestoreMethods().getUserDetail(userData.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return AppBar(title: Center(child: CircularProgressIndicator()));
            }

            final data = snapshot.data!;
            final isOnline = data.isOnline;
            final lastSeen = data.lastSeen;
            final name = data.name;
            final profilePic = data.profilePic;

            return AppBar(
              leadingWidth: 40,
              titleSpacing: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: profilePic.isNotEmpty
                        ? NetworkImage(profilePic)
                        : null,
                    child: (profilePic.isEmpty)
                        ? Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey.shade700,
                          )
                        : null,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      data.typingTo == myId
                          ? Text(
                              'typing...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                          : Text(
                              isOnline
                                  ? 'online'
                                  : 'last seen at ${lastSeen.hour.toString().padLeft(2, '0')}:${lastSeen.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () => showChatOptions(context, roomId, myId),
                ),
              ],
            );
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder(
              stream: FirestoreMethods().getMessages(roomId: roomId, uid: myId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                }

                final messages = snapshot.data!;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];

                        return GestureDetector(
                          onLongPress: () {
                            showMessageSettings(
                              context,
                              roomId,
                              message.messageId,
                              myId,
                              userData.uid,
                              message.senderId,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Align(
                              alignment: message.senderId == myId
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: message.senderId == myId
                                            ? Colors.greenAccent
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            message.text,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${message.createdAt.hour.toString().padLeft(2, '0')}:"
                                          "${message.createdAt.minute.toString().padLeft(2, '0')}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        if (message.senderId == myId)
                                          Icon(
                                            message.isSeen
                                                ? Icons.done_all
                                                : Icons.done,
                                            size: 18,
                                            color: message.isSeen
                                                ? Colors.blue
                                                : Colors.white,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: TextStyle(color: Colors.white),
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(101, 217, 209, 217),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 169, 168, 169),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 169, 168, 169),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    cursorColor: Colors.white,
                    onChanged: (value) {
                      FirestoreMethods().updateUserTyping(
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
                        : Colors.greenAccent,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (messageController.text.trim().isEmpty) return;
                      FirestoreMethods().sendMessage(
                        text: messageController.text.trim(),
                        uid1: myId,
                        uid2: userData.uid,
                      );
                      messageController.clear();
                    },
                    icon: Icon(Icons.send),
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
