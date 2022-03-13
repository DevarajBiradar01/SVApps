import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

phoneAuth(String phoneNumber, {String? smsCode}) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  await auth.verifyPhoneNumber(
    phoneNumber: '+91 8123555224',
    codeSent: (String verificationId, int? resendToken) async {
      // Update the UI - wait for the user to enter the SMS code
      String smsCode = 'xxxx';

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      debugPrint('Time Out : ' + verificationId);
    },
    verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
      debugPrint('verification Completed : ' +
          json.encode(phoneAuthCredential).toString());
    },
    verificationFailed: (FirebaseAuthException error) {
      debugPrint('verification Failed : ' + error.toString());
    },
  );
}
