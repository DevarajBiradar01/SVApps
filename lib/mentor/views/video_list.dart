import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svapp/common/views/view_video.dart';
import 'package:svapp/mentor/views/add_video.dart';
import 'package:svapp/user/utils/navigation_manager.dart';
import 'package:svapp/user/utils/widgets.dart';

class VideoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Videos'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NavigationManager.navigateTo(context, AddVideo()),
        child: const Icon(Icons.add, size: 30),
        tooltip: 'Add Video',
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('videos').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.length > 0) {
                return ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return InkWell(
                        onTap: () => NavigationManager.navigateTo(
                          context,
                          VideoView(data: doc),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              colors: index % 2 == 0
                                  ? [Colors.deepOrange, Colors.lightBlueAccent]
                                  : [Colors.lightBlue, Colors.pinkAccent],
                            ),
                          ),
                          child: Card(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  'https://img.youtube.com/vi/' +
                                      doc['videoId'] +
                                      '/0.jpg',
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 10),
                                  child: Text(
                                    doc['title'],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
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
    );
  }
}
