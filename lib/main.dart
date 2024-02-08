import 'package:flutter/material.dart';
import 'package:leitner/pages/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leitner/pages/LoginPage.dart';
import 'package:leitner/pages/SettingsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? selectedLanguage = prefs.getString('selectedLanguage');

  runApp(MyApp(selectedLanguage: selectedLanguage));
}

class MyApp extends StatefulWidget {
  final String? selectedLanguage;

  const MyApp({super.key, this.selectedLanguage});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leitner',
      theme: ThemeData(
        fontFamily: "Mulish",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: Locale('en', 'US'), // Set the default locale
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: SettingsPage(Localizations.localeOf(context).languageCode),
    );
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _index = 0;
  Locale? _locale;
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
  }

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  setCurrentIndex(int index){
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale, // Set the locale from state
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
