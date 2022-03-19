import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/common/view_models/view_pdf_vm.dart';
import 'package:svapp/user/utils/widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../utils/utilities.dart';

class ViewPdf extends StatefulWidget {
  var data;
  ViewPdf({this.data});
  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ViewPdfVM>(context, listen: false)
        .getPdfUrl(widget.data['pdf']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: widget.data['title']),
      body: Consumer<ViewPdfVM>(
        builder: (context, model, child) => Container(
          child: model.pdfUrl == ''
              ? Center(child: CircularProgressIndicator())
              : SfPdfViewer.network(
                  model.pdfUrl,
                  canShowScrollStatus: true,
                  enableTextSelection: false,
                  canShowPasswordDialog: true,
                  canShowPaginationDialog: true,
                  canShowScrollHead: true,
                  enableDoubleTapZooming: true,
                  enableDocumentLinkAnnotation: true,
                  currentSearchTextHighlightColor: Colors.blueAccent,
                  onDocumentLoaded: (val) {
                    log(val.toString());
                  },
                  pageLayoutMode: PdfPageLayoutMode.continuous,
                  //  interactionMode: PDFIN,
                ),
        ),
      ),
    );
  }

  getDownloadUrl(path) async {
    return await FirebaseStorage.instance.ref(path).getDownloadURL();
  }
}
