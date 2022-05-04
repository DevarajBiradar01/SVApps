import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/user/utils/widgets.dart';
import 'package:svapp/user/view_models/test_screen_vm.dart';
import 'package:svapp/user/views/result_sheet.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../utils/utilities.dart';
import '../../widgets/radio_group.dart';

class TestScreen extends StatefulWidget {
  final dynamic data;
  const TestScreen({Key? key, this.data}) : super(key: key);
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  dynamic data;
  @override
  void initState() {
    super.initState();
    data = widget.data;
    Provider.of<TestScreenVM>(context, listen: false).questions =
        int.parse(data['noOfQns']);
    Provider.of<TestScreenVM>(context, listen: false)
        .initScreen(data['answers'], data);
    Provider.of<TestScreenVM>(context, listen: false).getUrl(data['pdf']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: data['examTitle'],
        // timeWidget: Provider.of<TestScreenVM>(context, listen: false)
        //         .isShowQuestion
        //     ? CountdownTimer(
        //         endTime: DateTime.now().millisecondsSinceEpoch +
        //             1000 * (int.parse(data['duration'])) * 6,
        //         textStyle: const TextStyle(
        //           fontSize: 16,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.white,
        //         ),
        //         endWidget: const Text('Time Up'),
        //         onEnd: () => Provider.of<TestScreenVM>(context, listen: false)
        //             .onSubmitPressed(context, data['id'], data),
        //       )
        //     : Container(),
      ),
      body: Column(
        children: [
          Consumer<TestScreenVM>(
            builder: (context, model, child) => Flexible(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                height: MediaQuery.of(context).size.height * .45,
                child: model.pdfUrl != ''
                    ? SfPdfViewer.network(
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
                      )
                    : Container(),
              ),
            ),
          ),
          Flexible(
            child: Consumer<TestScreenVM>(
                builder: (context, model, child) => model.isShowQuestion
                    ? Column(
                        children: [
                          Text(
                              model.isShowQuestion
                                  ? 'OMR Sheet'
                                  : 'Result Sheet',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          Text(model.isShowQuestion
                              ? '(Mark your answers below)'
                              : '(Check results below)'),
                          Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.red, width: 2),
                            ),
                            child: Consumer<TestScreenVM>(
                              builder: (context, model, child) => SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .33,
                                child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: model.isShowQuestion
                                        ? SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                buildQuestionWidgets(model),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: testButton(
                                                          context: context,
                                                          onTap: () => model
                                                              .onSubmitPressed(
                                                                  context,
                                                                  data['id'],
                                                                  data),
                                                          buttonName: 'Submit'),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        : ResultSheet(data: data)

                                    // rightAlignedButton(
                                    //         context: context,
                                    //         onTap: () => model.showResult(context, data),
                                    //         buttonName: 'Show Result'),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ResultSheet(data: data)),
          )
        ],
      ),
    );
  }

  // _scrollToBottom() {
  //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  // }

  buildQuestionWidgets(TestScreenVM model) {
    //WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToBottom());
    return ListView.builder(
      //controller: _scrollController,
      shrinkWrap: true,
      primary: false,
      itemCount: model.questions,
      itemBuilder: (context, i) => Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text(
              'Q.No. ' + (i + 1).toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            flex: 4,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: RadioGroupWidget(
                  radioList: model.radioModelList,
                  gap: 15,
                  onChanged: (radioButtonId) {
                    // _scrollController.animateTo(
                    //     _scrollController.position.maxScrollExtent,
                    //     duration: Duration(milliseconds: 200),
                    //     curve: Curves.easeOut);
                    model.onRadioButtonChanged(radioButtonId - 1, i, context);
                    setState(() {});
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getElementTitle(int index) {
    String strTitle;
    switch (index) {
      case 0:
        strTitle = 'A';
        break;
      case 1:
        strTitle = 'B';
        break;
      case 2:
        strTitle = 'C';
        break;
      case 3:
        strTitle = 'D';
        break;
      default:
        strTitle = '';
    }
    return Text(strTitle);
  }
}
