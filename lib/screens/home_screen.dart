import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jaguza_app/screens/qr_scanner_screen.dart';
import 'package:jaguza_app/screens/home_details/Decision%20support/decison_support.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease_info.dart';
import 'package:jaguza_app/screens/home_details/Gestation%20tracker/gestation_tracker.dart';
import 'package:jaguza_app/farm_premium/farm_premium_app.dart';
import 'package:jaguza_app/screens/home_details/Veterinary%20Doctors/veterinary_doctors.dart';
import 'package:jaguza_app/screens/home_details/Videos%20screen/videos_screen.dart';
import 'package:jaguza_app/screens/home_details/weather%20updates/weather_updates.dart';
import '../screens/home_details/Explore Screen/explore_screen.dart';
import '../screens/home_details/AI chart/ai_chart_screen.dart';
import '../screens/home_details/Report Sickness/report_sickness.dart';
import '../screens/home_details/Disease Information/disease_diagnosis.dart';
import '../screens/home_details/Market place/market_place.dart';
import './home_details/advertisement.dart';
import './home_details/jaguza_updates_screen.dart';
import '../services/app_localizations.dart';

// NAVIGATION SHELL

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeTab(),
    );
  }
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
  int _tabIndex = 0;
  final List<int> _tabHistory = [];

  void _dismissAd() => setState(() => _showAd = false);

  void _selectTab(int index) {
    if (index == _tabIndex) return;
    setState(() {
      _tabHistory.add(_tabIndex);
      _tabIndex = index;
    });
  }

  /// Handles the Android system back button: step back through the tab
  /// history before letting the app close.
  void _handleBack(bool didPop, Object? result) {
    if (didPop) return;
    if (_tabHistory.isNotEmpty) {
      setState(() => _tabIndex = _tabHistory.removeLast());
    } else if (_tabIndex != 0) {
      setState(() => _tabIndex = 0);
    }
  }

  String get _headerTitle {
    switch (_tabIndex) {
      case 1:
        return context.tr('User Posts');
      case 2:
        return context.tr('Doctors');
      case 3:
        return context.tr('Diseases');
      default:
        return 'Jaguza Livestock';
    }
  }

  void _goToAIChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AIChatTab()),
    );
  }

  void _openQrScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _tabIndex == 0 && _tabHistory.isEmpty,
      onPopInvokedWithResult: _handleBack,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: IndexedStack(
                index: _tabIndex,
                children: [
                  _buildHomeContent(),
                  const ExploreScreen(),
                  const VeterinaryDoctorsScreen(),
                  const AnimalDiseasesScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildAIQuestionBox(),
          const SizedBox(height: 18),
          _buildFeatureGrid(),
          if (_showAd) ...[const SizedBox(height: 16), _buildAdvertiseBanner()],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final scheme = Theme.of(context).colorScheme;
    final topInset = MediaQuery.of(context).padding.top;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Green backdrop behind the app bar and the top of the info card.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: topInset + 120,
          child: Container(
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(22),
              ),
            ),
          ),
        ),
        // Foreground content (also sizes the Stack).
        Padding(
          padding: EdgeInsets.only(top: topInset + 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [

                    SizedBox(width: 10,),

                    Image.asset(
                      'assets/icon/jaguza-app-icon-low.png',
                      width: 42,
                      height: 42,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _headerTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text("Uganda",style: TextStyle(fontSize: 11,color: Colors.white),)
                      ],
                    ),
                    const Spacer(),

                    _iconCircle(
                      icon: Icons.qr_code_scanner_rounded,
                      onTap: _openQrScanner,
                    ),
                    SizedBox(width: 5,),
                    _bell(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _infoCard(),
              ),
              const SizedBox(height: 2),
              _iconTabRow(),
              Divider(
                height: 1,
                thickness: 1,
                color: scheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
        // Notification bell straddling the seam between the header and the card.

      ],
    );
  }

  Widget _infoCard() {
    final scheme = Theme.of(context).colorScheme;
    final lines = [
      context.tr('Use Jaguza to Diagnose diseases, Track animals'),
      context.tr('Sell your agricultural products in Market'),
      context.tr('Know more about animal Diseases'),
      context.tr('Track your Expenses and Milk production'),
      context.tr('Contact Veterinary Doctors'),
      context.tr('Track Animal Gestation and so much more…'),
    ];
    return Card(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.5),
                child: Text(
                  '*  $line',
                  style: TextStyle(
                    color: scheme.primary,
                    fontSize: 11.5,
                    height: 1.15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _bell() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const JaguzaUpdatesScreen()),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            child: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconTabRow() {
    final scheme = Theme.of(context).colorScheme;

    Widget tab({
      IconData? material,
      String? asset,
      required bool active,
      VoidCallback? onTap,
      double size = 24,
    }) {
      final color = active
          ? scheme.primary
          : scheme.onSurfaceVariant.withValues(alpha: 0.55);
      return Expanded(
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              const SizedBox(height: 9),
              SizedBox(
                height: 26,
                child: asset != null
                    ? Image.asset(
                        asset,
                        width: size,
                        height: size,
                        color: color,
                        colorBlendMode: BlendMode.srcIn,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.pets_rounded, size: size, color: color),
                      )
                    : Icon(material, size: size, color: color),
              ),
              const SizedBox(height: 8),
              Container(
                height: 3,
                color: active ? scheme.primary : Colors.transparent,
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        tab(
          material: Icons.apps_rounded,
          active: _tabIndex == 0,
          size: 25,
          onTap: () => _selectTab(0),
        ),
        tab(
          asset: 'lib/assets/images/home icons/cow.png',
          active: _tabIndex == 1,
          size: 24,
          onTap: () => _selectTab(1),
        ),
        tab(
          asset: 'lib/assets/images/home icons/doctor.png',
          active: _tabIndex == 2,
          size: 24,
          onTap: () => _selectTab(2),
        ),
        tab(
          asset: 'lib/assets/images/home icons/disease.png',
          active: _tabIndex == 3,
          size: 24,
          onTap: () => _selectTab(3),
        ),
      ],
    );
  }

  Widget _iconCircle({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildAIQuestionBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        // Deliberate orange accent for the AI box, distinct from the green
        // design system — kept as a literal color.
        decoration: BoxDecoration(
          color: const Color(0xFFD97C2B),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.fromLTRB(18, 18, 12, 18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('Is there anything that you would like to know in the field of Agriculture?'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _goToAIChat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1B5E20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      context.tr('Ask Jaguza AI?'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 90, height: 90,
              child: Image.asset(
                'assets/icon/SmilingWomanWithGreenLaptop-Low.png',
                width: 112,
                height: 112,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    const green = Color(0xFF66BB6A);
    const grey = Color(0xFF90A4AE);
    const brown = Color(0xFFCE8548);

    final features = [
      FeatureItem(
        title: context.tr('Report sickness'),
        icon: FontAwesomeIcons.bug,
        color: green,
        screen: const ReportSicknessScreen(),
      ),
      FeatureItem(
        title: context.tr('Diagnosis'),
        icon: FontAwesomeIcons.stethoscope,
        color: grey,
        screen: const DiagnosisScreen(),
      ),
      FeatureItem(
        title: context.tr('Veterinary Doctors'),
        icon: FontAwesomeIcons.userNurse,
        color: grey,
        tabIndex: 2,
      ),
      FeatureItem(
        title: context.tr('Disease Information'),
        icon: FontAwesomeIcons.circleNodes,
        color: green,
        tabIndex: 3,
      ),
      FeatureItem(
        title: context.tr('Gestation tracker'),
        icon: FontAwesomeIcons.cow,
        color: green,
        screen: const GestationTrackerScreen(),
      ),
      FeatureItem(
        title: context.tr('Market'),
        icon: FontAwesomeIcons.cartShopping,
        color: grey,
        screen: const MarketplaceScreen(),
      ),
      FeatureItem(
        title: context.tr('Weather updates'),
        icon: FontAwesomeIcons.sun,
        color: grey,
        screen: const WeatherUpdatesScreen(),
      ),
      FeatureItem(
        title: context.tr('Decision Support'),
        icon: FontAwesomeIcons.circleQuestion,
        color: green,
        screen: const DecisionSupportScreen(),
      ),
      FeatureItem(
        title: context.tr('Visit our Website'),
        icon: FontAwesomeIcons.globe,
        color: green,
        isWebsite: true,
        url: 'https://jaguzalivestock.com',
      ),
      FeatureItem(
        title: context.tr('My farm'),
        icon: FontAwesomeIcons.cow,
        color: brown,
        screen: const FarmPremiumApp(),
      ),
      FeatureItem(
        title: context.tr('Videos'),
        icon: FontAwesomeIcons.film,
        color: green,
        screen: const VideoScreen(),
      ),
    ];

    final grid = features.take(8).toList();
    final lastRow = features.skip(8).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.7,
            ),
            itemCount: grid.length,
            itemBuilder: (context, index) => _FeatureCard(item: grid[index]),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemCount: lastRow.length,
            itemBuilder: (context, index) =>
                _FeatureCard(item: lastRow[index], compact: true),
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
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAdvertScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.campaign_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.tr('Advertise with Jaguza'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
                    color: const Color(0xFFF57C00).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFFF57C00),
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
  final bool compact;
  const _FeatureCard({required this.item, this.compact = false});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.item.color;
    // Darker shade for the top half that holds the icon.
    final topColor = Color.lerp(baseColor, Colors.black, 0.42)!;
    final compact = widget.compact;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        if (widget.item.isWebsite && widget.item.url != null) {
          _launchWebsite(context, widget.item.url!);
        } else if (widget.item.tabIndex != null) {
          context.findAncestorStateOfType<_HomeTabState>()?._selectTab(
            widget.item.tabIndex!,
          );
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
            ? (Matrix4.identity()..scale(0.95))
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            children: [
              // Top half: dark band with the icon.
              Expanded(
                flex: 42,
                child: Container(
                  width: double.infinity,
                  color: topColor,
                  alignment: Alignment.center,
                  child: FaIcon(
                    widget.item.icon,
                    color: Colors.white,
                    size: compact ? 20 : 24,
                  ),
                ),
              ),
              // Bottom half: coloured band with the label.
              Expanded(
                flex: 58,
                child: Container(
                  width: double.infinity,
                  color: baseColor,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    widget.item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: compact ? 11 : 12.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.2,
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
              content: Text(context.tr('Could not open website. Please try again.')),
              backgroundColor: errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.tr('Error')}: ${e.toString()}'),
            backgroundColor: errorColor,
          ),
        );
      }
    }
  }
}

class FeatureItem {
  final String title;
  final FaIconData icon;
  final Color color;
  final Widget? screen;
  final bool isWebsite;
  final String? url;
  final int? tabIndex;

  const FeatureItem({
    required this.title,
    required this.icon,
    required this.color,
    this.screen,
    this.isWebsite = false,
    this.url,
    this.tabIndex,
  });
}
