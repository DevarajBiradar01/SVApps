import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../firebase_auth/authentication_helper.dart';
import '../../user/utils/widgets.dart';
import '../../utils/utilities.dart';

class AddVideoVm extends ChangeNotifier {
  final TextEditingController _videoId = TextEditingController();
  final TextEditingController _title = TextEditingController();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  TextEditingController get video => _videoId;
  TextEditingController get title => _title;

  init() {
    _videoId.text = '';
    _title.text = '';
  }

  save(BuildContext context) async {
    if (_title.text.trim().isEmpty) {
      snackbar(context, 'Enter title field');
    } else if (_videoId.text.trim().isEmpty) {
      snackbar(context, 'Enter date field');
    } else {
      User? user = await AuthenticationHelper().getCurrentUser;
      final categoriesRef = _db.collection('videos').doc();
      await categoriesRef.set({
        'author': user?.displayName,
        'createdAt': DateTime.now().microsecondsSinceEpoch,
        'createdBy': user?.uid,
        'modifiedAt': DateTime.now().microsecondsSinceEpoch,
        'modifiedBy': user?.uid,
        'videoId': _videoId.text.trim(),
        'title': _title.text.trim(),
        'id': categoriesRef.id
      }).then((value) {
        log("AddTestVM :: saveTest ()  value : ");
        snackbar(context, 'Test Added Successfully');
        _videoId.text = '';
        _title.text = '';
        Navigator.pop(context);
      }).catchError((onError) {
        log("AddVideoVM :: saveCategory ()  onError : " + onError.toString());
        snackbar(context, onError.toString());
      });
    }
  }
}
