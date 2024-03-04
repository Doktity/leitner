import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<String> getUserName(String userId) async {
    DocumentSnapshot documentSnapshot  = await users.doc(userId).get();
    if(documentSnapshot.exists) {
      Map<String, dynamic> user = documentSnapshot.data() as Map<String, dynamic>;
      return user['username'];
    }
    return "";
  }
}