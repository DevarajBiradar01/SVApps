import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../../common/views/view_pdf.dart';
import '../utils/navigation_manager.dart';

class PDFs extends StatelessWidget {
  const PDFs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: 'PDFs'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('pdfs').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.length > 0) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          return InkWell(
                            onTap: () => NavigationManager.navigateTo(
                              context,
                              ViewPdf(data: doc),
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                  colors: index % 2 == 0
                                      ? [
                                          Colors.deepOrange,
                                          Colors.lightBlueAccent
                                        ]
                                      : [Colors.lightBlue, Colors.pinkAccent],
                                ),
                              ),
                              child: Card(
                                color: Colors.transparent,
                                child: ListTile(
                                  title: Text(
                                    doc['title'],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    doc['date'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: SizedBox(
                        height: 120,
                        child: Center(
                          child: Text(
                            "No pdfs available now",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return const Center(child: Text("No data"));
                }
              },
            ),
          ),
        ));
  }
}
