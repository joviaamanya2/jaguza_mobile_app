import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jaguza_app/services/api_service.dart';
import 'package:jaguza_app/screens/home_details/Decision%20support/decison_support.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease_info.dart';
import 'package:jaguza_app/screens/home_details/Gestation%20tracker/gestation_tracker.dart';
import 'package:jaguza_app/screens/home_details/My%20farm/my_farm.dart';
import 'package:jaguza_app/screens/home_details/Veterinary%20Doctors/veterinary_doctors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jaguza_app/screens/home_details/Videos%20screen/videos_screen.dart';
import 'package:jaguza_app/screens/home_details/weather%20updates/weather_updates.dart';
import '../screens/home_details/Explore Screen/explore_screen.dart';
import '../screens/home_details/AI chart/ai_chart_screen.dart';
import '../screens/home_details/Profile/profile_screen.dart';
import '../screens/home_details/Report Sickness/report_sickness.dart';
import '../screens/home_details/Disease Information/disease_diagnosis.dart';
import '../screens/home_details/Market place/market_place.dart';
import '../screens/home_details/Settings/settings_screen.dart';
import './home_details/advertisement.dart';

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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF133B24),
        canvasColor: const Color(0xFF133B24),
        cardColor: const Color(0xFF1E4E31),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF81C784),
          surface: const Color(0xFF1E4E31),
          background: const Color(0xFF133B24),
        ),
      ),
      home: const MainShell(),
    );
  }
}

