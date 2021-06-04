import 'package:flutter/material.dart';
import 'dart:math';

class Logo extends StatelessWidget {
  final Color? color;
  final double? size;
  const Logo({this.color, this.size}) : assert(color != null && size != null);
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 4,
      child: Image.asset(
        'assets/images/google_logo.png',
        width: size,
        color: color,
      ),
    );
  }
}
