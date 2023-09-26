import 'package:flutter/material.dart';

import 'DailyPage.dart';
import 'HomePage.dart';

class AnswerPage extends StatelessWidget {
  final String userInput;

  AnswerPage(this.userInput);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réponse'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('User Input: $userInput'),
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