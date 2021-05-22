import 'package:flutter/material.dart';

const List<Color> orangeGradients = [
  Color(0xFFFF9844),
  Color(0xFFFE8853),
  Color(0xFFFD7267),
];

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: 'backGround',
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: orangeGradients),
          ),
        ),
      ),
    );
  }
}
