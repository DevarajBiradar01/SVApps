import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/user/models/user_model.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../../../user/utils/spacers.dart';
import '../view_models/personal_info_vm.dart';

class PersonalInformation extends StatelessWidget {
  PersonalInformation({Key? key, required this.userModel}) : super(key: key);
  UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonalInfoVM>(
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  child: Image.asset(
                    'assets/sv_logo.png',
                    height: 100,
                  ),
                  alignment: Alignment.centerLeft,
                ),
                buildColumnSpacer(height: 20),
                const Text(
                  'Hello there,',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                buildColumnSpacer(height: 5),
                const Text(
                  'Personal details',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                buildColumnSpacer(height: 100),
                TextFormField(
                  controller: model.firstNameController,
                  decoration: const InputDecoration(
                    hintText: "Firstname",
                    label: Text('Firstname'),
                  ),
                  keyboardType: TextInputType.text,
                ),
                buildColumnSpacer(height: 30),
                TextFormField(
                  controller: model.lastNameController,
                  decoration: const InputDecoration(
                      hintText: "Lastname", label: Text('Lastname')),
                  keyboardType: TextInputType.text,
                ),
                buildColumnSpacer(height: 30),
                fullButton(
                    context: context,
                    onTap: () => model.updateDisplayName(context, userModel),
                    buttonName: "NEXT"),
                buildColumnSpacer(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
