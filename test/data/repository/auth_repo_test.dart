import 'package:firebase_auth_1/data/repository/auth_repo.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseMethods extends Mock implements FirebaseMethods {}

class MockFirestoreMethods extends Mock implements FirestoreMethods {}

void main() {
  late AuthRepo repo;
  late MockFirebaseMethods firebase;
  late MockFirestoreMethods firestore;

  setUp(() {
    firebase = MockFirebaseMethods();
    firestore = MockFirestoreMethods();
    repo = AuthRepo(firebase, firestore);
  });

  group('AuthRepo', () {
    group('Email Sign In', () {
      test('success', () async {
        when(
          () => firebase.emailSignIn(email: 'hi@gmail.com', password: 'hi1234'),
        ).thenAnswer((_) async {});

        await repo.emailSignIn(email: 'hi@gmail.com', password: 'hi1234');

        verify(
          () => firebase.emailSignIn(email: 'hi@gmail.com', password: 'hi1234'),
        ).called(1);
      });

      test('failure', () async {
        when(
          () => firebase.emailSignIn(email: 'hi@gmail.com', password: 'hi1234'),
        ).thenThrow(Exception());

        await expectLater(
          repo.emailSignIn(email: 'hi@gmail.com', password: 'hi1234'),
          throwsException,
        );

        verify(
          () => firebase.emailSignIn(email: 'hi@gmail.com', password: 'hi1234'),
        ).called(1);
      });
    });

    group('Google Sign In', () {
      test('success', () async {
        when(() => firebase.googleSignIn()).thenAnswer((_) async {});

        await repo.googleSignIn();

        verify(() => firebase.googleSignIn()).called(1);
      });

      test('failure', () async {
        when(() => firebase.googleSignIn()).thenThrow(Exception());

        await expectLater(repo.googleSignIn(), throwsException);

        verify(() => firebase.googleSignIn()).called(1);
      });
    });

    group('GitHub Sign In', () {
      test('success', () async {
        when(() => firebase.githubSignIn()).thenAnswer((_) async {});

        await repo.githubSignIn();

        verify(() => firebase.githubSignIn()).called(1);
      });

      test('failure', () async {
        when(() => firebase.githubSignIn()).thenThrow(Exception());

        await expectLater(repo.githubSignIn(), throwsException);

        verify(() => firebase.githubSignIn()).called(1);
      });
    });

    group('Logout', () {
      test('success', () async {
        when(() => firebase.logOut()).thenAnswer((_) async {});

        await repo.logOut();

        verify(() => firebase.logOut()).called(1);
      });

      test('failure', () async {
        when(() => firebase.logOut()).thenThrow(Exception());

        await expectLater(repo.logOut(), throwsException);

        verify(() => firebase.logOut()).called(1);
      });
    });

    group('Email Sign Up', () {
      test('success', () async {
        when(
          () => firebase.emailSignUp(email: 'hi@gmail.com', password: 'hi1234'),
        ).thenAnswer((_) async {});

        await repo.emailSignUp(email: 'hi@gmail.com', password: 'hi1234');

        verify(
          () => firebase.emailSignUp(email: 'hi@gmail.com', password: 'hi1234'),
        ).called(1);
      });

      test('failure', () async {
        when(
          () => firebase.emailSignUp(email: 'hi@gmail.com', password: 'hi1234'),
        ).thenThrow(Exception());

        await expectLater(
          repo.emailSignUp(email: 'hi@gmail.com', password: 'hi1234'),
          throwsException,
        );

        verify(
          () => firebase.emailSignUp(email: 'hi@gmail.com', password: 'hi1234'),
        ).called(1);
      });
    });

    group('Reset Password', () {
      test('success', () async {
        when(
          () => firebase.passwordReset(email: 'hi@gmail.com'),
        ).thenAnswer((_) async {});

        await repo.resetPassword(email: 'hi@gmail.com');

        verify(() => firebase.passwordReset(email: 'hi@gmail.com')).called(1);
      });

      test('failure', () async {
        when(
          () => firebase.passwordReset(email: 'hi@gmail.com'),
        ).thenThrow(Exception());

        await expectLater(
          repo.resetPassword(email: 'hi@gmail.com'),
          throwsException,
        );

        verify(() => firebase.passwordReset(email: 'hi@gmail.com')).called(1);
      });
    });

    group('Save Name', () {
      test('success', () async {
        when(() => firestore.updateUserName('dhruva')).thenAnswer((_) async {});

        await repo.saveName(name: 'dhruva');

        verify(() => firestore.updateUserName('dhruva')).called(1);
      });

      test('failure when empty name', () async {
        await expectLater(repo.saveName(name: ''), throwsA(isA<String>()));
      });
    });

    group('Delete Account - password', () {
      test('success', () async {
        when(
          () => firebase.deletePasswordUser('hi1234'),
        ).thenAnswer((_) async {});

        await repo.deleteAcc(password: 'hi1234', provider: 'password');

        verify(() => firebase.deletePasswordUser('hi1234')).called(1);
      });

      test('failure when password is null', () async {
        await expectLater(
          repo.deleteAcc(provider: 'password'),
          throwsA(isA<String>()),
        );
      });
    });

    group('Delete Account - Google', () {
      test('success', () async {
        when(() => firebase.deleteGoogleUser()).thenAnswer((_) async {});

        await repo.deleteAcc(provider: 'google.com');

        verify(() => firebase.deleteGoogleUser()).called(1);
      });

      test('failure', () async {
        when(() => firebase.deleteGoogleUser()).thenThrow(Exception());

        await expectLater(
          repo.deleteAcc(provider: 'google.com'),
          throwsException,
        );
      });
    });

    group('Delete Account - GitHub', () {
      test('success', () async {
        when(() => firebase.deleteGithubUser()).thenAnswer((_) async {});

        await repo.deleteAcc(provider: 'github.com');

        verify(() => firebase.deleteGithubUser()).called(1);
      });

      test('failure', () async {
        when(() => firebase.deleteGithubUser()).thenThrow(Exception());

        await expectLater(
          repo.deleteAcc(provider: 'github.com'),
          throwsException,
        );
      });
    });
  });
}
