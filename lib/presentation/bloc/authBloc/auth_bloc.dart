import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
    on<SignInButtonClickedEvent>(signInButtonClickedEvent);
    on<HomeSignUpButtonClickedEvent>((event, emit) {
      emit(AuthShowSignUpPageState());
    });
    on<ForgotPasswordButtonClickedEvent>((event, emit) {
      emit(AuthShowForgotPasswordPage());
    });
    on<GoogleSignInButtonClickedEvent>(googleSignInButtonClickedEvent);
    on<LogOutButtonClickedEvent>(logOutButtonClickedEvent);
    on<RealSignUpButtonClickedEvent>(realSignUpButtonClickedEvent);
    on<GitHubSignInButtonClickedEvent>(gitHubSignInButtonClickedEvent);
    on<ResetButtonClickedEvent>(resetButtonClickedEvent);
    on<ProceedButtonClickedEvent>(proceedButtonClickedEvent);
    on<DeleteAccountButtonClickedEvent>(deleteAccountButtonClickedEvent);
  }

  Future<void> signInButtonClickedEvent(
    SignInButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await FirebaseMethods().emailSignIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }

  Future<void> googleSignInButtonClickedEvent(
    GoogleSignInButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await FirebaseMethods().googleSignIn();
      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> logOutButtonClickedEvent(
    LogOutButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) {
    FirebaseMethods().logOut();
    emit(AuthInitial());
  }

  FutureOr<void> realSignUpButtonClickedEvent(
    RealSignUpButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await FirebaseMethods().emailSignUp(
        email: event.email,
        password: event.password,
      );
      emit(AuthSignUpSuccessState());
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> gitHubSignInButtonClickedEvent(
    GitHubSignInButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await FirebaseMethods().githubSignIn();
      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> resetButtonClickedEvent(
    ResetButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await FirebaseMethods().passwordReset(email: event.email);
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> proceedButtonClickedEvent(
    ProceedButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    {
      emit(AuthLoadingState());
      try {
        if (event.name.trim().isEmpty) {
          emit(AuthFailureState(errorMessage: 'Name cannot be empty'));
          return;
        }
        await FirestoreMethods().updateUserName(event.name);
        emit(AuthFinishedState());
      } catch (e) {
        emit(AuthFailureState(errorMessage: e.toString()));
      }
    }
  }

  FutureOr<void> deleteAccountButtonClickedEvent(
    DeleteAccountButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      if (event.provider == 'password') {
        if (event.password != null && event.password!.isNotEmpty) {
          await FirebaseMethods().deletePasswordUser(event.password!);
        } else {
          throw 'password cannot be null';
        }
      } else if (event.provider == 'google.com') {
        await FirebaseMethods().deleteGoogleUser();
      } else if (event.provider == 'github.com') {
        await FirebaseMethods().deleteGithubUser();
      }
      emit(AccountDeletedState());
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }
}
