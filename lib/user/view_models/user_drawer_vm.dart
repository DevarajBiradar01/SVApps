import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../firebase_auth/authentication_helper.dart';

class UserDrawerVM extends ChangeNotifier {
  User? user;
  var userInfo;
  getUser() async {
    User? user = await AuthenticationHelper().getCurrentUser;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: user!.uid)
        .get();
    // Get data from docs and convert map to List
    userInfo = querySnapshot.docs.map((doc) => doc.data()).toList();
    //userInfo = json.decode(json.encode(userInfo));
    userInfo = userInfo[0];
    notifyListeners();
  }
}
