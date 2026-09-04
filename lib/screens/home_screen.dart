import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
      key: _scaffoldKey,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNav(),
      drawer: _buildDrawer(),
    );
  }

  void _launchWebsite(String url) async {
    final errorColor = Theme.of(context).colorScheme.error;
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
            SnackBar(
              content: const Text('Could not open website. Please try again.'),
              backgroundColor: errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: errorColor,
          ),
        );
      }
    }
  }

  Widget _buildDrawer() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Drawer(
      backgroundColor: theme.cardColor,
      child: Column(
        children: [
          // Drawer Header - Solid Green
          Container(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
            width: double.infinity,
            color: scheme.primary, // Solid color, no gradient
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
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
                  Divider(color: Theme.of(context).colorScheme.outlineVariant, height: 1),
                  _buildDrawerItem(
                    icon: Icons.add_rounded,
                    title: 'Feed',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Veterinary Help',
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
                  Divider(color: Theme.of(context).colorScheme.outlineVariant, height: 16),
                  _buildDrawerSection(
                    title: 'Account',
                    icon: Icons.account_circle_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProfileTab()),
                      );
                    },
                  ),
                  Divider(color: Theme.of(context).colorScheme.outlineVariant, height: 16),
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
                  Divider(color: Theme.of(context).colorScheme.outlineVariant, height: 16),
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
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11),
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
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary, size: 18),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: scheme.onSurface,
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
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: scheme.onSurfaceVariant, size: 20),
      title: Text(
        title,
        style: TextStyle(
          color: scheme.onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: scheme.primary,
        size: 18,
      ),
      onTap: onTap,
      dense: true,
      hoverColor: scheme.primary.withValues(alpha: 0.05),
      splashColor: scheme.primary.withValues(alpha: 0.1),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Logout',
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: scheme.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: scheme.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Share JAGUZA',
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Share the Jaguza app with your fellow farmers!',
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: scheme.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
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

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      color: theme.cardColor,
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
                        ? scheme.onSurface.withValues(alpha: 0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        active ? item.activeIcon : item.icon,
                        color: active
                            ? scheme.onSurface
                            : scheme.onSurfaceVariant,
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
                              ? scheme.onSurface
                              : scheme.onSurfaceVariant,
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
            const SizedBox(height: 18),
            _buildGreetingSection(),
            const SizedBox(height: 18),
            _buildHealthAlertBanner(),
            const SizedBox(height: 18),
            _buildAIQuestionBox(),
            const SizedBox(height: 24),
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
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
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
                color: Colors.white.withValues(alpha: 0.1),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jaguza', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                SizedBox(height: 2),
                Text('Your farm, growing stronger', style: TextStyle(color: Color(0xFFD6F3E2), fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          _iconCircle(
            icon: Icons.person_outline_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileTab()),
            ),
            color: scheme.primary,
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
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning, Farmer 👋',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: scheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'What would you like to do today?',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthAlertBanner() {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportSicknessScreen())),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7EF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFBFE6CC)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.health_and_safety_rounded, color: Colors.white, size: 25),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Is an animal unwell?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF174D32))),
                    SizedBox(height: 4),
                    Text('Report symptoms and get help quickly', style: TextStyle(fontSize: 12, color: Color(0xFF47745B))),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 15, color: scheme.primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIQuestionBox() {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        // Deliberate orange accent for the AI box, distinct from the green
        // design system — kept as a literal color.
        decoration: BoxDecoration(
          color: const Color(0xFFF57C00),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: const Color(0xFFF57C00).withValues(alpha: 0.22), blurRadius: 14, offset: const Offset(0, 6))],
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
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12)),
                  child: Icon(
                    Icons.question_answer_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
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
                  backgroundColor: Theme.of(context).cardColor,
                  foregroundColor: const Color(0xFFE65100),
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
        icon: Icons.assignment_late_outlined,
        color: const Color(0xFF66BB6A),
        screen: const ReportSicknessScreen(),
      ),
      FeatureItem(
        title: 'Diagnosis',
        icon: Icons.biotech_outlined,
        color: const Color(0xFF90A4AE),
        screen: const DiagnosisScreen(),
      ),
      FeatureItem(
        title: 'Veterinary\nDoctors',
        icon: Icons.medical_services_outlined,
        color: const Color(0xFF66BB6A),
        screen: const VeterinaryDoctorsScreen(),
      ),
      FeatureItem(
        title: 'Disease\nInformation',
        icon: Icons.menu_book_outlined,
        color: const Color(0xFF90A4AE),
        screen: const AnimalDiseasesScreen(),
      ),
      FeatureItem(
        title: 'My\nFarm',
        icon: Icons.agriculture_outlined,
        color: const Color(0xFF66BB6A),
        screen: const MyFarmScreen(),
      ),
      FeatureItem(
        title: 'Market\nPlace',
        icon: Icons.storefront_outlined,
        color: const Color(0xFF90A4AE),
        screen: const MarketplaceScreen(),
      ),
      FeatureItem(
        title: 'Gestation\nTracker',
        icon: Icons.monitor_heart_outlined,
        color: const Color(0xFF66BB6A),
        screen: const GestationTrackerScreen(),
      ),
      FeatureItem(
        title: 'Weather\nUpdates',
        icon: Icons.wb_sunny_outlined,
        color: const Color(0xFF81D4FA),
        screen: const WeatherUpdatesScreen(),
      ),
      FeatureItem(
        title: 'Decision\nSupport',
        icon: Icons.lightbulb_outline_rounded,
        color: const Color(0xFF66BB6A),
        screen: const DecisionSupportScreen(),
      ),
      FeatureItem(
        title: 'Video',
        icon: Icons.play_circle_outline_rounded,
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
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return _FeatureCard(item: features[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdvertiseBanner() {
    final scheme = Theme.of(context).colorScheme;
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
          color: scheme.primary.withValues(alpha: 0.08),
          child: Row(
            children: [
              Icon(
                Icons.campaign_rounded,
                color: scheme.primary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Advertise with Jaguza',
                  style: TextStyle(
                    color: scheme.primary,
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
                  color: scheme.primary,
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
                  child: Text(
                    'Learn More',
                    style: TextStyle(
                      color: scheme.onPrimary,
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
                    color: scheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: scheme.primary,
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
    final scheme = Theme.of(context).colorScheme;
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
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.item.icon, color: scheme.primary, size: 25),
            ),
            const SizedBox(height: 7),
            Text(
              widget.item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchWebsite(BuildContext context, String url) async {
    final errorColor = Theme.of(context).colorScheme.error;
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
            SnackBar(
              content: const Text('Could not open website. Please try again.'),
              backgroundColor: errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: errorColor,
          ),
        );
      }
    }
  }
}

class FeatureItem {
  final String title;
  final IconData icon;
  final Color color;
  final Widget? screen;
  final bool isWebsite;
  final String? url;

  const FeatureItem({
    required this.title,
    this.icon = Icons.apps_rounded,
    required this.color,
    this.screen,
    this.isWebsite = false,
    this.url,
  });
}
