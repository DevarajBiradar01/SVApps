import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../firebase_auth/authentication_helper.dart';
import '../../user/utils/widgets.dart';
import '../../utils/utilities.dart';

class AddVideoVm extends ChangeNotifier {
  final TextEditingController _videoId = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  String selectedCategory = 'Select Category';
  String selectedSubCategory = 'Select Sub Category';
  String _uploadedFile = '';

  TextEditingController get video => _videoId;
  TextEditingController get title => _title;
  TextEditingController get description => _description;

  String get uploadedFile => _uploadedFile;
  init() {
    _videoId.text = '';
    _title.text = '';
    _description.text = '';
    _uploadedFile = '';
    selectedCategory = 'Select Category';
    selectedSubCategory = 'Select Sub Category';
  }

  uploadPDF(BuildContext context) async {
    _uploadedFile = await getPdfAndUpload(context);
    notifyListeners();
  }

  selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  selectSubCategory(String subCategory) {
    selectedSubCategory = subCategory;
    notifyListeners();
  }

  save(BuildContext context) async {
    if (selectedCategory == 'Select Category') {
      snackbar(context, 'Please Select Category');
    } else if (selectedSubCategory == 'Select Sub Category') {
      snackbar(context, 'Please Select Sub Category');
    } else if (_title.text.trim().isEmpty) {
      snackbar(context, 'Enter title field');
    } else if (_description.text.trim().isEmpty) {
      snackbar(context, 'Enter description field');
    } else if (_videoId.text.trim().isEmpty) {
      snackbar(context, 'Enter date field');
    } else {
      showProgress(context);
      User? user = await AuthenticationHelper().getCurrentUser;
      final categoriesRef = _db.collection('videos').doc();
      await categoriesRef.set({
        'author': user?.displayName,
        'category': selectedCategory,
        'sub_category': selectedSubCategory,
        'createdAt': DateTime.now().microsecondsSinceEpoch,
        'createdBy': user?.uid,
        'modifiedAt': DateTime.now().microsecondsSinceEpoch,
        'modifiedBy': user?.uid,
        'videoId': _videoId.text.trim(),
        'title': _title.text.trim(),
        'description': _description.text.trim(),
        'id': categoriesRef.id,
        'pdf': _uploadedFile,
        'likes': 0,
        'views': 0
      }).then((value) {
        Navigator.of(context).pop();
        log("AddTestVM :: saveTest ()  value : ");
        snackbar(context, 'Test Added Successfully');
        _videoId.text = '';
        _title.text = '';
        _description.text = '';
        _uploadedFile = '';
        selectedCategory = 'Select Category';
        selectedSubCategory = 'Select Sub Category';
        Navigator.pop(context);
      }).catchError((onError) {
        Navigator.of(context).pop();
        log("AddVideoVM :: saveCategory ()  onError : " + onError.toString());
        snackbar(context, onError.toString());
      });
    }
  }
}
