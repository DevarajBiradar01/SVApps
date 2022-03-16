import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/user/utils/spacers.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../view_models/sign_up_vm.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpVM>(
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
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
                  style: (TextStyle(
                    fontSize: 22,
                  )),
                ),
                buildColumnSpacer(height: 5),
                const Text(
                  'Get on Board',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                buildColumnSpacer(height: 100),
                usernameTextField(model.usernameController),
                buildColumnSpacer(height: 30),
                passwordTextField(model.passwordController,
                    label: 'Create your password'),
                buildColumnSpacer(height: 30),
                fullButton(
                    context: context,
                    onTap: () => model.signUp(context),
                    buttonName: 'SIGN UP'),
                buildColumnSpacer(height: 30),
                leftLinkText(
                    context: context,
                    onTap: () => model.onSignInPressed(context),
                    link: 'Have an account? Click here to sign in'),
                buildColumnSpacer(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
