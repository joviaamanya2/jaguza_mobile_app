import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jaguza_app/screens/splash_screen.dart';
import 'package:jaguza_app/services/language_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF1E7B4E), // Green
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF1E7B4E),
    ),
  );

  // Run the app with language loading
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      await LanguageService.initialize();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
        ],
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E7B4E)),
            ),
          ),
        ),
      );
    }

    return ValueListenableBuilder<Locale>(
      valueListenable: LanguageService.localeNotifier,
      builder: (context, locale, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jaguza Livestock',
      locale: locale,
      // Add these to provide MaterialLocalizations
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
        Locale('es'), // Spanish
        Locale('de'), // German
        Locale('it'), // Italian
        Locale('pt'), // Portuguese
        Locale('ar'), // Arabic
        Locale('zh'), // Chinese
        Locale('ja'), // Japanese
        Locale('sw'), // Swahili
        Locale('ha'), // Hausa
        Locale('yo'), // Yoruba
        Locale('ig'), // Igbo
        Locale('zu'), // Zulu
        Locale('xh'), // Xhosa
        Locale('sn'), // Shona
        Locale('so'), // Somali
        Locale('am'), // Amharic
        Locale('ti'), // Tigrinya
        Locale('om'), // Oromo
        Locale('rw'), // Kinyarwanda
        Locale('rn'), // Kirundi
        Locale('lg'), // Luganda
        Locale('ach'), // Acholi
        Locale('alz'), // Alur
        Locale('lgg'), // Lugbara
        Locale('nyn'), // Runyankore
        Locale('nyo'), // Runyoro
        Locale('ttj'), // Rutooro
        Locale('cgg'), // Rukiga
        Locale('myx'), // Lumasaba/Lugisu
        Locale('gwr'), // Lugwere
        Locale('luo'), // Luo
        Locale('ln'), // Lingala
        Locale('ff'), // Fula
        Locale('wo'), // Wolof
        Locale('tw'), // Twi
        Locale('ber'), // Berber
        Locale('ny'), // Chichewa
        Locale('st'), // Sesotho
        Locale('tn'), // Setswana
        Locale('ko'), // Korean
        Locale('ru'), // Russian
        Locale('hi'), // Hindi
        Locale('ur'), // Urdu
        Locale('bn'), // Bengali
        Locale('ta'), // Tamil
        Locale('te'), // Telugu
        Locale('ml'), // Malayalam
        Locale('si'), // Sinhala
        Locale('ne'), // Nepali
        Locale('km'), // Khmer
        Locale('th'), // Thai
        Locale('vi'), // Vietnamese
        Locale('id'), // Indonesian
        Locale('ms'), // Malay
        Locale('tl'), // Tagalog
        Locale('el'), // Greek
        Locale('tr'), // Turkish
        Locale('pl'), // Polish
        Locale('uk'), // Ukrainian
        Locale('cs'), // Czech
        Locale('hu'), // Hungarian
        Locale('ro'), // Romanian
        Locale('bg'), // Bulgarian
        Locale('hr'), // Croatian
        Locale('sr'), // Serbian
        Locale('sq'), // Albanian
        Locale('mk'), // Macedonian
      ],
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
        if (locale == null) return const Locale('en');
        
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return locale;
          }
        }
        return const Locale('en');
      },
      home: const SplashScreen(),
    ),
    );
  }
}
