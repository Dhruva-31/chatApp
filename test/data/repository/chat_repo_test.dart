import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:firebase_auth_1/data/model/chatroom_model.dart';
import 'package:firebase_auth_1/data/model/message_model.dart';
import 'package:firebase_auth_1/data/repository/chat_repo.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';

class MockFirestoreMethods extends Mock implements FirestoreMethods {}

void main() {
  late MockFirestoreMethods mockFirestore;
  late ChatRepo chatRepo;

  setUp(() {
    mockFirestore = MockFirestoreMethods();
    chatRepo = ChatRepo(firestoreMethods: mockFirestore);
  });

  group('ChatRepo test - ', () {
    test('generateRoomId test', () {
      final id = chatRepo.generateRoomId('b', 'a');
      expect(id, 'a_b');
    });

    test('getOtherParticipantId test', () {
      final other = chatRepo.getOtherParticipantId('1', ['1', '2']);
      expect(other, '2');
    });

    test('hasChatRooms test', () {
      expect(chatRepo.hasChatRooms(null), false);
      expect(chatRepo.hasChatRooms([]), false);
      expect(chatRepo.hasChatRooms([1]), true);
    });

    test('isMessageValid test', () {
      expect(chatRepo.isMessageValid('   '), false);
      expect(chatRepo.isMessageValid('hi'), true);
    });

    test('checkDayChanged test', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(chatRepo.checkDayChanged(yesterday), true);
    });

    test('formatMessageTime test', () {
      final date = DateTime(2024, 1, 1, 9, 5);
      expect(chatRepo.formatMessageTime(date), '09:05');
    });

    test('getUnseenMessages test', () {
      final messages = [
        MessageModel(
          messageId: '1',
          text: 'hi',
          senderId: '2',
          isSeen: false,
          createdAt: DateTime.now(),
        ),
        MessageModel(
          messageId: '2',
          text: 'yo',
          senderId: '2',
          isSeen: true,
          createdAt: DateTime.now(),
        ),
      ];

      final unseen = chatRepo.getUnseenMessages(messages, '2');
      expect(unseen.length, 1);
    });

    test('getStatusText test typing', () {
      final text = chatRepo.getStatusText(
        isOnline: true,
        typingTo: 'me',
        myId: 'me',
        lastSeen: DateTime.now(),
      );

      expect(text, 'typing...');
    });

    test('getStatusText test online', () {
      final text = chatRepo.getStatusText(
        isOnline: true,
        typingTo: '',
        myId: 'me',
        lastSeen: DateTime.now(),
      );

      expect(text, 'online');
    });
  });

  group('ChatRepo firestore test - ', () {
    test('getChatRooms delegates to firestore', () {
      when(
        () => mockFirestore.getChatRooms('1'),
      ).thenAnswer((_) => Stream.value(<ChatRoomModel>[]));

      final stream = chatRepo.getChatRooms('1');

      expect(stream, isA<Stream<List<ChatRoomModel>>>());
      verify(() => mockFirestore.getChatRooms('1')).called(1);
    });

    test('sendMessage test', () async {
      when(
        () => mockFirestore.sendMessage(
          text: any(named: 'text'),
          uid1: any(named: 'uid1'),
          uid2: any(named: 'uid2'),
        ),
      ).thenAnswer((_) async {});

      await chatRepo.sendMessage(text: 'hello', uid1: '1', uid2: '2');

      verify(
        () => mockFirestore.sendMessage(text: 'hello', uid1: '1', uid2: '2'),
      ).called(1);
    });

    test('resetUnseenCount test', () async {
      when(
        () => mockFirestore.resetUnseenCount('room', '1'),
      ).thenAnswer((_) async {});

      await chatRepo.resetUnseenCount('room', '1');

      verify(() => mockFirestore.resetUnseenCount('room', '1')).called(1);
    });

    test('markMessageAsSeen test', () async {
      when(
        () => mockFirestore.markMessageAsSeen('room', '2'),
      ).thenAnswer((_) async {});

      await chatRepo.markMessageAsSeen('room', '2');

      verify(() => mockFirestore.markMessageAsSeen('room', '2')).called(1);
    });

    test('clearChatForUser test', () {
      when(
        () => mockFirestore.clearChatForUser('room', '1'),
      ).thenAnswer((_) async {});

      chatRepo.clearChatForUser('room', '1');

      verify(() => mockFirestore.clearChatForUser('room', '1')).called(1);
    });

    test('deleteMessage test', () {
      when(
        () => mockFirestore.deleteMessage(roomId: 'room', messageId: 'msg'),
      ).thenAnswer((_) async {});

      chatRepo.deleteMessage(roomId: 'room', messageId: 'msg');

      verify(
        () => mockFirestore.deleteMessage(roomId: 'room', messageId: 'msg'),
      ).called(1);
    });
  });

  group('ChatRepo combined test', () {
    test('handleSendMessage sends and clears input test', () {
      bool cleared = false;

      when(
        () => mockFirestore.sendMessage(
          text: any(named: 'text'),
          uid1: any(named: 'uid1'),
          uid2: any(named: 'uid2'),
        ),
      ).thenAnswer((_) async {});

      chatRepo.handleSendMessage(
        message: 'hello',
        myId: '1',
        otherUserId: '2',
        onMessageSent: () => cleared = true,
      );

      expect(cleared, true);
    });

    test('handleMessagesSeen marks messages when foreground test', () async {
      final messages = [
        MessageModel(
          messageId: '1',
          text: 'hi',
          senderId: '2',
          isSeen: false,
          createdAt: DateTime.now(),
        ),
      ];

      when(
        () => mockFirestore.resetUnseenCount(any(), any()),
      ).thenAnswer((_) async {});
      when(
        () => mockFirestore.markMessageAsSeen(any(), any()),
      ).thenAnswer((_) async {});

      chatRepo.handleMessagesSeen(
        messages: messages,
        roomId: 'room',
        myId: '1',
        otherUserId: '2',
        isInForeground: true,
      );

      verify(() => mockFirestore.resetUnseenCount('room', '1')).called(1);
      verify(() => mockFirestore.markMessageAsSeen('room', '2')).called(1);
    });
  });
}
