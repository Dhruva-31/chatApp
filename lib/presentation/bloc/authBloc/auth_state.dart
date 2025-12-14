part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSuccessState extends AuthState {}

final class AuthFailureState extends AuthState {
  final String errorMessage;

  AuthFailureState({required this.errorMessage});
}

final class AuthShowSignUpPageState extends AuthState {}

final class AuthShowPhoneSignInPage extends AuthState {}

final class AuthShowForgotPasswordPage extends AuthState {}

final class AuthFinishedState extends AuthState {}
