import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/mentor/views/categories.dart';
import 'package:svapp/mentor/views/sub_categories.dart';
import 'package:svapp/user/utils/navigation_manager.dart';

import '../../live_exams_list.dart';
import '../../user/utils/widgets.dart';
import '../../utils/utilities.dart';
import '../../widgets/header_card.dart';
import '../../widgets/test_card.dart';
import '../view_models/mentor_home_vm.dart';

class MentorHome extends StatefulWidget {
  _MentorHomeState createState() => _MentorHomeState();
}

class _MentorHomeState extends State<MentorHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<MentorHomeVM>(context, listen: false).getCurrentUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<MentorHomeVM>(
        builder: (context, model, child) => FloatingActionButton(
          onPressed: () => model.addTest(context),
          child: const Icon(Icons.add, size: 30),
          tooltip: 'Create course or exam',
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                color: Colors.blue,
                child: const CircleAvatar(
                  minRadius: 50,
                  maxRadius: 50,
                  child: CircleAvatar(
                    minRadius: 40,
                    maxRadius: 40,
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              child: const Card(
                child: ListTile(
                  title: Text('Categories'),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                NavigationManager.navigateTo(context, Categories());
              },
            ),
            InkWell(
              child: const Card(
                child: ListTile(
                  title: Text('Sub Categories'),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                NavigationManager.navigateTo(context, SubCategories());
              },
            ),
          ],
        ),
      ),
      appBar: dashboardAppBar(title: 'Mentor Dashboard'),
      body: Consumer<MentorHomeVM>(
        builder: (context, model, child) => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                HeaderCard(
                  title: 'Ongoing  Exams',
                  onTap: () => NavigationManager.navigateTo(
                    context,
                    LiveExamsList(
                      appTitle: 'Live Exams',
                      query: FirebaseFirestore.instance
                          .collection('test')
                          .where('endDate',
                              isGreaterThanOrEqualTo: getTodayDateTimeStamp())
                          //.where('createdBy', isEqualTo: model.userId)
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
                          // .where('createdBy', isEqualTo: model.userId)
                          .limit(2)
                          // .orderBy('endDate')
                          .snapshots(),
                    ),
                    height: 370),
                HeaderCard(
                  title: 'Archived',
                  onTap: () => NavigationManager.navigateTo(
                    context,
                    LiveExamsList(
                      appTitle: 'Archived',
                      query: FirebaseFirestore.instance
                          .collection('test')
                          //.where('createdBy', isEqualTo: model.userId)
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
                          // .where('createdBy', isEqualTo: model.userId)
                          .where('endDate', isLessThan: getTodayDateTimeStamp())
                          .orderBy('endDate', descending: true)
                          .limit(2)
                          .snapshots(),
                    ),
                    height: 370),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
