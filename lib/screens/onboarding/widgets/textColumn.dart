import 'package:flutter/material.dart';
import 'package:saanjalo/constants.dart';

class TextColumn extends StatelessWidget {
  final String? title;
  final String? text;
  TextColumn({this.title, this.text}) : assert(title != null && text != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
            color: kWhite,
          ),
        ),
        SizedBox(
          height: kSpaceS,
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kWhite,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
