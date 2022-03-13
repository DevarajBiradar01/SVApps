import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../user/utils/spacers.dart';

class InfoWidget extends StatelessWidget {
  final String label;
  final String value;
  const InfoWidget({Key? key, required this.label, required this.value})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        buildColumnSpacer(height: 5),
        Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        )
      ],
    );
  }
}
