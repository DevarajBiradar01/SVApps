import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../firebase_auth/authentication_helper.dart';
import '../../user/utils/widgets.dart';
import '../../utils/utilities.dart';

class Category {
  String createdBy;
  String categoryName;

  Category(this.createdBy, this.categoryName);
}

class SubCategoriesVM extends ChangeNotifier {
  TextEditingController subCategoryController = TextEditingController();
  List<Category> _subCategory = [];
  List<Category> get subcategories => _subCategory;
  List<String> _category = [];
  List<String> get categories => _category;
  String selectedCategory = 'Select Category';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  saveCategory(BuildContext context) async {
    if (selectedCategory == 'Select Category') {
      snackbar(context, 'Please select category');
    } else if (subCategoryController.text.trim().length > 0) {
      await FirebaseFirestore.instance
          .collection("sub_categories")
          .where("subCategoryName",
              isEqualTo: subCategoryController.text.trim().toUpperCase())
          .get()
          .then((value) async {
        if (value.docs.length > 0) {
          snackbar(context, 'Category already exists');
        } else {
          User? user = await AuthenticationHelper().getCurrentUser;
          final categoriesRef = _db.collection('sub_categories');
          await categoriesRef.add({
            'category': selectedCategory,
            'subCategoryName': subCategoryController.text.trim().toUpperCase(),
            'createdBy': user?.uid,
          }).then((value) {
            log("CategoriesVM :: saveCategory ()  value : ");
            snackbar(context, 'Sub Category Added Successfully');

            Navigator.pop(context);
            subCategoryController.text = '';
          }).catchError((onError) {
            log("CategoriesVM :: saveCategory ()  onError : " +
                onError.toString());
            snackbar(context, onError.toString());
          });
        }
      });
    } else {
      snackbar(context, 'Please enter sub category');
    }
  }

  deleteSubCategory(String categoryName) async {
    await FirebaseFirestore.instance
        .collection("sub_categories")
        .where("subCategoryName", isEqualTo: categoryName)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("sub_categories")
            .doc(element.id)
            .delete()
            .then((value) {
          print("Success!");
        });
      });
    });
  }

  selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }
}
