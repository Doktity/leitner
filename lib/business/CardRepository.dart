import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class CardRepository {
  final CollectionReference cards = FirebaseFirestore.instance.collection('Cards');
  final CollectionReference liens = FirebaseFirestore.instance.collection('LiensUserCard');

  Future<List<Map<String, dynamic>>> getAllCards() async {
    QuerySnapshot querySnapshot = await cards.get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> getUserCards(String userId) async {
    QuerySnapshot liensSnapshot = await liens.where('userId', isEqualTo: userId).get();

    List<String> cardIds = liensSnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>?;
      return data != null ? data['cardId'] as String? : null;
    }).where((id) => id != null).cast<String>().toList();


    List<Map<String, dynamic>> userCards = [];
    for(String cardId in cardIds) {
      DocumentSnapshot cardSnapshot = await cards.doc(cardId).get();
      if(cardSnapshot.exists) {
        userCards.add(cardSnapshot.data() as Map<String, dynamic>);
      }
    }

    return userCards;
  }

  Future<dynamic> getRandomCard(String userId) async {
    DateTime today = DateTime.now();
    QuerySnapshot liensSnapshot = await liens
        .where('userId', isEqualTo: userId)
        .where('nextPlay', isLessThanOrEqualTo: Timestamp.fromDate(today))
        .get();

    if(liensSnapshot.docs.isEmpty) {
      throw Exception('No linked cards available today for this user');
    }

    List<String> cardIds = liensSnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>?;
      return data != null ? data['cardId'] as String? : null;
    }).where((id) => id != null).cast<String>().toList();

    List<DocumentSnapshot> cardDocs = [];
    for (String cardId in cardIds) {
      DocumentSnapshot cardDoc = await cards.doc(cardId).get();
      if (cardDoc.exists) {
        cardDocs.add(cardDoc);
      }
    }

    if (cardDocs.isEmpty) {
      throw Exception('No cards found for the given card IDs.');
    }

    DocumentSnapshot randomDoc = cardDocs[Random().nextInt(cardDocs.length)];
    Map<String, dynamic> cardData = randomDoc.data() as Map<String, dynamic>;
    cardData['id'] = randomDoc.id;
    return cardData;
  }

  Future<List<String>> getCategories() async {
    QuerySnapshot querySnapshot = await cards.get();

    // Set of categories to avoid duplicates
    var categories = <String>{};

    // Add categories into set
    for(var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if(data.containsKey('categorie') && data['categorie'] is List) {
        List<dynamic> cardCategories = data['categorie'];
        categories.addAll(cardCategories.cast<String>());
      }
    }

    // Change set into list
    return categories.toList();

  }

  Future<int> getUserCardPeriode(String userId, String cardId) async {
    QuerySnapshot querySnapshot = await liens
        .where('userId', isEqualTo: userId)
        .where('cardId', isEqualTo: cardId)
        .get();

    if(querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data() as dynamic;
      return data['periode'];
    } else {
      return 1;
    }
  }

  void updatePeriode(bool isCorrect, int periode, String userId, String cardId) async {
    int newPeriode = isCorrect ? periode + 1 : max(1, periode - 1);
    DateTime today = DateTime.now();
    DateTime nextPlay = today.add(Duration(days: newPeriode));

    QuerySnapshot querySnapshot = await liens
        .where('userId', isEqualTo: userId)
        .where('cardId', isEqualTo: cardId)
        .get();

    if(querySnapshot.docs.isNotEmpty) {
      String lienId = querySnapshot.docs.first.id;

      await liens
          .doc(lienId)
          .update({
            'periode': newPeriode,
            'lastPlayed': Timestamp.fromDate(today),
            'nextPlay': Timestamp.fromDate(nextPlay)
          });
    }
  }

}
