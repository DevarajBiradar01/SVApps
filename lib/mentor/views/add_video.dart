import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/mentor/view_models/add_video_vm.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../../user/utils/spacers.dart';

class AddVideo extends StatefulWidget {
  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Add Video'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<AddVideoVm>(
            builder: (context, model, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                TextFormField(
                  controller: model.title,
                  decoration: const InputDecoration(
                      hintText: "Title", label: Text('Title')),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                ),
                buildColumnSpacer(height: 20),
                TextFormField(
                  controller: model.description,
                  decoration: const InputDecoration(
                      hintText: "Description", label: Text('Description')),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  maxLines: 4,
                ),
                buildColumnSpacer(height: 20),
                TextFormField(
                  controller: model.video,
                  decoration: const InputDecoration(
                      hintText: "Enter Video Id",
                      label: Text('Enter Video Id')),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                ),
                buildColumnSpacer(height: 20),
                Row(
                  children: [
                    SizedBox(
                      child: Text(model.uploadedFile),
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    const Spacer(),
                    FittedBox(
                      child: testButton(
                          context: context,
                          onTap: () => model.uploadPDF(context),
                          buttonName: 'Upload PDF'),
                    )
                  ],
                ),
                buildColumnSpacer(height: 30),
                fullButton(
                    context: context,
                    onTap: () => model.save(context),
                    buttonName: 'Add Video')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
