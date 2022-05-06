import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svapp/firebase_auth/authentication_helper.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../../../user/utils/spacers.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPassword({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  child: Image.asset(
                    'assets/sv_logo.png',
                    height: 100,
                  ),
                  alignment: Alignment.centerLeft,
                ),
                buildColumnSpacer(height: 20),
                const Text(
                  'Hello there,',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                buildColumnSpacer(height: 5),
                const Text(
                  'Welcome back',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                buildColumnSpacer(height: 80),
                usernameTextField(emailController),
                buildColumnSpacer(height: 30),
                buildColumnSpacer(height: 30),
                fullButton(
                  context: context,
                  onTap: () => {
                    AuthenticationHelper().sendPasswordResetEmail(
                        context, emailController.text.trim())
                  },
                  buttonName: " SEND EMAIL ",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
