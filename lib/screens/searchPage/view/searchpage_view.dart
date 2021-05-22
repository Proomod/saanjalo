import 'package:flutter/material.dart';

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
    return Text(query);
  }
}
