import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svapp/user/utils/widgets.dart';

class Ranks extends StatefulWidget {
  final String testId;
  final String marksPerQns;
  final String noOfQns;
  const Ranks(
      {Key? key,
      required this.testId,
      required this.marksPerQns,
      required this.noOfQns})
      : super(key: key);
  @override
  _RanksState createState() => _RanksState();
}

class _RanksState extends State<Ranks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Ranks'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.green],
                  ),
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'No of Questions \n' + widget.noOfQns.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Marks per Question \n' + widget.marksPerQns.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('attendees')
                  .where('testId', isEqualTo: widget.testId)
                  .orderBy('correct', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.length > 0) {
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        int marks = int.parse(doc['correct'].toString()) *
                            int.parse(widget.marksPerQns);
                        return Card(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: Chip(
                                padding: const EdgeInsets.all(5),
                                backgroundColor: getBadgeColor(index),
                                elevation: 5,
                                label: Text((index + 1).toString(),
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                              title: buildUserDetails(doc['userId']),
                              subtitle: Text('Correct : ' +
                                  doc['correct'].toString() +
                                  "\n" +
                                  'Wrong : ' +
                                  doc['wrong'].toString()),
                              trailing: Text(
                                marks.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          "No ranks available now",
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
    );
  }

  buildUserDetails(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot doc = snapshot.data!.docs.first;
          return Text(doc['firstName'].toString().toUpperCase() +
              ' ' +
              doc['lastName'].toString().toUpperCase());
        } else {
          return const Text('');
        }
      },
    );
  }

  Color getBadgeColor(int index) {
    switch (index) {
      case 0:
        return Colors.green.shade400;
      case 1:
        return Colors.green.shade400;
      case 2:
        return Colors.green.shade400;
      default:
        return Colors.blue.shade200;
    }
  }
}
