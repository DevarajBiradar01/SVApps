import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:svapp/user/view_models/user_drawer_vm.dart';
import 'package:svapp/user/views/pdfs.dart';
import 'package:svapp/user/views/videos.dart';

import '../../authentication/aspirant/view_models/sign_in_vm.dart';
import '../../live_exams_list.dart';
import '../../utils/utilities.dart';
import '../../widgets/categories_list_view_all.dart';
import '../utils/navigation_manager.dart';
import '../utils/spacers.dart';

buildUserDrawer(BuildContext context) {
  Provider.of<UserDrawerVM>(context, listen: false).getUser();

  return Drawer(
    child: Consumer<UserDrawerVM>(
      builder: (context, model, child) => Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.blue],
              ),
            ),
            child: Column(
              children: [
                buildColumnSpacer(height: 40),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.pink,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.pink,
                    child: Icon(
                      Icons.account_circle,
                      size: 80,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  height: 40,
                  child: FittedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          model.userInfo != null
                              ? model.userInfo['firstName']
                              : 'User ID',
                          style: TextStyle(color: Colors.white),
                        ),
                        buildRowSpacer(width: 5),
                        Text(
                            model.userInfo != null
                                ? model.userInfo['lastName']
                                : 'User ID',
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  NavigationManager.navigateTo(
                      context,
                      LiveExamsList(
                        appTitle: 'Live Exams',
                        query: FirebaseFirestore.instance
                            .collection('test')
                            .where('endDate',
                                isGreaterThanOrEqualTo: getTodayDateTimeStamp())
                            .snapshots(),
                      ));
                },
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: const Text(
                      'Exams',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  NavigationManager.navigateTo(
                      context, CategoriesListViewAll());
                },
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: const Text(
                      'Mock Test Series',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  NavigationManager.navigateTo(
                    context,
                    LiveExamsList(
                      appTitle: 'Archived',
                      query: FirebaseFirestore.instance
                          .collection('test')
                          .where('endDate', isLessThan: getTodayDateTimeStamp())
                          .orderBy('endDate', descending: true)
                          .snapshots(),
                    ),
                  );
                },
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: const Text(
                      'Archived Tests',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  NavigationManager.navigateTo(context, Videos());
                },
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: const Text(
                      'Videos',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  NavigationManager.navigateTo(context, PDFs());
                },
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: const Text(
                      'PDFs',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Provider.of<SignInVM>(context, listen: false).logout(context);
                },
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: const Text(
                      'Logout',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
