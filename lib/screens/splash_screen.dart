import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaguza_app/screens/onboarding%20screens/onboarding1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import 'home_screen.dart';
import 'language_selection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _taglineFade;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // Logo fade + scale
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnim = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    // Tagline fades in slightly after logo
    _taglineFade = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    _scaleController.forward();
    _fadeController.forward();

    Future.delayed(const Duration(seconds: 3), _checkAuthAndNavigate);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    if (_hasNavigated || !mounted) return;

    try {
      final apiService = ApiService();
      await apiService.loadTokens();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final savedLanguage = prefs.getString('language_code');

      if (!mounted) return;
      setState(() => _hasNavigated = true);

      if (token != null && token.isNotEmpty) {
        if (savedLanguage != null && savedLanguage.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainShell()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
          );
        }
      } else {
        _goToOnboarding();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _hasNavigated = true);
      _goToOnboarding();
    }
  }

  void _goToOnboarding() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingScreen1(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Changed to dark for white background
        systemNavigationBarColor: Colors.white, // Changed to white
        systemNavigationBarIconBrightness: Brightness.dark, // Changed to dark
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white, // Changed to white background
          ),
          child: Stack(
            children: [
              // Subtle decorative circles - adjusted for white background
              Positioned(
                top: -60,
                right: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.03), // Changed to subtle black
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                left: -50,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.02), // Changed to subtle black
                  ),
                ),
              ),

              // Main content
              Center(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo with scale animation - kept as is (white bg with black text)
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white, // Keeping logo background white
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1), // Lighter shadow for white bg
                                blurRadius: 32,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              'lib/assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // App name - changed to black
                      FadeTransition(
                        opacity: _taglineFade,
                        child: const Text(
                          'JAGUZA',
                          style: TextStyle(
                            color: Colors.black, // Changed to black
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 4.0,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tagline - changed to dark gray
                      FadeTransition(
                        opacity: _taglineFade,
                        child: Text(
                          'Know your herd, wherever they roam.',
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.7), // Changed to dark gray
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Version / brand note at bottom - changed to dark gray
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _taglineFade,
                  child: Center(
                    child: Text(
                      'Jaguza Farm Tech',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.4), // Changed to dark gray
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}