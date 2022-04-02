import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hear_me_final/utils/Preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(Preference.LANGUAGE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(Preference.LANGUAGE) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  return languageCode.isNotEmpty ? Locale(languageCode, '') : Locale('en', '');
}

void changeLanguage(BuildContext context, String selectedLanguageCode) async {
  var _locale = await setLocale(selectedLanguageCode);
  MyApp.setLocale(context, _locale);
}
