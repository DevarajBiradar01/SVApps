import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/authentication/mentor/view_models/mentor_login_vm.dart';
import 'package:svapp/user/utils/spacers.dart';
import 'package:svapp/user/utils/widgets.dart';

class MentorLogin extends StatelessWidget {
  const MentorLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MentorLoginVm>(
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: const EdgeInsets.all(16),
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
                  'Hello Mentor,',
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
                buildColumnSpacer(height: 100),
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
                  buttonName: "SIGN IN",
                ),
                buildColumnSpacer(height: 30),
                centeredLinkText(
                    context: context,
                    onTap: () {},
                    link:
                        "Don't have an account? Please contact svexams@gmail.com"),
                buildColumnSpacer(height: 20),
                centeredLinkText(
                    context: context,
                    onTap: () => model.loginAsAspirant(context),
                    link: "Login as Aspirant"),
                buildColumnSpacer(height: 20),
                buildColumnSpacer(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
