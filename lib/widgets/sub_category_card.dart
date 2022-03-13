import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'card_item.dart';

class SubCategoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('test')
          .orderBy('category')
          // .where('status', isNotEqualTo: 'Live')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.length > 0) {
            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(0),
              children: List.generate(
                snapshot.data!.docs.length,
                (index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: CardItem(
                      data: doc,
                      showBanner: true,
                      title: doc['sub_category'],
                      bannerTitle: doc['status'],
                      count: snapshot.data!.docs.length,
                    ),
                  );
                },
              ),
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
    );
  }
}
