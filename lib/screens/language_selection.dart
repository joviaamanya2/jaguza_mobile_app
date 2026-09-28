import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../services/language_service.dart';
import '../services/app_localizations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguage;
  bool _isLoading = true;

  // Scoped to the languages Jaguza has real translations for today.
  // Grow this list (and AppLocalizations) as more languages are completed.
  final List<Map<String, String>> _languages = LanguageService.getSupportedLanguages();

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final savedLanguageCode = await LanguageService.getLanguageCode();
      
      if (savedLanguageCode != null && savedLanguageCode.isNotEmpty) {
        // Find the language name from the code
        final language = _languages.firstWhere(
          (lang) => lang['code'] == savedLanguageCode,
          orElse: () => {'name': 'English', 'code': 'en'},
        );
        setState(() {
          _selectedLanguage = language['name']!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _selectedLanguage = 'English';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _selectedLanguage = 'English';
        _isLoading = false;
      });
    }
  }

  // Applies the picked language to the whole app the moment it's tapped in
  // the dropdown, instead of waiting for DONE — LanguageService.saveLanguage
  // updates the shared locale notifier, which MyApp listens to, so every
  // translated string on screen (including this one) switches instantly.
  Future<void> _selectLanguage(String languageName) async {
    setState(() => _selectedLanguage = languageName);

    final languageEntry = _languages.firstWhere(
      (lang) => lang['name'] == languageName,
      orElse: () => {'name': 'English', 'code': 'en'},
    );

    try {
      await LanguageService.saveLanguage(languageEntry['code']!, languageName);
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to change language. Please try again.');
      }
    }
  }

  void _continueToHome() {
    if (_selectedLanguage == null) return;
    // The language is already applied — this just moves on to the app.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainShell(),
      ),
      (route) => false,
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height * 0.32;

    final scheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // 1. Top Background Image with Overlay
          Stack(
            children: [
              Container(
                height: headerHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?q=80&w=1000'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 24,
                bottom: 28,
                child: Text(
                  'Jaguza Livestock',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 2. Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  // Language Selection Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: scheme.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              context.tr('Set App Language'),
                              style: TextStyle(
                                color: scheme.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Text(
                          context.tr('Language'),
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: scheme.outlineVariant),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedLanguage,
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down, color: scheme.onSurfaceVariant),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _selectLanguage(newValue);
                                }
                              },
                              items: _languages.map<DropdownMenuItem<String>>((Map<String, String> lang) {
                                return DropdownMenuItem<String>(
                                  value: lang['name'],
                                  child: Text(
                                    lang['name']!,
                                    style: TextStyle(
                                      color: scheme.onSurface,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            AppLocalizations.of(context).languagesAvailable(_languages.length),
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: scheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _continueToHome,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'DONE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.check_rounded, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // 3. Footer Copyright Text
                  Text(
                    '© 2025 Jaguza Livestock. All rights reserved.',
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
