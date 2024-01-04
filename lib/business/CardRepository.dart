import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class CardRepository {
  final CollectionReference cards = FirebaseFirestore.instance.collection('Cards');

  Future<List<Map<String, dynamic>>> getCards() async {
    QuerySnapshot querySnapshot = await cards.get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<dynamic> getRandomCard() async {
    QuerySnapshot querySnapshot = await cards.where('periode', isEqualTo: 1).get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('No cards with periode set to 1 found.');
    }

    DocumentSnapshot randomDoc = querySnapshot.docs[Random().nextInt(querySnapshot.docs.length)];
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

}
