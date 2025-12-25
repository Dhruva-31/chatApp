import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:firebase_auth_1/presentation/pages/auth_pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mocktail/mocktail.dart';

/// --------------------
/// Mock & Fake classes
/// --------------------

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  testWidgets('LogInPage shows Sign In UI when state is AuthInitialState', (
    WidgetTester tester,
  ) async {
    final mockAuthBloc = MockAuthBloc();

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LogInPage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byIcon(Icons.arrow_forward_outlined), findsOneWidget);
  });

  testWidgets(
    'LogInPage shows loading indicator when state is AuthLoadingState',
    (WidgetTester tester) async {
      final mockAuthBloc = MockAuthBloc();

      when(() => mockAuthBloc.state).thenReturn(AuthLoadingState());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LogInPage(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('tapping Sign In button', (WidgetTester tester) async {
    final mockAuthBloc = MockAuthBloc();

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LogInPage(),
        ),
      ),
    );
    //INITIAl
    expect(find.text('Welcome Back!'), findsOneWidget);

    await tester.pump();

    // Tap Sign In button
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    // Verify event was added
    verify(
      () => mockAuthBloc.add(any(that: isA<SignInButtonClickedEvent>())),
    ).called(1);
  });

  testWidgets('tapping Sign Up button', (WidgetTester tester) async {
    final mockAuthBloc = MockAuthBloc();

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LogInPage(),
        ),
      ),
    );
    //INITIAl
    expect(find.text('Welcome Back!'), findsOneWidget);

    await tester.pump();

    // Tap Sign In button
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    // Verify event was added
    verify(
      () => mockAuthBloc.add(any(that: isA<HomeSignUpButtonClickedEvent>())),
    ).called(1);
  });

  testWidgets('tapping Google button', (WidgetTester tester) async {
    final mockAuthBloc = MockAuthBloc();

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LogInPage(),
        ),
      ),
    );
    //INITIAl
    expect(find.text('Welcome Back!'), findsOneWidget);

    await tester.pump();

    // Tap Sign In button
    await tester.tap(find.byIcon(FontAwesomeIcons.google));
    await tester.pump();

    // Verify event was added
    verify(
      () => mockAuthBloc.add(any(that: isA<GoogleSignInButtonClickedEvent>())),
    ).called(1);
  });

  testWidgets('tapping Github button', (WidgetTester tester) async {
    final mockAuthBloc = MockAuthBloc();

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LogInPage(),
        ),
      ),
    );
    //INITIAl
    expect(find.text('Welcome Back!'), findsOneWidget);

    await tester.pump();

    // Tap Sign In button
    await tester.tap(find.byIcon(FontAwesomeIcons.github));
    await tester.pump();

    // Verify event was added
    verify(
      () => mockAuthBloc.add(any(that: isA<GitHubSignInButtonClickedEvent>())),
    ).called(1);
  });

  testWidgets('tapping forgot password button', (WidgetTester tester) async {
    final mockAuthBloc = MockAuthBloc();

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LogInPage(),
        ),
      ),
    );
    //INITIAl
    expect(find.text('Welcome Back!'), findsOneWidget);

    await tester.pump();

    // Tap Sign In button
    await tester.tap(find.text('Forgot Password?'));
    await tester.pump();

    // Verify event was added
    verify(
      () =>
          mockAuthBloc.add(any(that: isA<ForgotPasswordButtonClickedEvent>())),
    ).called(1);
  });

  testWidgets('scaffold error testing', (WidgetTester tester) async {
    final mockAuthBloc = MockAuthBloc();

    when(
      () => mockAuthBloc.state,
    ).thenReturn(AuthFailureState(errorMessage: 'error'));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LogInPage(),
        ),
      ),
    );

    expect(find.byType(ScaffoldMessenger), findsOneWidget);
  });
}
