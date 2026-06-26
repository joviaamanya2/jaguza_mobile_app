import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease_info.dart';
import 'package:jaguza_app/screens/home_details/Veterinary%20Doctors/veterinary_doctors.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home_details/Explore Screen/explore_screen.dart';
import '../screens/home_details/AI chart/ai_chart_screen.dart';
import '../screens/home_details/Profile/profile_screen.dart';
void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const JaguzaApp());
}

class JaguzaApp extends StatelessWidget {
  const JaguzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jaguza',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFFF57C00),
          surface: Colors.white,
        ),
      ),
      home: const MainShell(),
    );
  }
}


//  NAVIGATION SHELL — owns the bottom nav, hosts all 4 tabs

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeTab(),
    ExploreScreen(),
    AIChatTab(),
    ProfileTab(),
  ];

  void _switchTab(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      _NavData(Icons.home_outlined, Icons.home_rounded, 'Home'),
      _NavData(Icons.explore_outlined, Icons.explore_rounded, 'Explore'),
      _NavData(Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'AI Chat'),
      _NavData(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
    ];

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
            children: List.generate(items.length, (i) {
              final item = items[i];
              final active = _currentIndex == i;
              return GestureDetector(
                onTap: () => _switchTab(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFF2E7D32).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        active ? item.activeIcon : item.icon,
                        color: active
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFBDBDBD),
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: active
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFBDBDBD),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavData(this.icon, this.activeIcon, this.label);
}


class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late Animation<double> _overlayScale;
  late Animation<double> _overlayFade;
  bool _showOverlay = true;
  bool _showAd = true;

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
      setState(() => _showOverlay = true);
      _overlayController.forward(from: 0.0);
    }
  }

  void _dismissAd() => setState(() => _showAd = false);

  /// Switch to the AI Chat tab from the "Ask Jaguza AI" button
  void _goToAIChat() {
    final shell = context.findAncestorStateOfType<_MainShellState>();
    shell?.setState(() => shell._currentIndex = 2);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
                if (_showAd) ...[
                  const SizedBox(height: 20),
                  _buildAdvertiseBanner(),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        if (_showOverlay) _buildDropdownOverlay(),
      ],
    );
  }

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
          _iconCircle(
            icon: Icons.menu_rounded,
            onTap: () {},
            color: Colors.white24,
          ),
          const SizedBox(width: 8),
          _iconCircle(
            icon: Icons.arrow_back_rounded,
            onTap: _showFeatureOverlay,
            color: Colors.white24,
          ),
          const SizedBox(width: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                    decoration: BoxDecoration(
                      color: Color(0xFFFF5252),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFFFF5252), blurRadius: 6),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '0',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
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

  Widget _iconCircle(
      {required IconData icon,
      required VoidCallback onTap,
      Color color = Colors.white24}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hello, Farmer! 👋',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          const Text('What would you like to do today?',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B5E20)))
        ],
      ),
    );
  }

  Widget _buildAIQuestionBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFFF8F00), Color(0xFFF57C00)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFF57C00).withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 6))
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
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.auto_awesome_rounded,
                        color: Colors.white, size: 20)),
                const SizedBox(width: 10),
                const Text('Ask Jaguza AI',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
                'Ask any agricultural question and get instant AI-powered answers.',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                    height: 1.4)),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goToAIChat,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFF57C00),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0),
                child: const Text('Ask Jaguza AI ?',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final gridFeatures = [
      FeatureItem(
          icon: Icons.coronavirus_rounded,
          title: 'Report\nSickness',
          color: const Color(0xFFE53935),
          bgLight: const Color(0xFFFFEBEE),
          screen: const _PlaceholderScreen(
              title: 'Report Sickness', icon: Icons.coronavirus_rounded)),
      FeatureItem(
          icon: Icons.tab_unselected_sharp,
          title: 'Diagnosis',
          color: const Color(0xFF1E88E5),
          bgLight: const Color(0xFFE3F2FD),
          screen: const _PlaceholderScreen(
              title: 'Diagnosis', icon: Icons.tab_unselected_sharp)),
      FeatureItem(
          icon: Icons.medical_services_rounded,
          title: 'Veterinary\nDoctors',
          color: const Color(0xFF43A047),
          bgLight: const Color(0xFFE8F5E9),
          screen: const VeterinaryDoctorsScreen()),
      FeatureItem(
          icon: Icons.biotech_rounded,
          title: 'Disease\nInformation',
          color: const Color(0xFF8E24AA),
          bgLight: const Color(0xFFF3E5F5),
          screen: const AnimalDiseasesScreen()),
      FeatureItem(
          icon: Icons.pets_rounded,
          title: 'My\nFarm',
          color: const Color(0xFF6D4C41),
          bgLight: const Color(0xFFEFEBE9),
          screen: const _PlaceholderScreen(
              title: 'My Farm', icon: Icons.pets_rounded)),
      FeatureItem(
          icon: Icons.shopping_cart_rounded,
          title: 'Market\nPlace',
          color: const Color(0xFFFB8C00),
          bgLight: const Color(0xFFFFF3E0),
          screen: const _PlaceholderScreen(
              title: 'Market Place', icon: Icons.shopping_cart_rounded)),
      FeatureItem(
          icon: Icons.pregnant_woman_rounded,
          title: 'Gestation\nTracker',
          color: const Color(0xFFEC407A),
          bgLight: const Color(0xFFFCE4EC),
          screen: const _PlaceholderScreen(
              title: 'Gestation Tracker',
              icon: Icons.pregnant_woman_rounded)),
      FeatureItem(
          icon: Icons.cloud_rounded,
          title: 'Weather\nUpdates',
          color: const Color(0xFF039BE5),
          bgLight: const Color(0xFFE1F5FE),
          screen: const _PlaceholderScreen(
              title: 'Weather Updates', icon: Icons.cloud_rounded)),
      FeatureItem(
          icon: Icons.lightbulb_rounded,
          title: 'Decision\nSupport',
          color: const Color(0xFFFFA000),
          bgLight: const Color(0xFFFFF8E1),
          screen: const _PlaceholderScreen(
              title: 'Decision Support', icon: Icons.lightbulb_rounded)),
    ];

    final rowFeatures = [
      FeatureItem(
          icon: Icons.language_rounded,
          title: 'Visit our\nWebsite',
          color: const Color(0xFF5E35B1),
          bgLight: const Color(0xFFEDE7F6),
          screen: const _PlaceholderScreen(
              title: 'Visit Website', icon: Icons.language_rounded)),
      FeatureItem(
          icon: Icons.videocam_rounded,
          title: 'Video',
          color: const Color(0xFFD81B60),
          bgLight: const Color(0xFFFCE4EC),
          screen: const _PlaceholderScreen(
              title: 'Videos', icon: Icons.videocam_rounded)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemCount: gridFeatures.length,
            itemBuilder: (context, index) {
              return _FeatureCard(item: gridFeatures[index]);
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _FeatureCard(item: rowFeatures[0])),
              const SizedBox(width: 12),
              Expanded(child: _FeatureCard(item: rowFeatures[1])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvertiseBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Dismissible(
        key: const Key('ad_banner'),
        direction: DismissDirection.horizontal,
        onDismissed: (_) => _dismissAd(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
              left: 20, top: 14, bottom: 14, right: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20).withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: const Color(0xFF2E7D32).withOpacity(0.15)),
          ),
          child: Row(
            children: [
              const Icon(Icons.campaign_rounded,
                  color: Color(0xFF2E7D32), size: 22),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Advertise with Jaguza',
                    style: TextStyle(
                        color: Color(0xFF1B5E20),
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('Learn More',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _dismissAd,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.close_rounded,
                      color: Color(0xFF2E7D32), size: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownOverlay() {
    final overlayItems = [
      _OverlayItem(icon: Icons.search_rounded, title: 'Diagnose Diseases', subtitle: 'AI-powered disease detection'),
      _OverlayItem(icon: Icons.storefront_rounded, title: 'Sell Farm Products', subtitle: 'Reach buyers easily'),
      _OverlayItem(icon: Icons.pets_rounded, title: 'Learn Animal Diseases', subtitle: 'Comprehensive knowledge base'),
      _OverlayItem(icon: Icons.vaccines_rounded, title: 'Vaccination Schedule', subtitle: 'Never miss a vaccination'),
      _OverlayItem(icon: Icons.chat_rounded, title: 'Ask Jaguza AI', subtitle: 'Instant agricultural answers'),
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _closeOverlay,
            child: FadeTransition(
              opacity: _overlayFade,
              child: Container(color: Colors.black.withOpacity(0.25)),
            ),
          ),
        ),
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
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 12, 14),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Color(0xFFEEEEEE)))),
                      child: Row(
                        children: [
                          Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color(0xFF2E7D32),
                                    Color(0xFF66BB6A)
                                  ]),
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Icon(
                                  Icons.agriculture_rounded,
                                  color: Colors.white,
                                  size: 22)),
                          const SizedBox(width: 12),
                          const Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('What can Jaguza do?',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1B1B1B))),
                              SizedBox(height: 2),
                              Text('Explore our core features',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9E9E9E)))
                            ],
                          )),
                          GestureDetector(
                            onTap: _closeOverlay,
                            child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius:
                                        BorderRadius.circular(10)),
                                child: const Icon(Icons.close_rounded,
                                    color: Color(0xFF757575),
                                    size: 18)),
                          ),
                        ],
                      ),
                    ),
                    ...overlayItems
                        .map((item) => _buildOverlayItem(item)),
                    const SizedBox(height: 8),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20, 4, 20, 18),
                      child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: _closeOverlay,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF2E7D32),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14)),
                                  elevation: 0),
                              child: const Text('Get Started',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3)))),
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
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(item.icon,
                      color: const Color(0xFF2E7D32), size: 22)),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121))),
                  const SizedBox(height: 2),
                  Text(item.subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9E9E9E)))
                ],
              )),
              const Icon(Icons.chevron_right_rounded,
                  color: Color(0xFFBDBDBD), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}




