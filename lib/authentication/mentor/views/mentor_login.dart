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
          child: ListView(
            children: [
              svgWidget(context,
                  svgPath: 'assets/signin_logo.png',
                  height: 400.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain),
              buildColumnSpacer(height: 30),
              titleMessage('Mentor Login', alignment: Alignment.centerLeft),
              buildColumnSpacer(height: 30),
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
                      buttonName: "SIGN IN"),
                ],
              ),
              buildColumnSpacer(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
