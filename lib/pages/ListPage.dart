import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  Map<String, bool> expandedStates = {}; // Map to store expanded states
  List<String> uniqueCategories = [];
  String selectedCategory = 'All';

  void filterCards(String categorie) {
    setState(() {
      selectedCategory = categorie;
    });
  }

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
            if (element['categorie'] != null) {
              for (var categorie in element['categorie']) {
                if (!uniqueCategories.contains(categorie)) {
                  uniqueCategories.add(categorie);
                }
              }
            }
          });

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        filterCards(newValue!);
                      },
                      items: ['All', ...uniqueCategories].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        filterCards('All');
                      },
                      child: Text('Clear Filter'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final item = cards[index];
                    final questionImgPath = item['questionImgPath'] ?? '';
                    final question = item['question'] ?? '';
                    final reponseKey = item['reponseKey'] ?? '';
                    final reponseText = item['reponseText'] ?? '';
                    final categories = item['categorie'];

                    // Apply filter
                    if (selectedCategory != 'All' && !categories.contains(selectedCategory)) {
                      return Container();
                    }

                    return Card(
                      child: Column(
                        children: [
                          ExpansionTile(
                            leading: FlutterLogo(size: 56.0),
                            title: Text('$question'),
                            subtitle: Text('$reponseKey'),
                            children: [
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        for (var categorie in categories)
                                          Chip(
                                            label: Text(categorie),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(reponseText),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      )
    );
  }
}