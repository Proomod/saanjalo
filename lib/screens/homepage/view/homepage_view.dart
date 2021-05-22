import 'package:flutter/material.dart';
import 'package:saanjalo/AuthBloc/authenticationbloc_bloc.dart';
import 'package:saanjalo/screens/searchPage/searchpage.dart';
import "package:provider/provider.dart";

// class HomePage extends StatefulWidget {

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => HomePage(),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedBottomIndex = 0;

  void _setIndex(int value) {
    setState(() {
      selectedBottomIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const String avatarUrl =
        "https://c7.uihere.com/files/340/946/334/avatar-user-computer-icons-software-developer-avatar.jpg";
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: GestureDetector(
            onTap: () {
              context
                  .read<AuthenticationblocBloc>()
                  .add(AuthenticationLogOutRequest());
            },
            child: Container(
                padding: EdgeInsets.zero,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Image.network(
                  avatarUrl,
                  fit: BoxFit.cover,
                )),
          ),
          title: const Text(
            'Chats',
          ),
          elevation: 0,
          actions: [
            CircleAvatar(
                backgroundColor: Colors.grey[600],
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                )),
            const SizedBox(width: 10),
            CircleAvatar(
                backgroundColor: Colors.grey[600],
                child: Icon(
                  Icons.create,
                  color: Colors.white,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: GestureDetector(
                onTap: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                },
                child: Container(
                  child: Row(
                    children: [
                      const SizedBox(width: 15.0),
                      Icon(
                        Icons.search,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text('Search', style: TextStyle(color: Colors.grey[400])),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  ),
                  height: 40.0,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: CircleAvatar(
                        radius: 25.0,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.grey[800],
                      ),
                    ),
                    SizedBox(width: 15.0),
                    ActiveButton(),
                    ActiveButton(),
                    ActiveButton(),
                    ActiveButton(),
                    ActiveButton(),
                    ActiveButton(),
                  ]),
            ),
            Expanded(
              child: Column(children: [
                ChatBoxes(),
                ChatBoxes(),
                ChatBoxes(),
                ChatBoxes(),
                ChatBoxes(),
                ChatBoxes(),
                ChatBoxes(),
                ChatBoxes(),
                ChatBoxes(),
              ]),
            ),
            BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: "Chats"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.people), label: "People"),
              ],
              currentIndex: selectedBottomIndex,
              onTap: _setIndex,
              selectedItemColor: Colors.white,
            ),
          ]),
        ));
  }
}

class ChatBoxes extends StatelessWidget {
  const ChatBoxes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        // color: Colors.black,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
        ));
  }
}

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
