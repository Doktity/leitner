import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to HomePage
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: StreamBuilder(
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
              final questionImgPath = item['questionImgPath'] ?? '';
              final question = item['question'] ?? '';
              final reponseKey = item['reponseKey'] ?? '';

              return Card(
                child: ListTile(
                  leading: FlutterLogo(size: 56.0),
                  title: Text('$question'),
                  subtitle: Text('$reponseKey'),
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