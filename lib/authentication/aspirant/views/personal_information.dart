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
          child: ListView(
            children: [
              svgWidget(context),
              titleMessage("Personal Information"),
              buildColumnSpacer(),
              headerMessage("Please provide your firstname and lastname here."),
              buildColumnSpacer(),
              TextFormField(
                controller: model.firstNameController,
                decoration: const InputDecoration(
                  hintText: "Firstname",
                ),
                keyboardType: TextInputType.text,
              ),
              buildColumnSpacer(),
              TextFormField(
                controller: model.lastNameController,
                decoration: const InputDecoration(
                  hintText: "Lastname",
                ),
                keyboardType: TextInputType.text,
              ),
              buildColumnSpacer(),
              rightAlignedButton(
                  context: context,
                  onTap: () => model.updateDisplayName(context, userModel),
                  buttonName: "NEXT"),
              buildColumnSpacer(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
