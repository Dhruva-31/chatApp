import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';

class FirebaseMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  //EMAIL SIGN UP
  Future<void> emailSignUp({
    required String email,
    required String password,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  //EMAIL SIGN IN
  Future<void> emailSignIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      bool exists = await FirestoreMethods().userExists(
        userCredential.user!.uid,
      );
      if (!exists) {
        UserModel user = UserModel(
          uid: userCredential.user!.uid,
          name: '',
          email: email,
          profilePic: "",
          isOnline: false,
          fcmToken: "",
          lastSeen: DateTime.now(),
          createdAt: DateTime.now(),
        );
        FirestoreMethods().saveUserToFirestore(user);
      }
      final uid = userCredential.user!.uid;
      await FirestoreMethods().updateUserOnLogin(uid);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  //PASSWORD RESET
  Future<void> passwordReset({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  //GOOGLE SIGN IN
  Future<void> googleSignIn() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope("email");
      googleProvider.addScope("profile");
      googleProvider.setCustomParameters({"prompt": "select_account"});

      final userCredential = await auth.signInWithProvider(googleProvider);
      bool exists = await FirestoreMethods().userExists(
        userCredential.user!.uid,
      );
      if (exists) {
        await FirestoreMethods().updateUserOnLogin(userCredential.user!.uid);
      } else {
        UserModel user = UserModel(
          uid: userCredential.user!.uid,
          name: '',
          email: userCredential.user!.email!,
          profilePic: userCredential.user!.photoURL as String,
          isOnline: true,
          fcmToken: "",
          lastSeen: DateTime.now(),
          createdAt: DateTime.now(),
        );
        await FirestoreMethods().saveUserToFirestore(user);
      }
    } catch (e) {
      rethrow;
    }
  }

  //GITHUB SIGN IN
  Future<void> githubSignIn() async {
    try {
      GithubAuthProvider githubProvider = GithubAuthProvider();
      githubProvider.addScope('read:user');
      githubProvider.addScope('user:email');

      final userCredential = await auth.signInWithProvider(githubProvider);
      bool exists = await FirestoreMethods().userExists(
        userCredential.user!.uid,
      );
      if (exists) {
        await FirestoreMethods().updateUserOnLogin(userCredential.user!.uid);
      } else {
        UserModel user = UserModel(
          uid: userCredential.user!.uid,
          name: '',
          email: userCredential.user!.email!,
          profilePic: userCredential.user!.photoURL as String,
          isOnline: true,
          fcmToken: "",
          lastSeen: DateTime.now(),
          createdAt: DateTime.now(),
          typingTo: '',
        );
        await FirestoreMethods().saveUserToFirestore(user);
      }
    } catch (e) {
      rethrow;
    }
  }

  //SIGNOUT
  Future<void> logOut() async {
    await auth.signOut();
    await FirestoreMethods().updateUserOnSignOut(currentUser!.uid);
  }

  //DELETEACC
  Future<void> deletePasswordUser(String password) async {
    try {
      final email = currentUser!.email!;
      final cred = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser!.reauthenticateWithCredential(cred);
      await currentUser!.delete();
      await FirestoreMethods().deleteUserDetails(currentUser!.uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGoogleUser() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      await currentUser!.reauthenticateWithProvider(googleAuthProvider);
      await currentUser!.delete();
      await FirestoreMethods().deleteUserDetails(currentUser!.uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGithubUser() async {
    try {
      GithubAuthProvider githubAuthProvider = GithubAuthProvider();
      await currentUser!.reauthenticateWithProvider(githubAuthProvider);
      await currentUser!.delete();
      await FirestoreMethods().deleteUserDetails(currentUser!.uid);
    } catch (e) {
      rethrow;
    }
  }

  String getLoginProvider() {
    return currentUser!.providerData.first.providerId;
  }
}
