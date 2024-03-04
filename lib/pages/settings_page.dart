import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SettingsPage extends StatefulWidget {
  final String selectedLanguage;

  SettingsPage(this.selectedLanguage);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _selectedLanguage;

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
    this._selectedLanguage = widget.selectedLanguage;
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
}
