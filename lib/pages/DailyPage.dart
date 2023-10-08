import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AnswerPage.dart';
import 'HomePage.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {

  final _formKey = GlobalKey<FormState>();
  final reponseController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    reponseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text('Daily'),
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
        stream: FirebaseFirestore.instance.collection("Cards")
            .orderBy('periode', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData){
            return Text("Pas de données");
          }


          List<dynamic> cards = snapshot.data!.docs;
          final max = cards.length > 10 ? 10 : cards.length;

          final card = cards[Random().nextInt(max)];
          final String cardId = card.id;
          final int periode = card['periode'] ?? '';
          final String question = card['question'] ?? '';
          final String reponseKey = card['reponseKey'] ?? '';
          final String reponseText = card['reponseText'] ?? '';

          return Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Center(
                        child: Text(
                            question,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: "Mulish"
                          ),
                        )
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Réponse",
                          hintText: "Entrez votre réponse",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Champs obligatoire";
                          }
                          return null;
                        },
                        controller: reponseController,
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: (){
                            if (_formKey.currentState!.validate()){
                              final reponseInput = reponseController.text;

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AnswerPage(reponseInput, reponseKey, reponseText, cardId, periode)
                                  )
                              );
                            }
                          },
                          child: Text("Envoyer")
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}