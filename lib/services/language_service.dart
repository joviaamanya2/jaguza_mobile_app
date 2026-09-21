// lib/services/language_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageCodeKey = 'language_code';
  static const String _languageNameKey = 'language_name';

  /// The single source of truth for the language used by the whole app.
  /// `MyApp` listens to this notifier and rebuilds its MaterialApp immediately.
  static final ValueNotifier<Locale> localeNotifier =
      ValueNotifier(const Locale('en'));

  static Locale get currentLocale => localeNotifier.value;

  static List<Locale> get supportedLocales =>
      getSupportedLanguages().map((language) => Locale(language['code']!)).toList();

  static Future<void> initialize() async {
    final languageCode = await getLanguageCode();
    localeNotifier.value = Locale(languageCode?.isNotEmpty == true
        ? languageCode!
        : 'en');
  }

  static Future<void> saveLanguage(String languageCode, String languageName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
    await prefs.setString(_languageNameKey, languageName);

    localeNotifier.value = Locale(languageCode);
  }

  static Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageCodeKey);
  }

  static Future<String?> getLanguageName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageNameKey);
  }

  static Future<void> setLocale(String languageCode) async {
    await saveLanguage(languageCode, getLanguageNameFromCode(languageCode));
  }

  static Locale getCurrentLocale() {
    return currentLocale;
  }

  static Future<void> clearLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageCodeKey);
    await prefs.remove(_languageNameKey);
    localeNotifier.value = const Locale('en');
  }

  // Scoped to the languages Jaguza actually ships full translations for
  // today. Add more entries here — and a matching block in
  // AppLocalizations — as new languages are completed.
  static String getLanguageCodeFromName(String languageName) {
    final Map<String, String> languageCodeMap = {
      'English': 'en',
      'Luganda': 'lg',
      'Swahili': 'sw',
    };

    return languageCodeMap[languageName] ?? 'en';
  }

  // Get display name for a language code
  static String getLanguageNameFromCode(String languageCode) {
    final Map<String, String> languageNameMap = {
      'en': 'English',
      'lg': 'Luganda',
      'sw': 'Swahili',
    };

    return languageNameMap[languageCode] ?? 'English';
  }

  // Get all supported languages with their codes
  static List<Map<String, String>> getSupportedLanguages() {
    return [
      {'name': 'English', 'code': 'en'},
      {'name': 'Luganda', 'code': 'lg'},
      {'name': 'Swahili', 'code': 'sw'},
    ];
  }
}