//  SHARED WIDGETS


class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
                width: 32, height: 32,
                margin: const EdgeInsets.only(right: 8, top: 4),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xFFFF8F00),
                      Color(0xFFF57C00)
                    ]),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: Colors.white, size: 16)),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.of(context).size.width * 0.78),
                  decoration: BoxDecoration(
                    color: isUser
                        ? const Color(0xFF2E7D32)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black
                              .withOpacity(isUser ? 0.1 : 0.04),
                          blurRadius: isUser ? 10 : 6,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Text(message.text,
                      style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : const Color(0xFF333333),
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: isUser
                              ? FontWeight.w500
                              : FontWeight.w400)),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(message.time,
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey[400])),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            Container(
                width: 32, height: 32,
                margin: const EdgeInsets.only(left: 8, top: 4),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xFF2E7D32),
                      Color(0xFF43A047)
                    ]),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 16)),
          ],
        ],
      ),
    );
  }
}

class _FeedPostCard extends StatefulWidget {
  final FeedPost post;
  final int index;
  final AnimationController controller;
  const _FeedPostCard(
      {required this.post, required this.index, required this.controller});

  @override
  State<_FeedPostCard> createState() => _FeedPostCardState();
}

class _FeedPostCardState extends State<_FeedPostCard> {
  bool _isLiked = false;
  int _likeCount = 0;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likes;
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final startDelay = (widget.index * 0.07).clamp(0.0, 0.7);
    final slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: widget.controller,
            curve: Interval(startDelay,
                (startDelay + 0.4).clamp(0.0, 1.0),
                curve: Curves.easeOutCubic)));
    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.controller,
            curve: Interval(startDelay,
                (startDelay + 0.4).clamp(0.0, 1.0),
                curve: Curves.easeOut)));

    return SlideTransition(
      position: slideAnim,
      child: FadeTransition(
        opacity: fadeAnim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 5))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Row(
                  children: [
                    Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              post.authorColor,
                              post.authorColor.withOpacity(0.7)
                            ]),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: post.authorColor
                                      .withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3))
                            ]),
                        child: Center(
                            child: Text(post.authorInitials,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight.w800)))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(post.author,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1F36))),
                            if (post.isVerified) ...[
                              const SizedBox(width: 5),
                              const Icon(
                                  Icons.verified_rounded,
                                  color: Color(0xFF2E7D32),
                                  size: 15),
                            ],
                          ]),
                          const SizedBox(height: 2),
                          Row(children: [
                            Icon(Icons.location_on_rounded,
                                color: Colors.grey[400],
                                size: 12),
                            const SizedBox(width: 3),
                            Text(post.location,
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.grey[500])),
                            const SizedBox(width: 8),
                            Text('•',
                                style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 11)),
                            const SizedBox(width: 8),
                            Text(post.timeAgo,
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.grey[400])),
                          ]),
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: post.categoryColor
                                .withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(20)),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(post.categoryIcon,
                                  size: 13,
                                  color: post.categoryColor),
                              const SizedBox(width: 4),
                              Text(post.category,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: post.categoryColor)),
                            ])),
                  ],
                ),
              ),
              _buildPostImage(post),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  child: Text(post.title,
                      style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1F36),
                          height: 1.35))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  child: Text(post.excerpt,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.5),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis)),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: GestureDetector(
                      onTap: () {},
                      child: Text('Read more',
                          style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2E7D32),
                              decoration:
                                  TextDecoration.underline,
                              decorationColor: const Color(
                                      0xFF2E7D32)
                                  .withOpacity(0.4))))),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Divider(
                      color: Colors.grey[200], height: 1)),
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(8, 0, 12, 12),
                child: Row(
                  children: [
                    _actionBtn(
                        icon: _isLiked
                            ? Icons.favorite_rounded
                            : Icons
                                .favorite_border_rounded,
                        label: '$_likeCount',
                        color: _isLiked
                            ? const Color(0xFFE53935)
                            : Colors.grey.shade100,
                        onTap: () {
                          setState(() {
                            _isLiked = !_isLiked;
                            _likeCount +=
                                _isLiked ? 1 : -1;
                          });
                        }),
                    _actionBtn(
                        icon: Icons
                            .chat_bubble_outline_rounded,
                        label: '${post.comments}',
                        color: Colors.grey.shade100,
                        onTap: () {}),
                    const Spacer(),
                    _actionBtn(
                        icon: Icons.share_rounded,
                        label: 'Share',
                        color: Colors.grey.shade100,
                        onTap: () {}),
                    const SizedBox(width: 4),
                    GestureDetector(
                        onTap: () => setState(
                            () => _isBookmarked =
                                !_isBookmarked),
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                                _isBookmarked
                                    ? Icons.bookmark_rounded
                                    : Icons
                                        .bookmark_border_rounded,
                                color: _isBookmarked
                                    ? const Color(0xFFFFA000)
                                    : Colors.grey[400],
                                size: 20))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostImage(FeedPost post) {
    return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              post.imageGradientStart,
              post.imageGradientEnd
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Stack(
          children: [
            Positioned(
                right: -30, top: -30,
                child: Container(
                    width: 140, height: 140,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle))),
            Positioned(
                left: 20, bottom: -20,
                child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        shape: BoxShape.circle))),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 70, height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(22)),
                      child: Icon(post.categoryIcon,
                          color: Colors.white, size: 34)),
                  const SizedBox(height: 12),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt_rounded,
                                color: Colors.white
                                    .withOpacity(0.8),
                                size: 13),
                            const SizedBox(width: 5),
                            Text(
                                '${post.location}, ${post.dateTime}',
                                style: TextStyle(
                                    color: Colors.white
                                        .withOpacity(0.9),
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight.w500)),
                          ])),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _actionBtn(
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: color)),
            ])));
  }
}

