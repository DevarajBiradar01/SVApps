import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/user/utils/spacers.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../view_models/sign_in_vm.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SignInVM>(
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ListView(
            children: [
              svgWidget(context,
                  svgPath: 'assets/signin_logo.png',
                  height: 400.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain),
              titleMessage('Sign In'),
              buildColumnSpacer(),
              headerMessage(
                  "Dear Aspirant, Welcome to SV Exams, Please sign in to access the tests"),
              buildColumnSpacer(),
              usernameTextField(model.usernameController),
              buildColumnSpacer(),
              passwordTextField(model.passwordController),
              buildColumnSpacer(),
              Row(
                children: [
                  leftLinkText(
                      context: context,
                      onTap: () => model.onForgotPasswordPressed(context),
                      link: 'Forgot Password?'),
                  const Spacer(),
                  rightAlignedButton(
                    context: context,
                    onTap: () => model.signIn(context),
                    buttonName: "SIGN IN",
                  ),
                ],
              ),
              buildColumnSpacer(height: 30),
              centeredLinkText(
                  context: context,
                  onTap: () => model.onSignUpPressed(context),
                  link: "Don't have an account? Click Here"),
              buildColumnSpacer(height: 20),
              centeredLinkText(
                  context: context,
                  onTap: () => model.onLoginAsMentorPressed(context),
                  link: "Login as Mentor"),
              buildColumnSpacer(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
