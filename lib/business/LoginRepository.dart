import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginRepository {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      if(userCredential.user != null) {
        await saveUserToFirestore(userCredential.user);
      }
      
      // Once signed in, return the UserCredential
      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }
  
  Future<void> saveUserToFirestore(User? user) async {
    if(user == null) return;

    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    Map<String, dynamic> userData = {
      'email': user.email,
      'lastConnection': DateTime.timestamp(),
    };

    await users.doc(user.uid).set(userData, SetOptions(merge: true));
  }

  Future<String> signOutGoogle() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    return "signout";
  }

}