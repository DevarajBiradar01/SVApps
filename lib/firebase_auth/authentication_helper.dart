import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../utils/utilities.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> get getCurrentUser async => _auth.currentUser;

  //SIGN UP METHOD
  Future signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    log('AuthenticationHelper :: signUp() - email : ' + email);
    log('AuthenticationHelper :: signUp() - password : ' + password);
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      log('AuthenticationHelper :: signUp() - userCredential : ' +
          userCredential.toString());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('AuthenticationHelper :: signUp() - FirebaseAuthException : ' +
          e.message.toString());
      snackbar(context, e.message.toString());
    }
  }

  Future<String?> getUserById(BuildContext context, String userId) async {
    await FirebaseFirestore.instance
        .collection("user")
        .where("uid", isEqualTo: userId)
        .get()
        .then((value) {
      log(value.docs.single.toString());
    }).catchError((onError) {
      log("CategoriesVM :: saveCategory ()  onError : " + onError.toString());
      snackbar(context, onError.toString());
    });
  }

  //SIGN IN METHOD
  Future signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    log('AuthenticationHelper :: signIn() - email : ' + email);
    log('AuthenticationHelper :: signIn() - password : ' + password);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      log('AuthenticationHelper :: signUp() - userCredential : ' +
          userCredential.toString());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('AuthenticationHelper :: signIn() - FirebaseAuthException : ' +
          e.message.toString());
      snackbar(context, e.message.toString());
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    log('AuthenticationHelper :: signOut() ');
    await _auth.signOut();
    log('AuthenticationHelper :: signOut() : signed out ');
  }
}
