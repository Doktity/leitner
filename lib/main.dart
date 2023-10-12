import 'package:flutter/material.dart';
import 'package:leitner/pages/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leitner/pages/LoginPage.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _index = 0;

  setCurrentIndex(int index){
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('fr'), // French
      ],
      home: FutureBuilder(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); //Or a loading screen
          } else {
            if(snapshot.hasData) {
              print('User is signed in!');
              return HomePage(); // User is signed in!
            } else {
              print('User is currently signed out!');
              return LoginPage(); // User is currently signed out!
            }
          }
        },
      ),
    );
  }
}