class _TypingDot extends StatelessWidget {
  final int index;
  final AnimationController controller;
  const _TypingDot({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    final delay = (index * 0.2).clamp(0.0, 0.4);
    return AnimatedBuilder(
        index: index,
        controller: controller,
        child: Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
                color: Colors.grey[400], shape: BoxShape.circle)));
  }
}

class AnimatedBuilder extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final Widget child;
  const AnimatedBuilder(
      {required this.index, required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    final startDelay = (index * 0.06).clamp(0.0, 0.6);
    final slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: controller,
            curve: Interval(startDelay,
                (startDelay + 0.4).clamp(0.0, 1.0),
                curve: Curves.easeOutCubic)));
    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(startDelay,
                (startDelay + 0.4).clamp(0.0, 1.0),
                curve: Curves.easeOut)));
    return SlideTransition(
        position: slideAnim,
        child: FadeTransition(opacity: fadeAnim, child: child));
  }
}

class _FeatureCard extends StatefulWidget {
  final FeatureItem item;
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
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => widget.item.screen)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: _pressed
            ? (Matrix4.identity()..scale(0.94))
            : Matrix4.identity(),
        decoration: BoxDecoration(
            color: widget.item.bgLight.withOpacity(0.6),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: Colors.black
                      .withOpacity(_pressed ? 0.04 : 0.06),
                  blurRadius: _pressed ? 4 : 10,
                  offset: Offset(0, _pressed ? 1 : 4))
            ]),
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                    color: widget.item.bgLight,
                    borderRadius: BorderRadius.circular(14)),
                child: Icon(widget.item.icon,
                    color: widget.item.color, size: 24)),
            const SizedBox(height: 10),
            Text(widget.item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                    height: 1.35)),
          ],
        ),
      ),
    );
  }
}


