import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/user/view_models/test_screen_vm.dart';

import '../../firebase_auth/authentication_helper.dart';
import '../../widgets/info_widget.dart';
import '../utils/widgets.dart';

class ResultSheet extends StatefulWidget {
  dynamic data;
  bool isShowAppBar;
  ResultSheet({Key? key, required this.data, this.isShowAppBar = false})
      : super(key: key);
  _ResultSheetState createState() => _ResultSheetState();
}

class _ResultSheetState extends State<ResultSheet> {
  dynamic data;
  // String user = '';
  User? user;
  var markedAnswers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.data;
    Provider.of<TestScreenVM>(context, listen: false).getCurrentUserId();
    // Provider.of<TestScreenVM>(context, listen: false)
    //     .getMarkedAnswers(data['id']);
    getUserId();
  }

  getUserId() async {
    user = await AuthenticationHelper().getCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isShowAppBar
          ? appBar(title: 'Result Sheet')
          : const PreferredSize(
              child: SizedBox(height: 0), preferredSize: Size.zero),
      body: SingleChildScrollView(
        child: Consumer<TestScreenVM>(
          builder: (context, model, child) => Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('attendees')
                    .where('userId', isEqualTo: user?.uid)
                    .where('testId', isEqualTo: data['id'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.length > 0) {
                      DocumentSnapshot doc = snapshot.data!.docs.first;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 5,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.red]),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InfoWidget(
                                      label: 'Correct',
                                      value: doc['correct'].toString()),
                                  Spacer(),
                                  InfoWidget(
                                      label: 'Wrong',
                                      value: doc['wrong'].toString()),
                                  Spacer(),
                                  InfoWidget(
                                      label: 'Time Taken', value: '4:56:20'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        height: 120,
                        child: const Center(
                          child: Text(
                            "No exams available now",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  } else {
                    return const Center(child: Text("No data"));
                  }
                },
              ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Q No.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        'Correct',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        'Marked',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        'Result',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('attendees')
                    .where('testId', isEqualTo: data['id'])
                    .where('userId', isEqualTo: model.userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.length > 0) {
                      DocumentSnapshot doc = snapshot.data!.docs.first;
                      return SingleChildScrollView(
                        child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: doc['correctAnswers'].length,
                            itemBuilder: (context, index) {
                              //  DocumentSnapshot doc = snapshot.data!.docs[index];
                              return Card(
                                elevation: 5,
                                color: doc['correctAnswers'][index] ==
                                        doc['submitted_answers'][index]
                                    ? Colors.green.shade300
                                    : Colors.red.shade300,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    gradient: LinearGradient(
                                        colors: doc['correctAnswers'][index] ==
                                                doc['submitted_answers'][index]
                                            ? [
                                                Colors.green.shade400,
                                                Colors.white
                                              ]
                                            : [
                                                Colors.red.shade400,
                                                Colors.white
                                              ]),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        (index + 1).toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      Text(
                                        getAlphabetValue(
                                          doc['correctAnswers'][index],
                                        ),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      Text(
                                        getAlphabetValue(
                                            doc['submitted_answers'][index]),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      doc['submitted_answers'][index] ==
                                              doc['correctAnswers'][index]
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                              size: 30,
                                            )
                                          : const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                      // const Text(
                                      //   'Result',
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return const SizedBox(
                        height: 120,
                        child: Center(
                          child: Text(
                            "No exams available now",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  } else {
                    return const Center(child: Text("No data"));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  getAlphabetValue(int index) {
    String value;
    switch (index) {
      case -1:
        value = ' ';
        break;
      case 0:
        value = 'A';
        break;
      case 1:
        value = 'B';
        break;
      case 2:
        value = 'C';
        break;
      case 3:
        value = 'D';
        break;
      default:
        value = 'A';
    }
    return value;
  }
}
