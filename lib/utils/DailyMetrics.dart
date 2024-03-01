import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum GameMode { chill, classic, suddenDeath, marathon }

class DailyMetrics {
  String userId;
  DateTime date;
  GameMode gameMode;
  int totalCards = 0;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  DateTime sessionStartTime;
  DateTime? sessionEndTime;
  List<String> cardIds = [];
  List<String> gageIds = [];
  int lifePoint = 5;
  // Other fields as required

  DailyMetrics({
    required this.userId,
    required this.gameMode,
    DateTime? date,
  }) : this.date = date ?? DateTime.now(),
        this.sessionStartTime = DateTime.now();

  void cardAnswered(bool isCorrect) {
    totalCards++;
    if (isCorrect) {
      correctAnswers++;
    } else {
      incorrectAnswers++;
    }
  }

  void endSession() {
    sessionEndTime = DateTime.now();
    // Logic to save the metrics to Firebase or other operations
  }

  void addCardId(String cardId) {
    cardIds.add(cardId);
  }

  void addGageId(String gageId) {
    gageIds.add(gageId);
  }

  bool handleGamemodeLogic(bool isCorrect, BuildContext context) {
    switch(gameMode) {
      case GameMode.chill:
        // nothing happens
        return false;
      case GameMode.classic:
        // Dare if no lifePoint
        lifePoint--;
        if(lifePoint == 0) {
          lifePoint = 5;
          return true;
        }
        return false;
      case GameMode.suddenDeath:
        // Dare if false
        return !isCorrect;
      case GameMode.marathon:
        // Always dare
        return true;
    }
  }

// Other methods as needed
}
