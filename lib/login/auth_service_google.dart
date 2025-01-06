import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ward/home/nav_bar.dart';
import 'package:ward/login/login.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;


  Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      // Sign out the user first to clear any cached tokens
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google user credentials
        await _auth.signInWithCredential(credential);

        // Navigate to the main page of the app upon successful sign-in
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyNavBar()));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed: $error"), backgroundColor: Colors.red),
      );
    }
  }


  // Method to sign out the current user
  Future<void> signOut() async {
    await _googleSignIn.signOut(); // Sign out from Google
    await _auth.signOut(); // Sign out from Firebase
  }


  // Method to listen to auth state changes
  Stream<User?> get userChanges => _auth.authStateChanges();

  // Method to get the current user (if any)
  User? get currentUser => _auth.currentUser;


  Future<void> deleteUser(BuildContext context) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Delete the user from Firebase
        await user.delete();
        // Sign out the user
        await _googleSignIn.signOut();
        await _auth.signOut();
        // Navigate to the login page
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Login()));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting account: $error"),
              backgroundColor: Colors.red),
        );
      }
    }
  }
}
