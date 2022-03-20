import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svapp/common/views/view_pdf.dart';
import 'package:svapp/user/utils/navigation_manager.dart';
import 'package:svapp/user/utils/spacers.dart';
import 'package:svapp/user/utils/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoView extends StatefulWidget {
  var data;
  VideoView({this.data});
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: widget.data['videoId'],
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    return Scaffold(
      appBar: appBar(title: widget.data['title']),
      body: Column(
        children: [
          YoutubePlayerBuilder(
            onExitFullScreen: () {},
            player: YoutubePlayer(
              controller: _controller,
            ),
            builder: (context, player) {
              return Column(
                children: [
                  // some widgets
                  player,
                  //some other widgets
                ],
              );
            },
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
                              width: MediaQuery.of(context).size.width * .8,
                              child: Text(
                                widget.data['title'].toString().toUpperCase(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width * .15,
                            //   child: Row(
                            //     children: [
                            //       const Icon(
                            //         Icons.thumb_up_alt_outlined,
                            //         color: Colors.red,
                            //       ),
                            //       buildRowSpacer(width: 5),
                            //       Text(
                            //         widget.data['likes'].toString(),
                            //         style: const TextStyle(
                            //           fontWeight: FontWeight.bold,
                            //           fontSize: 18,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // buildRowSpacer(width: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.blue,
                                ),
                                buildRowSpacer(width: 5),
                                Text(
                                  widget.data['views'].toString(),
                                  style: TextStyle(
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
              ],
            ),
          )
        ],
      ),
    );
  }

  getDownloadUrl(path) async {
    return await FirebaseStorage.instance.ref(path).getDownloadURL();
  }
}
