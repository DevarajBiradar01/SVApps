import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:svapp/mentor/views/mentor_home.dart';

import '../../firebase_auth/authentication_helper.dart';
import '../../user/utils/navigation_manager.dart';
import '../../user/utils/widgets.dart';
import '../../utils/utilities.dart';
import '../views/answers.dart';

class AddTestVM extends ChangeNotifier {
  String selectedCategory = 'Select Category';
  String selectedSubCategory = 'Select Sub Category';
  String selectedMedium = 'Select Medium';
  String selectedStatus = 'Select Status';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  TextEditingController noOfQuestionsController = TextEditingController();
  TextEditingController examTitleController = TextEditingController();
  TextEditingController examFeeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController examStartDateController = TextEditingController();
  TextEditingController examEndDateController = TextEditingController();
  TextEditingController examStartTimeController = TextEditingController();
  TextEditingController examEndTimeController = TextEditingController();
  TextEditingController examDurationController = TextEditingController();
  TextEditingController marksPerQuestionController = TextEditingController();
  TextEditingController optionsPerQuestion = TextEditingController();
  TextEditingController negativeMarks = TextEditingController();

  initScreen() {
    selectedCategory = 'Select Category';
    selectedSubCategory = 'Select Sub Category';
    selectedMedium = 'Select Medium';
    selectedStatus = 'Select Status';
    noOfQuestionsController = TextEditingController();
    examTitleController = TextEditingController();
    examFeeController = TextEditingController();
    descriptionController = TextEditingController();
    examStartDateController = TextEditingController();
    examEndDateController = TextEditingController();
    examStartTimeController = TextEditingController();
    examEndTimeController = TextEditingController();
    examDurationController = TextEditingController();
    marksPerQuestionController = TextEditingController();
    optionsPerQuestion = TextEditingController();
    negativeMarks = TextEditingController();
  }

  selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  selectSubCategory(String subCategory) {
    selectedSubCategory = subCategory;
    notifyListeners();
  }

  selectMedium(String medium) {
    selectedMedium = medium;
    notifyListeners();
  }

  selectStatus(String status) {
    selectedStatus = status;
    notifyListeners();
  }

  onNextPressed(BuildContext context) async {
    if (selectedCategory == 'Select Category') {
      snackbar(context, 'Please Select Category');
    } else if (selectedSubCategory == 'Select Sub Category') {
      snackbar(context, 'Please Select Sub Category');
    } else if (selectedMedium == 'Select Medium') {
      snackbar(context, 'Please Select Medium');
    } else if (noOfQuestionsController.text.trim().length < 1) {
      snackbar(context, 'Please Enter No Of Questions field');
    } else if (examTitleController.text.trim().length < 1) {
      snackbar(context, 'Please Enter Exam Title field');
    } else if (descriptionController.text.trim().length < 1) {
      snackbar(context, 'Please Enter Description field');
    } else if (examStartDateController.text.trim() == '') {
      snackbar(context, 'Please Enter Exam Start Date field');
    } else if (examEndDateController.text.trim() == '') {
      snackbar(context, 'Please Enter Exam End Date field');
    }
    // else if (examStartTimeController.text.trim() == '') {
    //   snackbar(context, 'Please Enter Exam Start Time field');
    // }
    // else if (examEndTimeController.text.trim() == '') {
    //   snackbar(context, 'Please Enter Exam End Time field');
    // }
    else if (examDurationController.text.trim().length < 1) {
      snackbar(context, 'Exam Duration must be more than 5 Minutes!');
    } else if (marksPerQuestionController.text.trim().length < 1) {
      snackbar(context, 'Minimum marks per question is 1!');
    }
    // else if (int.parse(optionsPerQuestion.text.trim()) < 4) {
    //   snackbar(context, 'Minimum options per question is 4!');
    // }
    else if (selectedStatus == 'Select Status') {
      snackbar(context, 'Please Select Status');
    } else {
      questions = int.parse(noOfQuestionsController.text.trim());
      answers = List.filled(questions, 0);
      NavigationManager.navigateTo(context, Answers());
      //save(context);
    }
  }

  save(BuildContext context) async {
    if (examDurationController.text.trim().length < 1) {
      snackbar(context, 'Enter exam fee field');
    } else if (!_uploadedFile.contains('.pdf')) {
      snackbar(context, 'Upload pdf file!');
    } else {
      User? user = await AuthenticationHelper().getCurrentUser;
      final categoriesRef = _db.collection('test').doc();
      answers;
      await categoriesRef.set({
        'category': selectedCategory,
        'sub_category': selectedSubCategory,
        'medium': selectedMedium,
        'noOfQns': noOfQuestionsController.text.trim(),
        'examTitle': examTitleController.text.trim(),
        'desc': descriptionController.text.trim(),
        'startDate':
            convertStringToTimeStamp(examStartDateController.text.trim()),
        'endDate': convertStringToTimeStamp(examEndDateController.text.trim()),
        // 'startTime': examStartTimeController.text.trim(),
        // 'endTime': examEndTimeController.text.trim(),
        'duration': examDurationController.text.trim(),
        'marksPerQns': marksPerQuestionController.text.trim(),
        'optionsPerQns': 4,
        'attemptCount': 0,
        'status': selectedStatus,
        'author': user?.displayName,
        'createdAt': DateTime.now().microsecondsSinceEpoch,
        'createdBy': user?.uid,
        'modifiedAt': DateTime.now().microsecondsSinceEpoch,
        'modifiedBy': user?.uid,
        'pdf': _uploadedFile,
        'fees': examFeeController.text.trim(),
        'answers': answers,
        'id': categoriesRef.id
      }).then((value) {
        log("AddTestVM :: saveTest ()  value : ");
        snackbar(context, 'Test Added Successfully');
        NavigationManager.pushAndRemoveUntil(context, MentorHome());
      }).catchError((onError) {
        log("CategoriesVM :: saveCategory ()  onError : " + onError.toString());
        snackbar(context, onError.toString());
      });
    }
  }

  String _uploadedFile = '';
  String get uploadedFile => _uploadedFile;
  uploadPDF(BuildContext context) async {
    _uploadedFile = await getPdfAndUpload(context);
    notifyListeners();
  }

  int questions = 0;
  List<int> answers = [];
  getSelectedAnswers(BuildContext context, int selectedIndex, int radioValue) {
    answers[selectedIndex - 1] = radioValue - 1;
    print(answers);
  }
}
