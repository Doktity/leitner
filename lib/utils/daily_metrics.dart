import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum GameMode { classic, survival, suddenDeath, marathon }

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
  List<String> dareIds = [];
  int totalLifePoint = 5;
  int currentLifePoint = 5;
  // Other fields as required

  DailyMetrics({
    required this.userId,
    required this.gameMode,
    DateTime? date,
  }) : this.date = date ?? DateTime.now(),
        sessionStartTime = DateTime.now();

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

  void addDareId(String dareId) {
    dareIds.add(dareId);
  }

  bool handleGamemodeLogic(bool isCorrect) {
    switch(gameMode) {
      case GameMode.classic:
        // nothing happens
        return false;
      case GameMode.survival:
        // Dare if no lifePoint
        if(!isCorrect) currentLifePoint--;
        if(currentLifePoint == 0) {
          currentLifePoint = totalLifePoint;
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

  String getGameMode(BuildContext context) {
    switch(gameMode) {
      case GameMode.classic:
        return AppLocalizations.of(context)!.classic;
      case GameMode.survival:
        return AppLocalizations.of(context)!.survival;
      case GameMode.suddenDeath:
        return AppLocalizations.of(context)!.sudden_death;
      case GameMode.marathon:
        return AppLocalizations.of(context)!.marathon;
    }
  }

// Other methods as needed
}