//  DATA MODELS


class _OverlayItem {
  final IconData icon;
  final String title;
  final String subtitle;
  const _OverlayItem(
      {required this.icon, required this.title, required this.subtitle});
}

class FeatureItem {
  final IconData icon;
  final String title;
  final Color color;
  final Color bgLight;
  final Widget screen;
  const FeatureItem(
      {required this.icon,
      required this.title,
      required this.color,
      required this.bgLight,
      required this.screen});
}

class CategoryItem {
  final IconData icon;
  final String label;
  const CategoryItem({required this.icon, required this.label});
}

class FeedPost {
  final String author, location, dateTime, timeAgo, title, excerpt, category;
  final int likes, comments;
  final bool isVerified;
  final Color authorColor, categoryColor, imageGradientStart, imageGradientEnd;
  final IconData categoryIcon;
  String get authorInitials => author.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();
  const FeedPost({required this.author, required this.location, required this.dateTime, required this.timeAgo, required this.title, required this.excerpt, required this.category, required this.likes, required this.comments, this.isVerified = false, required this.authorColor, required this.categoryColor, required this.categoryIcon, required this.imageGradientStart, required this.imageGradientEnd});
}

class ChatMessage {
  final String text, time;
  final bool isUser;
  const ChatMessage({required this.text, required this.time, required this.isUser});
}

