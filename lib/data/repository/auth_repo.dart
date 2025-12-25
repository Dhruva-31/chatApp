// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';

class AuthRepo {
  final FirebaseMethods firebaseMethods;
  final FirestoreMethods firestoreMethods;
  AuthRepo(this.firebaseMethods, this.firestoreMethods);

  Future<void> emailSignIn({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseMethods.emailSignIn(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> googleSignIn() async {
    try {
      await firebaseMethods.googleSignIn();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> githubSignIn() async {
    try {
      await firebaseMethods.githubSignIn();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      await firebaseMethods.logOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> emailSignUp({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseMethods.emailSignUp(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await firebaseMethods.passwordReset(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveName({required String name}) async {
    try {
      if (name.trim().isEmpty) {
        throw 'Name cannot be empty';
      }
      await firestoreMethods.updateUserName(name);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAcc({String? password, required String provider}) async {
    try {
      if (provider == 'password') {
        if (password != null && password.isNotEmpty) {
          await firebaseMethods.deletePasswordUser(password);
        } else {
          throw 'password cannot be null';
        }
      } else if (provider == 'google.com') {
        await firebaseMethods.deleteGoogleUser();
      } else if (provider == 'github.com') {
        await firebaseMethods.deleteGithubUser();
      }
    } catch (e) {
      rethrow;
    }
  }
}
