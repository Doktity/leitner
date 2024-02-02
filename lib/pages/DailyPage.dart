import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../business/CardRepository.dart';
import 'AnswerPage.dart';
import 'HomePage.dart';
import 'ListPage.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  final _formKey = GlobalKey<FormState>();
  final reponseController = TextEditingController();
  final CardRepository _cardRepository = CardRepository();
  dynamic card = {};
  int periode = 1;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  bool noCardsAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      card = await _cardRepository.getRandomCard(userId);
      periode = await _cardRepository.getUserCardPeriode(userId, card['id']);
    } catch (e) {
      noCardsAvailable = true;
    }
    setState(() {}); // Trigger a rebuild after data is loaded
  }

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
        title: Text(AppLocalizations.of(context)!.daily,
          style: TextStyle(
            fontFamily: "Mulish",
          ),
        ),
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
      body: SingleChildScrollView(
        child: (card == {}) ?
        const Center(child: CircularProgressIndicator())
        : noCardsAvailable ?
          Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "There is no card available today",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Mulish",
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "Come back tomorrow!",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Mulish",
                            ),
                          ),
                          SizedBox(height: 20,),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to HomePage
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => HomePage()),
                                    (Route<dynamic> route) => false,
                              );
                            },
                            child: Text("Home"),
                          ),
                          SizedBox(height: 10), // Spacing
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to ListPage (replace 'ListPage()' with your actual ListPage class)
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ListPage()),
                              );
                            },
                            child: Text("List"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
          : Column(
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
                        card['question'] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Mulish",
                        ),
                      ),
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final reponseInput = reponseController.text;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AnswerPage(
                                  reponseInput,
                                  card['reponseKey'] ?? '',
                                  card['reponseText'] ?? '',
                                  card['id'],
                                  userId,
                                  periode,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text("Envoyer"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
