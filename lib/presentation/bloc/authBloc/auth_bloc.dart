// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth_1/data/repository/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;
  AuthBloc(this.authRepo) : super(AuthInitial()) {
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
      await authRepo.emailSignIn(email: event.email, password: event.password);
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
      await authRepo.googleSignIn();
      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> logOutButtonClickedEvent(
    LogOutButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await authRepo.logOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> realSignUpButtonClickedEvent(
    RealSignUpButtonClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await authRepo.emailSignUp(email: event.email, password: event.password);
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
      await authRepo.githubSignIn();
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
      await authRepo.resetPassword(email: event.email);
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
        await authRepo.saveName(name: event.name);
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
      await authRepo.deleteAcc(
        password: event.password,
        provider: event.provider,
      );
      emit(AccountDeletedState());
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }
}
