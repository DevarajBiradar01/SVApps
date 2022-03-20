import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../../common/views/view_video.dart';
import '../utils/navigation_manager.dart';

class Videos extends StatelessWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Videos'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .orderBy('categoryName')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return Container(
                      decoration: BoxDecoration(
                          // gradient:
                          //     LinearGradient(colors: [Colors.red, Colors.blue]),
                          ),
                      child: InkWell(
                        onTap: () => NavigationManager.navigateTo(
                          context,
                          VideosSubCategory(
                            category: doc['categoryName'],
                            categoryLogo: doc['logo'],
                          ),
                        ),
                        child: Card(
                          // color: Colors.transparent ,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            leading: doc['logo'].isNotEmpty
                                ? Image.network(
                                    doc['logo'],
                                    width: 70,
                                    height: 70,
                                  )
                                : Image.asset(
                                    'assets/sv_logo.png',
                                    width: 70,
                                    height: 70,
                                  ),
                            title: Text(
                              doc['categoryName'],
                              style: TextStyle(
                                  //  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Container(
                height: 120,
                child: const Center(
                  child: Text(
                    "No categories available now",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          } else {
            return const Center(child: Text("No data"));
          }
        },
      ),
    );
  }
}

class VideosSubCategory extends StatelessWidget {
  String category;
  String categoryLogo;
  VideosSubCategory({Key? key, required this.category, this.categoryLogo = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: category + ' Videos'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sub_categories')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return Container(
                      decoration: BoxDecoration(
                          // gradient:
                          //     LinearGradient(colors: [Colors.red, Colors.blue]),
                          ),
                      child: InkWell(
                        onTap: () => NavigationManager.navigateTo(
                            context,
                            VideoList(
                              subCategory: doc['subCategoryName'],
                            )),
                        child: Card(
                          // color: Colors.transparent,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            leading: categoryLogo.isNotEmpty
                                ? Image.network(
                                    categoryLogo,
                                    width: 70,
                                    height: 70,
                                  )
                                : Image.asset(
                                    'assets/sv_logo.png',
                                    width: 70,
                                    height: 70,
                                  ),
                            title: Text(
                              doc['subCategoryName'],
                              style: TextStyle(
                                  //  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Container(
                height: 120,
                child: const Center(
                  child: Text(
                    "No categories available now",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          } else {
            return const Center(child: Text("No data"));
          }
        },
      ),
    );
  }
}

class VideoList extends StatelessWidget {
  String subCategory;
  VideoList({Key? key, required this.subCategory}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: subCategory),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('videos')
                .where('sub_category', isEqualTo: subCategory)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.length > 0) {
                  return ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return InkWell(
                          onTap: () => NavigationManager.navigateTo(
                            context,
                            VideoView(data: doc),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(
                                colors: index % 2 == 0
                                    ? [
                                        Colors.deepOrange,
                                        Colors.lightBlueAccent
                                      ]
                                    : [Colors.lightBlue, Colors.pinkAccent],
                              ),
                            ),
                            child: Card(
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    'https://img.youtube.com/vi/' +
                                        doc['videoId'] +
                                        '/0.jpg',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 10),
                                    child: Text(
                                      doc['title'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          "No videos available now for this category",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return const Center(child: Text("No data"));
              }
            },
          ),
        ),
      ),
    );
  }
}
