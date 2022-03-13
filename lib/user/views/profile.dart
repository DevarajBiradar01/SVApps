import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svapp/user/utils/spacers.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              buildColumnSpacer(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {},
                  child: const Icon(Icons.edit, size: 30),
                ),
              ),
              buildColumnSpacer(),
              const CircleAvatar(
                radius: 50,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 45,
                  child: Icon(
                    Icons.person,
                    size: 45,
                  ),
                ),
              ),
              buildColumnSpacer(),
              const Text(
                'Firstname Lastname',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5),
              ),
              buildColumnSpacer(height: 30),
              buildDetailsWidget(key: 'DOB : ', value: '12/08/1889'),
              buildColumnSpacer(),
              buildDetailsWidget(
                  key: 'Email : ', value: 'spardhavishwas@gmail.com'),
              buildColumnSpacer(),
              buildDetailsWidget(key: 'Contact : ', value: '9xxxxxxxxx'),
              buildColumnSpacer(),
              buildDetailsWidget(key: 'Qualification : ', value: 'BA'),
              buildColumnSpacer(),
              buildDetailsWidget(key: 'City : ', value: 'Indi, Karnataka'),
              buildColumnSpacer(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Select your preference : ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              buildChip('SDA, FDA, KPSC, PSI, Banking, UPSC'),
              buildColumnSpacer(),
            ],
          ),
        ),
      ),
    );
  }

  buildDetailsWidget({required String key, required String value}) {
    return Row(
      children: [
        Text(
          key,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 4,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  buildChip(String value) {
    List<String> chips = value.split(',');
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: chips.length,
      itemBuilder: (context, index) => CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        onChanged: (bool? value) {},
        value: true,
        visualDensity: const VisualDensity(vertical: .01, horizontal: 0.1),
        title: Text(
          chips[index],
          textAlign: TextAlign.left,
          style: const TextStyle(
            //   fontSize: 16,
            fontWeight: FontWeight.w500,
            //   letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
