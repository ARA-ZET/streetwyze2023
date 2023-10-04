import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:street_wyze/models/firebase_users.dart';

import '../models/user.dart';
import 'notification_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final notificationService = NotificationsService();

  // Create user object based on User
  StreetWyzeUser? _userFromFirebaseUser(User? user) {
    if (user == null) {
      return null;
    }
    notificationService.requestPermission();
    notificationService.getToken();
    return StreetWyzeUser(user.displayName, user.email, user.uid);
  }

  // Auth change user stream
  Stream<StreetWyzeUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<StreetWyzeUser?> signInAnonymously() async {
    try {
      final UserCredential result = await _auth.signInAnonymously();
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _userFromFirebaseUser(result.user);
      if (user != null) {
        // Successful login
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage = '';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided.';
        } else if (e.code == 'too-many-requests') {
          errorMessage = 'Access to this account has been temporarily disabled';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<dynamic> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        await checkAndCreateUser(userCredential.user!);

        return _userFromFirebaseUser(userCredential.user);
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage = '';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'sign_in_canceled') {
          errorMessage = 'Wrong password provided.';
        } else if (e.code == 'too-many-requests') {
          errorMessage = 'Access to this account has been temporarily disabled';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> checkAndCreateUser(User user) async {
    // Check if the user exists in your database
    // For example, using Firestore
    DocumentSnapshot userSnapshot =
        await db.collection('Users').doc(user.uid).get();

    if (!userSnapshot.exists) {
      createUser(FirebaseUser(user.displayName?.split(",")[0],
          user.displayName?.split(",")[1], user.email, user.uid, "user"));
    }
  }

  Future<StreetWyzeUser?> registerWithEmailAndPassword(BuildContext context,
      String name, String surname, String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      createUser(FirebaseUser(name, surname, email, result.user?.uid, "user"));
      final user = _userFromFirebaseUser(result.user);
      signInWithEmailAndPassword(context, email, password);
      return user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage = '';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided.';
        } else if (e.code == 'too-many-requests') {
          errorMessage = 'Access to this account has been temporarily disabled';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    return null;
  }

  createUser(FirebaseUser firebaseUser) {
    db
        .collection("Users")
        .doc(firebaseUser.uid)
        .set(firebaseUser.toJson())
        .whenComplete(() => debugPrint("user created ${firebaseUser.uid}"));
    notificationService.requestPermission();
    notificationService.getToken();
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Sign Out Error: $e');
      }
    }
  }
}
