import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svapp/mentor/view_models/add_pdf_vm.dart';

import '../../user/utils/spacers.dart';
import '../../user/utils/widgets.dart';
import '../../widgets/picker_widget.dart';

class AddPdf extends StatefulWidget {
  @override
  _AddPdfState createState() => _AddPdfState();
}

class _AddPdfState extends State<AddPdf> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AddPdfVM>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Add PDF'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<AddPdfVM>(
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
              SizedBox(
                child: PickerWidget(
                    hintText: 'Date of PDF',
                    prefixIcon: Icon(Icons.lock_clock),
                    controller: model.date),
              ),
              buildColumnSpacer(height: 20),
              Row(
                children: [
                  SizedBox(
                    child: Text(model.uploadedFile),
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  const Spacer(),
                  FittedBox(
                    child: testButton(
                        context: context,
                        onTap: () => model.uploadPDF(context),
                        buttonName: 'Upload PDF'),
                  )
                ],
              ),
              buildColumnSpacer(height: 30),
              fullButton(
                  context: context,
                  onTap: () => model.save(context),
                  buttonName: 'Add PDF')
            ],
          ),
        ),
      ),
    );
  }
}
