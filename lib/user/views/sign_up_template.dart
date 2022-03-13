import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpTemplate extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget? body;

  const SignUpTemplate(
      {Key? key, required this.title, required this.subTitle, this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .5,
                child: SvgPicture.asset(
                  'assets/brain_logo.svg',
                  semanticsLabel: 'A red up arrow',
                  fit: BoxFit.contain,
                  height: 200,
                ),
              ),
            ),
            //Spacer(),
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      ),
    );
  }
}
