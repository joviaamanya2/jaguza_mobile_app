import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jaguza_app/screens/splash_screen.dart';
import 'package:jaguza_app/services/language_service.dart';
import 'package:jaguza_app/services/app_localizations.dart';
import 'package:jaguza_app/services/theme_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService.initialize();

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
          AppLocalizations.delegate,
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
      builder: (context, locale, _) => ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeService.mode,
        builder: (context, themeMode, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jaguza Livestock',
      locale: locale,
      themeMode: themeMode,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      // Add these to provide MaterialLocalizations
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LanguageService.supportedLocales,
      /* const [
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
      ], */
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
      ),
    );
  }

  static ThemeData get _lightTheme {
    final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF1E7B4E));
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF4F6F8),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E7B4E),
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: _inputTheme(colorScheme),
    );
  }

  static ThemeData get _darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF45B97C),
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF101714),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF163D2A),
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A2520),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: _inputTheme(colorScheme, fillColor: const Color(0xFF1A2520)),
    );
  }

  static InputDecorationTheme _inputTheme(ColorScheme colorScheme, {Color? fillColor}) {
    OutlineInputBorder border(Color color, {double width = 1}) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor ?? colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
      enabledBorder: border(colorScheme.outlineVariant),
      focusedBorder: border(colorScheme.primary, width: 1.5),
      errorBorder: border(colorScheme.error),
      focusedErrorBorder: border(colorScheme.error, width: 1.5),
    );
  }
}
