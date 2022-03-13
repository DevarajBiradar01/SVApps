import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/user/utils/widgets.dart';
import 'package:ui_components_library/ui_components_library.dart';

import '../../../user/utils/spacers.dart';
import '../view_models/phone_auth_vm.dart';

class PhoneAuth extends StatelessWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PhoneAuthVM>(
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              svgWidget(context),
              titleMessage("Phone Authentication"),
              buildColumnSpacer(),
              headerMessage(
                  "Please register your mobile number for better communication"),
              buildColumnSpacer(),
              UIMobileNumberField(controller: model.phoneController),
              buildColumnSpacer(),
              rightAlignedButton(
                  context: context,
                  onTap: () => model.updatePhone(context),
                  buttonName: "NEXT"),
              buildColumnSpacer(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
