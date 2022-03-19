import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:svapp/user/utils/widgets.dart';

log(String message) {
  if (kDebugMode) {
    print(message);
  }
}

Future<String?> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}

Future getPdfAndUpload(BuildContext context, {String directory = ''}) async {
  String url = '';
  try {
    var rng = Random();
    String randomName = "";
    for (var i = 0; i < 7; i++) {
      log(rng.nextInt(100).toString());
      randomName += rng.nextInt(100).toString();
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowCompression: true,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      String fileName = '${randomName}.pdf';
      log(fileName);
      log('${result.files.single.path!}');
      File file = File(result.files.single.path!);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage
          .ref()
          .child(directory.isEmpty ? 'exam_files' : directory)
          .child(fileName);
      UploadTask uploadTask = ref.putFile(file);
      url = uploadTask.snapshot.ref.fullPath;
    } else {
      snackbar(context, 'Canceled By User!');
      url = 'Canceled By User!';
    }
  } catch (exception) {
    snackbar(context, 'Upload Failed!');
    url = 'Upload Failed!';
  }
  return url;
}

Future getPdfUrl(String path) async {
  String url = await FirebaseStorage.instance.ref(path).getDownloadURL();
  return url;
}

int convertStringToTimeStamp(String date) {
  return DateTime.parse(date).millisecondsSinceEpoch;
}

String convertTimeStampToDateString(int timestamp) {
  log("Utilities :: convertTimeStampToDateString " + timestamp.toString());
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return dateTime.day.toString() +
      "/" +
      dateTime.month.toString() +
      "/" +
      dateTime.year.toString();
}

getTodayDateTimeStamp() {
  DateTime dateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  return dateTime.millisecondsSinceEpoch;
}

showProgress(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        height: 120,
        width: 80,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red, Colors.blue])),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
            Text(
              'Processing...',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}

// void documentFileUpload(String str) {
//   var data = {
//     "PDF": str,1647023400000
//   };
//   mainReference.child("Documents").child('pdf').set(data).then((v) {});
// }
