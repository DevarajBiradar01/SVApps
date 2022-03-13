import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../../live_exams_list.dart';
import '../../utils/utilities.dart';
import '../../widgets/card_item.dart';
import '../../widgets/categories_list_view_all.dart';
import '../../widgets/header_card.dart';
import '../../widgets/test_card.dart';
import '../utils/navigation_manager.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: dashboardAppBar(title: 'Aspirant Dashboard'),
      body: Container(
        padding: const EdgeInsets.all(2),
        child: ListView(
          shrinkWrap: true,
          children: [
            HeaderCard(
              title: 'LIVE EXAMS',
              onTap: () => NavigationManager.navigateTo(
                context,
                LiveExamsList(
                  appTitle: 'Live Exams',
                  query: FirebaseFirestore.instance
                      .collection('test')
                      .where('endDate',
                          isGreaterThanOrEqualTo: getTodayDateTimeStamp())
                      .snapshots(),
                ),
              ),
            ),
            SizedBox(
                child: TestCard(
                  limit: 2,
                  query: FirebaseFirestore.instance
                      .collection('test')
                      .where('endDate',
                          isGreaterThanOrEqualTo: getTodayDateTimeStamp())
                      .limit(2)
                      .snapshots(),
                ),
                height: 370),
            HeaderCard(
              title: 'MOCK TEST SERIES',
              onTap: () => NavigationManager.navigateTo(
                  context, CategoriesListViewAll()),
            ),
            // SubCategoryCard(),
            buildCategoryCardGridView(),
            Card(
              color: Colors.orange.shade200,
              elevation: 5,
              child: SizedBox(
                height: 50,
                child: Center(child: headerMessage('Advertisement')),
              ),
            ),
            HeaderCard(
              title: 'Archived',
              onTap: () => NavigationManager.navigateTo(
                context,
                LiveExamsList(
                  appTitle: 'Archived',
                  query: FirebaseFirestore.instance
                      .collection('test')
                      .where('endDate', isLessThan: getTodayDateTimeStamp())
                      .orderBy('endDate', descending: true)
                      .snapshots(),
                ),
              ),
            ),
            SizedBox(
                child: TestCard(
                  limit: 2,
                  query: FirebaseFirestore.instance
                      .collection('test')
                      .where('endDate', isLessThan: getTodayDateTimeStamp())
                      .orderBy('endDate', descending: true)
                      .limit(2)
                      .snapshots(),
                ),
                height: 370),
          ],
        ),
      ),
    );
  }

  buildCategoryCardGridView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .orderBy('categoryName')
          .limit(4)
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
    );
  }
}
