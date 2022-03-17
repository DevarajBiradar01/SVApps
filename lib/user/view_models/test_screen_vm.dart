import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svapp/user/views/result_sheet.dart';
import 'package:svapp/utils/utilities.dart';

import '../../firebase_auth/authentication_helper.dart';
import '../../widgets/radio_group.dart';
import '../utils/navigation_manager.dart';
import '../utils/widgets.dart';

class TestScreenVM extends ChangeNotifier {
  int questions = 0;
  late List<dynamic> correctAnswers;
  late List<int> answers;
  // late List<dynamic> markedAnswers;

  String timer = '0:00';
  String pdfUrl = '';

  initScreen(List<dynamic> originalAnswers, dynamic data) {
    checkUserAttended(data);
    answers = List.filled(questions, -1);
    correctAnswers = originalAnswers;

    timer = '0:00';
    isShowQuestion = true;
    correctAnswerCount = 0;
    wrongAnswerCount = 0;
    // markedAnswers = List.filled(questions, -1);
  }

  List<FormModel> radioModelList = [
    FormModel(key: 1, value: 'a'),
    FormModel(key: 2, value: 'b'),
    FormModel(key: 3, value: 'c'),
    FormModel(key: 4, value: 'd'),
  ];

  int correctAnswerCount = 0;
  int wrongAnswerCount = 0;
  onSubmitPressed(BuildContext context, String testId, dynamic data) async {
    for (int i = 0; i < questions; i++) {
      if (correctAnswers[i] == answers[i]) {
        correctAnswerCount++;
      } else {
        wrongAnswerCount++;
      }
    }
    User? user = await AuthenticationHelper().getCurrentUser;
    final categoriesRef = FirebaseFirestore.instance.collection('attendees');
    await categoriesRef.add({
      'submitted_answers': answers,
      'userId': user!.uid,
      'testId': testId,
      'correctAnswers': correctAnswers,
      'correct': correctAnswerCount,
      'wrong': wrongAnswerCount
    }).then((value) {
      log("AddTestVM :: saveTest ()  value : ");
      snackbar(context, 'Test Submitted Successfully');
      showResult(context, data);
    }).catchError((onError) {
      log("CategoriesVM :: saveCategory ()  onError : " + onError.toString());
      snackbar(context, onError.toString());
    });
  }

  onRadioButtonChanged(radioButtonId, int index, BuildContext context) {
    answers[index] = radioButtonId;
    log(index.toString());

    print(answers);
    notifyListeners();
  }

  getUrl(String path) async {
    pdfUrl = await getPdfUrl(path);
    notifyListeners();
  }

  bool isShowQuestion = true;
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

  showResult(BuildContext context, dynamic data) {
    NavigationManager.replaceTo(
        context, ResultSheet(data: data, isShowAppBar: true));
  }

  String userId = '';
  getCurrentUserId() async {
    User? user = await AuthenticationHelper().getCurrentUser;
    userId = user!.uid;
    notifyListeners();
  }

  // Future<void> getMarkedAnswers(String testId) async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('attendees')
  //       .where('testId', isEqualTo: testId)
  //       .get();
  //
  //   // Get data from docs and convert map to List
  //   markedAnswers = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   log(markedAnswers.toString());
  //   notifyListeners();
  // }
}
