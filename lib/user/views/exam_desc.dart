import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/user/utils/widgets.dart';
import 'package:svapp/user/view_models/exam_desc_vm.dart';
import 'package:svapp/user/views/test_screen.dart';
import 'package:svapp/utils/utilities.dart';

import '../../widgets/info_widget.dart';
import '../utils/navigation_manager.dart';
import '../utils/spacers.dart';

class ExamDesc extends StatefulWidget {
  final dynamic data;
  const ExamDesc({Key? key, required this.data}) : super(key: key);
  _ExamDescState createState() => _ExamDescState();
}

class _ExamDescState extends State<ExamDesc> {
  dynamic data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    Provider.of<ExamDescVM>(context, listen: false).checkUserAttended(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: data['examTitle']),
      body: ListView(
        // mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.amber,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Exam Title : " + data['examTitle'].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  buildColumnSpacer(height: 5),
                  Text(
                    "Category : " + data['category'].toString(),
                    style: const TextStyle(),
                  ),
                  buildColumnSpacer(height: 5),
                  // Text(
                  //   'Author : ' + data['author'],
                  //   style: const TextStyle(),
                  // ),
                  buildColumnSpacer(height: 5),
                  Text(
                    'Expires on : ' +
                        convertTimeStampToDateString(data['endDate']),
                    style: const TextStyle(),
                  ),
                ],
              ),
            ),
          ),
          buildColumnSpacer(height: 5),
          Card(
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      InfoWidget(label: 'Questions', value: data['noOfQns']),
                      Spacer(),
                      InfoWidget(
                        label: 'Max Marks',
                        value: (int.parse(data['marksPerQns']) *
                                int.parse(data['noOfQns']))
                            .toString(),
                      ),
                      const Spacer(),
                    ],
                  ),
                  buildColumnSpacer(),
                  Row(
                    children: [
                      InfoWidget(label: 'Time (Mins)', value: data['duration']),
                      const Spacer(),
                      // InfoWidget(label: 'Fees (Rupees)', value: data['fees']),
                      InfoWidget(label: 'Fees (Rupees)', value: 'Free'),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          buildColumnSpacer(),
          Container(
            height: MediaQuery.of(context).size.height * .45,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text("Description : \n" + data['desc'].toString()),
              ),
            ),
          ),
          Spacer(),
          Consumer<ExamDescVM>(
            builder: (context, model, child) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: testButton(
                    context: context,
                    onTap: () => NavigationManager.navigateTo(
                        context, TestScreen(data: data)),
                    buttonName:
                        model.isShowQuestion ? 'Start Test' : 'Show Result'),
              ),
            ),
          ),
          buildColumnSpacer(height: 5),
        ],
      ),
    );
  }
}