class _MenuItem {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final String? count;
  const _MenuItem({required this.icon, required this.title, required this.subtitle, required this.color, this.count});
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(title),
          centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 40, color: const Color(0xFF2E7D32))),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1F36)), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            const Text('Build your specific UI for this screen here.', style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}


//  SAMPLE DATA


const List<FeedPost> feedPosts = [
  FeedPost(author: 'Jaguza Official', location: 'Kampala', dateTime: 'Sep 8, 2023 · 1:19 PM', timeAgo: '2h ago', title: 'Benefits of Small Scale Poultry ~ Poultry Farming Guide', excerpt: 'Ever wondered whether small scale poultry farming is worth it? Here is a detailed breakdown of benefits, challenges, and tips to get started.', category: 'Poultry', likes: 24, comments: 5, isVerified: true, authorColor: Color(0xFF2E7D32), categoryColor: Color(0xFFE65100), categoryIcon: Icons.egg_rounded, imageGradientStart: Color(0xFFFF8F00), imageGradientEnd: Color(0xFFF57C00)),
  FeedPost(author: 'Dr. Atim Nancy', location: 'Jinja', dateTime: 'Sep 7, 2023 · 10:30 AM', timeAgo: '1d ago', title: 'Understanding Cattle Nutrition: A Complete Feeding Guide', excerpt: 'Proper nutrition is the backbone of a healthy herd. Learn about balanced feed rations, mineral supplements, and seasonal feeding strategies.', category: 'Cattle', likes: 38, comments: 12, isVerified: true, authorColor: Color(0xFF8E24AA), categoryColor: Color(0xFF1E88E5), categoryIcon: Icons.pets_rounded, imageGradientStart: Color(0xFF1565C0), imageGradientEnd: Color(0xFF42A5F5)),
  FeedPost(author: 'Mugisha David', location: 'Kabale', dateTime: 'Sep 6, 2023 · 4:45 PM', timeAgo: '2d ago', title: 'Modern Pig Farming Techniques for Ugandan Farmers', excerpt: 'Discover modern techniques in pig housing, feeding, disease prevention, and breeding that can significantly increase your farm output.', category: 'Pigs', likes: 15, comments: 3, authorColor: Color(0xFFFB8C00), categoryColor: Color(0xFFD84315), categoryIcon: Icons.set_meal_rounded, imageGradientStart: Color(0xFFD84315), imageGradientEnd: Color(0xFFFF7043)),
  FeedPost(author: 'Nabukenya Sarah', location: 'Wakiso', dateTime: 'Sep 5, 2023 · 9:00 AM', timeAgo: '3d ago', title: 'Dairy Farming Best Practices: From Milking to Market', excerpt: 'Learn the essential best practices for dairy farming including proper milking hygiene, milk storage, quality testing, and market strategies.', category: 'Cattle', likes: 42, comments: 8, isVerified: true, authorColor: Color(0xFF1E88E5), categoryColor: Color(0xFF1E88E5), categoryIcon: Icons.pets_rounded, imageGradientStart: Color(0xFF0D47A1), imageGradientEnd: Color(0xFF1976D2)),
  FeedPost(author: 'Okello James', location: 'Lira', dateTime: 'Sep 4, 2023 · 2:15 PM', timeAgo: '4d ago', title: 'Crop-Livestock Integration: Maximizing Your Farm Output', excerpt: 'How integrating crops and livestock can reduce costs, improve soil fertility, and create multiple income streams for smallholder farmers.', category: 'Crops', likes: 19, comments: 6, authorColor: Color(0xFF2E7D32), categoryColor: Color(0xFF2E7D32), categoryIcon: Icons.agriculture_rounded, imageGradientStart: Color(0xFF2E7D32), imageGradientEnd: Color(0xFF66BB6A)),
];