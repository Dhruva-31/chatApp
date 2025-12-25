// message_list_widget.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth_1/data/model/message_model.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/core/utils/message_settings.dart';

class MessageListWidget extends StatelessWidget {
  final FirestoreMethods firestoreMethods;
  final String roomId;
  final String myId;
  final String otherUserId;

  const MessageListWidget({
    super.key,
    required this.firestoreMethods,
    required this.roomId,
    required this.myId,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: firestoreMethods.getMessages(roomId: roomId, uid: myId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Center(
              child: Text(
                'No messages yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        final messages = snapshot.data!;
        return Padding(
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
                    otherUserId,
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
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: message.senderId == myId
                                  ? const Color(0xFF6C63FF)
                                  : const Color.fromARGB(133, 72, 72, 72),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message.text,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${message.createdAt.hour.toString().padLeft(2, '0')}:"
                                "${message.createdAt.minute.toString().padLeft(2, '0')}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(width: 5),
                              if (message.senderId == myId)
                                Icon(
                                  message.isSeen ? Icons.done_all : Icons.done,
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
        );
      },
    );
  }
}
