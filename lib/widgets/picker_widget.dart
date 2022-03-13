import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PickerWidget extends StatefulWidget {
  final bool isTimePicker;
  final String hintText;
  final Widget prefixIcon;
  // final String validationType;
  final TextEditingController controller;

  PickerWidget({
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    //this.validationType = Validation.kOPTIONAL,
    this.isTimePicker = false,
  });

  DatePickerWidgetState createState() => DatePickerWidgetState();
}

class DatePickerWidgetState extends State<PickerWidget> {
  double bottomPaddingToError = 12;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return TextFormField(
      readOnly: true,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontStyle: FontStyle.normal,
        letterSpacing: 1.2,
      ),
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        hintText: widget.hintText,
        label: Text(widget.hintText),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14.0,
          fontStyle: FontStyle.normal,
          letterSpacing: 1.2,
        ),
        contentPadding: EdgeInsets.only(
          top: 12,
          bottom: bottomPaddingToError,
          left: 8.0,
          right: 8.0,
        ),
        isDense: true,
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12.0,
          fontStyle: FontStyle.normal,
          letterSpacing: 1.2,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      controller: widget.controller,
      validator: (value) {
        // if (widget.validationType != null) {
        // var resultValidate =
        //     Validation.validateTextFormField(value!, widget.validationType);
        // if (resultValidate != null) {
        //   return resultValidate;
        // }
        return value;
        // }
        // return null;
      },
      onTap: () {
        getValueFromPicker();
      },
    );
  }

  getValueFromPicker() async {
    if (widget.isTimePicker == true) {
      var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      widget.controller.text = formatTimeOfDay(time!);
    } else {
      var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      widget.controller.text = date.toString().substring(0, 10);
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jms();
    return format.format(dt);
  }
}
