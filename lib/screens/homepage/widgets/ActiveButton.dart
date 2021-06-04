// ignore: file_names
import 'package:flutter/material.dart';

class ActiveButton extends StatelessWidget {
  const ActiveButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27.0),
              border: Border.all(
                color: Colors.blue,
                width: 3.0,
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.white60,
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 5.0,
              left: 40.0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.black, width: 2.0)),
                child: const CircleAvatar(
                  radius: 7.0,
                  backgroundColor: Colors.green,
                ),
              )),
        ],
      ),
    );
  }
}
