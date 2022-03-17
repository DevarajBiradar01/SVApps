import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:svapp/firebase_auth/authentication_helper.dart';
import 'package:svapp/user/utils/navigation_manager.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../../../user/models/user_model.dart';
import '../../../utils/utilities.dart';
import '../views/personal_information.dart';

class PhoneAuthVM extends ChangeNotifier {
  TextEditingController phoneController = TextEditingController();
  String get phoneNumber => phoneController.text.trim();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  updatePhone(BuildContext context) async {
    if (phoneNumber.length != 10) {
      log("PhoneAuthVM :: updatePhone () - Please enter valid 10 digit phone number");
      snackbar(context, 'Please enter valid 10 digit phone number');
    } else {
      showProgress(context);
      String? deviceId = await getDeviceId();
      User? user = await AuthenticationHelper().getCurrentUser;
      UserModel userModel = UserModel(
        email: user!.email!,
        userId: user.uid,
        mobileNumber: phoneNumber,
        role: 'user',
        deviceId: deviceId!,
      );
      final userRef = _db.collection('users').doc(user.uid);
      if ((await userRef.get()).exists) {
        await userRef.update(userModel.asMap()).then((value) {
          log("PhoneAuthVM :: updatePhone ()  value : ");
          snackbar(context, 'User updated successfully!');
          Navigator.pop(context);
          NavigationManager.navigateTo(
              context, PersonalInformation(userModel: userModel));
        }).catchError((onError) {
          log("SignInVM :: saveUserDetailsLocally ()  onError : " +
              onError.toString());
          Navigator.pop(context);
          snackbar(context, onError.toString());
        });
      }
    }
  }
}
