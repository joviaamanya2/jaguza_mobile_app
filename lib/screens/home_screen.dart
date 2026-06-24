import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jaguza',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Segoe UI',
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFFF57C00),
          surface: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const JaguzaHomePage(),
    );
  }
}

class JaguzaHomePage extends StatefulWidget {
  const JaguzaHomePage({super.key});

  @override
  State<JaguzaHomePage> createState() => _JaguzaHomePageState();
}

class _JaguzaHomePageState extends State<JaguzaHomePage>
    with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late Animation<double> _overlayScale;
  late Animation<double> _overlayFade;
  bool _showOverlay = true;

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _overlayScale = CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeOutCubic,
    );
    _overlayFade = CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeIn,
    );
    _overlayController.forward();
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  void _closeOverlay() {
    _overlayController.reverse().then((_) {
      setState(() => _showOverlay = false);
    });
  }

  void _showFeatureOverlay() {
    if (!_showOverlay) {
      setState(() {
        _showOverlay = true;
      });
      _overlayController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Main Scrollable Content (Fixes Overflow) ──
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 12),
                  _buildGreetingSection(),
                  const SizedBox(height: 16),
                  _buildAIQuestionBox(),
                  const SizedBox(height: 20),
                  _buildFeatureGrid(),
                  const SizedBox(height: 20),
                  _buildAdvertiseBanner(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Dropdown Overlay ──
          if (_showOverlay) _buildDropdownOverlay(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ═══════════════════════════════════════
  //  APP BAR
  // ═══════════════════════════════════════
  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2E7D32),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Menu Icon
          _iconCircle(
            icon: Icons.menu_rounded,
            onTap: () {},
            color: Colors.white24,
          ),
          const SizedBox(width: 8),
          // Back Arrow Icon (Fixed to reopen overlay)
          _iconCircle(
            icon: Icons.arrow_back_rounded,
            onTap: _showFeatureOverlay, 
            color: Colors.white24,
          ),
          const SizedBox(width: 12),
          // Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Jaguza',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const Spacer(),
          // Notification Bell
          GestureDetector(
            onTap: () {},
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _iconCircle(
                  icon: Icons.notifications_none_rounded,
                  onTap: () {},
                  color: Colors.white24,
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5252),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF5252),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconCircle({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white24,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  GREETING
  // ═══════════════════════════════════════
  Widget _buildGreetingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, Farmer! 👋',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'What would you like to do today?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  AI QUESTION BOX
  // ═══════════════════════════════════════
  Widget _buildAIQuestionBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8F00), Color(0xFFF57C00)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF57C00).withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Ask Jaguza AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Ask any agricultural question and get instant AI-powered answers.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFF57C00),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Ask Jaguza AI ?',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  FEATURE GRID (Updated with new cards)
  // ═══════════════════════════════════════
  Widget _buildFeatureGrid() {
    final features = [
      _FeatureItem(
        icon: Icons.coronavirus_rounded,
        title: 'Report\nSickness',
        color: const Color(0xFFE53935),
        bgLight: const Color(0xFFFFEBEE),
      ),
      _FeatureItem(
        icon: Icons.tab_unselected_sharp,
        title: 'Diagnosis',
        color: const Color(0xFF1E88E5),
        bgLight: const Color(0xFFE3F2FD),
      ),
      _FeatureItem(
        icon: Icons.medical_services_rounded,
        title: 'Veterinary\nDoctors',
        color: const Color(0xFF43A047),
        bgLight: const Color(0xFFE8F5E9),
      ),
      _FeatureItem(
        icon: Icons.biotech_rounded,
        title: 'Disease\nInformation',
        color: const Color(0xFF8E24AA),
        bgLight: const Color(0xFFF3E5F5),
      ),
      _FeatureItem(
        icon: Icons.pets_rounded,
        title: 'My\nAnimals',
        color: const Color(0xFF6D4C41),
        bgLight: const Color(0xFFEFEBE9),
      ),
      _FeatureItem(
        icon: Icons.shopping_cart_rounded,
        title: 'Market\nPlace',
        color: const Color(0xFFFB8C00),
        bgLight: const Color(0xFFFFF3E0),
      ),
      
      _FeatureItem(
        icon: Icons.pregnant_woman_rounded,
        title: 'Gestation\nTracker',
        color: const Color(0xFFEC407A),
        bgLight: const Color(0xFFFCE4EC),
      ),
      _FeatureItem(
        icon: Icons.cloud_rounded,
        title: 'Weather\nUpdates',
        color: const Color(0xFF039BE5),
        bgLight: const Color(0xFFE1F5FE),
      ),
      _FeatureItem(
        icon: Icons.lightbulb_rounded,
        title: 'Decision\nSupport',
        color: const Color(0xFFFFA000),
        bgLight: const Color(0xFFFFF8E1),
      ),
      _FeatureItem(
        icon: Icons.language_rounded,
        title: 'Visit our\nWebsite',
        color: const Color(0xFF5E35B1),
        bgLight: const Color(0xFFEDE7F6),
      ),
      _FeatureItem(
        icon: Icons.videocam_rounded,
        title: 'Video',
        color: const Color(0xFFD81B60),
        bgLight: const Color(0xFFFCE4EC),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.82,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final f = features[index];
          return _FeatureCard(item: f);
        },
      ),
    );
  }

  // ═══════════════════════════════════════
  //  ADVERTISE BANNER
  // ═══════════════════════════════════════
  Widget _buildAdvertiseBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1B5E20).withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF2E7D32).withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.campaign_rounded,
              color: Color(0xFF2E7D32),
              size: 22,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Advertise with Jaguza',
                style: TextStyle(
                  color: Color(0xFF1B5E20),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Learn More',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  DROPDOWN OVERLAY
  // ═══════════════════════════════════════
  Widget _buildDropdownOverlay() {
    final overlayItems = [
      _OverlayItem(
        icon: Icons.search_rounded,
        title: 'Diagnose Diseases',
        subtitle: 'AI-powered disease detection',
      ),
      _OverlayItem(
        icon: Icons.storefront_rounded,
        title: 'Sell Farm Products',
        subtitle: 'Reach buyers easily',
      ),
      _OverlayItem(
        icon: Icons.pets_rounded,
        title: 'Learn Animal Diseases',
        subtitle: 'Comprehensive knowledge base',
      ),
      _OverlayItem(
        icon: Icons.vaccines_rounded,
        title: 'Vaccination Schedule',
        subtitle: 'Never miss a vaccination',
      ),
      _OverlayItem(
        icon: Icons.chat_rounded,
        title: 'Ask Jaguza AI',
        subtitle: 'Instant agricultural answers',
      ),
    ];

    return Stack(
      children: [
        // Subtle backdrop to dismiss
        Positioned.fill(
          child: GestureDetector(
            onTap: _closeOverlay,
            child: FadeTransition(
              opacity: _overlayFade,
              child: Container(
                color: Colors.black.withOpacity(0.25),
              ),
            ),
          ),
        ),

        // The Dropdown Card
        Positioned(
          top: 80, 
          left: 20,
          right: 20,
          child: FadeTransition(
            opacity: _overlayFade,
            child: ScaleTransition(
              scale: _overlayScale,
              alignment: Alignment.topCenter, 
              child: Material(
                elevation: 16,
                shadowColor: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 12, 14),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFEEEEEE)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.agriculture_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'What can Jaguza do?',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1B1B1B),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Explore our core features',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9E9E9E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _closeOverlay,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Color(0xFF757575),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Items
                    ...overlayItems.map((item) => _buildOverlayItem(item)),
                    
                    const SizedBox(height: 8),

                    // Action Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _closeOverlay,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayItem(_OverlayItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _closeOverlay,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  color: const Color(0xFF2E7D32),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFBDBDBD),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  BOTTOM NAV
  // ═══════════════════════════════════════
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(icon: Icons.home_rounded, label: 'Home', active: true),
              _navItem(icon: Icons.explore_rounded, label: 'Explore'),
              _navItem(icon: Icons.chat_bubble_outline_rounded, label: 'AI Chat'),
              _navItem(icon: Icons.person_outline_rounded, label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    bool active = false,
  }) {
    final color = active ? const Color(0xFF2E7D32) : const Color(0xFFBDBDBD);
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════
//  DATA MODELS
// ═══════════════════════════════════════
class _FeatureItem {
  final IconData icon;
  final String title;
  final Color color;
  final Color bgLight;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.bgLight,
  });
}

class _OverlayItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OverlayItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// ═══════════════════════════════════════
//  FEATURE CARD
// ═══════════════════════════════════════
class _FeatureCard extends StatefulWidget {
  final _FeatureItem item;
  const _FeatureCard({required this.item});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform:
            _pressed ? (Matrix4.identity()..scale(0.94)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_pressed ? 0.04 : 0.06),
              blurRadius: _pressed ? 4 : 10,
              offset: Offset(0, _pressed ? 1 : 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.item.bgLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                widget.item.icon,
                color: widget.item.color,
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}