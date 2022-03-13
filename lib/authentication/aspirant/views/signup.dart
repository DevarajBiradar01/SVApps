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
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              svgWidget(context,
                  svgPath: 'assets/signup_logo.png',
                  height: 400.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain),
              titleMessage('Sign Up'),
              buildColumnSpacer(),
              headerMessage(
                  "Please register to SV Exams App by providing email id and password"),
              buildColumnSpacer(),
              usernameTextField(model.usernameController),
              buildColumnSpacer(),
              passwordTextField(model.passwordController),
              buildColumnSpacer(),
              Row(
                children: [
                  leftLinkText(
                      context: context,
                      onTap: () => model.onSignInPressed(context),
                      link: 'Have an account?'),
                  const Spacer(),
                  rightAlignedButton(
                      context: context,
                      onTap: () => model.signUp(context),
                      buttonName: 'SIGN UP'),
                ],
              ),
              buildColumnSpacer(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
