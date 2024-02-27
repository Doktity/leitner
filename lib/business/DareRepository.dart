import 'package:cloud_firestore/cloud_firestore.dart';

class DareRepository {
  final CollectionReference dares = FirebaseFirestore.instance.collection('Dares');
  final CollectionReference liens = FirebaseFirestore.instance.collection('LiensUserCard');

  Future<List<Map<String, dynamic>>> getAllDares() async {
    QuerySnapshot querySnapshot = await dares.get();

    Map<String, dynamic> dare;
    return querySnapshot.docs.map((doc) {
      dare = doc.data() as Map<String, dynamic>;
      dare['id'] = doc.id;
      return dare;
    }).cast<Map<String, dynamic>>().toList();
  }
}