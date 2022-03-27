import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svapp/common/views/view_pdf.dart';
import 'package:svapp/user/utils/navigation_manager.dart';
import 'package:svapp/user/utils/spacers.dart';
import 'package:svapp/user/utils/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../utils/utilities.dart';

class VideoView extends StatefulWidget {
  var data;
  VideoView({this.data});
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    updateViewCount();
    _controller = YoutubePlayerController(
      initialVideoId: widget.data['videoId'],
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  updateViewCount() async {
    log(widget.data['id']);
    int views = widget.data['views'];
    var collection = await FirebaseFirestore.instance.collection('videos');
    collection.doc(widget.data['id']).update({'views': ++views});
  }

  updateLikes() async {
    log(widget.data['id']);
    int likes = widget.data['likes'];
    var collection = await FirebaseFirestore.instance.collection('videos');
    collection.doc(widget.data['id']).update({'likes': ++likes});
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => buildVideoWidget(orientation),
    );
  }

  buildVideoWidget(Orientation orientation) {
    if (orientation == Orientation.landscape) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: FittedBox(
          fit: BoxFit.fill,
          child: YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              actionsPadding: const EdgeInsets.only(left: 16.0),
              bottomActions: [
                CurrentPosition(),
                const SizedBox(width: 10.0),
                ProgressBar(isExpanded: true),
                const SizedBox(width: 10.0),
                RemainingDuration(),
                FullScreenButton(),
              ],
              // width: MediaQuery.of(context).size.width,
            ),
            builder: (context, player) => player,
          ),
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: appBar(title: widget.data['title']),
        body: SingleChildScrollView(
          child: Column(
            children: [
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller,
                  width: MediaQuery.of(context).size.width,
                ),
                builder: (context, player) => player,
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: Text(
                                    widget.data['title']
                                        .toString()
                                        .toUpperCase(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () => updateLikes(),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .15,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.thumb_up_alt_outlined,
                                          color: Colors.red,
                                        ),
                                        buildRowSpacer(width: 5),
                                        Text(
                                          widget.data['likes'].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                buildRowSpacer(width: 5),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.blue,
                                    ),
                                    buildRowSpacer(width: 5),
                                    Text(
                                      widget.data['views'].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(widget.data['category']),
                            Text(widget.data['sub_category']),
                          ],
                        ),
                      ),
                    ),
                    buildColumnSpacer(),
                    widget.data['pdf'] != null &&
                            widget.data['pdf'].toString().isNotEmpty
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: alternativeTestButton(
                                  context: context,
                                  onTap: () => NavigationManager.navigateTo(
                                      context, ViewPdf(data: widget.data)),
                                  buttonName: 'View Pdf'),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(widget.data['description']),
                    ),
                    buildColumnSpacer(),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('videos')
                                .where('sub_category',
                                    isEqualTo: widget.data['sub_category'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.docs.length > 0) {
                                  return ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot doc =
                                          snapshot.data!.docs[index];
                                      return InkWell(
                                        onTap: () =>
                                            NavigationManager.replaceTo(
                                          context,
                                          VideoView(data: doc),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Card(
                                            color: Color.fromRGBO(
                                                254, 251, 234, 10),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
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
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0,
                                                                  vertical: 10),
                                                          child: Text(
                                                            doc['title']
                                                                .toString()
                                                                .toUpperCase(),
                                                            style:
                                                                const TextStyle(
                                                                    // color: Colors.white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0,
                                                                  vertical: 0),
                                                          child: Text(
                                                            doc['category']
                                                                .toString()
                                                                .toUpperCase(),
                                                            style:
                                                                const TextStyle(
                                                                    // color: Colors.white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0,
                                                                  vertical: 0),
                                                          child: Text(
                                                            doc['sub_category']
                                                                .toString()
                                                                .toUpperCase(),
                                                            style:
                                                                const TextStyle(
                                                                    // color: Colors.white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    10.0,
                                                                vertical: 0),
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .remove_red_eye_outlined,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            buildRowSpacer(
                                                                width: 5),
                                                            Text(
                                                              doc['views']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
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
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  getDownloadUrl(path) async {
    return await FirebaseStorage.instance.ref(path).getDownloadURL();
  }
}
