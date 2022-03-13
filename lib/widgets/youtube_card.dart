import 'package:flutter/material.dart';

List<String> images = [
  'https://www.pngmagic.com/product_images/youtube-banner-background-2048x1152.jpg',
  'https://www.pngmagic.com/product_images/youtube-banner-background-2048x1152.jpg',
];

class YoutubeCardItem extends StatelessWidget {
  const YoutubeCardItem({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: Card(
            color: Colors.blue.shade50,
            elevation: 5,
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(images[index]),
                ),
              ),
              child: const Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.play_circle_fill_outlined,
                  size: 45,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
