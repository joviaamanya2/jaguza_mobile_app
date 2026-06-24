import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './onboarding2.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _isVisible = true);
    });
  }

  void _goToNext() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingScreen2(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(position: tween.animate(animation), child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: _isVisible ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  // Skip Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: TextButton(
                        onPressed: _goToNext,
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
                  const SizedBox(height: 10),
                  
                
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 260,
                        maxHeight: 260,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 260,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0E2),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1B3A1B).withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(4, 6),
                            ),
                          ],
                        ),
                        child: CustomPaint(
                          painter: _StaticTrackingMapPainter(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Dots Row (Properly closed here)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(true),
                      const SizedBox(width: 8),
                      _buildDot(false),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                
                  SizedBox(
                    height: 200, 
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Comprehensive\nTracking',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1B3A1B),
                              height: 1.15,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Monitor your livestock health and real-time location with precision GPS tracking on an interactive 3D map.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6B7B60),
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  // Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _goToNext,
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
                              'Next',
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
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Copyright
                  const Text(
                    '© 2025 Jaguza Livestock. All rights reserved.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB0BCA6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
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
} 


// Static Painter: Draws once, never repaints

class _StaticTrackingMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Grid
    final gridPaint = Paint()
      ..color = const Color(0xFFD0DCC8)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    for (double i = -120; i <= 120; i += 40) {
      canvas.drawLine(Offset(center.dx + i, center.dy - 120),
          Offset(center.dx + i, center.dy + 120), gridPaint);
      canvas.drawLine(Offset(center.dx - 120, center.dy + i),
          Offset(center.dx + 120, center.dy + i), gridPaint);
    }

    // Terrain patches
    final fieldPaint = Paint()..color = const Color(0xFFC5D9B8);
    canvas.drawOval(
        Rect.fromCenter(
            center: center + const Offset(-60, -50), width: 80, height: 50),
        fieldPaint);
    canvas.drawOval(
        Rect.fromCenter(
            center: center + const Offset(50, 40), width: 90, height: 55),
        fieldPaint);
    canvas.drawOval(
        Rect.fromCenter(
            center: center + const Offset(10, -80), width: 60, height: 35),
        fieldPaint);

    // Water
    canvas.drawOval(
        Rect.fromCenter(
            center: center + const Offset(80, -60), width: 45, height: 30),
        Paint()..color = const Color(0xFFA8CCDB));

    // Fence
    final fencePaint = Paint()
      ..color = const Color(0xFF8B7355)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - 100, center.dy - 30)
        ..lineTo(center.dx - 100, center.dy + 80)
        ..lineTo(center.dx + 30, center.dy + 80)
        ..lineTo(center.dx + 30, center.dy + 20),
      fencePaint,
    );

    // Fully drawn GPS path
    final pathPaint = Paint()
      ..color = const Color(0xFF2D5A27)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - 70, center.dy + 50)
        ..quadraticBezierTo(center.dx - 40, center.dy + 10,
            center.dx - 10, center.dy + 30)
        ..quadraticBezierTo(center.dx + 20, center.dy + 45,
            center.dx + 50, center.dy + 15)
        ..quadraticBezierTo(
            center.dx + 70, center.dy - 5, center.dx + 60, center.dy - 40),
      pathPaint,
    );

    // Static Cow Markers
    final markerPositions = [
      center + const Offset(-70, 50),
      center + const Offset(-10, 30),
      center + const Offset(50, 15),
      center + const Offset(60, -40),
      center + const Offset(-50, -40),
      center + const Offset(30, 65),
    ];
    for (final pos in markerPositions) {
      canvas.drawCircle(pos, 5, Paint()..color = const Color(0xFF2D5A27));
      canvas.drawCircle(pos, 2.5, Paint()..color = Colors.white);
    }

    // Static Pulse Ring
    canvas.drawCircle(
      center + const Offset(60, -40),
      20,
      Paint()
        ..color = const Color(0xFF2D5A27).withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Pin drop
    _drawPinDrop(canvas, center + const Offset(60, -40) - const Offset(0, 28));

    // Compass
    _drawCompass(canvas, center + const Offset(110, -100));

    // Health badge
    _drawHealthBadge(canvas, center + const Offset(-100, -100));
  }

  void _drawPinDrop(Canvas canvas, Offset pos) {
    final path = Path()
      ..moveTo(pos.dx, pos.dy + 14)
      ..quadraticBezierTo(pos.dx - 10, pos.dy, pos.dx, pos.dy - 10)
      ..quadraticBezierTo(pos.dx + 10, pos.dy, pos.dx, pos.dy + 14);
    canvas.drawPath(path, Paint()..color = const Color(0xFFE74C3C));
    canvas.drawCircle(
        Offset(pos.dx, pos.dy - 6), 3.5, Paint()..color = Colors.white);
  }

  void _drawCompass(Canvas canvas, Offset pos) {
    canvas.drawCircle(pos, 18, Paint()..color = Colors.white);
    canvas.drawCircle(
        pos, 18,
        Paint()
          ..color = const Color(0xFFD0DCC8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);

    canvas.drawPath(
        Path()
          ..moveTo(pos.dx, pos.dy - 12)
          ..lineTo(pos.dx - 4, pos.dy)
          ..lineTo(pos.dx + 4, pos.dy)
          ..close(),
        Paint()..color = const Color(0xFFE74C3C));
    canvas.drawPath(
        Path()
          ..moveTo(pos.dx, pos.dy + 12)
          ..lineTo(pos.dx - 4, pos.dy)
          ..lineTo(pos.dx + 4, pos.dy)
          ..close(),
        Paint()..color = const Color(0xFF8B7355));

    final tp = TextPainter(
      text: const TextSpan(
        text: 'N',
        style: TextStyle(
          fontSize: 7,
          fontWeight: FontWeight.bold,
          color: Color(0xFFE74C3C),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - 26));
  }

  void _drawHealthBadge(Canvas canvas, Offset pos) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: pos, width: 70, height: 26),
            const Radius.circular(13)),
        Paint()..color = const Color(0xFF27AE60));
        
    final tp = TextPainter(
      text: const TextSpan(
        text: '\u2665 Healthy',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}