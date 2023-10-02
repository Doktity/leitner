import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'DailyPage.dart';
import 'HomePage.dart';

class AnswerPage extends StatelessWidget {
  final String userInput;
  final String reponse;
  final String cardId;
  final int periode;

  AnswerPage(this.userInput, this.reponse, this.cardId, this.periode);

  // Inside your AnswerPage class
  void _updatePeriode(bool isCorrect) async {
    int newPeriode = periode + 1;
    if (isCorrect) {
      await FirebaseFirestore.instance
          .collection('Cards')
          .doc(cardId) // Replace with your card's document ID
          .update({'periode': newPeriode}); // Replace with the new period value
    }
  }

  bool _isCorrect(String input, String reponse){
    if(input.toLowerCase() == reponse.toLowerCase()){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool isCorrect = _isCorrect(userInput, reponse);
    _updatePeriode(isCorrect);

    return Scaffold(
      appBar: AppBar(
        title: Text('Réponse'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('User Input: $userInput, Card input: $reponse'),
              Card(
                color: isCorrect ? Colors.green : Colors.red,
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Center(
                    child: Text(
                      isCorrect ? 'Good Job' : 'Too bad',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
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