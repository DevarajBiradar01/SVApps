import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svapp/user/utils/widgets.dart';
import 'package:svapp/widgets/card_item.dart';

import 'live_exams_list.dart';

class CategoryTestList extends StatelessWidget {
  String categoryName;
  String categoryLogo;
  CategoryTestList({required this.categoryName, this.categoryLogo = ''});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: categoryName),
        body: buildSubCategoryCardGridView());
  }

  buildSubCategoryCardGridView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sub_categories')
          .where('category', isEqualTo: categoryName)
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
                      title: doc['subCategoryName'],
                      logo: categoryLogo,
                      navigateToClass: LiveExamsList(
                        appTitle: doc['subCategoryName'] +
                            ' Exams Series'.toUpperCase(),
                        query: FirebaseFirestore.instance
                            .collection('test')
                            .where('sub_category',
                                isEqualTo: doc['subCategoryName'])
                            .snapshots(),
                      ),
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
    );
  }
}
