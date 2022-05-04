import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svapp/user/utils/widgets.dart';
import 'package:svapp/user/views/pdfs.dart';
import 'package:svapp/user/views/videos.dart';

import '../../live_exams_list.dart';
import '../../utils/utilities.dart';
import '../../widgets/card_item.dart';
import '../../widgets/categories_list_view_all.dart';
import '../../widgets/header_card.dart';
import '../../widgets/test_card.dart';
import '../utils/navigation_manager.dart';
import 'drawer.dart';

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
      drawer: buildUserDrawer(context),
      appBar: dashboardAppBar(title: 'Aspirant Dashboard'),
      body: Container(
        padding: const EdgeInsets.all(2),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                buildMenuCard(
                  label: 'Live \nExams ',
                  onTap: () {
                    NavigationManager.navigateTo(
                      context,
                      LiveExamsList(
                        appTitle: 'Live Exams',
                        query: FirebaseFirestore.instance
                            .collection('test')
                            .where('endDate',
                                isGreaterThanOrEqualTo: getTodayDateTimeStamp())
                            .snapshots(),
                      ),
                    );
                  },
                  //gradientColors: [Colors.pinkAccent, Colors.deepOrange],
                ),
                const Spacer(),
                buildMenuCard(
                  label: 'Video \nCourses',
                  onTap: () {
                    NavigationManager.navigateTo(context, const Videos());
                  },
                  //gradientColors: [Colors.green, Colors.blue]
                ),
                const Spacer(),
                buildMenuCard(
                  label: 'PDF \nNotes',
                  onTap: () {
                    NavigationManager.navigateTo(context, const PDFs());
                  },
                  //gradientColors: [Colors.pink, Colors.yellow]
                ),
              ],
            ),
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('test')
                  .where('endDate',
                      isGreaterThanOrEqualTo: getTodayDateTimeStamp())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.length > 0) {
                    return SizedBox(
                        child: TestCard(
                          limit: 2,
                          query: FirebaseFirestore.instance
                              .collection('test')
                              .where('endDate',
                                  isGreaterThanOrEqualTo:
                                      getTodayDateTimeStamp())
                              .limit(2)
                              .snapshots(),
                        ),
                        height: snapshot.data!.docs.length > 2 ? 370 : 185);
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
            HeaderCard(
              title: 'MOCK TEST SERIES',
              onTap: () => NavigationManager.navigateTo(
                  context, CategoriesListViewAll()),
            ),
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('test')
                  .where('endDate', isLessThan: getTodayDateTimeStamp())
                  .orderBy('endDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.length > 0) {
                    return SizedBox(
                        child: TestCard(
                          limit: 2,
                          query: FirebaseFirestore.instance
                              .collection('test')
                              .where('endDate',
                                  isLessThan: getTodayDateTimeStamp())
                              .orderBy('endDate', descending: true)
                              .limit(2)
                              .snapshots(),
                        ),
                        height: snapshot.data!.docs.length > 2 ? 370 : 185);
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

  buildMenuCard(
      {required String label,
      required dynamic onTap,
      List<Color> gradientColors = const [Colors.red, Colors.blue]}) {
    return Card(
      elevation: 5,
      child: Container(
        height: 130,
        child: InkWell(
          child: Column(
            children: [
              Container(
                // color: Color.fromRGBO(254, 251, 234, 100),
                child: Image.asset(
                  'assets/sv_logo.png',
                  width: 70,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                //  height: 40,
                width: MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // gradient: LinearGradient(colors: gradientColors),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: const TextStyle(
                      //  color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w200),
                ),
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
