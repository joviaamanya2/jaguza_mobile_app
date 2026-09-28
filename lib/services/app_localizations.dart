import 'package:flutter/widgets.dart';

/// Jaguza's application strings. Flutter's built-in localizations do not
/// translate strings written by the app, so all user-facing text should use
/// [AppLocalizations].t (or the BuildContext extension below).
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const delegate = _JaguzaLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  String t(String key) => _translations[locale.languageCode]?[key] ??
      _translations['en']![key] ?? key;

  String languagesAvailable(int count) =>
      '${t('languages_available')}: $count';

  // These are intentionally keyed by the English source text. This makes
  // incremental migration of existing screens safe and easy to review.
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'Skip': 'Skip', 'Track Your Herd': 'Track Your Herd',
      'Know where your livestock are in real time\nwith simple GPS tracking.':
          'Know where your livestock are in real time\nwith simple GPS tracking.',
      'Next': 'Next', 'Monitor Animal Health': 'Monitor Animal Health',
      'Catch health issues early with alerts and\nvitals tracking for every animal.':
          'Catch health issues early with alerts and\nvitals tracking for every animal.',
      'Back': 'Back', 'Get Started': 'Get Started',
      'Set App Language': 'Set App Language', 'Language': 'Language',
      'languages_available': 'languages available', 'DONE': 'DONE',
      'Settings': 'Settings', 'Manage your app preferences': 'Manage your app preferences',
      'Account': 'Account', 'Notifications': 'Notifications',
      'Preferences': 'Preferences', 'App Settings': 'App Settings',
      'Support': 'Support', 'About': 'About', 'Push Notifications': 'Push Notifications',
      'Real-time alerts for your herd': 'Real-time alerts for your herd',
      'Dark Mode': 'Dark Mode', 'Switch to dark interface': 'Switch to dark interface',
      'Privacy Policy': 'Privacy Policy', 'Terms & Conditions': 'Terms & Conditions',
      'Help Center': 'Help Center', 'Manage Account': 'Manage Account',
      'View and edit your profile settings': 'View and edit your profile settings',
      'Log Out': 'Log Out', 'Delete Account': 'Delete Account',
    },
    'fr': {
      'Skip': 'Passer', 'Track Your Herd': 'Suivez votre troupeau',
      'Know where your livestock are in real time\nwith simple GPS tracking.':
          'Sachez où se trouve votre bétail en temps réel\ngrâce au suivi GPS.',
      'Next': 'Suivant', 'Monitor Animal Health': 'Surveillez la santé animale',
      'Catch health issues early with alerts and\nvitals tracking for every animal.':
          'Détectez tôt les problèmes de santé grâce aux alertes\net au suivi des constantes.',
      'Back': 'Retour', 'Get Started': 'Commencer', 'Set App Language': 'Définir la langue',
      'Language': 'Langue', 'languages_available': 'langues disponibles', 'DONE': 'TERMINÉ',
      'Settings': 'Paramètres', 'Manage your app preferences': 'Gérez vos préférences',
      'Account': 'Compte', 'Notifications': 'Notifications', 'Preferences': 'Préférences',
      'App Settings': 'Paramètres de l’application', 'Support': 'Assistance', 'About': 'À propos',
      'Push Notifications': 'Notifications push', 'Real-time alerts for your herd': 'Alertes en temps réel pour votre troupeau',
      'Dark Mode': 'Mode sombre', 'Switch to dark interface': 'Passer à l’interface sombre',
      'Privacy Policy': 'Politique de confidentialité', 'Terms & Conditions': 'Conditions générales',
      'Help Center': 'Centre d’aide', 'Manage Account': 'Gérer le compte',
      'View and edit your profile settings': 'Voir et modifier votre profil', 'Log Out': 'Se déconnecter',
      'Delete Account': 'Supprimer le compte',
    },
    'es': {
      'Skip': 'Omitir', 'Track Your Herd': 'Controla tu rebaño', 'Next': 'Siguiente',
      'Monitor Animal Health': 'Controla la salud animal', 'Back': 'Atrás',
      'Get Started': 'Comenzar', 'Set App Language': 'Idioma de la aplicación',
      'Language': 'Idioma', 'languages_available': 'idiomas disponibles', 'DONE': 'LISTO',
      'Settings': 'Ajustes', 'Manage your app preferences': 'Gestiona tus preferencias',
      'Account': 'Cuenta', 'Notifications': 'Notificaciones', 'Preferences': 'Preferencias',
      'App Settings': 'Ajustes de la aplicación', 'Support': 'Soporte', 'About': 'Acerca de',
      'Push Notifications': 'Notificaciones push', 'Dark Mode': 'Modo oscuro',
      'Privacy Policy': 'Política de privacidad', 'Terms & Conditions': 'Términos y condiciones',
      'Help Center': 'Centro de ayuda', 'Manage Account': 'Gestionar cuenta',
      'Log Out': 'Cerrar sesión', 'Delete Account': 'Eliminar cuenta',
    },
    'sw': {
      'Skip': 'Ruka', 'Track Your Herd': 'Fuatilia mifugo yako', 'Next': 'Endelea',
      'Know where your livestock are in real time\nwith simple GPS tracking.':
          'Jua mifugo yako ilipo kwa wakati halisi\nkwa ufuatiliaji rahisi wa GPS.',
      'Monitor Animal Health': 'Fuatilia afya ya wanyama', 'Back': 'Rudi',
      'Catch health issues early with alerts and\nvitals tracking for every animal.':
          'Gundua matatizo ya afya mapema kwa arifa\nna ufuatiliaji wa hali ya kila mnyama.',
      'Get Started': 'Anza', 'Set App Language': 'Weka lugha ya programu',
      'Language': 'Lugha', 'languages_available': 'lugha zinapatikana', 'DONE': 'MALIZA',
      'Settings': 'Mipangilio', 'Manage your app preferences': 'Dhibiti mapendeleo ya programu',
      'Account': 'Akaunti', 'Notifications': 'Arifa', 'Preferences': 'Mapendeleo',
      'App Settings': 'Mipangilio ya programu', 'Support': 'Msaada', 'About': 'Kuhusu',
      'Push Notifications': 'Arifa za kushinikiza',
      'Real-time alerts for your herd': 'Arifa za wakati halisi kwa mifugo yako',
      'Dark Mode': 'Hali ya giza', 'Switch to dark interface': 'Badilisha kwenda mwonekano wa giza',
      'Privacy Policy': 'Sera ya faragha', 'Terms & Conditions': 'Sheria na masharti',
      'Help Center': 'Kituo cha msaada', 'Manage Account': 'Dhibiti akaunti',
      'View and edit your profile settings': 'Angalia na uhariri mipangilio ya wasifu wako',
      'Log Out': 'Toka', 'Delete Account': 'Futa akaunti',

      // ── Home shell (drawer + main tab) ──
      'Livestock Management': 'Usimamizi wa Mifugo', 'Farm Expenses': 'Matumizi ya Shamba',
      'Feed': 'Chakula', 'Veterinary Help': 'Msaada wa Mifugo',
      'Veterinary Doctors': 'Madaktari wa Mifugo', 'Labour': 'Wafanyakazi',
      'Equipment and Housing': 'Vifaa na Makazi', 'Ask Jaguza AI': 'Uliza Jaguza AI',
      'Communicate': 'Wasiliana', 'Tips and Suggestions': 'Vidokezo na Mapendekezo',
      'Share JAGUZA': 'Shiriki JAGUZA', 'Others': 'Nyingine',
      'Our Partners/About': 'Washirika Wetu/Kuhusu', 'Our Partners': 'Washirika Wetu',
      'Jaguza Livestock partners with agribusinesses, veterinary suppliers and cooperatives across Uganda. For the current list of partners, visit jaguzalivestock.com.':
          'Jaguza Livestock inashirikiana na makampuni ya kilimo, wasambazaji wa dawa za mifugo na vyama vya ushirika kote Uganda. Kwa orodha ya sasa ya washirika, tembelea jaguzalivestock.com.',
      'Visit our Website': 'Tembelea Tovuti Yetu',
      'Jaguza Livestock takes your privacy seriously. We collect only the data necessary to deliver our services. Your livestock data, farm records and location information are stored securely and never shared with third parties without your consent.\n\nYou may request deletion of your data at any time by contacting support@jaguzalivestock.com.':
          'Jaguza Livestock inachukua faragha yako kwa uzito. Tunakusanya tu taarifa muhimu kutoa huduma zetu. Data yako ya mifugo, kumbukumbu za shamba na taarifa za mahali huhifadhiwa kwa usalama na hazishirikiwi na wahusika wengine bila idhini yako.\n\nUnaweza kuomba kufutwa kwa data yako wakati wowote kwa kuwasiliana na support@jaguzalivestock.com.',
      'About App': 'Kuhusu Programu', 'About Jaguza': 'Kuhusu Jaguza',
      'Jaguza Livestock v1.0.0\n\nA livestock management app for farmers: diagnose diseases, track animals and gestation, reach veterinary doctors, buy and sell in the marketplace, and get AI-powered farming advice — all in one place.':
          'Jaguza Livestock v1.0.0\n\nProgramu ya usimamizi wa mifugo kwa wakulima: gundua magonjwa, fuatilia wanyama na ujauzito, wasiliana na madaktari wa mifugo, nunua na uza kwenye soko, na upate ushauri wa kilimo unaotumia AI — yote mahali pamoja.',
      'Logout': 'Toka', 'Are you sure you want to logout?': 'Una uhakika unataka kutoka?',
      'Cancel': 'Ghairi', 'Got it': 'Nimeelewa',
      'Share the Jaguza app with your fellow farmers!': 'Shiriki programu ya Jaguza na wakulima wenzako!',
      'Share': 'Shiriki', 'Version': 'Toleo',
      'Could not open website. Please try again.': 'Imeshindikana kufungua tovuti. Tafadhali jaribu tena.',
      'Error': 'Hitilafu', 'User Posts': 'Machapisho ya Watumiaji', 'Doctors': 'Madaktari',
      'Diseases': 'Magonjwa',
      'Use Jaguza to Diagnose diseases, Track animals': 'Tumia Jaguza kugundua magonjwa, Fuatilia wanyama',
      'Sell your agricultural products in Market': 'Uza bidhaa zako za kilimo Sokoni',
      'Know more about animal Diseases': 'Jua zaidi kuhusu Magonjwa ya wanyama',
      'Track your Expenses and Milk production': 'Fuatilia Matumizi yako na Uzalishaji wa Maziwa',
      'Contact Veterinary Doctors': 'Wasiliana na Madaktari wa Mifugo',
      'Track Animal Gestation and so much more…': 'Fuatilia Ujauzito wa Wanyama na mengine zaidi…',
      'Is there anything that you would like to know in the field of Agriculture?':
          'Je, kuna kitu ungependa kujua katika uwanja wa Kilimo?',
      'Ask Jaguza AI?': 'Uliza Jaguza AI?', 'Report sickness': 'Ripoti Ugonjwa',
      'Diagnosis': 'Uchunguzi', 'Disease Information': 'Taarifa za Magonjwa',
      'Gestation tracker': 'Kifuatiliaji cha Ujauzito', 'Market': 'Soko',
      'Weather updates': 'Taarifa za Hali ya Hewa', 'Decision Support': 'Msaada wa Maamuzi',
      'My farm': 'Shamba Langu', 'Videos': 'Video', 'Advertise with Jaguza': 'Tangaza na Jaguza',

      // ── Settings screen ──
      'How we handle your data': 'Jinsi tunavyoshughulikia data yako',
      'Review our terms of service': 'Pitia sheria zetu za huduma',
      'By using Jaguza Livestock you agree to use the app for lawful agricultural purposes only. Misuse, unauthorized access, or reverse-engineering of the platform is strictly prohibited.\n\nFor the full terms, visit jaguzalivestock.com/terms.':
          'Kwa kutumia Jaguza Livestock unakubali kutumia programu kwa madhumuni halali ya kilimo pekee. Matumizi mabaya, ufikiaji usioidhinishwa, au uhandisi wa kinyume wa jukwaa ni marufuku kabisa.\n\nKwa masharti kamili, tembelea jaguzalivestock.com/terms.',
      'FAQs and how-to guides': 'Maswali yanayoulizwa mara kwa mara na miongozo',
      'Need help? Visit our help center at help.jaguzalivestock.com or contact us:\n\nEmail: support@jaguzalivestock.com\nPhone: +256 XXX XXX XXX\n\nOur support team is available Monday – Friday, 8 AM – 6 PM (EAT).':
          'Unahitaji msaada? Tembelea kituo chetu cha msaada kwenye help.jaguzalivestock.com au wasiliana nasi:\n\nBarua pepe: support@jaguzalivestock.com\nSimu: +256 XXX XXX XXX\n\nTimu yetu ya msaada inapatikana Jumatatu – Ijumaa, saa 2 Asubuhi – saa 12 Jioni (EAT).',
      'App Version': 'Toleo la Programu', 'You are on the latest version': 'Uko kwenye toleo jipya zaidi',
      'You\'re up to date!': 'Uko sawa kabisa!', 'Sign out of your account': 'Toka kwenye akaunti yako',
      'Permanently remove your data': 'Futa data yako kabisa', 'All rights reserved': 'Haki zote zimehifadhiwa',
      'Are you sure you want to log out of your Jaguza account?':
          'Una uhakika unataka kutoka kwenye akaunti yako ya Jaguza?',
      'This action is permanent and cannot be undone. All your farm data, animals, and records will be deleted.':
          'Kitendo hiki ni cha kudumu na hakiwezi kutenduliwa. Data yote ya shamba lako, wanyama, na kumbukumbu zitafutwa.',
      'Delete': 'Futa',

      // ── Splash screen ──
      'Know your herd, wherever they roam.': 'Jua mifugo yako, popote iendapo.',

      // ── Login screen ──
      'Login successful! Welcome back': 'Umeingia kwa mafanikio! Karibu tena',
      'Invalid login credentials': 'Taarifa za kuingia si sahihi', 'Network error': 'Hitilafu ya mtandao',
      'Google Sign-In initiated': 'Kuingia kwa Google kumeanzishwa',
      'Apple Sign-In initiated': 'Kuingia kwa Apple kumeanzishwa',
      'SIGN IN': 'INGIA', 'Welcome back! Please enter your details.': 'Karibu tena! Tafadhali weka taarifa zako.',
      'Email or Phone Number': 'Barua Pepe au Namba ya Simu',
      'Please enter your email or phone number': 'Tafadhali weka barua pepe au namba yako ya simu',
      'Password': 'Nenosiri', 'Please enter your password': 'Tafadhali weka nenosiri lako',
      'Password must be at least 6 characters': 'Nenosiri lazima liwe na herufi 6 au zaidi',
      'Show password': 'Onyesha nenosiri', 'Hide password': 'Ficha nenosiri',
      'Forgot Password?': 'Umesahau Nenosiri?', 'OR CONTINUE WITH': 'AU ENDELEA NA',
      'Sign in with Google': 'Ingia na Google', 'Sign in with Apple': 'Ingia na Apple',
      "Don't have an Account?": 'Huna Akaunti?', 'Register': 'Jisajili',

      // ── Signup screen ──
      'Weak': 'Dhaifu', 'Fair': 'Wastani', 'Strong': 'Imara', 'Very strong': 'Imara Sana',
      'Please accept the Terms & Conditions to continue.':
          'Tafadhali kubali Sheria na Masharti ili kuendelea.',
      'Account created successfully! Welcome aboard': 'Akaunti imeundwa kwa mafanikio! Karibu',
      'Registration failed. Please try again.': 'Usajili umeshindwa. Tafadhali jaribu tena.',
      'First Name': 'Jina la Kwanza', 'Required': 'Inahitajika', 'Too short': 'Fupi mno',
      'Last Name': 'Jina la Mwisho', 'Email Address': 'Anwani ya Barua Pepe',
      'Please enter your email': 'Tafadhali weka barua pepe yako',
      'Enter a valid email address': 'Weka anwani sahihi ya barua pepe',
      'Phone Number': 'Namba ya Simu', 'Please enter a password': 'Tafadhali weka nenosiri',
      'Password must be at least 8 characters': 'Nenosiri lazima liwe na herufi 8 au zaidi',
      'Confirm Password': 'Thibitisha Nenosiri',
      'Please confirm your password': 'Tafadhali thibitisha nenosiri lako',
      'Passwords do not match': 'Manenosiri hayafanani',
      'Already have an account?': 'Una akaunti tayari?', 'Sign In': 'Ingia',
      'Create Account': 'Fungua Akaunti',
      'Join Jaguza and manage your herd smarter.': 'Jiunge na Jaguza na usimamie mifugo yako kwa akili zaidi.',
      'Please enter your phone number': 'Tafadhali weka namba yako ya simu',
      'Enter a valid phone number': 'Weka namba sahihi ya simu',
      'Password strength': 'Uimara wa nenosiri',
      'I have read and agree to the Jaguza Livestock': 'Nimesoma na nakubaliana na',
      'and Privacy Policy.': 'na Sera ya Faragha.', 'CREATE ACCOUNT': 'FUNGUA AKAUNTI',

      // ── Forgot password flow ──
      'Failed to send verification code': 'Imeshindikana kutuma msimbo wa uthibitisho',
      "No worries! Enter your email address and we'll send you a code to reset your password.":
          'Usijali! Weka anwani yako ya barua pepe nasi tutakutumia msimbo wa kurejesha nenosiri lako.',
      'Please enter your email address': 'Tafadhali weka anwani yako ya barua pepe',
      'Please enter a valid email address': 'Tafadhali weka anwani sahihi ya barua pepe',
      'SEND CODE': 'TUMA MSIMBO', 'Please enter the 6-digit code': 'Tafadhali weka msimbo wa tarakimu 6',
      'Invalid or expired code': 'Msimbo si sahihi au umeisha muda',
      'A new code has been sent to': 'Msimbo mpya umetumwa kwa',
      'Failed to resend the code': 'Imeshindikana kutuma tena msimbo', 'Verification': 'Uthibitisho',
      'Enter the 6-digit code sent to': 'Weka msimbo wa tarakimu 6 uliotumwa kwa',
      'Sending...': 'Inatuma...', "Didn't receive a code? Resend": 'Hujapokea msimbo? Tuma tena',
      'VERIFY CODE': 'THIBITISHA MSIMBO', 'Failed to reset password': 'Imeshindikana kurejesha nenosiri',
      'Create New Password': 'Tengeneza Nenosiri Jipya',
      'Your new password must be different from previously used passwords.':
          'Nenosiri lako jipya lazima liwe tofauti na manenosiri uliyotumia awali.',
      'New Password': 'Nenosiri Jipya', 'Please enter a new password': 'Tafadhali weka nenosiri jipya',
      'RESET PASSWORD': 'REJESHA NENOSIRI', 'Password Reset\nSuccessful!': 'Kurejesha Nenosiri\nKumefanikiwa!',
      'Your password has been successfully reset. You can now use your new credentials to log in.':
          'Nenosiri lako limerejeshwa kwa mafanikio. Sasa unaweza kutumia taarifa zako mpya kuingia.',
      'BACK TO LOGIN': 'RUDI KUINGIA',
    },
    'lg': {
      'Skip': 'Buuka', 'Track Your Herd': 'Londoola Ente Zo',
      'Know where your livestock are in real time\nwith simple GPS tracking.':
          'Manya we ebisibo byo biri mu kiseera ekyo\nnga okozesa GPS ennyangu.',
      'Next': 'Ekiddako', 'Monitor Animal Health': 'Londoola Obulamu bw\'Ensolo',
      'Catch health issues early with alerts and\nvitals tracking for every animal.':
          'Zuula obuzibu bw\'obulamu mangu ng\'okozesa obubaka\nn\'okulondoola embeera ya buli nsolo.',
      'Back': 'Ddayo', 'Get Started': 'Tandika',
      'Set App Language': 'Teekawo Olulimi lwa App', 'Language': 'Olulimi',
      'languages_available': 'ennimi eziriwo', 'DONE': 'KIMALIDDWA',
      'Settings': 'Entegeka', 'Manage your app preferences': 'Ddaabiriza by\'oyagala mu app',
      'Account': 'Akawunti', 'Notifications': 'Obubaka',
      'Preferences': 'By\'oyagala', 'App Settings': 'Entegeka za App',
      'Support': 'Obuyambi', 'About': 'Ebikwata ku App', 'Push Notifications': 'Obubaka obw\'amangu',
      'Real-time alerts for your herd': 'Obubaka obw\'oku kiseera ekyo obukwata ku bisibo byo',
      'Dark Mode': 'Enkola ey\'Ekizikiza', 'Switch to dark interface': 'Kyusa okudda ku mwonekano ogw\'ekizikiza',
      'Privacy Policy': 'Etteeka ery\'Ebyekyama', 'Terms & Conditions': 'Ebigambo n\'Ebiragiro',
      'Help Center': 'Ekifo eky\'Obuyambi', 'Manage Account': 'Ddaabiriza Akawunti',
      'View and edit your profile settings': 'Laba era okyuse entegeka za profile yo',
      'Log Out': 'Fuluma', 'Delete Account': 'Sazaamu Akawunti',

      // ── Home shell (drawer + main tab) ──
      'Livestock Management': 'Okuddukanya Ebisibo', 'Farm Expenses': 'Ensimbi ez\'Ekyalo',
      'Feed': 'Emmere y\'Ebisolo', 'Veterinary Help': 'Obuyambi bwa Musawo w\'Ebisolo',
      'Veterinary Doctors': 'Abasawo b\'Ebisolo', 'Labour': 'Abakozi',
      'Equipment and Housing': 'Ebyuma n\'Ebifo by\'Okusula', 'Ask Jaguza AI': 'Buuza Jaguza AI',
      'Communicate': 'Tuukirizaganya', 'Tips and Suggestions': 'Amagezi n\'Ebiteeso',
      'Share JAGUZA': 'Gabana JAGUZA', 'Others': 'Ebirala',
      'Our Partners/About': 'Bakwatakwata Naffe/Ebitukwatako', 'Our Partners': 'Bakwatakwata Naffe',
      'Jaguza Livestock partners with agribusinesses, veterinary suppliers and cooperatives across Uganda. For the current list of partners, visit jaguzalivestock.com.':
          'Jaguza Livestock akolagana n\'amakampuni g\'ebyobulimi, abatunda eddagala ly\'ebisolo, n\'amakolero g\'obumu mu Uganda yonna. Okulaba abakwatakwata kaakano, kyalira jaguzalivestock.com.',
      'Visit our Website': 'Kyalira Omukutu Gwaffe',
      'Jaguza Livestock takes your privacy seriously. We collect only the data necessary to deliver our services. Your livestock data, farm records and location information are stored securely and never shared with third parties without your consent.\n\nYou may request deletion of your data at any time by contacting support@jaguzalivestock.com.':
          'Jaguza Livestock etwala eby\'ekyama byo nga bikulu nnyo. Tukuŋŋaanya bubwo ebikwata ku by\'obuweereza bwaffe. Ebikwata ku bisolo byo, ebiwandiiko by\'ekyalo n\'obuwangwa buterekebwa mu bukuumi era tebigabanibwa na bantu balala nga tosuubidde.\n\nOsobola okusaba okusangulwa kw\'ebikwata ku ggwe ekiseera kyonna nga oyita ku support@jaguzalivestock.com.',
      'About App': 'Ebikwata ku App', 'About Jaguza': 'Ebikwata ku Jaguza',
      'Jaguza Livestock v1.0.0\n\nA livestock management app for farmers: diagnose diseases, track animals and gestation, reach veterinary doctors, buy and sell in the marketplace, and get AI-powered farming advice — all in one place.':
          'Jaguza Livestock v1.0.0\n\nApp eddukanya ebisibo ey\'abalimi: zuula endwadde, londoola ebisolo n\'olubuto, tuukirira abasawo b\'ebisolo, gula era otunde mu katale, ate ofune amagezi g\'obulimi okuva mu AI — byonna mu kifo kimu.',
      'Logout': 'Fuluma', 'Are you sure you want to logout?': 'Oli mukakafu nti oyagala kufuluma?',
      'Cancel': 'Lekeraawo', 'Got it': 'Ntegedde',
      'Share the Jaguza app with your fellow farmers!': 'Gabana app ya Jaguza n\'abalimi banno!',
      'Share': 'Gabana', 'Version': 'Version',
      'Could not open website. Please try again.': 'Tesobodde kuggulawo omukutu. Ddamu ogezeeko.',
      'Error': 'Ensobi', 'User Posts': 'Ebiwandiiko by\'Abakozesa', 'Doctors': 'Abasawo',
      'Diseases': 'Endwadde',
      'Use Jaguza to Diagnose diseases, Track animals': 'Kozesa Jaguza okuzuula endwadde, Okulondoola ebisolo',
      'Sell your agricultural products in Market': 'Tunda ebintu byo eby\'obulimi mu Katale',
      'Know more about animal Diseases': 'Manya ebisingawo ku Ndwadde z\'ebisolo',
      'Track your Expenses and Milk production': 'Londoola Ensimbi zo n\'Amata g\'ofulumya',
      'Contact Veterinary Doctors': 'Tuukirira Abasawo b\'Ebisolo',
      'Track Animal Gestation and so much more…': 'Londoola Olubuto lw\'Ebisolo n\'ebirala bingi…',
      'Is there anything that you would like to know in the field of Agriculture?':
          'Waliwo ekintu ky\'oyagala okumanya mu by\'Obulimi?',
      'Ask Jaguza AI?': 'Buuza Jaguza AI?', 'Report sickness': 'Wandiika Obulwadde',
      'Diagnosis': 'Okuzuula Obulwadde', 'Disease Information': 'Amawulire ku Ndwadde',
      'Gestation tracker': 'Ekilondoola Olubuto', 'Market': 'Katale',
      'Weather updates': 'Amawulire g\'Obudde', 'Decision Support': 'Obuyambi mu Kusalawo',
      'My farm': 'Ekyalo Kyange', 'Videos': 'Vidiyo', 'Advertise with Jaguza': 'Langirira ne Jaguza',

      // ── Settings screen ──
      'How we handle your data': 'Engeri gye tukozesaamu ebikwata ku ggwe',
      'Review our terms of service': 'Laba ebiragiro byaffe eby\'obuweereza',
      'By using Jaguza Livestock you agree to use the app for lawful agricultural purposes only. Misuse, unauthorized access, or reverse-engineering of the platform is strictly prohibited.\n\nFor the full terms, visit jaguzalivestock.com/terms.':
          'Bw\'okozesa Jaguza Livestock okkiriza okukozesa app olw\'ebigendererwa by\'obulimi ebikkirizibwa mu mateeka. Okukozesa obubi, okuyingira awatali lukusa, oba okuzuula enkola y\'app kimenyeddwa ddala.\n\nOkufuna ebiragiro byonna, kyalira jaguzalivestock.com/terms.',
      'FAQs and how-to guides': 'Ebibuuzo ebibuuzibwa emirundi mingi n\'obulagirizi',
      'Need help? Visit our help center at help.jaguzalivestock.com or contact us:\n\nEmail: support@jaguzalivestock.com\nPhone: +256 XXX XXX XXX\n\nOur support team is available Monday – Friday, 8 AM – 6 PM (EAT).':
          'Weetaaga obuyambi? Kyalira ekifo kyaffe eky\'obuyambi ku help.jaguzalivestock.com oba tutuukirire:\n\nEmail: support@jaguzalivestock.com\nEsimu: +256 XXX XXX XXX\n\nEkibinja kyaffe eky\'obuyambi kiba kiriwo Balaza – Lwakutaano, essaawa 2 Enkya – essaawa 12 Olweggulo (EAT).',
      'App Version': 'Version ya App', 'You are on the latest version': 'Olina version omupya ennyo',
      'You\'re up to date!': 'Oli mu mbeera entuufu!', 'Sign out of your account': 'Fuluma ku akawunti yo',
      'Permanently remove your data': 'Sazaamu ebikwata ku ggwe ddala', 'All rights reserved': 'Eddembe lyonna likuumiddwa',
      'Are you sure you want to log out of your Jaguza account?':
          'Oli mukakafu nti oyagala okuva ku akawunti yo eya Jaguza?',
      'This action is permanent and cannot be undone. All your farm data, animals, and records will be deleted.':
          'Ekikolwa kino tekisoboka kuddamu kukyusibwa. Ebikwata ku kyalo kyo byonna, ebisolo, n\'ebiwandiiko binaasangulwa.',
      'Delete': 'Sazaamu',

      // ── Splash screen ──
      'Know your herd, wherever they roam.': 'Manya ebisibo byo, wonna gye bibeera.',

      // ── Login screen ──
      'Login successful! Welcome back': 'Oyingidde bulungi! Tukwanirizza',
      'Invalid login credentials': 'Ebikwata ku kuyingira si bituufu', 'Network error': 'Ensobi ya network',
      'Google Sign-In initiated': 'Okuyingira kwa Google kutandikiddwa',
      'Apple Sign-In initiated': 'Okuyingira kwa Apple kutandikiddwa',
      'SIGN IN': 'YINGIRA', 'Welcome back! Please enter your details.': 'Tukwanirizza! Tuusa ebikwata ku ggwe.',
      'Email or Phone Number': 'Email oba Namba ya Ssimu',
      'Please enter your email or phone number': 'Teeka email yo oba namba yo eya ssimu',
      'Password': 'Ekigambo eky\'ekyama', 'Please enter your password': 'Teeka ekigambo kyo eky\'ekyama',
      'Password must be at least 6 characters': 'Ekigambo eky\'ekyama kirina okuba n\'obumanyi 6 oba okusukkiriza',
      'Show password': 'Laga ekigambo eky\'ekyama', 'Hide password': 'Kweka ekigambo eky\'ekyama',
      'Forgot Password?': 'Weerabidde Ekigambo eky\'ekyama?', 'OR CONTINUE WITH': 'OBA WEYAMBISE',
      'Sign in with Google': 'Yingira ne Google', 'Sign in with Apple': 'Yingira ne Apple',
      "Don't have an Account?": 'Tolina Akawunti?', 'Register': 'Wewandiise',

      // ── Signup screen ──
      'Weak': 'Ekitono', 'Fair': 'Ekifaanana', 'Strong': 'Ekinywevu', 'Very strong': 'Ekinywevu Nnyo',
      'Please accept the Terms & Conditions to continue.':
          'Kkiriza Ebiragiro n\'Ebigambo okusobola okweyongerayo.',
      'Account created successfully! Welcome aboard': 'Akawunti etondeddwa bulungi! Tukwanirizza',
      'Registration failed. Please try again.': 'Okwewandiisa kulemye. Ddamu ogezeeko.',
      'First Name': 'Erinnya Erisooka', 'Required': 'Kyetaagisa', 'Too short': 'Kimpi nnyo',
      'Last Name': 'Erinnya Ery\'Ekika', 'Email Address': 'Email',
      'Please enter your email': 'Teeka email yo',
      'Enter a valid email address': 'Teeka email entuufu',
      'Phone Number': 'Namba ya Ssimu', 'Please enter a password': 'Teeka ekigambo eky\'ekyama',
      'Password must be at least 8 characters': 'Ekigambo eky\'ekyama kirina okuba n\'obumanyi 8 oba okusukkiriza',
      'Confirm Password': 'Kakasa Ekigambo eky\'ekyama',
      'Please confirm your password': 'Kakasa ekigambo kyo eky\'ekyama',
      'Passwords do not match': 'Ebigambo eby\'ekyama tebifaanagana',
      'Already have an account?': 'Olina akawunti dda?', 'Sign In': 'Yingira',
      'Create Account': 'Tonda Akawunti',
      'Join Jaguza and manage your herd smarter.': 'Yingira mu Jaguza oddukanye ebisibo byo n\'amagezi.',
      'Please enter your phone number': 'Teeka namba yo eya ssimu',
      'Enter a valid phone number': 'Teeka namba entuufu eya ssimu',
      'Password strength': 'Amaanyi g\'ekigambo eky\'ekyama',
      'I have read and agree to the Jaguza Livestock': 'Nsomye era nkkiriza',
      'and Privacy Policy.': 'n\'Etteeka ery\'Ebyekyama.', 'CREATE ACCOUNT': 'TONDA AKAWUNTI',

      // ── Forgot password flow ──
      'Failed to send verification code': 'Okutuma koodi ey\'okukakasa kulemye',
      "No worries! Enter your email address and we'll send you a code to reset your password.":
          'Teweraliikirira! Teeka email yo tunaakuweereza koodi ey\'okuzza obuggya ekigambo kyo eky\'ekyama.',
      'Please enter your email address': 'Teeka email yo',
      'Please enter a valid email address': 'Teeka email entuufu',
      'SEND CODE': 'WEEREZA KOODI', 'Please enter the 6-digit code': 'Teeka koodi ey\'ennamba 6',
      'Invalid or expired code': 'Koodi si ntuufu oba ewedde ekiseera',
      'A new code has been sent to': 'Koodi empya eweereddwayo ku',
      'Failed to resend the code': 'Okuddamu okuweereza koodi kulemye', 'Verification': 'Okukakasa',
      'Enter the 6-digit code sent to': 'Teeka koodi ey\'ennamba 6 eyaweerezebwa ku',
      'Sending...': 'Nga tukiweereza...', "Didn't receive a code? Resend": 'Tofunye koodi? Ddamu oweereze',
      'VERIFY CODE': 'KAKASA KOODI', 'Failed to reset password': 'Okuzza obuggya ekigambo eky\'ekyama kulemye',
      'Create New Password': 'Tonda Ekigambo Eky\'ekyama Ekipya',
      'Your new password must be different from previously used passwords.':
          'Ekigambo kyo ekipya eky\'ekyama kirina okuba ekitali kimu na ebyo bye wakoze eby\'edda.',
      'New Password': 'Ekigambo Eky\'ekyama Ekipya', 'Please enter a new password': 'Teeka ekigambo ekipya eky\'ekyama',
      'RESET PASSWORD': 'ZZA OBUGGYA EKIGAMBO EKY\'EKYAMA',
      'Password Reset\nSuccessful!': 'Okuzza Obuggya Ekigambo\nKuwedde Bulungi!',
      'Your password has been successfully reset. You can now use your new credentials to log in.':
          'Ekigambo kyo eky\'ekyama kizzeemu obuggya bulungi. Kaakano osobola okukozesa ebikwata ku ggwe ebipya okuyingira.',
      'BACK TO LOGIN': 'DDAYO OKUYINGIRA',
    },
  };
}

class _JaguzaLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _JaguzaLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => true;
  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);
  @override
  bool shouldReload(_JaguzaLocalizationsDelegate old) => false;
}

extension JaguzaLocalization on BuildContext {
  String tr(String key) => AppLocalizations.of(this).t(key);
}
