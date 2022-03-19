import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      flags:
          const YoutubePlayerFlags(autoPlay: true, mute: false, isLive: true),
    );
    return Scaffold(
      appBar: appBar(title: widget.data['title']),
      body: YoutubePlayerBuilder(
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
    );
  }

  getDownloadUrl(path) async {
    return await FirebaseStorage.instance.ref(path).getDownloadURL();
  }
}
