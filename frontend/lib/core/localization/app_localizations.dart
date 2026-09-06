import 'package:flutter/material.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  bool get isHindi => locale.languageCode == 'hi';

  String get chooseLanguage => isHindi ? 'भाषा चुनें' : 'Choose language';
  String get languagePrompt => isHindi
      ? 'वह भाषा चुनें जिसमें आप सहज महसूस करते हैं।'
      : 'Choose the language that feels most comfortable.';
  String get english => 'English';
  String get hindi => 'हिंदी';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}