import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_1/data/repository/auth_repo.dart';
import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
  });
  group('AuthBloc test - ', () {
    group('Email Sign In - ', () {
      blocTest<AuthBloc, AuthState>(
        'when email signIn is successful',
        setUp: () => when(
          () => mockAuthRepo.emailSignIn(
            email: 'hi@gmail.com',
            password: 'hi1234',
          ),
        ).thenAnswer((_) async {}),

        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(
          SignInButtonClickedEvent(email: 'hi@gmail.com', password: 'hi1234'),
        ),
        expect: () => [isA<AuthSuccessState>()],
        skip: 1,
        verify: (_) {
          verify(
            () => mockAuthRepo.emailSignIn(
              email: 'hi@gmail.com',
              password: 'hi1234',
            ),
          ).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'when email signIn is failure',
        setUp: () =>
            when(
              () => mockAuthRepo.emailSignIn(
                email: 'hi@gmail.com',
                password: 'hi1234',
              ),
            ).thenAnswer((_) async {
              throw Error();
            }),

        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(
          SignInButtonClickedEvent(email: 'hi@gmail.com', password: 'hi1234'),
        ),
        expect: () => [isA<AuthFailureState>()],
        skip: 1,
        verify: (_) {
          verify(
            () => mockAuthRepo.emailSignIn(
              email: 'hi@gmail.com',
              password: 'hi1234',
            ),
          ).called(1);
        },
      );
    });

    group('Google Sign In - ', () {
      blocTest(
        'when google sign in is successful',
        setUp: () =>
            when(() => mockAuthRepo.googleSignIn()).thenAnswer((_) async {}),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(GoogleSignInButtonClickedEvent()),
        skip: 1,
        expect: () => [isA<AuthSuccessState>()],
        verify: (_) {
          verify(() => mockAuthRepo.googleSignIn()).called(1);
        },
      );

      blocTest(
        'when google sign in is failure',
        setUp: () =>
            when(() => mockAuthRepo.googleSignIn()).thenAnswer((_) async {
              throw Error();
            }),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(GoogleSignInButtonClickedEvent()),
        skip: 1,
        expect: () => [isA<AuthFailureState>()],
        verify: (_) {
          verify(() => mockAuthRepo.googleSignIn()).called(1);
        },
      );
    });

    group('Github Sign In - ', () {
      blocTest(
        'when github sign in is successful',
        setUp: () =>
            when(() => mockAuthRepo.githubSignIn()).thenAnswer((_) async {}),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(GitHubSignInButtonClickedEvent()),
        skip: 1,
        expect: () => [isA<AuthSuccessState>()],
        verify: (_) {
          verify(() => mockAuthRepo.githubSignIn()).called(1);
        },
      );

      blocTest(
        'when github sign in is failure',
        setUp: () =>
            when(() => mockAuthRepo.githubSignIn()).thenAnswer((_) async {
              throw Error();
            }),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(GitHubSignInButtonClickedEvent()),
        skip: 1,
        expect: () => [isA<AuthFailureState>()],
        verify: (_) {
          verify(() => mockAuthRepo.githubSignIn()).called(1);
        },
      );
    });
    group('Acc LogOut - ', () {
      blocTest(
        'when log out is successful',
        setUp: () => when(() => mockAuthRepo.logOut()).thenAnswer((_) async {}),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(LogOutButtonClickedEvent()),
        skip: 1,
        expect: () => [isA<AuthInitial>()],
        verify: (_) {
          verify(() => mockAuthRepo.logOut()).called(1);
        },
      );

      blocTest(
        'when log out is failure',
        setUp: () => when(() => mockAuthRepo.logOut()).thenAnswer((_) async {
          throw Error();
        }),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(LogOutButtonClickedEvent()),
        skip: 1,
        expect: () => [isA<AuthFailureState>()],
        verify: (_) {
          verify(() => mockAuthRepo.logOut()).called(1);
        },
      );
    });

    group('Acc Deletion - ', () {
      blocTest(
        'when deletion(password) is success',
        setUp: () => when(
          () =>
              mockAuthRepo.deleteAcc(password: 'hi1234', provider: 'password'),
        ).thenAnswer((_) async {}),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(
          DeleteAccountButtonClickedEvent(
            password: 'hi1234',
            provider: 'password',
          ),
        ),
        skip: 1,
        expect: () => [isA<AccountDeletedState>()],
        verify: (_) {
          verify(
            () => mockAuthRepo.deleteAcc(
              password: 'hi1234',
              provider: 'password',
            ),
          ).called(1);
        },
      );
      blocTest(
        'when deletion(password) is failure due to null password',
        setUp: () =>
            when(
              () =>
                  mockAuthRepo.deleteAcc(password: null, provider: 'password'),
            ).thenAnswer((_) async {
              throw Error();
            }),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(
          DeleteAccountButtonClickedEvent(password: null, provider: 'password'),
        ),
        skip: 1,
        expect: () => [isA<AuthFailureState>()],
      );

      blocTest(
        'when deletion(google) is success',
        setUp: () => when(
          () => mockAuthRepo.deleteAcc(provider: 'google.com'),
        ).thenAnswer((_) async {}),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) =>
            bloc.add(DeleteAccountButtonClickedEvent(provider: 'google.com')),
        skip: 1,
        expect: () => [isA<AccountDeletedState>()],
      );

      blocTest(
        'when deletion(github) is success',
        setUp: () => when(
          () => mockAuthRepo.deleteAcc(provider: 'github.com'),
        ).thenAnswer((_) async {}),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) =>
            bloc.add(DeleteAccountButtonClickedEvent(provider: 'github.com')),
        skip: 1,
        expect: () => [isA<AccountDeletedState>()],
      );

      blocTest(
        'when deletion is failure',
        setUp: () => when(() => mockAuthRepo.deleteAcc(provider: 'password'))
            .thenAnswer((_) async {
              throw Error();
            }),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(
          DeleteAccountButtonClickedEvent(
            password: 'hi1234',
            provider: 'password',
          ),
        ),
        skip: 1,
        expect: () => [isA<AuthFailureState>()],
      );
    });

    group('Email Sign Up - ', () {
      blocTest<AuthBloc, AuthState>(
        'when email sign up is successful',
        setUp: () => when(
          () => mockAuthRepo.emailSignUp(
            email: 'hi@gmail.com',
            password: 'hi1234',
          ),
        ).thenAnswer((_) async {}),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(
          RealSignUpButtonClickedEvent(
            email: 'hi@gmail.com',
            password: 'hi1234',
          ),
        ),
        skip: 1,
        expect: () => [isA<AuthSignUpSuccessState>()],
        verify: (_) {
          verify(
            () => mockAuthRepo.emailSignUp(
              email: 'hi@gmail.com',
              password: 'hi1234',
            ),
          ).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'when email sign up is failure',
        setUp: () =>
            when(
              () => mockAuthRepo.emailSignUp(
                email: 'hi@gmail.com',
                password: 'hi1234',
              ),
            ).thenAnswer((_) async {
              throw Error();
            }),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(
          RealSignUpButtonClickedEvent(
            email: 'hi@gmail.com',
            password: 'hi1234',
          ),
        ),
        skip: 1,
        expect: () => [isA<AuthFailureState>()],
      );
    });

    group('Reset password - ', () {
      blocTest<AuthBloc, AuthState>(
        'when reset password is successful',
        setUp: () => when(
          () => mockAuthRepo.resetPassword(email: 'hi@gmail.com'),
        ).thenAnswer((_) async {}),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(ResetButtonClickedEvent(email: 'hi@gmail.com')),
        skip: 1,
        expect: () => [isA<AuthInitial>()],
        verify: (_) {
          verify(
            () => mockAuthRepo.resetPassword(email: 'hi@gmail.com'),
          ).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'when reset passord is failure',
        setUp: () =>
            when(
              () => mockAuthRepo.resetPassword(email: 'hi@gmail.com'),
            ).thenAnswer((_) async {
              throw Error();
            }),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(ResetButtonClickedEvent(email: 'hi@gmail.com')),
        skip: 1,
        expect: () => [isA<AuthFailureState>()],
      );
    });

    group('Save name - ', () {
      blocTest<AuthBloc, AuthState>(
        'when saving name is successful',
        setUp: () => when(
          () => mockAuthRepo.saveName(name: 'dhruva'),
        ).thenAnswer((_) async {}),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(ProceedButtonClickedEvent(name: 'dhruva')),
        skip: 1,
        expect: () => [isA<AuthFinishedState>()],
        verify: (_) {
          verify(() => mockAuthRepo.saveName(name: 'dhruva')).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'when saving name is failure',
        setUp: () => when(() => mockAuthRepo.saveName(name: 'dhruva'))
            .thenAnswer((_) async {
              throw Error();
            }),
        build: () => AuthBloc(mockAuthRepo),
        act: (bloc) => bloc.add(ProceedButtonClickedEvent(name: 'dhruva')),
        skip: 1,
        expect: () => [isA<AuthFailureState>()],
      );
    });
  });
}
