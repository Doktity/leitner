import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'DailyPage.dart';
import 'HomePage.dart';

class AnswerPage extends StatelessWidget {
  final String userInput;
  final String reponseKey;
  final String reponseText;
  final String cardId;
  final int periode;

  AnswerPage(this.userInput, this.reponseKey, this.reponseText, this.cardId, this.periode);


  void _updatePeriode(bool isCorrect) async {
    int newPeriode = periode;
    if(isCorrect) {
      newPeriode += 1;
    } else {
      newPeriode = newPeriode == 1 ? newPeriode : newPeriode - 1;
    }
    await FirebaseFirestore.instance
        .collection('Cards')
        .doc(cardId) // Replace with your card's document ID
        .update({'periode': newPeriode}); // Replace with the new period value
  }

  bool _isCorrect(String input, String reponse){
    if(input.toLowerCase() == reponse.toLowerCase()){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool isCorrect = _isCorrect(userInput, reponseKey);
    _updatePeriode(isCorrect);

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