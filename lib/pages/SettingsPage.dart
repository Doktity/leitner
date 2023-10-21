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

  @override
  void initState() {
    super.initState();
    this._selectedLanguage = widget.selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                _changeLanguage(newValue!);
              },
              items: <String>['fr', 'en', 'es']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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
