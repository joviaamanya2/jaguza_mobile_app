import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './onboarding1.dart';
import '../auth_screens/login_screen.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _goToSignIn() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
      (route) => false,
    );
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeController,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min, // REQUIRED for scroll views
                children: [
                  const SizedBox(height: 20),
                  
                  // Skip Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: TextButton(
                        onPressed: _goToSignIn,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Color(0xFF7A8A6E),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Illustration (Replaced Expanded with fixed sizing)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: MediaQuery.of(context).size.width * 0.75,
                        child: _buildIllustration(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Text Section (Replaced Expanded with natural sizing)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDot(false),
                            const SizedBox(width: 8),
                            _buildDot(true),
                          ],
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'Smart\nInsights',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1B3A1B),
                            height: 1.15,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Harness AI-powered analytics to optimize your farm operations, boost productivity, and make data-driven decisions.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF6B7B60),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(36, 0, 36, 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _goBack,
                          style: TextButton.styleFrom(
                              minimumSize: const Size(80, 52)),
                          child: const Row(
                            children: [
                              Icon(Icons.arrow_back,
                                  size: 20, color: Color(0xFF7A8A6E)),
                              SizedBox(width: 4),
                              Text(
                                'Back',
                                style: TextStyle(
                                  color: Color(0xFF7A8A6E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _goToSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D5A27),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(150, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.check, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Copyright
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      '\u00a9 2025 Jaguza Livestock. All rights reserved.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFB0BCA6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 32 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2D5A27) : const Color(0xFFD4E0CC),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  // ── Lightweight illustration using widgets instead of CustomPaint ──
  Widget _buildIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0E2),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B3A1B).withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(4, 6),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D5A27),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome,
                        size: 14, color: Color(0xFF6FCF73)),
                    SizedBox(width: 4),
                    Text(
                      'AI Powered',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 55,
          left: 20,
          child: _buildMiniBarChart(),
        ),
        Positioned(
          top: 45,
          right: 15,
          child: _buildMiniLineChart(),
        ),
        Positioned(
          bottom: 70,
          left: 15,
          child: _buildStatCard('+24%', 'Yield', const Color(0xFF27AE60)),
        ),
        Positioned(
          bottom: 70,
          right: 15,
          child: _buildStatCard('98%', 'Health', const Color(0xFF2D5A27)),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildFarmSilhouette(),
        ),
        Positioned(top: 50, left: 100, child: _floatingDot()),
        Positioned(top: 80, right: 85, child: _floatingDot()),
        Positioned(top: 140, left: 30, child: _floatingDot()),
        Positioned(top: 160, right: 25, child: _floatingDot()),
      ],
    );
  }

  Widget _buildMiniBarChart() {
    return Container(
      width: 110,
      height: 85,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'Production',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7B60),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bar(0.5, const Color(0xFF5A9A52)),
                _bar(0.4, const Color(0xFF4A8A42)),
                _bar(0.7, const Color(0xFF3A7034)),
                _bar(0.55, const Color(0xFF2D5A27)),
                _bar(0.65, const Color(0xFF27AE60)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(double fraction, Color color) {
    return Container(
      width: 12,
      height: double.infinity,
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: fraction,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniLineChart() {
    return Container(
      width: 115,
      height: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'Trends',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7B60),
            ),
          ),
          const SizedBox(height: 2),
           Expanded(
            child: CustomPaint(
              painter: _MiniLinePainter(),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      width: 68,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 3,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8B9A80),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmSilhouette() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      child: CustomPaint(
        size: const Size(280, 65),
        painter: _FarmSilhouettePainter(),
      ),
    );
  }

  Widget _floatingDot() {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A27).withOpacity(0.35),
        shape: BoxShape.circle,
      ),
    );
  }
}

// ── Minimal line chart painter (static, no animations) ──
class _MiniLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final points = [
      Offset(0, h * 0.8),
      Offset(w * 0.2, h * 0.3),
      Offset(w * 0.4, h * 0.5),
      Offset(w * 0.6, h * 0.15),
      Offset(w * 0.8, h * 0.35),
      Offset(w, h * 0.1),
    ];

    final grid = Paint()
      ..color = const Color(0xFFE8F0E2)
      ..strokeWidth = 0.5;
    for (int i = 0; i < 3; i++) {
      final y = h * 0.2 * i;
      canvas.drawLine(Offset(0, y), Offset(w, y), grid);
    }

    final areaPath = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      areaPath.lineTo(points[i].dx, points[i].dy);
    }
    areaPath.lineTo(w, h);
    areaPath.lineTo(0, h);
    areaPath.close();
    canvas.drawPath(
        areaPath, Paint()..color = const Color(0xFF2D5A27).withOpacity(0.08));

    final linePath = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xFF2D5A27)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (final p in points) {
      canvas.drawCircle(p, 2.5, Paint()..color = const Color(0xFF2D5A27));
      canvas.drawCircle(p, 1.2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Minimal farm silhouette painter (static) ──
class _FarmSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawPath(
      Path()
        ..moveTo(0, h)
        ..lineTo(0, h * 0.5)
        ..lineTo(w, h * 0.5)
        ..lineTo(w, h)
        ..close(),
      Paint()..color = const Color(0xFFC5D9B8),
    );

    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(w * 0.35, h * 0.6), width: 50, height: 30),
      Paint()..color = const Color(0xFF8B6914),
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.35 - 27, h * 0.45)
        ..lineTo(w * 0.35, h * 0.25)
        ..lineTo(w * 0.35 + 27, h * 0.45)
        ..close(),
      Paint()..color = const Color(0xFF6B4E0A),
    );

    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(w * 0.55, h * 0.55), width: 16, height: 35),
      Paint()..color = const Color(0xFFB0B0B0),
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.55, h * 0.35), width: 16, height: 7),
      Paint()..color = const Color(0xFFB0B0B0),
    );

    _tree(canvas, w * 0.15, h * 0.5);
    _tree(canvas, w * 0.78, h * 0.5);
    _tree(canvas, w * 0.9, h * 0.52);

    final fence = Paint()
      ..color = const Color(0xFF8B7355)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(w * 0.62, h * 0.6), Offset(w * 0.95, h * 0.65), fence);
    for (double x = 0.62; x <= 0.95; x += 0.05) {
      canvas.drawLine(
          Offset(w * x, h * 0.57), Offset(w * x, h * 0.67), fence);
    }
  }

  void _tree(Canvas canvas, double x, double y) {
    canvas.drawRect(
        Rect.fromCenter(center: Offset(x, y + 10), width: 4, height: 12),
        Paint()..color = const Color(0xFF6B4E0A));
    canvas.drawCircle(
        Offset(x, y), 9, Paint()..color = const Color(0xFF4A8A42));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}