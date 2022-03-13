import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../firebase_auth/authentication_helper.dart';
import '../../../user/models/user_model.dart';
import '../../../user/utils/navigation_manager.dart';
import '../../../user/utils/widgets.dart';
import '../../../utils/utilities.dart';
import '../views/phone_auth.dart';
import '../views/signin.dart';

class SignUpVM extends ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String get username => usernameController.text.trim();
  String get password => passwordController.text.trim();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  void onSignInPressed(BuildContext context) {
    NavigationManager.navigateTo(context, const SignIn());
  }

  void signUp(BuildContext context) async {
    log("SignUpVM :: signUp ()  ");
    try {
      if (username.isEmpty && password.isEmpty) {
        String message = "Please enter username and password!";
        log("SignUpVM :: signUp () : Please enter username and password!");
        snackbar(context, message);
      } else if (!isValidEmail(username)) {
        log('Please enter valid email id.');
        snackbar(context, 'Please enter valid email id.');
      } else if (!isValidPassword(password)) {
        log('Password must be of minimum 8 characters and must contain at least one lower, one upper, one number and one special character');
        snackbar(context,
            'Password must be of minimum 8 characters and must contain at least one lower, one upper, one number and one special character');
      } else {
        log("SignUpVM :: signUp () : Authentication - ");
        UserCredential userCredential = await AuthenticationHelper()
            .signUp(email: username, password: password, context: context);
        log("SignUpVM :: signUp () : response - " + userCredential.toString());
        saveUserDetailsLocally(context, userCredential);
        resetFields();
      }
    } catch (exception) {
      String message = exception.toString();
      log("SignUpVM :: signUp () : exception - " + exception.toString());
      snackbar(context, message);
    }
  }

  resetFields() {
    usernameController.text = '';
    passwordController.text = '';
    notifyListeners();
  }

  void saveUserDetailsLocally(
      BuildContext context, UserCredential userCredential) async {
    log("SignUpVM :: saveUserDetailsLocally ()  ");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    User user = userCredential.user!;
    UserModel userModel = UserModel(
      email: user.email!,
      userId: user.uid,
    );

    final userRef = _db.collection('users').doc(user.uid);

    await userRef.set(userModel.asMap()).then((value) {
      log("SignUpVM :: saveUserDetailsLocally ()  value : ");
      resetFields();
      prefs.setString('firebase_user_id', user.uid.toString());
      snackbar(context,
          'Thank you for registering the to SV Exams, All the best...');
      NavigationManager.navigateTo(context, const PhoneAuth());
    }).catchError((onError) {
      log("SignUpVM :: saveUserDetailsLocally ()  onError : " +
          onError.toString());
      snackbar(context, onError.toString());
    });
  }
}
