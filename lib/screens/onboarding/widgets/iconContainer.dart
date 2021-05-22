import 'package:flutter/material.dart';
import 'package:saanjalo/constants.dart';

class IconContainer extends StatelessWidget {
  final IconData? icon;
  final double? padding;

  IconContainer({this.icon, this.padding})
      : assert(icon != null && padding != null);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding!),
      child: Icon(
        icon,
        size: 32.0,
        color: kWhite,
      ),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.25),
        shape: BoxShape.circle,
      ),
    );
  }
}
