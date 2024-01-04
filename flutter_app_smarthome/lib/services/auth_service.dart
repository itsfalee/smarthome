import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //instace of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign user in
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      // sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    }
    // catch any error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// buat akun baru
  Future<UserCredential> signUpWithEmailandPassword(
      String email, password, namaPengguna) async {
    try {
// sign up
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
          _firestore.collection('user').doc(userCredential.user!.uid).set(
            {
              'uid': userCredential.user!.uid,
              'email': email,
              'NamaPengguna': namaPengguna,
            }
          );

      return userCredential;
    }
// catch any error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
