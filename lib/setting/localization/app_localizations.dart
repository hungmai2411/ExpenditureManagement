import 'package:expenditure_management/setting/localization/app_localizations_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show json;

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = {};

  Future<void> load() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map<String, String>((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  /*String translate(String key) => _localizedStrings[key] as String;*/
  String translate(String key) {
    final value = _localizedStrings[key];
    return value is String ? value : '';
  }

  /*bool get isEnLocale => locale.languageCode == 'en';*/
  // default language
  bool get isEnLocale => locale.languageCode == 'vi';
}
