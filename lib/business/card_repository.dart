import 'package:cloud_firestore/cloud_firestore.dart';

class CardRepository {
  final CollectionReference cards = FirebaseFirestore.instance.collection('Cards');
  final CollectionReference liens = FirebaseFirestore.instance.collection('LiensUserCard');

  Future<List<Map<String, dynamic>>> getAllCards() async {
    QuerySnapshot querySnapshot = await cards.get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> getLiensUserCard(String userId) async {
    QuerySnapshot liensSnapshot = await liens.where('userId', isEqualTo: userId).get();
    return liensSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>?> getCardById(String cardId) async {
    DocumentSnapshot cardSnapshot = await cards.doc(cardId).get();
    Map<String, dynamic>? card;
    if(cardSnapshot.exists) {
      card = cardSnapshot.data() as Map<String, dynamic>;
      card['id'] = cardSnapshot.id;
    }
    return card;
  }

  Future<List<Map<String, dynamic>>> getLiensUserCardByNextPlay(String userId) async{
    DateTime today = DateTime.now();
    QuerySnapshot liensSnapshot = await liens
        .where('userId', isEqualTo: userId)
        .where('nextPlay', isLessThanOrEqualTo: Timestamp.fromDate(today))
        .get();
    return liensSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
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

  void updatePeriode(int periode, DateTime today, DateTime nextPlay, String userId, String cardId) async {

    QuerySnapshot querySnapshot = await liens
        .where('userId', isEqualTo: userId)
        .where('cardId', isEqualTo: cardId)
        .get();

    if(querySnapshot.docs.isNotEmpty) {
      String lienId = querySnapshot.docs.first.id;

      await liens
          .doc(lienId)
          .update({
            'periode': periode,
            'lastPlayed': Timestamp.fromDate(today),
            'nextPlay': Timestamp.fromDate(nextPlay)
          });
    }
  }

  Future<List<Map<String, dynamic>>> getListCards(List<String> cardIds) async {
    List<Map<String, dynamic>> cardsList = [];

    for(String cardId in cardIds) {
      DocumentSnapshot cardSnapshot = await cards.doc(cardId).get();
      if(cardSnapshot.exists) {
        Map<String, dynamic> card = cardSnapshot.data() as Map<String, dynamic>;
        card['id'] = cardSnapshot.id;
        cardsList.add(card);
      }
    }
    return cardsList;
  }

  Future<void> deleteCard(String cardId, WriteBatch batch) async {
    // Delete the card from Cards collection
    DocumentReference cardRef = cards.doc(cardId);
    batch.delete(cardRef);

    // Find and delete all lienCardUser of that card
    QuerySnapshot liensSnapshot = await liens
      .where('cardId', isEqualTo: cardId)
      .get();
    for(DocumentSnapshot lien in liensSnapshot.docs) {
      batch.delete(lien.reference);
    }
  }

  Future<void> addCard(String userId, Map<String, dynamic> card) async {

    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference newCardRef = cards.doc();
    batch.set(newCardRef, card);

    DocumentReference newLienRef = liens.doc();
    Map<String, dynamic> lienData = {
      "userId": userId,
      "cardId": newCardRef.id,
      "periode": 1,
      "lastPlayed": DateTime.now(),
      "nextPlay": DateTime.now(),
      "isDownloaded": false,
      "packId": "",
      "creatorId" : userId
    };
    batch.set(newLienRef, lienData);

    await batch.commit();
  }

  Future<void> updateCard(String cardId, Map<String, dynamic> card) async {

    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference cardRef = cards.doc(cardId);
    batch.update(cardRef, card);

    QuerySnapshot liensSnapshot = await liens
      .where('cardId', isEqualTo: cardId)
      .get();
    for(var doc in liensSnapshot.docs) {
      DocumentReference lienRef = doc.reference;
      Map<String, dynamic> updateData = {
        'periode': 1,
        'nextPlay': DateTime.now()
      };
      batch.update(lienRef, updateData);
    }

    await batch.commit();
  }

}
