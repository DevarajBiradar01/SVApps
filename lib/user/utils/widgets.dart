import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/user/utils/spacers.dart';

import '../../authentication/aspirant/view_models/sign_in_vm.dart';

Center svgWidget(BuildContext context,
    {String svgPath = 'assets/sv_logo.png',
    height = 200.0,
    var width,
    BoxFit fit = BoxFit.contain}) {
  return Center(
    child: SizedBox(
      height: MediaQuery.of(context).size.height * .4,
      width: width ?? MediaQuery.of(context).size.width * .4,
      child: Center(child: Image.asset(svgPath, fit: fit, height: height)),
    ),
  );
}

Align rightAlignedButton(
    {required BuildContext context,
    required Function() onTap,
    required String buttonName}) {
  return Align(
    alignment: Alignment.centerRight,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          MediaQuery.of(context).size.width * 0.25,
          45,
        ),
      ),
      child: Text(buttonName),
    ),
  );
}

InkWell testButton(
    {required BuildContext context,
    required Function() onTap,
    required String buttonName}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Colors.teal,
            Colors.blue,
          ],
        ),
      ),
      child: Align(
        child: Text(
          buttonName,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

InkWell alternativeTestButton(
    {required BuildContext context,
    required Function() onTap,
    required String buttonName}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Colors.pinkAccent,
            Colors.blue,
          ],
        ),
      ),
      child: Align(
        child: Text(
          buttonName,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

InkWell centeredLinkText(
    {required BuildContext context,
    required Function() onTap,
    required String link}) {
  return InkWell(
    onTap: onTap,
    child: Align(
      alignment: Alignment.center,
      child: Text(
        link,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

InkWell leftLinkText(
    {required BuildContext context,
    required Function() onTap,
    required String link}) {
  return InkWell(
    onTap: onTap,
    child: Align(
      alignment: Alignment.center,
      child: Text(
        link,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

TextFormField passwordTextField(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      hintText: "Password",
    ),
    obscureText: true,
    keyboardType: TextInputType.visiblePassword,
  );
}

TextFormField usernameTextField(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      hintText: "Email Id",
    ),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: TextInputType.emailAddress,
  );
}

bool isValidEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(p);
  return regExp.hasMatch(em);
}

bool isValidPassword(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

Align titleMessage(String message,
    {Alignment alignment = Alignment.center,
    TextAlign textAlign = TextAlign.center}) {
  return Align(
    alignment: alignment,
    child: Text(
      message,
      textAlign: textAlign,
      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
    ),
  );
}

Align headerMessage(String message,
    {Color fontColor = Colors.black, Alignment alignment = Alignment.center}) {
  return Align(
    alignment: alignment,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: fontColor),
      ),
    ),
  );
}

void snackbar(BuildContext context, String message) {
  SnackBar snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      message,
      style: const TextStyle(
          fontSize: 16, letterSpacing: 1.2, fontWeight: FontWeight.w500),
    ),
    backgroundColor: Colors.blue,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

AppBar dashboardAppBar({required String title}) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.red,
            Colors.blueAccent,
          ],
        ),
      ),
    ),
    actions: [
      Consumer<SignInVM>(
        builder: (context, model, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: InkWell(
                child: const Icon(Icons.power_settings_new_sharp),
                onTap: () => model.logout(context),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

AppBar testAppBar({required String title, required Widget timeWidget}) {
  return AppBar(
    title: Text(title),
    centerTitle: false,
    leading: SizedBox(),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.red,
            Colors.blueAccent,
          ],
        ),
      ),
    ),
    actions: [
      Consumer<SignInVM>(builder: (context, model, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: InkWell(
                child: Row(
                  children: [
                    const Icon(Icons.timer),
                    buildRowSpacer(),
                    timeWidget,
                    buildRowSpacer(),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    ],
  );
}

AppBar appBar({required String title}) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.red,
            Colors.blueAccent,
          ],
        ),
      ),
    ),
  );
}
