import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../user/utils/navigation_manager.dart';
import '../user/utils/spacers.dart';
import '../user/utils/widgets.dart';
import '../user/views/exam_desc.dart';
import '../utils/utilities.dart';

class TestCard extends StatelessWidget {
  final int limit;
  final bool isMentorCard;
  String collection = 'test';
  dynamic query;

  TestCard({Key? key, this.limit = 1, this.isMentorCard = false, this.query})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (query == null) {
      query = FirebaseFirestore.instance
          .collection(collection)
          .limit(limit)
          .snapshots();
    } else {
      query = query;
    }
    return SizedBox(
      height: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: query,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length > 0) {
              return ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return Card(
                      elevation: 5,
                      child: Material(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc['examTitle'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              buildColumnSpacer(height: 2),
                              Text(
                                doc['desc'].toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              //buildColumnSpacer(height: 2),
                              Text(
                                'Ends on ' +
                                    convertTimeStampToDateString(
                                        doc['endDate']),
                                style: const TextStyle(
                                  color: Colors.deepOrange,
                                ),
                              ),
                              buildColumnSpacer(height: 2),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5, top: 5),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            width: 1.5, color: Colors.grey),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Questions',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        buildColumnSpacer(height: 5),
                                        Text(doc['noOfQns'])
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5, top: 5),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            width: 1.5, color: Colors.grey),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Max Marks',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        buildColumnSpacer(height: 5),
                                        Text(
                                          (int.parse(doc['marksPerQns']) *
                                                  int.parse(doc['noOfQns']))
                                              .toString(),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5, top: 5),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            width: 1.5, color: Colors.grey),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Time',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        buildColumnSpacer(height: 5),
                                        Text(
                                          doc['duration'] + 'Mins',
                                        )
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5, top: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Fees',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        buildColumnSpacer(height: 5),
                                        const Text(
                                          'Free',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        )
                                        // Text(
                                        //   doc['fees'],
                                        // )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              buildColumnSpacer(height: 2),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.language,
                                      ),
                                      buildRowSpacer(width: 5),
                                      Text(
                                        doc['medium'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: testButton(
                                        context: context,
                                        onTap: () =>
                                            NavigationManager.navigateTo(
                                                context, ExamDesc(data: doc)),
                                        buttonName: doc['fees'] == '0'
                                            ? 'Attempt Now'
                                            : 'Unlock'),
                                  ),
                                ],
                              ),
                              buildColumnSpacer(height: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
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
          }
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return CircularProgressIndicator();
          // }
          else {
            return const Center(child: Text("No data"));
          }
        },
      ),
    );
  }
}
