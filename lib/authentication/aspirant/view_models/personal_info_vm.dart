import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:svapp/firebase_auth/authentication_helper.dart';
import 'package:svapp/user/models/user_model.dart';
import 'package:svapp/user/utils/widgets.dart';
import 'package:svapp/user/views/user_home.dart';
import 'package:svapp/utils/utilities.dart';

import '../../../user/utils/navigation_manager.dart';

class PersonalInfoVM extends ChangeNotifier {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  String get firstname => firstNameController.text.trim();
  String get lastname => lastNameController.text.trim();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  updateDisplayName(BuildContext context, UserModel userModel) async {
    if (firstname.isEmpty || lastname.isEmpty) {
      log("PersonalInfoVM :: updateDisplayName () - Please enter firstname and lastname");
      snackbar(context, 'Please enter firstname and lastname');
    } else {
      showProgress(context);
      User? user = await AuthenticationHelper().getCurrentUser;
      userModel.firstName = firstname;
      userModel.lastName = lastname;
      userModel.role = 'user';
      final userRef = _db.collection('users').doc(user!.uid);
      if ((await userRef.get()).exists) {
        await userRef.update(userModel.asMap()).then((value) {
          log("PhoneAuthVM :: updateDisplayName ()  value : ");
          snackbar(context, 'User updated successfully!');
          Navigator.pop(context);
          NavigationManager.replaceTo(context, const UserHome());
        }).catchError((onError) {
          log("SignInVM :: updateDisplayName ()  onError : " +
              onError.toString());
          Navigator.pop(context);
          snackbar(context, onError.toString());
        });
      }
    }
  }
}
