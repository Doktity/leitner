import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leitner/business/CardRepository.dart';

class PackRepository {
  final CollectionReference packs = FirebaseFirestore.instance.collection('Packs');
  final CollectionReference liens = FirebaseFirestore.instance.collection('LiensUserCard');
  final CardRepository cards = CardRepository();

  Future<List<Map<String, dynamic>>> getAllPacks() async {
    QuerySnapshot querySnapshot = await packs.get();

    Map<String, dynamic> pack;
    return querySnapshot.docs.map((doc) {
        pack = doc.data() as Map<String, dynamic>;
        pack['id'] = doc.id;
        return pack;
    }).cast<Map<String, dynamic>>().toList();
  }

  Future<bool> isUserSubscribed(String userId, String packId) async {
    QuerySnapshot querySnapshot = await liens
        .where('userId', isEqualTo: userId)
        .where('packId', isEqualTo: packId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<Map<String, dynamic>?> getPack(String packId) async {
    DocumentSnapshot documentSnapshot  = await packs.doc(packId).get();
    if(documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> addLien(String userId, String packId) async {
    Map<String, dynamic>? pack  = await getPack(packId);
    print(pack);
    if(pack != null) {
      List<String> cardIds = List<String>.from(pack['cards']);
      List<Map<String, dynamic>> cardList = await cards.getListCards(cardIds);

      for(var card in cardList) {
        await liens.add({
          "userId": userId,
          "cardId": card['id'],
          "periode": 1,
          "lastPlayed": DateTime.now(),
          "nextPlay": DateTime.now(),
          "isDownloaded": true,
          "packId": packId
        });
      }
    }
  }

  Future<void> removeLien(String userId, String packId) async {
    QuerySnapshot querySnapshot = await liens
        .where('userId', isEqualTo: userId)
        .where('packId', isEqualTo: packId)
        .get();

    for(var doc in querySnapshot.docs) {
      await liens.doc(doc.id).delete();
    }
  }
}