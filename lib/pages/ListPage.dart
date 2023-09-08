import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  final list = [
    {
      "titre": "Titre 1",
      "question": "q1",
      "reponse": "r1",
    },
    {
      "titre": "Titre 2",
      "question": "q2",
      "reponse": "r2",
    },
    {
      "titre": "Titre 3",
      "question": "q3",
      "reponse": "r3",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              final titre = item['titre'];
              final question = item['question'];
              final reponse = item['reponse'];

              return Card(
                child: ListTile(
                  leading: FlutterLogo(size: 56.0),
                  title: Text('$titre'),
                  subtitle: Text('$question'),
                  trailing: Icon(Icons.more_vert),
                ),
              );
            }
        )
    );
  }
}