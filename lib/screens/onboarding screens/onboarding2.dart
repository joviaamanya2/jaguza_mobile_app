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
                mainAxisSize: MainAxisSize.min,
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

                  // Illustration
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

                  // Text Section
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
                          'Digital\nLivestock Monitoring',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1B3A1B),
                            height: 1.15,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Track your animals in real-time, monitor health vitals, and manage your entire herd digitally from anywhere.',
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

  // ═══════════════════════════════════════
  //  ILLUSTRATION
  // ═══════════════════════════════════════

  Widget _buildIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background card
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

        // Top badge
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
                    Icon(Icons.sensors_rounded,
                        size: 14, color: Color(0xFF6FCF73)),
                    SizedBox(width: 4),
                    Text(
                      'Real-time Tracking',
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

        // Main scene
        Positioned.fill(
          top: 35,
          child: CustomPaint(
            painter: _FarmScenePainter(),
            size: Size.infinite,
          ),
        ),

        // Small signal dots
        Positioned(top: 55, left: 100, child: _signalDot()),
        Positioned(top: 75, right: 90, child: _signalDot()),
        Positioned(bottom: 80, left: 40, child: _signalDot()),
      ],
    );
  }

  Widget _signalDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A27).withOpacity(0.25),
        shape: BoxShape.circle,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  FARM SCENE — Farmer monitoring a mixed herd
// ═══════════════════════════════════════════════════

