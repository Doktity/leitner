import 'package:cloud_firestore/cloud_firestore.dart';

class PackRepository {
  final CollectionReference packs = FirebaseFirestore.instance.collection('Packs');
  final CollectionReference liensCard = FirebaseFirestore.instance.collection('LiensUserCard');
  final CollectionReference liensDare = FirebaseFirestore.instance.collection('LiensUserDare');

  Future<List<Map<String, dynamic>>> getAllPacks() async {
    QuerySnapshot querySnapshot = await packs.get();

    Map<String, dynamic> pack;
    return querySnapshot.docs.map((doc) {
        pack = doc.data() as Map<String, dynamic>;
        pack['id'] = doc.id;
        return pack;
    }).cast<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>?> getPack(String packId) async {
    DocumentSnapshot documentSnapshot  = await packs.doc(packId).get();
    if(documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> addLienCard(String userId, List<Map<String, dynamic>> cardList) async {
    for(var card in cardList) {
      await liensCard.add({
        "userId": userId,
        "cardId": card['id'],
        "periode": 1,
        "lastPlayed": DateTime.now(),
        "nextPlay": DateTime.now(),
      });
    }
  }

  Future<void> removeLienCard(String userId, List<String> cardIds) async {
    for(String cardId in cardIds) {
      QuerySnapshot querySnapshot = await liensCard
          .where('userId', isEqualTo: userId)
          .where('cardId', isEqualTo: cardId)
          .get();

      for(var doc in querySnapshot.docs) {
        await liensCard.doc(doc.id).delete();
      }
    }
  }

  Future<void> removeIdFromIds(String id, WriteBatch batch) async {
    QuerySnapshot querySnapshot = await packs.where('ids', arrayContains: id).get();
    for(DocumentSnapshot pack in querySnapshot.docs) {
      List<String> updatedIds = List<String>.from(pack['ids']);
      updatedIds.remove(id);
      batch.update(pack.reference, {'ids': updatedIds});
    }
  }
}