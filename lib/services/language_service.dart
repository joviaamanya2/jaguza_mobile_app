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
    localeNotifier.value = Locale(languageCode);
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

  static String getLanguageCodeFromName(String languageName) {
    final Map<String, String> languageCodeMap = {
      'English': 'en',
      'French': 'fr',
      'Spanish': 'es',
      'German': 'de',
      'Italian': 'it',
      'Portuguese': 'pt',
      'Arabic': 'ar',
      'Chinese': 'zh',
      'Japanese': 'ja',
      'Swahili': 'sw',
      'Hausa': 'ha',
      'Yoruba': 'yo',
      'Igbo': 'ig',
      'Zulu': 'zu',
      'Xhosa': 'xh',
      'Shona': 'sn',
      'Somali': 'so',
      'Amharic': 'am',
      'Tigrinya': 'ti',
      'Oromo': 'om',
      'Kinyarwanda': 'rw',
      'Kirundi': 'rn',
      'Luganda': 'lg',
      'Acholi': 'ach',
      'Alur': 'alz',
      'Lugbara': 'lgg',
      'Runyankore': 'nyn',
      'Runyoro': 'nyo',
      'Rutooro': 'ttj',
      'Rukiga': 'cgg',
      'Lumasaba': 'myx',
      'Lugisu': 'myx',
      'Lugwere': 'gwr',
      'Luo': 'luo',
      'Lingala': 'ln',
      'Fula': 'ff',
      'Wolof': 'wo',
      'Twi': 'tw',
      'Berber': 'ber',
      'Chichewa': 'ny',
      'Sesotho': 'st',
      'Setswana': 'tn',
      'Korean': 'ko',
      'Russian': 'ru',
      'Hindi': 'hi',
      'Urdu': 'ur',
      'Bengali': 'bn',
      'Tamil': 'ta',
      'Telugu': 'te',
      'Malayalam': 'ml',
      'Sinhala': 'si',
      'Nepali': 'ne',
      'Khmer': 'km',
      'Thai': 'th',
      'Vietnamese': 'vi',
      'Indonesian': 'id',
      'Malay': 'ms',
      'Tagalog': 'tl',
      'Greek': 'el',
      'Turkish': 'tr',
      'Polish': 'pl',
      'Ukrainian': 'uk',
      'Czech': 'cs',
      'Hungarian': 'hu',
      'Romanian': 'ro',
      'Bulgarian': 'bg',
      'Croatian': 'hr',
      'Serbian': 'sr',
      'Albanian': 'sq',
      'Macedonian': 'mk',
    };
    
    return languageCodeMap[languageName] ?? 'en';
  }

  // Get display name for a language code
  static String getLanguageNameFromCode(String languageCode) {
    final Map<String, String> languageNameMap = {
      'en': 'English',
      'fr': 'French',
      'es': 'Spanish',
      'de': 'German',
      'it': 'Italian',
      'pt': 'Portuguese',
      'ar': 'Arabic',
      'zh': 'Chinese',
      'ja': 'Japanese',
      'sw': 'Swahili',
      'ha': 'Hausa',
      'yo': 'Yoruba',
      'ig': 'Igbo',
      'zu': 'Zulu',
      'xh': 'Xhosa',
      'sn': 'Shona',
      'so': 'Somali',
      'am': 'Amharic',
      'ti': 'Tigrinya',
      'om': 'Oromo',
      'rw': 'Kinyarwanda',
      'rn': 'Kirundi',
      'lg': 'Luganda',
      'ach': 'Acholi',
      'alz': 'Alur',
      'lgg': 'Lugbara',
      'nyn': 'Runyankore',
      'nyo': 'Runyoro',
      'ttj': 'Rutooro',
      'cgg': 'Rukiga',
      'myx': 'Lumasaba',
      'gwr': 'Lugwere',
      'luo': 'Luo',
      'ln': 'Lingala',
      'ff': 'Fula',
      'wo': 'Wolof',
      'tw': 'Twi',
      'ber': 'Berber',
      'ny': 'Chichewa',
      'st': 'Sesotho',
      'tn': 'Setswana',
      'ko': 'Korean',
      'ru': 'Russian',
      'hi': 'Hindi',
      'ur': 'Urdu',
      'bn': 'Bengali',
      'ta': 'Tamil',
      'te': 'Telugu',
      'ml': 'Malayalam',
      'si': 'Sinhala',
      'ne': 'Nepali',
      'km': 'Khmer',
      'th': 'Thai',
      'vi': 'Vietnamese',
      'id': 'Indonesian',
      'ms': 'Malay',
      'tl': 'Tagalog',
      'el': 'Greek',
      'tr': 'Turkish',
      'pl': 'Polish',
      'uk': 'Ukrainian',
      'cs': 'Czech',
      'hu': 'Hungarian',
      'ro': 'Romanian',
      'bg': 'Bulgarian',
      'hr': 'Croatian',
      'sr': 'Serbian',
      'sq': 'Albanian',
      'mk': 'Macedonian',
    };
    
    return languageNameMap[languageCode] ?? 'English';
  }

  // Get all supported languages with their codes
  static List<Map<String, String>> getSupportedLanguages() {
    return [
      {'name': 'English', 'code': 'en'},
      {'name': 'French', 'code': 'fr'},
      {'name': 'Spanish', 'code': 'es'},
      {'name': 'German', 'code': 'de'},
      {'name': 'Italian', 'code': 'it'},
      {'name': 'Portuguese', 'code': 'pt'},
      {'name': 'Arabic', 'code': 'ar'},
      {'name': 'Chinese', 'code': 'zh'},
      {'name': 'Japanese', 'code': 'ja'},
      {'name': 'Swahili', 'code': 'sw'},
      {'name': 'Hausa', 'code': 'ha'},
      {'name': 'Yoruba', 'code': 'yo'},
      {'name': 'Igbo', 'code': 'ig'},
      {'name': 'Zulu', 'code': 'zu'},
      {'name': 'Xhosa', 'code': 'xh'},
      {'name': 'Shona', 'code': 'sn'},
      {'name': 'Somali', 'code': 'so'},
      {'name': 'Amharic', 'code': 'am'},
      {'name': 'Tigrinya', 'code': 'ti'},
      {'name': 'Oromo', 'code': 'om'},
      {'name': 'Kinyarwanda', 'code': 'rw'},
      {'name': 'Kirundi', 'code': 'rn'},
      {'name': 'Luganda', 'code': 'lg'},
      {'name': 'Acholi', 'code': 'ach'},
      {'name': 'Alur', 'code': 'alz'},
      {'name': 'Lugbara', 'code': 'lgg'},
      {'name': 'Runyankore', 'code': 'nyn'},
      {'name': 'Runyoro', 'code': 'nyo'},
      {'name': 'Rutooro', 'code': 'ttj'},
      {'name': 'Rukiga', 'code': 'cgg'},
      {'name': 'Lumasaba', 'code': 'myx'},
      {'name': 'Lugwere', 'code': 'gwr'},
      {'name': 'Luo', 'code': 'luo'},
      {'name': 'Lingala', 'code': 'ln'},
      {'name': 'Fula', 'code': 'ff'},
      {'name': 'Wolof', 'code': 'wo'},
      {'name': 'Twi', 'code': 'tw'},
      {'name': 'Berber', 'code': 'ber'},
      {'name': 'Chichewa', 'code': 'ny'},
      {'name': 'Sesotho', 'code': 'st'},
      {'name': 'Setswana', 'code': 'tn'},
      {'name': 'Korean', 'code': 'ko'},
      {'name': 'Russian', 'code': 'ru'},
      {'name': 'Hindi', 'code': 'hi'},
      {'name': 'Urdu', 'code': 'ur'},
      {'name': 'Bengali', 'code': 'bn'},
      {'name': 'Tamil', 'code': 'ta'},
      {'name': 'Telugu', 'code': 'te'},
      {'name': 'Malayalam', 'code': 'ml'},
      {'name': 'Sinhala', 'code': 'si'},
      {'name': 'Nepali', 'code': 'ne'},
      {'name': 'Khmer', 'code': 'km'},
      {'name': 'Thai', 'code': 'th'},
      {'name': 'Vietnamese', 'code': 'vi'},
      {'name': 'Indonesian', 'code': 'id'},
      {'name': 'Malay', 'code': 'ms'},
      {'name': 'Tagalog', 'code': 'tl'},
      {'name': 'Greek', 'code': 'el'},
      {'name': 'Turkish', 'code': 'tr'},
      {'name': 'Polish', 'code': 'pl'},
      {'name': 'Ukrainian', 'code': 'uk'},
      {'name': 'Czech', 'code': 'cs'},
      {'name': 'Hungarian', 'code': 'hu'},
      {'name': 'Romanian', 'code': 'ro'},
      {'name': 'Bulgarian', 'code': 'bg'},
      {'name': 'Croatian', 'code': 'hr'},
      {'name': 'Serbian', 'code': 'sr'},
      {'name': 'Albanian', 'code': 'sq'},
      {'name': 'Macedonian', 'code': 'mk'},
    ];
  }
}
