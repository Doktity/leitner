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

  Future<List<Map<String, dynamic>>> getLiensUserDare(String userId) async {
    QuerySnapshot liensSnapshot = await liens.where('userId', isEqualTo: userId).get();
    return liensSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>?> getDareById(String dareId) async {
    DocumentSnapshot dareSnapshot = await dares.doc(dareId).get();
    Map<String, dynamic>? dare;
    if(dareSnapshot.exists) {
      dare = dareSnapshot.data() as Map<String, dynamic>;
      dare['id'] = dareSnapshot.id;
    }
    return dare;
  }

  Future<void> deleteDare(String dareId, WriteBatch batch) async {
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