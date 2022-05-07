import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/mentor/view_models/categories_vm.dart';
import 'package:svapp/user/utils/spacers.dart';

import '../../user/utils/widgets.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      floatingActionButton: Consumer<CategoriesVM>(
        builder: (context, model, widget) => FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              enableDrag: true,
              builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) =>
                    AnimatedPadding(
                  padding: MediaQuery.of(context).viewInsets,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.decelerate,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          headerMessage('Add Category',
                              alignment: Alignment.topLeft),
                          buildColumnSpacer(),
                          TextFormField(
                            controller: model.categoryController,
                            decoration: const InputDecoration(
                              hintText: "Enter Category Name",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                          ),
                          buildColumnSpacer(),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       child: Text(model.uploadedFile),
                          //       width: MediaQuery.of(context).size.width * 0.3,
                          //     ),
                          //     const Spacer(),
                          //     FittedBox(
                          //       child: testButton(
                          //           context: context,
                          //           onTap: () => model.uploadPDF(context),
                          //           buttonName: 'Upload PDF'),
                          //     )
                          //   ],
                          // ),
                          // buildColumnSpacer(),
                          rightAlignedButton(
                              context: context,
                              onTap: () => model.saveCategory(context),
                              buttonName: 'ADD'),
                          buildColumnSpacer(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: Consumer<CategoriesVM>(
        builder: (context, model, widget) => StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.length > 0) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            title: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.centerLeft,
                              child: Text(doc['categoryName'],
                                  textAlign: TextAlign.left),
                            ),
                            trailing: InkWell(
                              onTap: () =>
                                  model.deleteCategory(doc['categoryName']),
                              child: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(
                    child: Text(
                  "No Category found \n Please add category by clicking below add button.",
                  textAlign: TextAlign.center,
                ));
              }
            } else {
              return const Center(child: Text("No data"));
            }
          },
        ),
      ),
    );
  }
}
