import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaguza_app/services/language_service.dart';
import 'package:jaguza_app/services/app_localizations.dart';
import 'package:jaguza_app/services/theme_service.dart';

// Import your Profile/Account screen
import 'package:jaguza_app/screens/home_details/Profile/profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ── Toggle states 
  bool _pushNotifications = true;
  bool get _darkMode => ThemeService.isDark;

  // ── Selected values 
  String _selectedLanguage = 'English';

  static const _kGreen = Color(0xFF2E7D32);
  static const _kGreenLight = Color(0xFF2E7D32);
  static const _kGreenFaint = Color(0xFF2E7D32);
  static const _kOrange = Color(0xFFF57C00);
  static const _kOrangeFaint = Color(0xFFFFF3E0);
  static const _kBg = Color(0xFFF4F6F8);
  static const _kCard = Colors.white;
  static const _kText = Color(0xFF1A1F36);
  static const _kSubtext = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE8EDF2);

  @override
  void initState() {
    super.initState();
    _selectedLanguage = LanguageService.getLanguageNameFromCode(
      LanguageService.currentLocale.languageCode,
    );
    LanguageService.localeNotifier.addListener(_syncLanguage);
  }

  @override
  void dispose() {
    LanguageService.localeNotifier.removeListener(_syncLanguage);
    super.dispose();
  }

  void _syncLanguage() {
    if (!mounted) return;
    setState(() {
      _selectedLanguage = LanguageService.getLanguageNameFromCode(
        LanguageService.currentLocale.languageCode,
      );
    });
  }

  Future<void> _changeLanguage(String languageName) async {
    await LanguageService.saveLanguage(
      LanguageService.getLanguageCodeFromName(languageName),
      languageName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Account section ─────────────────────────────────
                    _buildSectionLabel(context.tr('Account')),
                    _buildAccountCard(),

                    // ── Notifications ────────────────────────────────────
                    _buildSectionLabel(context.tr('Notifications')),
                    _buildCard([
                      _toggleRow(
                        icon: Icons.notifications_active_rounded,
                        iconColor: const Color(0xFFF59E0B),
                        title: 'Push Notifications',
                        subtitle: 'Real-time alerts for your herd',
                        value: _pushNotifications,
                        onChanged: (v) =>
                            setState(() => _pushNotifications = v),
                      ),
                    ]),

                    // ── Preferences ──────────────────────────────────────
                    _buildSectionLabel(context.tr('Preferences')),
                    _buildCard([
                      _dropdownRow(
                        icon: Icons.language_rounded,
                        iconColor: const Color(0xFF8B5CF6),
                        title: 'Language',
                        value: _selectedLanguage,
                        options: const [
                          'English',
                          'Luganda',
                          'Swahili',
                          'French',
                          'Runyankore',
                          'Acholi',
                        ],
                        onChanged: (v) {
                          if (v != null) _changeLanguage(v);
                        },
                      ),
                    ]),

                    // ── App Settings ─────────────────────────────────────
                    _buildSectionLabel(context.tr('App Settings')),
                    _buildCard([
                      _toggleRow(
                        icon: Icons.dark_mode_rounded,
                        iconColor: const Color(0xFF6366F1),
                        title: 'Dark Mode',
                        subtitle: 'Switch to dark interface',
                        value: _darkMode,
                        onChanged: (v) => ThemeService.setDarkMode(v),
                      ),
                      _divider(),
                      _tapRow(
                        icon: Icons.shield_outlined,
                        iconColor: _kGreen,
                        title: 'Privacy Policy',
                        subtitle: 'How we handle your data',
                        onTap: () => _showInfoSheet(
                          context,
                          title: 'Privacy Policy',
                          body:
                              'Jaguza Livestock takes your privacy seriously. We collect only the data necessary to deliver our services. Your livestock data, farm records and location information are stored securely and never shared with third parties without your consent.\n\nYou may request deletion of your data at any time by contacting support@jaguzalivestock.com.',
                        ),
                      ),
                      _divider(),
                      _tapRow(
                        icon: Icons.description_outlined,
                        iconColor: const Color(0xFF6366F1),
                        title: 'Terms & Conditions',
                        subtitle: 'Review our terms of service',
                        onTap: () => _showInfoSheet(
                          context,
                          title: 'Terms & Conditions',
                          body:
                              'By using Jaguza Livestock you agree to use the app for lawful agricultural purposes only. Misuse, unauthorized access, or reverse-engineering of the platform is strictly prohibited.\n\nFor the full terms, visit jaguzalivestock.com/terms.',
                        ),
                      ),
                    ]),

                    // ── Support ──────────────────────────────────────────
                    _buildSectionLabel(context.tr('Support')),
                    _buildCard([
                      _tapRow(
                        icon: Icons.help_outline_rounded,
                        iconColor: const Color(0xFF3B82F6),
                        title: 'Help Center',
                        subtitle: 'FAQs and how-to guides',
                        onTap: () => _showInfoSheet(
                          context,
                          title: 'Help Center',
                          body:
                              'Need help? Visit our help center at help.jaguzalivestock.com or contact us:\n\nEmail: support@jaguzalivestock.com\nPhone: +256 XXX XXX XXX\n\nOur support team is available Monday – Friday, 8 AM – 6 PM (EAT).',
                        ),
                      ),
                    ]),

                    // ── App info ─────────────────────────────────────────
                    _buildSectionLabel(context.tr('About')),
                    _buildCard([
                      _tapRow(
                        icon: Icons.info_outline_rounded,
                        iconColor: _kGreen,
                        title: 'App Version',
                        subtitle: 'Jaguza Livestock v1.0.0',
                        onTap: () {},
                        trailingText: 'v1.0.0',
                        showChevron: false,
                      ),
                      _divider(),
                      _tapRow(
                        icon: Icons.update_rounded,
                        iconColor: const Color(0xFF3B82F6),
                        title: 'Check for Updates',
                        subtitle: 'You are on the latest version',
                        onTap: () => _showSnack(context, 'You\'re up to date!'),
                      ),
                    ]),

                    // ── Danger zone ──────────────────────────────────────
                    const SizedBox(height: 8),
                    _buildCard([
                      _tapRow(
                        icon: Icons.logout_rounded,
                        iconColor: const Color(0xFFEF4444),
                        title: 'Log Out',
                        subtitle: 'Sign out of your account',
                        titleColor: const Color(0xFFEF4444),
                        onTap: () => _showLogoutDialog(context),
                      ),
                      _divider(),
                      _tapRow(
                        icon: Icons.person_off_outlined,
                        iconColor: const Color(0xFFEF4444),
                        title: 'Delete Account',
                        subtitle: 'Permanently remove your data',
                        titleColor: const Color(0xFFEF4444),
                        onTap: () => _showDeleteAccountDialog(context),
                      ),
                    ]),
                    const SizedBox(height: 16),

                    // Footer
                    Center(
                      child: Text(
                        '© 2025 Jaguar Farm Tech · All rights reserved',
                        style: TextStyle(
                          fontSize: 11,
                          color: _kSubtext.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kGreen, _kGreenLight],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('Settings'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      context.tr('Manage your app preferences'),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Account card (Manage Account) ─────────────────────────────────────────
  Widget _buildAccountCard() {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileTab()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_kGreen, _kGreenLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'View and edit your profile settings',
                      style: TextStyle(
                        fontSize: 13,
                        color: _kSubtext,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.dividerColor,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helpers ────
  Widget _buildSectionLabel(String label) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _divider() => Divider(
        height: 1,
        indent: 56,
        endIndent: 16,
        color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
      );

  Widget _iconBox(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 19),
    );
  }

  Widget _toggleRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _iconBox(icon, iconColor),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: _kOrange,
            activeTrackColor: _kOrangeFaint,
          ),
        ],
      ),
    );
  }

  Widget _tapRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? trailingText,
    Color? titleColor,
    bool showChevron = true,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _iconBox(icon, iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: titleColor ?? theme.colorScheme.onSurface)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            if (trailingText != null) ...[
              Text(trailingText,
                  style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500)),
              const SizedBox(width: 6),
            ],
            if (showChevron)
              Icon(Icons.chevron_right_rounded,
                  color: theme.dividerColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _dropdownRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      child: Row(
        children: [
          _iconBox(icon, iconColor),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface)),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              icon: Icon(Icons.arrow_drop_down_rounded,
                  color: theme.colorScheme.onSurfaceVariant, size: 20),
              style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500),
              onChanged: onChanged,
              items: [
                for (final opt in options)
                  DropdownMenuItem(value: opt, child: Text(opt))
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Dialogs & Sheets ─────────────────────────────────────────────────────
  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _kGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showInfoSheet(BuildContext ctx,
      {required String title, required String body}) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InfoSheet(title: title, body: body),
    );
  }

  void _showLogoutDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFFEF4444))),
        content: const Text(
            'Are you sure you want to log out of your Jaguza account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: _kSubtext)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Log Out',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Account',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFFEF4444))),
        content: const Text(
            'This action is permanent and cannot be undone. All your farm data, animals, and records will be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: _kSubtext)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── Info bottom sheet ────────────────────────────────────────────────────────
class _InfoSheet extends StatelessWidget {
  final String title;
  final String body;
  const _InfoSheet({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface)),
          const SizedBox(height: 14),
          Text(body,
              style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.65)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B7A45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Got it',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
