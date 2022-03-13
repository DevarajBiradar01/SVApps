import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:svapp/user/utils/navigation_manager.dart';

import '../../firebase_auth/authentication_helper.dart';
import '../views/add_test.dart';

class MentorHomeVM extends ChangeNotifier {
  String? userId;

  void addTest(BuildContext context) {
    NavigationManager.navigateTo(context, const AddTest());
    //NavigationManager.navigateTo(context, Answers());
  }

  getCurrentUserId() async {
    User? user = await AuthenticationHelper().getCurrentUser;
    userId = user?.uid;
    notifyListeners();
  }
}
