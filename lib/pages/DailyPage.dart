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
  bool isLoading = true;

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
    isLoading = false;
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
        title: Text(AppLocalizations.of(context)!.daily),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
        child: (isLoading) ?
        Container(
          margin: EdgeInsets.all(20),
          child: const SizedBox(
            height: 500,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        )
        : noCardsAvailable ?
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.no_cards,
                          style: const TextStyle(
                              fontSize: 24,
                              fontFamily: "Mulish",
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          AppLocalizations.of(context)!.come_back,
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: "Mulish",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                                (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(AppLocalizations.of(context)!.home),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const ListPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(AppLocalizations.of(context)!.list),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
          : Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Text(
                            card['question'] ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: "Mulish",
                            ),
                          ),
                        ),
                        if(card['questionImgPath'] != null && card['questionImgPath'].isNotEmpty)
                          Image.network(
                              card['questionImgPath'],
                              fit: BoxFit.contain,
                              height: 300,
                              width: double.infinity,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox();
                              },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: AppLocalizations.of(context)!.answer,
                          hintText: AppLocalizations.of(context)!.enter_answer,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.error_required_fields;
                          }
                          return null;
                        },
                        controller: reponseController,
                      ),
                    ),
                    const SizedBox(height: 20,),
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
                                  card['reponseImgPath'] ?? '',
                                  card['id'],
                                  userId,
                                  periode,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.send),
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
