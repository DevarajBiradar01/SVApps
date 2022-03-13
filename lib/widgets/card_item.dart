import 'package:flutter/material.dart';

import '../category_tests.dart';
import '../user/utils/navigation_manager.dart';
import '../user/utils/spacers.dart';

class CardItem extends StatelessWidget {
  bool showBanner;
  String bannerTitle;
  String title;
  int count;
  String logo;
  var data;
  dynamic navigateToClass;

  CardItem(
      {Key? key,
      this.showBanner = false,
      this.bannerTitle = '',
      required this.title,
      required this.data,
      this.count = 1,
      this.logo = '',
      this.navigateToClass})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bannerColor = Colors.blue;
    switch (bannerTitle) {
      case 'Live':
        bannerColor = Colors.red;
        break;
      case 'Featured':
        bannerColor = Colors.green;
        break;
      case 'Trending':
        bannerColor = Colors.orangeAccent;
        break;
      case 'Latest':
        bannerColor = Colors.blueAccent;
        break;
      default:
        bannerColor = Colors.blueAccent;
        break;
    }
    return InkWell(
      onTap: () => NavigationManager.navigateTo(
          context,
          navigateToClass ??
              CategoryTestList(categoryName: title, categoryLogo: logo)),
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width - 15,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  logo.isNotEmpty
                      ? Image.network(
                          logo,
                          width: 70,
                          height: 70,
                        )
                      : Image.asset(
                          'assets/sv_logo.png',
                          width: 70,
                          height: 70,
                        ),
                  buildColumnSpacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // headerMessage(title),
                  buildColumnSpacer(height: 5),
                  const Text('Mock Tests'),
                  buildColumnSpacer(height: 10),
                  const Spacer(),
                ],
              ),
              showBanner
                  ? Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(color: bannerColor),
                        child: Text(bannerTitle,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
