import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../firebase_auth/authentication_helper.dart';
import '../../user/utils/widgets.dart';
import '../../utils/utilities.dart';

class AddPdfVM extends ChangeNotifier {
  String _uploadedFile = '';
  final TextEditingController _date = TextEditingController();
  final TextEditingController _title = TextEditingController();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get uploadedFile => _uploadedFile;
  TextEditingController get date => _date;
  TextEditingController get title => _title;

  init() {
    _date.text = '';
    _title.text = '';
    _uploadedFile = '';
  }

  uploadPDF(BuildContext context) async {
    _uploadedFile = await getPdfAndUpload(context);
    notifyListeners();
  }

  save(BuildContext context) async {
    if (_title.text.trim().isEmpty) {
      snackbar(context, 'Enter title field');
    } else if (_date.text.trim().isEmpty) {
      snackbar(context, 'Enter date field');
    } else if (!_uploadedFile.contains('.pdf')) {
      snackbar(context, 'Upload pdf file!');
    } else {
      User? user = await AuthenticationHelper().getCurrentUser;
      final categoriesRef = _db.collection('pdfs').doc();
      await categoriesRef.set({
        'author': user?.displayName,
        'createdAt': DateTime.now().microsecondsSinceEpoch,
        'createdBy': user?.uid,
        'modifiedAt': DateTime.now().microsecondsSinceEpoch,
        'modifiedBy': user?.uid,
        'pdf': _uploadedFile,
        'title': _title.text.trim(),
        'date': _date.text.trim(),
        'id': categoriesRef.id
      }).then((value) {
        log("AddTestVM :: saveTest ()  value : ");
        snackbar(context, 'Test Added Successfully');
        _date.text = '';
        _title.text = '';
        _uploadedFile = '';
        Navigator.pop(context);
      }).catchError((onError) {
        log("CategoriesVM :: saveCategory ()  onError : " + onError.toString());
        snackbar(context, onError.toString());
      });
    }
  }
}
