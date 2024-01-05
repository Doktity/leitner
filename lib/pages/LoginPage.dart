import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../business/LoginRepository.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final LoginRepository _loginRepository = LoginRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                UserCredential? userCredential = await _loginRepository.signInWithGoogle();
                if (userCredential != null && mounted) {
                  // User signed in successfully, navigate to the next page
                  // or perform any other desired actions.
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => HomePage()
                      )
                  ); // Replace with the route for your home page.
                }
              },
              child: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}


