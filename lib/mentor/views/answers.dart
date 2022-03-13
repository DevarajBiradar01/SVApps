import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/mentor/view_models/add_test_vm.dart';
import 'package:svapp/user/utils/spacers.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../../widgets/radio_group.dart';

class Answers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddTestVM>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Add Exam Contd.'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Row(
                children: [
                  SizedBox(
                    child: Text(model.uploadedFile),
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  const Spacer(),
                  FittedBox(
                    child: rightAlignedButton(
                        context: context,
                        onTap: () => model.uploadPDF(context),
                        buttonName: 'Upload PDF'),
                  )
                ],
              ),
              buildColumnSpacer(),
              TextFormField(
                controller: model.examFeeController,
                decoration: const InputDecoration(
                    hintText: "Exam Title",
                    label: Text('Exam Fee (In Rupees)')),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
              ),
              buildColumnSpacer(height: 20),
              Text('Correct Answers:'),
              for (int i = 1; i <= model.questions; i++)
                Row(
                  children: [
                    Flexible(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Text(i.toString()))),
                    Flexible(
                      flex: 5,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: RadioGroupWidget(
                            radioList: radioModelList,
                            gap: 20,
                            onChanged: (radioButtonId) => onRadioButtonChanged(
                                radioButtonId, i, context)),
                      ),
                    )
                  ],
                ),
              rightAlignedButton(
                  context: context,
                  onTap: () => model.save(context),
                  buttonName: 'Save')
            ],
          ),
        ),
      ),
    );
  }

  void onRadioButtonChanged(
      int radioButtonId, int index, BuildContext context) {
    log('onRadioButtonChanged - value : ' + radioButtonId.toString());
    Provider.of<AddTestVM>(context, listen: false)
        .getSelectedAnswers(context, index, radioButtonId);
  }

  List<FormModel> radioModelList = [
    FormModel(key: 1, value: 'a'),
    FormModel(key: 2, value: 'b'),
    FormModel(key: 3, value: 'c'),
    FormModel(key: 4, value: 'd'),
  ];
}
