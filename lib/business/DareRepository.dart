import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class DareRepository {
  final CollectionReference dares = FirebaseFirestore.instance.collection('Dares');
  final CollectionReference liens = FirebaseFirestore.instance.collection('LiensUserDare');

  Future<List<Map<String, dynamic>>> getAllDares() async {
    QuerySnapshot querySnapshot = await dares.get();

    Map<String, dynamic> dare;
    return querySnapshot.docs.map((doc) {
      dare = doc.data() as Map<String, dynamic>;
      dare['id'] = doc.id;
      return dare;
    }).cast<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>> getRandomDare(String userId) async {
    QuerySnapshot liensSnapshot = await liens
        .where('userId', isEqualTo: userId)
        .get();

    if(liensSnapshot.docs.isEmpty) {
      throw Exception('No linked dares available for this user');
    }

    List<String> dareIds = liensSnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>?;
      return data != null ? data['dareId'] as String? : null;
    }).where((id) => id != null).cast<String>().toList();

    List<DocumentSnapshot> dareDocs = [];
    for (String dareId in dareIds) {
      DocumentSnapshot dareDoc = await dares.doc(dareId).get();
      if (dareDoc.exists) {
        dareDocs.add(dareDoc);
      }
    }

    if (dareDocs.isEmpty) {
      throw Exception('No cards found for the given card IDs.');
    }

    DocumentSnapshot randomDoc = dareDocs[Random().nextInt(dareDocs.length)];
    Map<String, dynamic> dareData = randomDoc.data() as Map<String, dynamic>;
    dareData['id'] = randomDoc.id;
    return dareData;
  }

  Future<List<String>> getCategories() async {
    QuerySnapshot querySnapshot = await dares.get();

    // Set of categories to avoid duplicates
    var categories = <String>{};

    // Add categories into set
    for(var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if(data.containsKey('categories') && data['categories'] is List) {
        List<dynamic> cardCategories = data['categories'];
        categories.addAll(cardCategories.cast<String>());
      }
    }

    // Change set into list
    return categories.toList();

  }

  Future<void> deleteDare(String dareId) async {
    try {
      // Start a batch write
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Delete the card from Cards collection
      DocumentReference dareRef = dares.doc(dareId);
      batch.delete(dareRef);

      // Find and delete all lienCardUser of that card
      QuerySnapshot liensSnapshot = await liens
          .where('dareId', isEqualTo: dareId)
          .get();
      for(DocumentSnapshot lien in liensSnapshot.docs) {
        batch.delete(lien.reference);
      }

      // Commit batch
      await batch.commit();
    } catch(e) {
      print('Error deleting card: $e');
    }
  }

  Future<void> addDare(String userId, Map<String, dynamic> dare) async {

    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference newDareRef = dares.doc();
    batch.set(newDareRef, dare);

    DocumentReference newLienRef = liens.doc();
    Map<String, dynamic> lienData = {
      "userId": userId,
      "dareId": newDareRef.id,
      "lastUsed": DateTime.now()
    };
    batch.set(newLienRef, lienData);

    await batch.commit();
  }

  Future<void> updateDare(String dareId, Map<String, dynamic> dare) async {

    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference dareRef = dares.doc(dareId);
    batch.update(dareRef, dare);

    QuerySnapshot liensSnapshot = await liens
        .where('dareId', isEqualTo: dareId)
        .get();
    for(var doc in liensSnapshot.docs) {
      DocumentReference lienRef = doc.reference;
      Map<String, dynamic> updateData = {
        'lastUsed': DateTime.now()
      };
      batch.update(lienRef, updateData);
    }

    await batch.commit();
  }
}