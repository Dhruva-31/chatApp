part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignInButtonClickedEvent extends AuthEvent {
  final String email;
  final String password;

  SignInButtonClickedEvent({required this.email, required this.password});
}

class HomeSignUpButtonClickedEvent extends AuthEvent {}

class ForgotPasswordButtonClickedEvent extends AuthEvent {}

class GoogleSignInButtonClickedEvent extends AuthEvent {}

class GitHubSignInButtonClickedEvent extends AuthEvent {}

class LogOutButtonClickedEvent extends AuthEvent {}

class RealSignUpButtonClickedEvent extends AuthEvent {
  final String email;
  final String password;

  RealSignUpButtonClickedEvent({required this.email, required this.password});
}

class ResetButtonClickedEvent extends AuthEvent {
  final String email;

  ResetButtonClickedEvent({required this.email});
}

class ProceedButtonClickedEvent extends AuthEvent {
  final String name;

  ProceedButtonClickedEvent({required this.name});
}
