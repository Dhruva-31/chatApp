// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:firebase_auth_1/data/model/chatroom_model.dart';
import 'package:firebase_auth_1/data/repository/chat_repo.dart';
import 'package:firebase_auth_1/data/repository/user_repo.dart';
import 'package:firebase_auth_1/presentation/pages/chat_page.dart';
import 'package:firebase_auth_1/presentation/widgets/user_card_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final String myId;
  const HomePage({super.key, required this.myId});

  @override
  Widget build(BuildContext context) {
    final ChatRepo chatRepo = context.read<ChatRepo>();
    final UserRepo userRepo = context.read<UserRepo>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Chats',
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: Colors.white),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: chatRepo.getChatRooms(myId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No chats yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          final chatRooms = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                final ChatRoomModel chatRoom = chatRooms[index];
                final secondUserId = chatRepo.getOtherParticipantId(
                  myId,
                  chatRoom.participants,
                );
                return StreamBuilder(
                  stream: userRepo.getUserDetail(secondUserId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final toUserData = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  secondUser: toUserData,
                                  myId: myId,
                                ),
                              ),
                            );
                          },
                          child: UserCardWidget(
                            myId: myId,
                            user: toUserData!,
                            chatroom: chatRoom,
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
