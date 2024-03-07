import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/business/user_repository.dart';
import 'package:leitner/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SettingsPage extends StatefulWidget {
  final String selectedLanguage;

  SettingsPage(this.selectedLanguage);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = "";
  final TextEditingController usernameController = TextEditingController();
  final UserService _userService = UserService();
  String username = "";
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Map<String, String> get languageMap {
    return {
      'en': AppLocalizations.of(context)!.english,
      'fr': AppLocalizations.of(context)!.french,
      'es': AppLocalizations.of(context)!.spanish,
    };
  }

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
    _loadData();
  }

  Future<void> _loadData() async {
    var fetchedUsername = await _userService.getUserName(userId);
    setState(() {
      username = fetchedUsername;
    });
  }

  @override
  void dispose() {
    super.dispose();

    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Card(
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      username == "" ? Text("Pseudo vide") : Text(username),
                      ElevatedButton(
                          onPressed: () {
                            _showUsernameDialog(context);
                          },
                          child: Text("Changer")
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Card(
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(AppLocalizations.of(context)!.language + " : ",
                        style: TextStyle(
                            fontFamily: "Mulish",
                            fontSize: 24
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: DropdownButton<String>(
                          value: _selectedLanguage,
                          onChanged: (String? newValue) {
                            _changeLanguage(newValue!);
                          },
                          items: languageMap.keys.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(languageMap[value]!, textAlign: TextAlign.center),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Locale _newLocale = Locale('fr', 'FR');

    if (language == 'en') {
      _newLocale = Locale('en', 'US');
    } else if (language == 'es') {
      _newLocale = Locale('es', 'ES');
    }

    // Save the selected language
    await prefs.setString('selectedLanguage', language);

    // Change the language
    MyApp.setLocale(context, _newLocale);
    setState(() {
      _selectedLanguage = language;
    });
  }

  void _showUsernameDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Changer de username"),
            content: TextFormField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Pseudo",
                  hintText: "Entrez votre pseudo",
                  border: const OutlineInputBorder()
              ),
              validator: (value){
                if (value == null || value.isEmpty){
                  return AppLocalizations.of(context)!.error_required_fields;
                }
                return null;
              },
              controller: usernameController,
            ),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () {

                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(AppLocalizations.of(context)!.confirm),
                onPressed: () async {
                  await _userService.updateUsername(userId, usernameController.text);
                  await _loadData();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
}
