import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/mentor/view_models/add_video_vm.dart';
import 'package:svapp/user/utils/widgets.dart';

import '../../user/utils/spacers.dart';

class AddVideo extends StatefulWidget {
  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Add Video'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<AddVideoVm>(
          builder: (context, model, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: model.title,
                decoration: const InputDecoration(
                    hintText: "Title", label: Text('Title')),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
              ),
              buildColumnSpacer(height: 20),
              TextFormField(
                controller: model.video,
                decoration: const InputDecoration(
                    hintText: "Enter Video Id", label: Text('Enter Video Id')),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
              ),
              buildColumnSpacer(height: 30),
              fullButton(
                  context: context,
                  onTap: () => model.save(context),
                  buttonName: 'Add Video')
            ],
          ),
        ),
      ),
    );
  }
}