// NAVIGATION SHELL

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = const [
    HomeTab(),
    ExploreScreen(),
    AIChatTab(),
    SettingsScreen(),
  ];

  void _switchTab(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNav(),
      drawer: _buildDrawer(),
    );
  }

  void _launchWebsite(String url) async {
    try {
      String fullUrl = url;
      if (!fullUrl.startsWith('http://') && !fullUrl.startsWith('https://')) {
        fullUrl = 'https://$fullUrl';
      }

      final Uri uri = Uri.parse(fullUrl);
      final bool canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open website. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header - Solid Green
          Container(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
            width: double.infinity,
            color: const Color(0xFF2E7D32), // Solid color, no gradient
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Icon(
                    Icons.agriculture_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jaguza',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Livestock Management',
                      style: TextStyle(
                        color: Color(0xFF81C784),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDrawerSection(
                    title: 'Farm Expenses',
                    icon: Icons.payments_outlined,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(color: Colors.grey, height: 1),
                  _buildDrawerItem(
                    icon: Icons.add_rounded,
                    title: 'Feed',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline_rounded,
                    title: '? Vetenary Help',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.medical_services_rounded,
                    title: 'Labour',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.people_outline_rounded,
                    title: 'Equipment and Housing',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(color: Colors.grey, height: 16),
                  _buildDrawerSection(
                    title: 'Account',
                    icon: Icons.account_circle_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileTab()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Manage Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileTab()),
                      );
                    },
                  ),
                  const Divider(color: Colors.grey, height: 16),
                  _buildDrawerSection(
                    title: 'Communicate',
                    icon: Icons.chat_outlined,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.lightbulb_outline_rounded,
                    title: 'Tips and Suggestions',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.share_outlined,
                    title: 'Share JAGUZA',
                    onTap: () {
                      Navigator.pop(context);
                      _showShareDialog(context);
                    },
                  ),
                  const Divider(color: Colors.grey, height: 16),
                  _buildDrawerSection(
                    title: 'Others',
                    icon: Icons.more_horiz_rounded,
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.handshake_outlined,
                    title: 'Our Partners/About',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.public_outlined,
                    title: 'Visit our Website',
                    onTap: () {
                      Navigator.pop(context);
                      _launchWebsite('https://jaguzalivestock.com');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About App',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.logout_outlined,
                    title: 'Logout',
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutDialog(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Version 2.0.0',
                      style: TextStyle(color: Colors.grey[400], fontSize: 11),
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

  Widget _buildDrawerSection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32), size: 18),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1A1F36),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700], size: 20),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1A1F36),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Color(0xFF2E7D32),
        size: 18,
      ),
      onTap: onTap,
      dense: true,
      hoverColor: const Color(0xFF2E7D32).withOpacity(0.05),
      splashColor: const Color(0xFF2E7D32).withOpacity(0.1),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Color(0xFF1A1F36),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Share JAGUZA',
          style: TextStyle(
            color: Color(0xFF1A1F36),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Share the Jaguza app with your fellow farmers!',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      _NavData(Icons.home_outlined, Icons.home_rounded, 'Home'),
      _NavData(Icons.explore_outlined, Icons.explore_rounded, 'Explore'),
      _NavData(
        Icons.chat_bubble_outline_rounded,
        Icons.chat_bubble_rounded,
        'AI Chat',
      ),
      _NavData(Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
    ];

    return Container(
      color: Colors.white,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFF1A1F36).withOpacity(0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        active ? item.activeIcon : item.icon,
                        color: active
                            ? const Color(0xFF1A1F36)
                            : const Color(0xFF9E9E9E),
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
                              ? const Color(0xFF1A1F36)
                              : const Color(0xFF9E9E9E),
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

// HomeTab
// HomeTab - Clean version with plain color cards, no icons, no farm registration
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _showAd = true;

  void _dismissAd() => setState(() => _showAd = false);

  void _goToAIChat() {
    final shell = context.findAncestorStateOfType<_MainShellState>();
    shell?.setState(() => shell._currentIndex = 2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: const Color(0xFF2E7D32),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              final shell = context.findAncestorStateOfType<_MainShellState>();
              shell?._scaffoldKey.currentState?.openDrawer();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Jaguza',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
          ),
          _iconCircle(
            icon: Icons.person_outline_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileTab()),
            ),
            color: const Color(0xFF2E7D32),
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

  Widget _buildGreetingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, Farmer',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage your livestock with confidence.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIQuestionBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        color: const Color(0xFFF57C00),
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
                    color: const Color(0xFFBF360C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.question_answer_rounded,
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
              'Get livestock guidance, health insight, and farm decisions powered by AI.',
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 13,
                height: 1.4,
              ),
            ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Ask Jaguza AI',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      FeatureItem(
        title: 'Report\nSickness',
        color: const Color(0xFF66BB6A),
        screen: const ReportSicknessScreen(),
      ),
      FeatureItem(
        title: 'Diagnosis',
        color: const Color(0xFF90A4AE),
        screen: const DiagnosisScreen(),
      ),
      FeatureItem(
        title: 'Veterinary\nDoctors',
        color: const Color(0xFF66BB6A),
        screen: const VeterinaryDoctorsScreen(),
      ),
      FeatureItem(
        title: 'Disease\nInformation',
        color: const Color(0xFF90A4AE),
        screen: const AnimalDiseasesScreen(),
      ),
      FeatureItem(
        title: 'My\nFarm',
        color: const Color(0xFF66BB6A),
        screen: const MyFarmScreen(),
      ),
      FeatureItem(
        title: 'Market\nPlace',
        color: const Color(0xFF90A4AE),
        screen: const MarketplaceScreen(),
      ),
      FeatureItem(
        title: 'Gestation\nTracker',
        color: const Color(0xFF66BB6A),
        screen: const GestationTrackerScreen(),
      ),
      FeatureItem(
        title: 'Weather\nUpdates',
        color: const Color(0xFF81D4FA),
        screen: const WeatherUpdatesScreen(),
      ),
      FeatureItem(
        title: 'Decision\nSupport',
        color: const Color(0xFF66BB6A),
        screen: const DecisionSupportScreen(),
      ),
    ];

    final rowFeatures = [
      FeatureItem(
        title: 'Visit our\nWebsite',
        color: const Color(0xFF4DD0E1),
        isWebsite: true,
        url: 'https://jaguzafarm.com/',
      ),
      FeatureItem(
        title: 'Video',
        color: const Color(0xFF90A4AE),
        screen: const VideoScreen(),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          GridView.builder(
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
              return _FeatureCard(item: features[index]);
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
            left: 20,
            top: 14,
            bottom: 14,
            right: 8,
          ),
          color: const Color(0xFF2E7D32).withOpacity(0.08),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAdvertScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Learn More',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
                  child: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF2E7D32),
                    size: 16,
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

// SHARED WIDGETS

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
      onTap: () {
        if (widget.item.isWebsite && widget.item.url != null) {
          _launchWebsite(context, widget.item.url!);
        } else if (widget.item.screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.item.screen!),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: _pressed
            ? (Matrix4.identity()..scale(0.94))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.item.color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // No icon, just plain color card
            const SizedBox(height: 4),
            Text(
              widget.item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchWebsite(BuildContext context, String url) async {
    try {
      String fullUrl = url;
      if (!fullUrl.startsWith('http://') && !fullUrl.startsWith('https://')) {
        fullUrl = 'https://$fullUrl';
      }

      final Uri uri = Uri.parse(fullUrl);
      final bool canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open website. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Updated FeatureItem - removed icon property
class FeatureItem {
  final String title;
  final Color color;
  final Widget? screen;
  final bool isWebsite;
  final String? url;

  const FeatureItem({
    required this.title,
    required this.color,
    this.screen,
    this.isWebsite = false,
    this.url,
  });
}