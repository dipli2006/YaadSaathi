import 'package:flutter/material.dart';

class LocaleService {
  LocaleService._();

  static final locale = ValueNotifier(const Locale('en'));

  static void setLocale(String languageCode) {
    locale.value = Locale(languageCode);
  }
}