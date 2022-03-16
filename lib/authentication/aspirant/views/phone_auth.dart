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
                  'Authenticate your phone number',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                buildColumnSpacer(height: 80),
                UIMobileNumberField(controller: model.phoneController),
                buildColumnSpacer(height: 30),
                fullButton(
                    context: context,
                    onTap: () => model.updatePhone(context),
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
