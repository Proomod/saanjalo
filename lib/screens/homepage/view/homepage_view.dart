import 'package:flutter/material.dart';
import 'package:saanjalo/AuthBloc/authenticationbloc_bloc.dart';
import 'package:saanjalo/screens/searchPage/searchpage.dart';
import 'package:provider/provider.dart';
import 'package:saanjalo/screens/homepage/widgets/ActiveButton.dart';
import 'package:saanjalo/screens/homepage/widgets/chatBox.dart';

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
  final List<Widget> _widgetList = [
    const ChatPage(),
    const Text('Hello there mate')
  ];

  void _setIndex(int value) {
    setState(() {
      selectedBottomIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const String avatarUrl =
        'https://c7.uihere.com/files/340/946/334/avatar-user-computer-icons-software-developer-avatar.jpg';
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
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                )),
            const SizedBox(width: 10),
            CircleAvatar(
                backgroundColor: Colors.grey[600],
                child: const Icon(
                  Icons.create,
                  color: Colors.white,
                ))
          ],
        ),
        body: _widgetList.elementAt(selectedBottomIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Chats'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'People'),
          ],
          currentIndex: selectedBottomIndex,
          onTap: _setIndex,
          selectedItemColor: Colors.white,
        ));
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      const SizedBox(height: 10.0),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: GestureDetector(
          onTap: () {
            showSearch(context: context, delegate: CustomSearchDelegate());
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
            children: <Widget>[
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
              const SizedBox(width: 15.0),
              const ActiveButton(),
              ActiveButton(),
              ActiveButton(),
              ActiveButton(),
              ActiveButton(),
              ActiveButton(),
            ]),
      ),
      Column(children: [
        const ChatBoxes(),
        const ChatBoxes(),
        const ChatBoxes(),
        const ChatBoxes(),
        const ChatBoxes(),
        const ChatBoxes(),
        const ChatBoxes(),
        const ChatBoxes(),
        const ChatBoxes(),
      ]),
    ]);
  }
}
