import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getSelectedLanguage() {
    return _prefs?.getString('selectedLanguage') ?? PlatformDispatcher.instance.locale.languageCode;
  }

  Future<bool> setSelectedLanguage(String language) {
    return _prefs?.setString('selectedLanguage', language) ?? Future.value(false);
  }

  String? getSelectedCategorie() {
    return _prefs?.getString('selectedCategorie') ?? "All";
  }

  Future<bool> setSelectedCategorie(String categorie) {
    return _prefs?.setString('selectedCategorie', categorie) ?? Future.value(false);
  }

  String? getSelectedPackId() {
    return _prefs?.getString('selectedPackId') ?? "All";
  }

  Future<bool> setSelectedPackId(String packId) {
    return _prefs?.setString('selectedPackId', packId) ?? Future.value(false);
  }
}