import 'package:flutter/material.dart';
import 'package:saanjalo/constants.dart';

class NextButton extends StatelessWidget {
  final VoidCallback? onpressed;
  NextButton({this.onpressed});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.all(8.0),
      onPressed: onpressed,
      shape: CircleBorder(),
      fillColor: kWhite,
      child: Icon(
        Icons.arrow_forward,
        color: kBlue,
        size: 35.0,
      ),
    );
  }
}
