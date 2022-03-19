import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ViewPdfVM extends ChangeNotifier {
  String pdfUrl = '';
  Future getPdfUrl(String path) async {
    pdfUrl = '';
    pdfUrl = await FirebaseStorage.instance.ref(path).getDownloadURL();
    notifyListeners();
  }
}
