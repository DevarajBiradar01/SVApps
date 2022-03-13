import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'non_scrollable_grid.dart';

class FormModel {
  FormModel({this.key, this.value});

  dynamic key;
  dynamic value;
}

class RadioGroupWidget extends StatefulWidget {
  const RadioGroupWidget({
    required this.radioList,
    required this.onChanged,
    this.columnCount = 4,
    this.gap = 0,
  });

  final List<FormModel> radioList;
  final Function onChanged;
  final int columnCount;
  final double gap;

  @override
  RadioGroupWidgetState createState() => RadioGroupWidgetState();
}

class RadioGroupWidgetState extends State<RadioGroupWidget> {
  int id = -1;

  @override
  Widget build(BuildContext context) {
    return NonScrollableGrid(
      margin: EdgeInsets.all(10),
      gap: widget.gap,
      columnCount: widget.columnCount,
      padding: const EdgeInsets.all(0),
      children: List.generate(
        widget.radioList.length,
        (index) => buildRadioListTile(widget.radioList[index], index),
      ),
    );
  }

  buildRadioListTile(FormModel radioModel, int index) {
    return RadioListTile(
      key: Key('radio_key_$index'),
      title: Text(
        radioModel.value.toString().toUpperCase(),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      groupValue: radioModel.key == id ? id : 0,
      contentPadding: const EdgeInsets.all(0),
      visualDensity: const VisualDensity(horizontal: 1, vertical: 1),
      value: radioModel.key,
      toggleable: true,
      dense: true,
      controlAffinity: ListTileControlAffinity.trailing,
      onChanged: (dynamic selectedId) {
        setState(() {
          id = selectedId;
        });
        widget.onChanged(selectedId);
      },
    );
  }
}
