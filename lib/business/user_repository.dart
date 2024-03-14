import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> saveUser(User? user) async {
    if(user == null) return;

    DocumentReference userDoc = users.doc(user.uid);
    var doc = await userDoc.get();

    if(doc.exists) {
      await userDoc.update({
          'lastConnection': DateTime.now()
        }
      );
    } else {
      await userDoc.set({
        'email': user.email,
        'lastConnection': DateTime.timestamp(),
        'nbLiensCard': 0,
        'nbLiensDare': 0,
        'nbAvailableCards': 0,
        'username': user.displayName
      }, SetOptions(merge: true));
    }
  }

  Future<void> updateCardCount(String userId, int delta) async {
    var userDoc = users.doc(userId);
    userDoc.get().then((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      int currentCount = data['nbLiensCard'] ?? 0;
      userDoc.update({'nbLiensCard': currentCount + delta});
    });
  }

  Future<void> updateDareCount(String userId, int delta) async {
    var userDoc = users.doc(userId);
    userDoc.get().then((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      int currentCount = data['nbLiensDare'] ?? 0;
      userDoc.update({'nbLiensDare': currentCount + delta});
    });
  }

  Future<void> updateAvailableCardCount(String userId, int count) async {
    var userDoc = users.doc(userId);
    userDoc.update({'nbAvailableCards': count });
  }

  Future<int> getNbAvailableCards(String userId) async {
    var userDoc = await users.doc(userId).get();
    if(userDoc.data() != null) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      return data['nbAvailableCards'];
    }

    return 0;
  }

  Future<bool> isAvailableCards(String userId) async {
    return await getNbAvailableCards(userId) > 0;
  }

  Future<void> updateUsername(String userId, String username) async {
    var userDoc = await users.doc(userId);
    userDoc.update({'username': username});
  }

  Future<void> updateDownloadedPackIds(String userId, List<String> packIds) async {
    var userDoc = await users.doc(userId);
    userDoc.update({'downloadedPackIds': packIds});
  }

  Future<List<String>> getDownloadedPackIds(String userId) async {
    DocumentSnapshot documentSnapshot  = await users.doc(userId).get();
    if(documentSnapshot.exists) {
      Map<String, dynamic> user = documentSnapshot.data() as Map<String, dynamic>;
      if(user['downloadedPackIds'] is List) {
        return List<String>.from(user['downloadedPackIds']);
      }
    }

    return [];
  }
}