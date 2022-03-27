import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/utilities.dart';

class ViewVideoVM extends ChangeNotifier {
  int _likes = 0;
  int _views = 0;
  bool isHideDesc = true;

  int get like => _likes;
  int get view => _views;

  init() {
    isHideDesc = true;
  }

  updateViewCount(var data) async {
    log(data['id']);
    int views = data['views'];
    var collection = await FirebaseFirestore.instance.collection('videos');
    collection.doc(data['id']).update({'views': ++views});
    _views = views;
    notifyListeners();
  }

  updateLikes(var data) async {
    log(data['id']);
    int likes = data['likes'];
    var collection = await FirebaseFirestore.instance.collection('videos');
    collection.doc(data['id']).update({'likes': ++likes});
    _likes = likes;
    notifyListeners();
  }

  toggleDescription() {
    if (isHideDesc) {
      isHideDesc = false;
    } else {
      isHideDesc = true;
    }
    notifyListeners();
  }
}
