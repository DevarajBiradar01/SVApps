import 'package:flutter/material.dart';
import 'package:svapp/user/utils/widgets.dart';
import 'package:svapp/widgets/test_card.dart';

class LiveExamsList extends StatelessWidget {
  String appTitle;
  dynamic query;
  LiveExamsList({Key? key, required this.appTitle, required this.query})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: appTitle),
      body: TestCard(query: query),
    );
  }
}
