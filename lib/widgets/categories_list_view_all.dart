import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../user/utils/widgets.dart';
import 'card_item.dart';

class CategoriesListViewAll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Categories'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .orderBy('categoryName')
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
                        showBanner: false,
                        title: doc['categoryName'],
                        logo: doc['logo'],
                        // bannerTitle: doc['status'],
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
      ),
    );
  }
}
