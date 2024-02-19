import 'package:esp32sensor/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/appUser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  //create user obj based on firebaseuser
  appUser _userFromFirebaseUser(user) {
    return user != null ? appUser(uid: user.uid) : appUser(uid: '');
  }

  //auth change user stream
  Stream<appUser> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  // sign in anonmymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  //sign in through email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for this email';
      } else if (e.code == 'wrong-password') {
        return 'Wrong Password';
      } else {
        return null;
      }
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password,
      String name, String mobile, String channel) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      //creating a new document for user
      await DatabaseService(uid: user!.uid)
          .updateUserData(user.uid, name, email, channel, mobile);

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'Email entered is already registered';
      } else {
        return null;
      }
    }
  }

  //Resetting Password
  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Email is being sent please wait for a minute';
    } catch (e) {
      return 'Please enter valid email';
    }
  }

  //changing password
  Future changePassword(String newPassword) async {
    try {
      await currentUser!.updatePassword(newPassword);
      signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
