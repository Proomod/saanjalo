import 'package:flutter/material.dart';
import 'package:saanjalo/screens/chatPage/chatPage.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:saanjalo/screens/videoCalling/videoCalling.dart';

class ChatBoxes extends StatelessWidget {
  const ChatBoxes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VideoCalling()),
            ),
        child: Card(
            // color: Colors.black,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          const Text('Your Name',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20.0,
                              )),
                          const Text('Your Message'),
                        ],
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    child: Icon(Icons.check, size: 12.0),
                    radius: 8.0,
                  )
                ],
              ),
            )));
  }
}