class _FarmScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Sky gradient (subtle) ──
    final skyRect = Rect.fromLTWH(0, 0, w, h * 0.5);
    final skyPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFE8F0E2).withOpacity(0),
          const Color(0xFFD4E8CC).withOpacity(0.5),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(skyRect);
    canvas.drawRect(skyRect, skyPaint);

    // ── Sun ──
    canvas.drawCircle(
      Offset(w * 0.82, h * 0.12),
      18,
      Paint()..color = const Color(0xFFF5E6B8).withOpacity(0.6),
    );
    canvas.drawCircle(
      Offset(w * 0.82, h * 0.12),
      12,
      Paint()..color = const Color(0xFFFCEFC4).withOpacity(0.8),
    );

    // ── Distant hills ──
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.38)
        ..quadraticBezierTo(w * 0.2, h * 0.28, w * 0.4, h * 0.34)
        ..quadraticBezierTo(w * 0.6, h * 0.40, w * 0.8, h * 0.32)
        ..quadraticBezierTo(w * 0.95, h * 0.27, w, h * 0.33)
        ..lineTo(w, h * 0.5)
        ..lineTo(0, h * 0.5)
        ..close(),
      Paint()..color = const Color(0xFFC5D9B8).withOpacity(0.5),
    );

    // ── Main ground ──
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.5)
        ..quadraticBezierTo(w * 0.3, h * 0.45, w * 0.5, h * 0.48)
        ..quadraticBezierTo(w * 0.7, h * 0.51, w, h * 0.47)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close(),
      Paint()..color = const Color(0xFFB8D4A8),
    );

    // Foreground ground strip
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.72)
        ..quadraticBezierTo(w * 0.25, h * 0.68, w * 0.5, h * 0.71)
        ..quadraticBezierTo(w * 0.75, h * 0.74, w, h * 0.7)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close(),
      Paint()..color = const Color(0xFFA3C492),
    );

    // ── Fence posts ──
    final fencePaint = Paint()
      ..color = const Color(0xFF8B7355)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Horizontal rails
    canvas.drawLine(
        Offset(w * 0.02, h * 0.55), Offset(w * 0.65, h * 0.52), fencePaint);
    canvas.drawLine(
        Offset(w * 0.02, h * 0.60), Offset(w * 0.65, h * 0.57), fencePaint);

    // Vertical posts
    for (double x = 0.02; x <= 0.65; x += 0.1) {
      canvas.drawLine(
          Offset(w * x, h * 0.50), Offset(w * x, h * 0.62), fencePaint);
    }

    // ── Tree (right side) ──
    _tree(canvas, w * 0.88, h * 0.40, 1.0);
    _tree(canvas, w * 0.76, h * 0.43, 0.7);

    // ── Grass tufts ──
    _grassTuft(canvas, w * 0.1, h * 0.67);
    _grassTuft(canvas, w * 0.35, h * 0.65);
    _grassTuft(canvas, w * 0.6, h * 0.68);
    _grassTuft(canvas, w * 0.85, h * 0.66);
    _grassTuft(canvas, w * 0.15, h * 0.82);
    _grassTuft(canvas, w * 0.55, h * 0.84);
    _grassTuft(canvas, w * 0.78, h * 0.80);

    // ════════════════════════════════
    //  ANIMALS
    // ════════════════════════════════

    // Cow (large, center-left)
    _cow(canvas, w * 0.25, h * 0.52, 1.0);

    // Goat (right of cow)
    _goat(canvas, w * 0.48, h * 0.50, 0.85);

    // Sheep (further right)
    _sheep(canvas, w * 0.60, h * 0.54, 0.75);

    // Chicken (small, near fence)
    _chicken(canvas, w * 0.12, h * 0.58, 0.7);

    // Another chicken
    _chicken(canvas, w * 0.18, h * 0.62, 0.55);

    // Small calf (near cow)
    _cow(canvas, w * 0.33, h * 0.56, 0.5);

    // ════════════════════════════════
    //  FARMER with tablet
    // ════════════════════════════════
    _farmer(canvas, w * 0.42, h * 0.68);

    // ── Small tracking rings on animals ──
    canvas.drawCircle(
      Offset(w * 0.25, h * 0.42),
      10,
      Paint()
        ..color = const Color(0xFF2D5A27).withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawCircle(
      Offset(w * 0.48, h * 0.40),
      8,
      Paint()
        ..color = const Color(0xFF2D5A27).withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    canvas.drawCircle(
      Offset(w * 0.60, h * 0.44),
      7,
      Paint()
        ..color = const Color(0xFF2D5A27).withOpacity(0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
  }

  // ── Cow ──
  void _cow(Canvas canvas, double x, double y, double s) {
    final body = Paint()..color = const Color(0xFF7A8A6E);
    final dark = Paint()..color = const Color(0xFF5A6A4E);
    final white = Paint()..color = const Color(0xFFF5F5F0);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: 32 * s, height: 16 * s),
      body,
    );

    // White patch
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(x - 4 * s, y - 2 * s),
          width: 14 * s,
          height: 8 * s),
      white,
    );

    // Head
    canvas.drawCircle(Offset(x + 18 * s, y - 5 * s), 8 * s, dark);

    // Horns
    final hornPaint = Paint()
      ..color = const Color(0xFFD4C4A0)
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(x + 15 * s, y - 12 * s),
        Offset(x + 12 * s, y - 18 * s),
        hornPaint);
    canvas.drawLine(
        Offset(x + 21 * s, y - 12 * s),
        Offset(x + 24 * s, y - 18 * s),
        hornPaint);

    // Eye
    canvas.drawCircle(
        Offset(x + 20 * s, y - 6 * s), 1.5 * s, white);

    // Legs
    final legPaint = Paint()..color = const Color(0xFF5A6A4E);
    for (double dx in [-9, -3, 5, 11]) {
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset(x + dx * s, y + 12 * s),
            width: 3.5 * s,
            height: 10 * s),
        legPaint,
      );
    }

    // Tail
    final tailPaint = Paint()
      ..color = const Color(0xFF5A6A4E)
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final tailPath = Path()
      ..moveTo(x - 16 * s, y - 2 * s)
      ..quadraticBezierTo(
          x - 22 * s, y - 14 * s, x - 20 * s, y - 18 * s);
    canvas.drawPath(tailPath, tailPaint);

    // Tail tuft
    canvas.drawCircle(
        Offset(x - 20 * s, y - 18 * s), 3 * s, dark);
  }

  // ── Goat ──
  void _goat(Canvas canvas, double x, double y, double s) {
    final body = Paint()..color = const Color(0xFFD4C4A0);
    final dark = Paint()..color = const Color(0xFFB0A080);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: 24 * s, height: 13 * s),
      body,
    );

    // Head
    canvas.drawCircle(Offset(x + 14 * s, y - 4 * s), 6.5 * s, dark);

    // Horns (curved)
    final hornPaint = Paint()
      ..color = const Color(0xFF8B7355)
      ..strokeWidth = 1.8 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final hornL = Path()
      ..moveTo(x + 12 * s, y - 10 * s)
      ..quadraticBezierTo(
          x + 6 * s, y - 20 * s, x + 10 * s, y - 22 * s);
    canvas.drawPath(hornL, hornPaint);
    final hornR = Path()
      ..moveTo(x + 16 * s, y - 10 * s)
      ..quadraticBezierTo(
          x + 22 * s, y - 20 * s, x + 18 * s, y - 22 * s);
    canvas.drawPath(hornR, hornPaint);

    // Eye
    canvas.drawCircle(
        Offset(x + 16 * s, y - 5 * s), 1.2 * s, Paint()..color = const Color(0xFFFFFFFF));

    // Beard
    final beardPaint = Paint()
      ..color = const Color(0xFFB0A080)
      ..strokeWidth = 1 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(x + 16 * s, y), Offset(x + 17 * s, y + 6 * s), beardPaint);

    // Legs
    final legPaint = Paint()..color = const Color(0xFFB0A080);
    for (double dx in [-6, -1, 5, 9]) {
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset(x + dx * s, y + 9 * s),
            width: 2.5 * s,
            height: 9 * s),
        legPaint,
      );
    }

    // Tail (short, up)
    final tailPaint = Paint()
      ..color = const Color(0xFFB0A080)
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(x - 12 * s, y - 3 * s),
        Offset(x - 14 * s, y - 10 * s),
        tailPaint);
  }

  // ── Sheep ──
  void _sheep(Canvas canvas, double x, double y, double s) {
    final fluffy = Paint()..color = const Color(0xFFF0EDE4);
    final dark = Paint()..color = const Color(0xFF4A4A4A);
    final legPaint = Paint()..color = const Color(0xFF4A4A4A);

    // Fluffy body (overlapping circles)
    for (Offset offset in [
      Offset(0, 0),
      Offset(-6 * s, -2 * s),
      Offset(6 * s, -2 * s),
      Offset(-3 * s, -6 * s),
      Offset(3 * s, -6 * s),
      Offset(0, -4 * s),
    ]) {
      canvas.drawCircle(
          Offset(x + offset.dx, y + offset.dy), 7 * s, fluffy);
    }

    // Head
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(x + 12 * s, y - 2 * s),
          width: 8 * s,
          height: 10 * s),
      dark,
    );

    // Ears
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(x + 8 * s, y - 7 * s),
          width: 4 * s,
          height: 6 * s),
      dark,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(x + 16 * s, y - 7 * s),
          width: 4 * s,
          height: 6 * s),
      dark,
    );

    // Eye
    canvas.drawCircle(
        Offset(x + 13 * s, y - 3 * s), 1 * s, Paint()..color = const Color(0xFFFFFFFF));

    // Legs
    for (double dx in [-5, 0, 5, 9]) {
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset(x + dx * s, y + 9 * s),
            width: 2.5 * s,
            height: 8 * s),
        legPaint,
      );
    }
  }

  // ── Chicken ──
  void _chicken(Canvas canvas, double x, double y, double s) {
    final bodyPaint = Paint()..color = const Color(0xFFE67E22);
    final darkPaint = Paint()..color = const Color(0xFFD35400);
    final redPaint = Paint()..color = const Color(0xFFC0392B);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: 14 * s, height: 11 * s),
      bodyPaint,
    );

    // Head
    canvas.drawCircle(Offset(x + 8 * s, y - 5 * s), 5 * s, bodyPaint);

    // Comb
    canvas.drawCircle(Offset(x + 8 * s, y - 10 * s), 2.5 * s, redPaint);
    canvas.drawCircle(Offset(x + 6 * s, y - 9.5 * s), 1.8 * s, redPaint);
    canvas.drawCircle(Offset(x + 10 * s, y - 9.5 * s), 1.8 * s, redPaint);

    // Beak
    canvas.drawPath(
      Path()
        ..moveTo(x + 13 * s, y - 5 * s)
        ..lineTo(x + 17 * s, y - 4 * s)
        ..lineTo(x + 13 * s, y - 3 * s)
        ..close(),
      darkPaint,
    );

    // Eye
    canvas.drawCircle(
        Offset(x + 9 * s, y - 5.5 * s), 1 * s, Paint()..color = const Color(0xFF1B3A1B));

    // Tail feathers
    final tailPaint = Paint()
      ..color = const Color(0xFFD35400)
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(x - 7 * s, y - 2 * s),
        Offset(x - 14 * s, y - 12 * s), tailPaint);
    canvas.drawLine(Offset(x - 6 * s, y), Offset(x - 12 * s, y - 10 * s),
        tailPaint);
    canvas.drawLine(Offset(x - 5 * s, y + 1 * s),
        Offset(x - 10 * s, y - 7 * s), tailPaint);

    // Legs
    final legPaint = Paint()
      ..color = const Color(0xFFD35400)
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(x - 2 * s, y + 5 * s),
        Offset(x - 3 * s, y + 11 * s), legPaint);
    canvas.drawLine(Offset(x + 3 * s, y + 5 * s),
        Offset(x + 2 * s, y + 11 * s), legPaint);
  }

  // ── Farmer with tablet ──
  void _farmer(Canvas canvas, double x, double y) {
    final skinPaint = Paint()..color = const Color(0xFF8B6914);
    final shirtPaint = Paint()..color = const Color(0xFF2D5A27);
    final pantsPaint = Paint()..color = const Color(0xFF5A4A3A);
    final bootPaint = Paint()..color = const Color(0xFF3E2723);
    final hairPaint = Paint()..color = const Color(0xFF1B3A1B);

    // Legs
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(x - 4, y + 28), width: 8, height: 18),
        pantsPaint);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(x + 5, y + 28), width: 8, height: 18),
        pantsPaint);

    // Boots
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(x - 4, y + 39), width: 9, height: 6),
        bootPaint);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(x + 5, y + 39), width: 9, height: 6),
        bootPaint);

    // Body / shirt
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, y + 10), width: 24, height: 22),
          const Radius.circular(4)),
      shirtPaint,
    );

    // Arms
    final armPaint = Paint()
      ..color = const Color(0xFF2D5A27)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Left arm (down)
    canvas.drawLine(Offset(x - 12, y + 4), Offset(x - 16, y + 18), armPaint);

    // Right arm (holding tablet up)
    canvas.drawLine(Offset(x + 12, y + 4), Offset(x + 20, y - 2), armPaint);

    // Hand (skin color) holding tablet
    canvas.drawCircle(Offset(x + 20, y - 2), 3.5, skinPaint);

    // ── Tablet ──
    final tabletPaint = Paint()..color = const Color(0xFF1A1A2E);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x + 26, y - 8), width: 16, height: 22),
          const Radius.circular(3)),
      tabletPaint,
    );

    // Tablet screen
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(x + 26, y - 9), width: 13, height: 18),
          const Radius.circular(2)),
      Paint()..color = const Color(0xFF4AE68A),
    );

    // Tablet content lines
    final linePaint = Paint()
      ..color = const Color(0xFF2D5A27)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(x + 21, y - 14), Offset(x + 31, y - 14), linePaint);
    canvas.drawLine(
        Offset(x + 21, y - 11), Offset(x + 28, y - 11), linePaint);
    canvas.drawLine(
        Offset(x + 21, y - 8), Offset(x + 30, y - 8), linePaint);

    // Small heart/pulse icon on tablet
    canvas.drawCircle(Offset(x + 26, y - 2), 2.5,
        Paint()..color = const Color(0xFFE74C3C));

    // Neck
    canvas.drawRect(
        Rect.fromCenter(center: Offset(x, y - 2), width: 8, height: 5),
        skinPaint);

    // Head
    canvas.drawCircle(Offset(x, y - 10), 10, skinPaint);

    // Hair
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(x, y - 12), width: 22, height: 16),
      -3.14,
      0,
      false,
      hairPaint,
    );

    // Hat (simple cap)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(x, y - 18), width: 24, height: 6),
          const Radius.circular(3)),
      Paint()..color = const Color(0xFF2D5A27),
    );
    // Hat brim
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(x, y - 15), width: 28, height: 3),
        Paint()..color = const Color(0xFF245020));

    // Eye
    canvas.drawCircle(Offset(x + 4, y - 10), 1.5, Paint()..color = const Color(0xFF1B3A1B));

    // Smile
    final smilePaint = Paint()
      ..color = const Color(0xFF5A4A3A)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(x + 2, y - 7), width: 8, height: 5),
      0.3,
      2.8,
      false,
      smilePaint,
    );
  }

  // ── Tree ──
  void _tree(Canvas canvas, double x, double y, double s) {
    // Trunk
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(x, y + 12 * s), width: 5 * s, height: 14 * s),
      Paint()..color = const Color(0xFF6B4E0A),
    );

    // Foliage layers
    canvas.drawCircle(Offset(x, y - 2 * s), 12 * s,
        Paint()..color = const Color(0xFF4A8A42));
    canvas.drawCircle(Offset(x - 6 * s, y + 2 * s), 9 * s,
        Paint()..color = const Color(0xFF5A9A52));
    canvas.drawCircle(Offset(x + 7 * s, y + 1 * s), 8 * s,
        Paint()..color = const Color(0xFF5A9A52));
    canvas.drawCircle(Offset(x, y - 8 * s), 8 * s,
        Paint()..color = const Color(0xFF6BAA62));
  }

  // ── Grass tuft ──
  void _grassTuft(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..color = const Color(0xFF5A8A42)
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(x, y), Offset(x - 2, y - 7), paint);
    canvas.drawLine(Offset(x, y), Offset(x + 1, y - 8), paint);
    canvas.drawLine(Offset(x, y), Offset(x + 3, y - 6), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}