// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PackageLocalizations {
  Locale locale = const Locale('id', 'ID');

  PackageLocalizations(this.locale);

  static PackageLocalizations of(BuildContext context) {
    return Localizations.of<PackageLocalizations>(context, PackageLocalizations)!;
  }

  static const LocalizationsDelegate<PackageLocalizations> delegate = _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = {"a": "a"};

  Future<bool> load() async {
    String assetLoc = 'assets/i18n/${locale.languageCode}.json';
    String jsonString =
    await rootBundle.loadString(assetLoc);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  Future<bool> loadByLocale(Locale loc) async {
    // Load the language JSON file from the "lang" folder
    String assetLoc = 'assets/i18n/${locale.languageCode}.json';
    String jsonString =
    await rootBundle.loadString(assetLoc);
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations object
class _AppLocalizationsDelegate extends LocalizationsDelegate<PackageLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['id', 'en'].contains(locale.languageCode);
  }

  @override
  Future<PackageLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    PackageLocalizations localizations = PackageLocalizations(locale);
    bool loaded = await localizations.load();
    if (!loaded) {
      print('not loeaded');
    }
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// class AppLanguage extends ChangeNotifier {
//   Locale _appLocale = const Locale('id', 'ID');

//   Locale get appLocal => _appLocale;
//   fetchLocale() async {
//     var prefs = await SharedPreferences.getInstance();
//     if (prefs.getString('language_code') == null) {
//       _appLocale = const Locale('id', 'ID');
//       return Null;
//     }
//     _appLocale = Locale(prefs.getString('language_code')!);
//     return Null;
//   }


//   void changeLanguage(Locale type) async {
//     if (_appLocale == type) {
//       print('_appLocale == type 222333');
//     } else {
//       print('_appLocale != type 222333');
//     }
//     notifyListeners();
//   }
// }
