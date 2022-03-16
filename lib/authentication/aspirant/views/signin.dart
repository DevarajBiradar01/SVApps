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
        //appBar: appBar(title: 'SV Exams'),
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
                  usernameTextField(model.usernameController),
                  buildColumnSpacer(height: 30),
                  passwordTextField(model.passwordController),
                  buildColumnSpacer(height: 30),
                  InkWell(
                    onTap: () => model.onForgotPasswordPressed(context),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  buildColumnSpacer(height: 30),
                  fullButton(
                    context: context,
                    onTap: () => model.signIn(context),
                    buttonName: " SIGN IN ",
                  ),
                  buildColumnSpacer(height: 30),
                  centeredLinkText(
                      context: context,
                      onTap: () => model.onSignUpPressed(context),
                      link: "Don't have an account? Click here to sign up"),
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
        ),
      ),
    );
  }
}
