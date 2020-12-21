import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guardiantest/Models/User.dart' as guardianTest;
import 'package:guardiantest/Screens/FirstPage.dart';
import 'package:guardiantest/Screens/HomeScreen.dart';

class FirebaseAuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  guardianTest.User _currentUser;

  guardianTest.User currentUser() {
    print("PIDO EL CURRENT USER: $_currentUser");
    return _currentUser;
  }

  String getString() {
    return "HOLI";
  }

//sign in anon
  Future signInAnon() async {
    try {
      UserCredential authResult = await _firebaseAuth.signInAnonymously();
      User user = authResult.user;
      return user;
    } catch (e) {
      print("error: $e");
      return null;
    }
  }

//sign in with email and password
  Future<String> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    final UserCredential authResult = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    if (authResult.user.emailVerified) {
      print("Login name ${authResult.user.displayName}");
      var result = await _getUserFromFirebase(authResult.user, context);
      return result;
    } else {
      return "Verify Email";
    }
  }

//register with email and password
  Future<String> registerWithEmailAndPassword(
      String email, String password) async {
    final UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    try {
      await authResult.user.sendEmailVerification();
      return authResult.user.uid;
    } catch (e) {
      return null;
    }
  }

//sign out
  Future<void> signOut(BuildContext _context) async {
    await _firebaseAuth.signOut();
    _currentUser = null;
    Navigator.pushReplacement(
        _context, MaterialPageRoute(builder: (context) => FirstPage()));
  }

  Future<String> _getUserFromFirebase(User user, BuildContext context) async {
    if (user == null) {
      _currentUser = null;
      return 'ERROR';
    }
    var firestoreUser = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .get();

    if (firestoreUser.data() == null) {
      _currentUser = null;
      return 'ERROR';
    } else {
      _currentUser = new guardianTest.User.fromDocument(firestoreUser);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      print("CURRENT USER MAIL ${_currentUser.email}");
      var user = currentUser();
      print("USER: ${user.email}");
      return "";
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
