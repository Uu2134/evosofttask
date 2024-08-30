import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<firebase_auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  firebase_auth.User? currentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<String?> signUp(String email, String password, String name, String role) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': name,
          'role': role,
        });
        return null;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }

  Future<String?> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['role'];
  }
}
