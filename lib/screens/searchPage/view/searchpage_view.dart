import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saanjalo/screens/chatPage/chatPage.dart';
import 'package:authentication_repository/authentication_repository.dart';

class CustomSearchDelegate extends SearchDelegate<dynamic> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = ThemeData.dark().copyWith(
      backgroundColor: Colors.black,
    );

    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_left),
        onPressed: () {
          return close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('caseSearch', arrayContains: query)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.data!.docs.isEmpty)
            return Column(
              children: [
                const Text('Suggestions'),
                Row(
                  children: [
                    const CircleAvatar(),
                    const CircleAvatar(),
                    const CircleAvatar(),
                    const CircleAvatar(),
                  ],
                )
              ],
            );
          final results = snapshot.data?.docs;

          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(results![index].data()['username'].toString()),
                  trailing: TextButton(
                      onPressed: () {
                        User myUser = User.fromJson(results[index].data());
                        print(myUser.id);

                        print(
                            ' the result is fucked ${results[index].data()['username']}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                    receiver:
                                        User.fromJson(results[index].data()),
                                  )),
                        );

                        //create chatRoom with receiver and senderId for now
                      },
                      child: Text("Add friend")),
                );
              });
        });
  }
}
