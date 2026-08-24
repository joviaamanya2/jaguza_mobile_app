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
      'Monitor Animal Health': 'Fuatilia afya ya wanyama', 'Back': 'Rudi',
      'Get Started': 'Anza', 'Set App Language': 'Weka lugha ya programu',
      'Language': 'Lugha', 'languages_available': 'lugha zinapatikana', 'DONE': 'MALIZA',
      'Settings': 'Mipangilio', 'Manage your app preferences': 'Dhibiti mapendeleo ya programu',
      'Account': 'Akaunti', 'Notifications': 'Arifa', 'Preferences': 'Mapendeleo',
      'App Settings': 'Mipangilio ya programu', 'Support': 'Msaada', 'About': 'Kuhusu',
      'Push Notifications': 'Arifa za kushinikiza', 'Dark Mode': 'Hali ya giza',
      'Privacy Policy': 'Sera ya faragha', 'Terms & Conditions': 'Sheria na masharti',
      'Help Center': 'Kituo cha msaada', 'Manage Account': 'Dhibiti akaunti',
      'Log Out': 'Toka', 'Delete Account': 'Futa akaunti',
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
