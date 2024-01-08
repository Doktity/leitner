import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/business/CardRepository.dart';

import 'DailyPage.dart';
import 'HomePage.dart';

class AnswerPage extends StatelessWidget {
  final String userInput;
  final String reponseKey;
  final String reponseText;
  final String cardId;
  final String userId;
  final int periode;
  final CardRepository _cardRepository = CardRepository();

  AnswerPage(this.userInput, this.reponseKey, this.reponseText, this.cardId, this.userId, this.periode);

  bool _isCorrect(String input, String reponse){
    if(input.toLowerCase() == reponse.toLowerCase()){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool isCorrect = _isCorrect(userInput, reponseKey);
    _cardRepository.updatePeriode(isCorrect, periode, userId, cardId);

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.answer),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                color: isCorrect ? Colors.green : Colors.red,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Center(
                    child: Text(
                      isCorrect ? AppLocalizations.of(context)!.good_job : AppLocalizations.of(context)!.too_bad,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'La réponse était $reponseKey'
                        ),
                        Text(reponseText)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.replay_outlined),
            label: "Rejouer",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Maison"
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DailyPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        },
      ),
    );
  }
}