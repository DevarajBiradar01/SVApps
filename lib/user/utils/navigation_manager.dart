import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../authentication/aspirant/views/signin.dart';

class NavigationManager {
  static navigateTo(BuildContext context, dynamic navigateToClass) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => navigateToClass));
  }

  static replaceTo(BuildContext context, dynamic navigateToClass) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => navigateToClass));
  }

  static replace(BuildContext context, dynamic navigateToClass) {
    Navigator.replace(context,
        newRoute: MaterialPageRoute(builder: (context) => navigateToClass),
        oldRoute: MaterialPageRoute(builder: (context) => navigateToClass));
  }

  static pushAndRemoveUntil(BuildContext context, dynamic navigateToClass) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => navigateToClass),
        (Route<dynamic> route) => false);
  }

  static navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }
}
