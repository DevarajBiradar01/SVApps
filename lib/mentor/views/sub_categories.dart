import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../user/utils/spacers.dart';
import '../../user/utils/widgets.dart';
import '../view_models/sub_categories_vm.dart';

class SubCategories extends StatefulWidget {
  const SubCategories({Key? key}) : super(key: key);
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
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
      floatingActionButton: Consumer<SubCategoriesVM>(
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
                          headerMessage('Add Sub Category',
                              alignment: Alignment.topLeft),
                          buildColumnSpacer(),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('categories')
                                  .orderBy("categoryName")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  debugPrint(
                                      'snapshot status: ${snapshot.error}');
                                  return Container(
                                    child: Text('No Data'),
                                  );
                                } else {
                                  return DropdownButtonFormField<dynamic>(
                                    items: snapshot.data?.docs.map((label) {
                                      print(label.get('categoryName'));
                                      return DropdownMenuItem(
                                        child: FittedBox(
                                            child: Text(
                                                label.get('categoryName'))),
                                        value: label.get('categoryName'),
                                      );
                                    }).toList(),
                                    hint: const Text('Select Category'),
                                    onChanged: (value) {
                                      model.selectCategory(value);
                                      setState(() {});
                                    },
                                  );
                                }
                              }),
                          buildColumnSpacer(),
                          TextFormField(
                            controller: model.subCategoryController,
                            decoration: const InputDecoration(
                              hintText: "Enter Category Name",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                          ),
                          buildColumnSpacer(),
                          rightAlignedButton(
                              context: context,
                              onTap: () => model.saveCategory(context),
                              buttonName: 'ADD')
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
      body: Consumer<SubCategoriesVM>(
        builder: (context, model, widget) => StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('sub_categories')
              .snapshots(),
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
                              child: Text(doc['subCategoryName'],
                                  textAlign: TextAlign.left),
                            ),
                            subtitle: Container(
                              padding: const EdgeInsets.only(left: 8),
                              alignment: Alignment.centerLeft,
                              child: Text(doc['category'],
                                  textAlign: TextAlign.left),
                            ),
                            trailing: InkWell(
                              onTap: () => model
                                  .deleteSubCategory(doc['subCategoryName']),
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
