import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../business/login_repository.dart';
import 'home_page.dart';

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
        title: Text(AppLocalizations.of(context)!.login,
          style: const TextStyle(
            fontFamily: "Mulish",
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                  backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  fixedSize: MaterialStatePropertyAll(Size(400, 100)),
                  foregroundColor: MaterialStatePropertyAll(Colors.black)
              ),
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
              label: Text(AppLocalizations.of(context)!.signin_google,
                style: TextStyle(
                    fontFamily: "Mulish",
                    fontSize: 24
                ),
              ),
              icon: const Icon(Icons.login)
            ),
          ],
        ),
      ),
    );
  }
}

