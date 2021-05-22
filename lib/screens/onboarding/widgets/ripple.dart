import 'package:flutter/material.dart';
import 'package:saanjalo/constants.dart';

class Ripple extends StatelessWidget {
  const Ripple({this.radius, Key? key}) : super(key: key);

  final double? radius;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
        left: screenWidth / 2 - radius!,
        bottom: 2 * kPaddingL - radius!,
        child: Container(
          height: 2 * radius!,
          width: 2 * radius!,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: kWhite,
          ),
        ));
  }
}
