import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  @override
  Widget build(BuildContext context) {
    return Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Cards").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if (snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }

            if (!snapshot.hasData){
              return Text("Pas de données");
            }

            List<dynamic> cards = [];
            snapshot.data!.docs.forEach((element) {
              cards.add(element);
            });

            return ListView.builder(
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final item = cards[index];
                  final titre = item['questionImgPath'] ?? '';
                  final question = item['question'] ?? '';
                  final reponse = item['reponse'] ?? '';

                  return Card(
                    child: ListTile(
                      leading: FlutterLogo(size: 56.0),
                      title: Text('$titre'),
                      subtitle: Text('$question'),
                      trailing: Icon(Icons.more_vert),
                    ),
                  );
                }
            );
          },
        )
    );
  }
}