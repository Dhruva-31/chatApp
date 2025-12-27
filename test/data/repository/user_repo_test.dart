import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/repository/user_repo.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirestoreMethods extends Mock implements FirestoreMethods {}

void main() {
  late MockFirestoreMethods mockFirestore;
  late UserRepo userRepo;

  setUp(() {
    mockFirestore = MockFirestoreMethods();
    userRepo = UserRepo(firestoreMethods: mockFirestore);
  });
  group('UserRepo test - ', () {
    test('getUserDetails test', () {
      final user = UserModel(
        uid: '1',
        name: 'Test',
        email: 'test@test.com',
        profilePic: '',
        isOnline: true,
        fcmToken: '',
        lastSeen: DateTime.now(),
        createdAt: DateTime.now(),
      );
      when(
        () => mockFirestore.getUserDetail('1'),
      ).thenAnswer((_) => Stream.value(user));

      final stream = userRepo.getUserDetail('1');

      expect(stream, isA<Stream<UserModel>>());
      verify(() => mockFirestore.getUserDetail('1')).called(1);
    });
    test('updateUserTyping test', () async {
      when(() => mockFirestore.updateUserTyping('2')).thenAnswer((_) async {});

      await userRepo.updateUserTyping('2');

      verify(() => mockFirestore.updateUserTyping('2')).called(1);
    });

    test('clearTypingStatus test', () async {
      when(() => mockFirestore.updateUserTyping('')).thenAnswer((_) async {});

      await userRepo.clearTypingStatus();

      verify(() => mockFirestore.updateUserTyping('')).called(1);
    });

    test('getUsers test', () {
      when(
        () => mockFirestore.getUsers('1'),
      ).thenAnswer((_) => Stream.value(<UserModel>[]));

      final stream = userRepo.getUsers('1');

      expect(stream, isA<Stream<List<UserModel>>>());
      verify(() => mockFirestore.getUsers('1')).called(1);
    });

    test('updateUserOnLogin test', () async {
      when(() => mockFirestore.updateUserOnLogin('1')).thenAnswer((_) async {});

      await userRepo.updateUserOnLogin('1');

      verify(() => mockFirestore.updateUserOnLogin('1')).called(1);
    });
  });
}
