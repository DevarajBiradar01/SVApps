import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:svapp/user/utils/widgets.dart';
import 'package:svapp/user/views/user_home.dart';

import '../../authentication/aspirant/views/signin.dart';
import '../../main.dart';
import '../../mentor/views/mentor_home.dart';
import '../../utils/utilities.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    Widget widget = const SignIn();
    try {
      String userDetails = prefs.getString('user_details').toString();
      log(userDetails);
      if (prefs.getString('user_details') != null &&
          prefs.getString('user_details').toString().isNotEmpty) {
        final user = json.decode(userDetails);
        if (user['role'] == 'user') {
          widget = const UserHome();
        } else if (user['role'] == 'mentor') {
          widget = MentorHome();
        }
      } else {
        widget = const SignIn();
      }
    } catch (error) {
      widget = const SignIn();
    }
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: svgWidget(context)),
    );
  }
}
