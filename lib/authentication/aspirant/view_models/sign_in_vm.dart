import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svapp/authentication/aspirant/views/forgot_password.dart';
import 'package:svapp/authentication/mentor/views/mentor_login.dart';
import 'package:svapp/firebase_auth/authentication_helper.dart';
import 'package:svapp/user/utils/navigation_manager.dart';
import 'package:svapp/user/views/user_home.dart';
import 'package:svapp/utils/utilities.dart';

import '../../../main.dart';
import '../../../user/models/user_model.dart';
import '../../../user/utils/widgets.dart';
import '../views/signup.dart';

class SignInVM extends ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String get username => usernameController.text.trim();
  String get password => passwordController.text.trim();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  void signIn(BuildContext context) async {
    log("SignInVM :: signIn ()  ");
    try {
      if (username.isNotEmpty && password.isNotEmpty) {
        showProgress(context);
        UserCredential userCredential = await AuthenticationHelper()
            .signIn(email: username, password: password, context: context);
        log("SignInVM :: signIn () : userCredential - " +
            userCredential.toString());

        if (userCredential != null) {
          getUserDetails(context, userCredential);
        }
        Navigator.pop(context);
      } else {
        log("SignInVM :: signIn () : Please enter username and password!");
      }
    } catch (exception) {
      log("SignInVM :: signIn () : exception - " + exception.toString());
    }
  }

  resetFields() {
    usernameController.text = '';
    passwordController.text = '';
    notifyListeners();
  }

  void onSignUpPressed(BuildContext context) {
    NavigationManager.navigateTo(context, SignUp());
  }

  void onLoginAsMentorPressed(BuildContext context) {
    NavigationManager.navigateTo(context, const MentorLogin());
  }

  void onForgotPasswordPressed(BuildContext context) {
    NavigationManager.navigateTo(context, ForgotPassword());
  }

  void getUserDetails(
      BuildContext context, UserCredential userCredential) async {
    log("SignInVM :: saveUserDetailsLocally ()  ");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = userCredential.user!;

    final userRef = _db.collection('users').doc(user.uid);
    await userRef.get().then((value) {
      log("SignInVM :: getUserDetails ()  data : " + value.data().toString());
      var response = value.data();
      UserModel user = UserModel.fromMap(response!);
      if (user.role == 'user') {
        prefs.setString('user_details', json.encode(value.data()));
        snackbar(context, 'Logged in successfully!');
        resetFields();
        NavigationManager.pushAndRemoveUntil(context, UserHome());
      } else {
        log("SignInVM :: saveUserDetailsLocally () : Login Failed ");
        snackbar(context, 'Login Failed!');
      }
    }).catchError((onError) {
      log("SignInVM :: saveUserDetailsLocally ()  onError : " +
          onError.toString());
      snackbar(context, onError.toString());
    });
  }

  logout(BuildContext context) {
    log("SignInVM :: logout ()  ");
    AuthenticationHelper().signOut();
    prefs.setString('user_details', '');
    log("SignInVM :: Logged out successfully  ");
    snackbar(context, ' Logged out successfully');
    NavigationManager.navigateToLogin(context);
  }
}
