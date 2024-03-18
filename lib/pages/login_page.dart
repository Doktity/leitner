import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_colors.dart';
import '../services/login_service.dart';
import '../utils/gradient_app_bar.dart';
import '../utils/gradient_button.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final LoginService _loginRepository = LoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: AppLocalizations.of(context)!.login, automaticallyImplyLeading: false),
      backgroundColor: AppColors.backgroundGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientButton(
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
              maxWidth: 400,
              heightFactor: 0.11,
              child: GradientButton.buildButtonContent(Icons.login, AppLocalizations.of(context)!.signin_google),
            )
          ],
        ),
      ),
    );
  }
}


