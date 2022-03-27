import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../../common/views/view_video.dart';
import '../../widgets/header_card.dart';
import '../utils/navigation_manager.dart';
import '../utils/spacers.dart';

class Videos extends StatelessWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Videos'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderCard(
              title: 'All Courses',
              onTap: () => {},
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .orderBy('categoryName')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.length > 0) {
                    return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
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
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    //color: Colors.grey,
                                    width: 150,
                                    height: 100,
                                    child: doc['logo'].isNotEmpty
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
                                  ),
                                  Flexible(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          doc['categoryName'],
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              //  color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
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
          ],
        ),
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
        child: Column(
          children: [
            HeaderCard(title: 'Course Videos', onTap: () {}),
            StreamBuilder<QuerySnapshot>(
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
                            ),
                            child: Card(
                              color: Color.fromRGBO(254, 251, 234, 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Image.network(
                                      'https://img.youtube.com/vi/' +
                                          doc['videoId'] +
                                          '/0.jpg',
                                      width: 150,
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 10),
                                            child: Text(
                                              doc['title']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  // color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 0),
                                            child: Text(
                                              doc['category']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  // color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 0),
                                            child: Text(
                                              doc['sub_category']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  // color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.thumb_up_alt_outlined,
                                                    color: Colors.red,
                                                  ),
                                                  buildRowSpacer(width: 5),
                                                  Text(
                                                    doc['likes'].toString(),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              buildRowSpacer(),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .remove_red_eye_outlined,
                                                    color: Colors.lightBlue,
                                                  ),
                                                  buildRowSpacer(width: 5),
                                                  Text(
                                                    doc['views'].toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
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
          ],
        ),
      ),
    );
  }
}
