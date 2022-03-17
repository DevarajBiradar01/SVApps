import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../user/utils/widgets.dart';

class HeaderCard extends StatelessWidget {
  final String title;
  final dynamic onTap;
  final List<Color> gradientColors;
  const HeaderCard(
      {Key? key,
      required this.title,
      this.onTap,
      this.gradientColors = const [
        Colors.cyan,
        Colors.red,
        //Colors.grey
      ]})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        //padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 35,
              child: headerMessage(
                title,
                fontColor: Colors.white,
                alignment: Alignment.centerLeft,
              ),
            ),
            const Spacer(),
            onTap != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: onTap,
                      child: const Text(
                        'View All >>>',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
