import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leitner/business/card_repository.dart';
import 'package:leitner/business/pack_repository.dart';

class CardService {
  final CardRepository _cardRepository = CardRepository();
  final PackRepository _packRepository = PackRepository();

  Future<List<Map<String, dynamic>>> getAllCards() async {
    return await _cardRepository.getAllCards();
  }

  Future<List<Map<String, dynamic>>> getUserCards(String userId) async {
    List<Map<String, dynamic>> cardLinks = await _cardRepository.getLiensUserCard(userId);
    List<Map<String, dynamic>> userCards = [];

    for(var link in cardLinks) {
      String? cardId = link['cardId'];
      if(cardId != null) {
        var cardData = await _cardRepository.getCardById(cardId);
        if(cardData != null) {
          cardData['cardId'] = cardId;
          cardData['packId'] = link['packId'];
          cardData['creatorId'] = link['creatorId'];
          userCards.add(cardData);
        }
      }
    }

    return userCards;
  }

  Future<dynamic> getRandomCard(String userId) async {
    List<Map<String, dynamic>> liensUserCard = await _cardRepository.getLiensUserCardByNextPlay(userId);

    List<String> cardIds = liensUserCard.map((doc) => doc['cardId']).where((id) => id != null).cast<String>().toList();

    List<Map<String, dynamic>> cards = [];
    for (String cardId in cardIds) {
      Map<String, dynamic>? card = await _cardRepository.getCardById(cardId);
      if (card != null) {
        cards.add(card);
      }
    }

    if (cards.isEmpty) {
      throw Exception('No cards found for the given card IDs.');
    }

    Map<String, dynamic> randomCard = cards[Random().nextInt(cards.length)];
    return randomCard;
  }

  Future<List<String>> getCategories() async {
    List<Map<String, dynamic>> cards = await _cardRepository.getAllCards();

    // Set of categories to avoid duplicates
    var categories = <String>{};

    // Add categories into set
    for(var card in cards) {
      if(card.containsKey('categorie') && card['categorie'] is List) {
        List<dynamic> cardCategories = card['categorie'];
        categories.addAll(cardCategories.cast<String>());
      }
    }

    // Change set into list
    return categories.toList();
  }

  Future<int> getUserCardPeriode(String userId, String cardId) async {
    return _cardRepository.getUserCardPeriode(userId, cardId);
  }

  void updatePeriode(bool isCorrect, int periode, String userId, String cardId) async {
    int newPeriode = isCorrect ? periode + 1 : max(1, periode - 1);
    DateTime today = DateTime.now();
    DateTime nextPlay = today.add(Duration(days: newPeriode));

    _cardRepository.updatePeriode(newPeriode, today, nextPlay, userId, cardId);
  }

  Future<List<Map<String, dynamic>>> getListCards(List<String> cardIds) async {
    return await _cardRepository.getListCards(cardIds);
  }

  Future<void> deleteCard(String cardId) async {
    try {
      // Start a batch write
      WriteBatch batch = FirebaseFirestore.instance.batch();

      await _cardRepository.deleteCard(cardId, batch);

      //Find pack with that card and delete it from the list
      _packRepository.removeIdFromIds(cardId, batch);

      // Commit batch
      await batch.commit();
    } catch(e) {
      print('Error deleting card: $e');
    }
  }

  Future<void> addCard(String userId, Map<String, dynamic> card) async {
    await _cardRepository.addCard(userId, card);
  }

  Future<void> updateCard(String cardId, Map<String, dynamic> card) async {
    await _cardRepository.updateCard(cardId, card);
  }
}