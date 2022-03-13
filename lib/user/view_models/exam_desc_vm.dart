import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../firebase_auth/authentication_helper.dart';

class ExamDescVM extends ChangeNotifier {
  bool isShowQuestion = false;
  checkUserAttended(dynamic data) async {
    User? user = await AuthenticationHelper().getCurrentUser;
    await FirebaseFirestore.instance
        .collection("attendees")
        .where("userId", isEqualTo: user!.uid)
        .where('testId', isEqualTo: data['id'])
        .get()
        .then((value) async {
      if (value.docs.length > 0) {
        isShowQuestion = false;
      } else {
        isShowQuestion = true;
      }
    });
    notifyListeners();
  }
}
