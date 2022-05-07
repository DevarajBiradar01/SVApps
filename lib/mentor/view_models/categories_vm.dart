import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:svapp/firebase_auth/authentication_helper.dart';
import 'package:svapp/utils/utilities.dart';

import '../../user/utils/widgets.dart';

class Category {
  String createdBy;
  String categoryName;

  Category(this.createdBy, this.categoryName);
}

class CategoriesVM extends ChangeNotifier {
  TextEditingController categoryController = TextEditingController();
  List<Category> _category = [];
  List<Category> get categories => _category;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  String get uploadedFile => _uploadedFile;
  String _uploadedFile = '';
  uploadPDF(BuildContext context) async {
    _uploadedFile = await getPdfAndUpload(context);
    notifyListeners();
  }

  saveCategory(BuildContext context) async {
    if (categoryController.text.trim().length > 0) {
      await FirebaseFirestore.instance
          .collection("categories")
          .where("categoryName",
              isEqualTo: categoryController.text.trim().toUpperCase())
          .get()
          .then((value) async {
        if (value.docs.length > 0) {
          snackbar(context, 'Category already exists');
        } else {
          User? user = await AuthenticationHelper().getCurrentUser;
          final categoriesRef = _db.collection('categories');
          await categoriesRef.add({
            'categoryName': categoryController.text.trim().toUpperCase(),
            'createdBy': user?.uid,
            'logo': _uploadedFile
          }).then((value) {
            log("CategoriesVM :: saveCategory ()  value : ");
            snackbar(context, 'Category Added Successfully');

            Navigator.pop(context);
            categoryController.text = '';
          }).catchError((onError) {
            log("CategoriesVM :: saveCategory ()  onError : " +
                onError.toString());
            snackbar(context, onError.toString());
          });
        }
      });
    } else {
      snackbar(context, 'Please enter category!');
    }
  }

  deleteCategory(String categoryName) async {
    await FirebaseFirestore.instance
        .collection("categories")
        .where("categoryName", isEqualTo: categoryName)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("categories")
            .doc(element.id)
            .delete()
            .then((value) {
          print("Success!");
        });
      });
    });
  }
}
