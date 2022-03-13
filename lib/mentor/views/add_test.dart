import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/mentor/view_models/add_test_vm.dart';
import 'package:svapp/user/utils/spacers.dart';
import 'package:svapp/widgets/picker_widget.dart';
import 'package:svapp/widgets/radio_group.dart';

import '../../user/utils/widgets.dart';
import '../../utils/utilities.dart';

class AddTest extends StatefulWidget {
  const AddTest({Key? key}) : super(key: key);

  @override
  _AddTestState createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  @override
  void initState() {
    super.initState();
    Provider.of<AddTestVM>(context, listen: false).initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Add Exam'),
      body: Consumer<AddTestVM>(
        builder: (context, model, child) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .orderBy("categoryName")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        debugPrint('snapshot status: ${snapshot.error}');
                        return const Text('No Data');
                      } else {
                        return DropdownButtonFormField<dynamic>(
                          items: snapshot.data?.docs.map((label) {
                            log(label.get('categoryName'));
                            return DropdownMenuItem(
                              child: FittedBox(
                                  child: Text(label.get('categoryName'))),
                              value: label.get('categoryName'),
                            );
                          }).toList(),
                          hint: const Text('Select Category'),
                          onChanged: (value) {
                            model.selectCategory(value);
                          },
                        );
                      }
                    }),
                buildColumnSpacer(),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('sub_categories')
                        .where('category', isEqualTo: model.selectedCategory)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        debugPrint('snapshot status: ${snapshot.error}');
                        return const Text('No Data');
                      } else {
                        return DropdownButtonFormField<dynamic>(
                          items: snapshot.data?.docs.map((label) {
                            return DropdownMenuItem(
                              child: FittedBox(
                                  child: Text(label.get('subCategoryName'))),
                              value: label.get('subCategoryName'),
                            );
                          }).toList(),
                          hint: const Text('Select Sub Category'),
                          onChanged: (value) {
                            model.selectSubCategory(value);
                          },
                        );
                      }
                    }),
                buildColumnSpacer(),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .45,
                      child: DropdownButtonFormField<String>(
                        //  value: _ratingController,
                        items:
                            ['Select Medium', 'English', 'Kannada', 'KN - EN']
                                .map((label) => DropdownMenuItem(
                                      child: Text(label.toString()),
                                      value: label,
                                    ))
                                .toList(),
                        hint: const Text('Select Medium'),
                        onChanged: (value) {
                          model.selectMedium(value!);
                        },
                      ),
                    ),
                    buildRowSpacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .45,
                      child: TextFormField(
                        controller: model.noOfQuestionsController,
                        decoration: const InputDecoration(
                          hintText: "No of Questions",
                          label: Text('No of Questions'),
                        ),
                        inputFormatters: [],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                buildColumnSpacer(),
                TextFormField(
                  controller: model.examTitleController,
                  decoration: const InputDecoration(
                      hintText: "Exam Title", label: Text('Exam Title')),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                ),
                buildColumnSpacer(),
                TextFormField(
                  controller: model.descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Description", label: Text('Description')),
                  minLines: 3,
                  maxLines: 3,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                ),
                buildColumnSpacer(),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .45,
                      child: PickerWidget(
                          hintText: 'Exam Start Date',
                          prefixIcon: Icon(Icons.lock_clock),
                          controller: model.examStartDateController),
                    ),
                    buildRowSpacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .45,
                      child: PickerWidget(
                          hintText: 'Exam End Date',
                          prefixIcon: const Icon(Icons.lock_clock),
                          controller: model.examEndDateController),
                    ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * .45,
                    //   child: PickerWidget(
                    //     hintText: 'Exam Start Time',
                    //     prefixIcon: Icon(Icons.lock_clock),
                    //     controller: model.examStartTimeController,
                    //     isTimePicker: true,
                    //   ),
                    // ),
                  ],
                ),
                // buildColumnSpacer(),
                // Row(
                //   children: [
                //     // SizedBox(
                //     //   width: MediaQuery.of(context).size.width * .45,
                //     //   child: PickerWidget(
                //     //       hintText: 'Exam End Date',
                //     //       prefixIcon: const Icon(Icons.lock_clock),
                //     //       controller: model.examEndDateController),
                //     // ),
                //     // buildRowSpacer(),
                //     // SizedBox(
                //     //   width: MediaQuery.of(context).size.width * .45,
                //     //   child: PickerWidget(
                //     //     hintText: 'Exam End Time',
                //     //     prefixIcon: Icon(Icons.lock_clock),
                //     //     controller: model.examEndTimeController,
                //     //     isTimePicker: true,
                //     //   ),
                //     // ),
                //   ],
                // ),
                buildColumnSpacer(),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: model.examDurationController,
                        decoration: const InputDecoration(
                          hintText: "Exam Duration (In Minutes)",
                          label: Text("Exam Duration (In Minutes)"),
                        ),
                        inputFormatters: [],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    buildRowSpacer(),
                    Flexible(
                      child: TextFormField(
                        controller: model.marksPerQuestionController,
                        decoration: const InputDecoration(
                          hintText: "Marks per question",
                          label: Text("Marks per question"),
                        ),
                        inputFormatters: [],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                buildColumnSpacer(),
                // TextFormField(
                //   controller: model.optionsPerQuestion,
                //   decoration: const InputDecoration(
                //     hintText: "options per question",
                //     label: Text("options per question"),
                //   ),
                //   inputFormatters: [],
                //   autovalidateMode: AutovalidateMode.onUserInteraction,
                //   keyboardType: TextInputType.number,
                // ),
                // buildColumnSpacer(),
                DropdownButtonFormField<String>(
                  //  value: _ratingController,
                  items: [
                    'Select Status',
                    'Live',
                    'Latest',
                    'Trending',
                    'Featured'
                  ]
                      .map((label) => DropdownMenuItem(
                            child: Text(label.toString()),
                            value: label,
                          ))
                      .toList(),
                  hint: const Text('Select Status'),
                  onChanged: (value) {
                    model.selectStatus(value!);
                  },
                ),
                buildColumnSpacer(),
                rightAlignedButton(
                    context: context,
                    onTap: () => model.onNextPressed(context),
                    buttonName: 'Next')
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onRadioButtonChanged(int radioButtonId) {
    print('onRadioButtonChanged - value : ' + radioButtonId.toString());
  }

  List<FormModel> radioModelList = [
    FormModel(key: 1, value: 'a'),
    FormModel(key: 2, value: 'b'),
    FormModel(key: 3, value: 'c'),
    FormModel(key: 4, value: 'd'),
  ];
}
