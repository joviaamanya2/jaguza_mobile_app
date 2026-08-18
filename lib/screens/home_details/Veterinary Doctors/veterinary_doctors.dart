import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jaguza_app/screens/home_details/Profile/profile_screen.dart';
import 'package:jaguza_app/screens/home_screen.dart';
import '../My farm/my_farm.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const VetDoctorsApp());
}

class VetDoctorsApp extends StatelessWidget {
  const VetDoctorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jaguza - Veterinary Doctors',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        primaryColor: const Color(0xFF2E7D32),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF2E7D32),
          secondary: Color(0xFF2E7D32),
        ),
        fontFamily: 'Inter',
      ),
      home: const VeterinaryDoctorsScreen(),
    );
  }
}

class VeterinaryDoctorsScreen extends StatefulWidget {
  const VeterinaryDoctorsScreen({super.key});

  @override
  State<VeterinaryDoctorsScreen> createState() => _VeterinaryDoctorsScreenState();
}

class _VeterinaryDoctorsScreenState extends State<VeterinaryDoctorsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _showFilterSheet = false;
  int _selectedNavIndex = 2; // Default to Doctors tab

  final List<String> _filters = ['All', 'Nearby', 'Top Rated', 'Available Now'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<VetDoctor> get _filteredDoctors {
    final query = _searchQuery.toLowerCase();
    return vetDoctors.where((doc) {
      final matchesSearch = doc.name.toLowerCase().contains(query) ||
          doc.location.toLowerCase().contains(query) ||
          doc.specialty.toLowerCase().contains(query);
      final matchesFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Nearby' && doc.isNearby) ||
          (_selectedFilter == 'Top Rated' && doc.rating >= 4.5) ||
          (_selectedFilter == 'Available Now' && doc.isAvailableNow);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  List<ExtensionWorker> get _filteredWorkers {
    final query = _searchQuery.toLowerCase();
    return extensionWorkers.where((w) {
      final matchesSearch = w.name.toLowerCase().contains(query) ||
          w.location.toLowerCase().contains(query) ||
          w.specialty.toLowerCase().contains(query);
      final matchesFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Nearby' && w.isNearby) ||
          (_selectedFilter == 'Top Rated' && w.rating >= 4.5) ||
          (_selectedFilter == 'Available Now' && w.isAvailableNow);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildFilterChips(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDoctorsList(),
                _buildWorkersList(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF2E7D32),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        children: [
          Row(
            children: [
              _headerIcon(Icons.arrow_back_rounded, onTap: () => Navigator.pop(context)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find Experts',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                       Text(
                      'Veterinary Doctors',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _headerIcon(Icons.filter_list_rounded, onTap: () {
                setState(() => _showFilterSheet = !_showFilterSheet);
                _showFilterBottomSheet(context);
              }),
              const SizedBox(width: 8),
              _headerIcon(Icons.tune_rounded, onTap: () {
                _showSortBottomSheet(context);
              }),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statChip(Icons.verified_rounded, '24 Verified'),
              const SizedBox(width: 8),
              _statChip(Icons.star_rounded, '4.6 Avg'),
              const SizedBox(width: 8),
              _statChip(Icons.location_on_rounded, '12 Nearby'),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.filter_list_rounded, color: Color(0xFF2E7D32), size: 20),
                const SizedBox(width: 10),
                const Text('Filter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._filters.map((filter) => _filterOption(filter, _selectedFilter == filter, () {
              setState(() => _selectedFilter = filter);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Filter: $filter'),
                  backgroundColor: const Color(0xFF2E7D32),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            })),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _filterOption(String title, bool isActive, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isActive ? const Color(0xFF2E7D32) : Colors.grey[400]!),
                  color: isActive ? const Color(0xFF2E7D32) : Colors.transparent,
                ),
                child: isActive ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null,
              ),
              const SizedBox(width: 14),
              Text(title, style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? const Color(0xFF2E7D32) : const Color(0xFF1A1F36),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune_rounded, color: Color(0xFF2E7D32), size: 20),
                const SizedBox(width: 10),
                const Text('Sort & Filter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _sortOption(Icons.star_rounded, 'Highest Rated', 'Sort by best reviews', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sorted by: Highest Rated'),
                  backgroundColor: Color(0xFF2E7D32),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            }),
            _sortOption(Icons.location_on_rounded, 'Nearest First', 'Sort by distance', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sorted by: Nearest First'),
                  backgroundColor: Color(0xFF2E7D32),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            }),
            _sortOption(Icons.schedule_rounded, 'Available Now', 'Show only available', () {
              Navigator.pop(context);
              setState(() => _selectedFilter = 'Available Now');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter: Available Now'),
                  backgroundColor: Color(0xFF2E7D32),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            }),
            _sortOption(Icons.verified_rounded, 'Verified Only', 'Show only verified experts', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter: Verified Only'),
                  backgroundColor: Color(0xFF2E7D32),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sortOption(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[500], size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36))),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerIcon(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _statChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search by name, location, or specialty...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2E7D32), size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: Icon(Icons.close_rounded, color: Colors.grey[400], size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          ),
        ),
      ),
    );
  }

  // Removed _buildQuickActions() method entirely

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isActive = _selectedFilter == filter;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF2E7D32) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive ? const Color(0xFF2E7D32) : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey[600],
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
          ],
        ),
        indicatorPadding: const EdgeInsets.all(3),
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFF1B5E20),
        unselectedLabelColor: Colors.grey[500],
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: '  Veterinary Doctors  '),
          Tab(text: '  Extension Workers  '),
        ],
      ),
    );
  }

  Widget _buildDoctorsList() {
    final doctors = _filteredDoctors;
    if (doctors.isEmpty) {
      return _emptyState('No doctors found', 'Try adjusting your search or filters');
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: doctors.length,
      itemBuilder: (context, index) => _DoctorCard(doctor: doctors[index]),
    );
  }

  Widget _buildWorkersList() {
    final workers = _filteredWorkers;
    if (workers.isEmpty) {
      return _emptyState('No workers found', 'Try adjusting your search');
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: workers.length,
      itemBuilder: (context, index) => _WorkerCard(worker: workers[index]),
    );
  }

  Widget _emptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36))),
            const SizedBox(height: 6),
            Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, 'Home', _selectedNavIndex == 0, () {
                setState(() => _selectedNavIndex = 0);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainShell()),
                  (route) => false,
                );
              }),
              _navItem(Icons.pets_rounded, 'My Farm', _selectedNavIndex == 1, () {
                setState(() => _selectedNavIndex = 1);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyFarmScreen()),
                ).then((_) {
                  setState(() => _selectedNavIndex = 2);
                });
              }),
              _navItem(Icons.medical_services_rounded, 'Doctors', _selectedNavIndex == 2, () {
                setState(() => _selectedNavIndex = 2);
                // Already on this screen
              }),
              _navItem(Icons.person_rounded, 'Profile', _selectedNavIndex == 3, () {
                setState(() => _selectedNavIndex = 3);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreenWrapper()),
                ).then((_) {
                  setState(() => _selectedNavIndex = 2);
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active, VoidCallback onTap) {
    final color = active ? const Color(0xFF2E7D32) : const Color(0xFF9E9E9E);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: active
                ? BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), borderRadius: BorderRadius.circular(10))
                : null,
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w600 : FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  DATA MODELS (unchanged)
// ═══════════════════════════════════════════════════════════════

class VetDoctor {
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final bool isVerified;
  final bool isNearby;
  final bool isAvailableNow;
  final String bio;
  final String availability;
  final String consultFee;
  final Color avatarColor;
  final Color tagColor;
  final String initials;
  final String phone;
  final double latitude;
  final double longitude;

  VetDoctor({
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.isVerified,
    required this.isNearby,
    this.isAvailableNow = true,
    required this.bio,
    required this.availability,
    required this.consultFee,
    required this.avatarColor,
    required this.tagColor,
    required this.initials,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });
}

class ExtensionWorker {
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final bool isVerified;
  final bool isNearby;
  final bool isAvailableNow;
  final String bio;
  final String availability;
  final String serviceArea;
  final String languages;
  final Color avatarColor;
  final Color tagColor;
  final String initials;
  final String phone;
  final double latitude;
  final double longitude;

  ExtensionWorker({
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.isVerified,
    required this.isNearby,
    this.isAvailableNow = true,
    required this.bio,
    required this.availability,
    required this.serviceArea,
    required this.languages,
    required this.avatarColor,
    required this.tagColor,
    required this.initials,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });
}

final List<VetDoctor> vetDoctors = [
  VetDoctor(
    name: 'Dr. James Okello',
    specialty: 'Large Animal Surgery',
    location: 'Kampala, Makerere Hill Road',
    rating: 4.8,
    isVerified: true,
    isNearby: true,
    isAvailableNow: true,
    bio: 'Experienced veterinary surgeon with 15+ years in large animal surgery. Specializes in cattle, goats, and sheep surgical procedures. Graduate of Makerere University.',
    availability: 'Mon-Fri: 8AM-5PM',
    consultFee: 'UGX 50,000',
    avatarColor: const Color(0xFF1565C0),
    tagColor: const Color(0xFF1565C0),
    initials: 'JO',
    phone: '+256772123456',
    latitude: 0.3380,
    longitude: 32.5700,
  ),
  VetDoctor(
    name: 'Dr. Sarah Namukwaya',
    specialty: 'Preventive Medicine',
    location: 'Entebbe, Port Bell Road',
    rating: 4.9,
    isVerified: true,
    isNearby: true,
    isAvailableNow: true,
    bio: 'Specialist in preventive veterinary medicine and vaccination programs. Leads community animal health initiatives across Central Uganda.',
    availability: 'Mon-Sat: 9AM-6PM',
    consultFee: 'UGX 40,000',
    avatarColor: const Color(0xFF2E7D32),
    tagColor: const Color(0xFF2E7D32),
    initials: 'SN',
    phone: '+256773234567',
    latitude: 0.0580,
    longitude: 32.4620,
  ),
  VetDoctor(
    name: 'Dr. Robert Mugisha',
    specialty: 'Poultry Health & Surgery',
    location: 'Jinja, Main Street',
    rating: 4.6,
    isVerified: true,
    isNearby: false,
    isAvailableNow: false,
    bio: 'Poultry health specialist with extensive experience in broiler and layer management. Provides surgical and medical care for poultry farms.',
    availability: 'Mon-Fri: 7AM-4PM',
    consultFee: 'UGX 35,000',
    avatarColor: const Color(0xFFE65100),
    tagColor: const Color(0xFFE65100),
    initials: 'RM',
    phone: '+256774345678',
    latitude: 0.4281,
    longitude: 33.2065,
  ),
  VetDoctor(
    name: 'Dr. Grace Akello',
    specialty: 'Ruminant Nutrition',
    location: 'Mbarara, Mbarara Town',
    rating: 4.7,
    isVerified: true,
    isNearby: false,
    isAvailableNow: true,
    bio: 'Expert in ruminant nutrition and herd health management. Works with dairy and beef cattle farmers in western Uganda.',
    availability: 'Mon-Fri: 8AM-5PM',
    consultFee: 'UGX 45,000',
    avatarColor: const Color(0xFF6A1B9A),
    tagColor: const Color(0xFF6A1B9A),
    initials: 'GA',
    phone: '+256775456789',
    latitude: -0.6087,
    longitude: 30.6531,
  ),
  VetDoctor(
    name: 'Dr. Peter Ochieng',
    specialty: 'Swine Health & Surgery',
    location: 'Gulu, Gulu Town',
    rating: 4.5,
    isVerified: true,
    isNearby: false,
    isAvailableNow: false,
    bio: 'Veterinary surgeon specializing in swine health, biosecurity, and herd management. Serves northern Uganda.',
    availability: 'Tue-Sat: 8AM-5PM',
    consultFee: 'UGX 40,000',
    avatarColor: const Color(0xFF00838F),
    tagColor: const Color(0xFF00838F),
    initials: 'PO',
    phone: '+256776567890',
    latitude: 2.7741,
    longitude: 32.2989,
  ),
  VetDoctor(
    name: 'Dr. Fatima Nalubega',
    specialty: 'Preventive Medicine & Vaccination',
    location: 'Mukono, Jinja Road',
    rating: 4.4,
    isVerified: false,
    isNearby: true,
    isAvailableNow: true,
    bio: 'Community-focused vet with expertise in vaccination programs and preventive care for smallholder farmers.',
    availability: 'Mon-Fri: 9AM-4PM',
    consultFee: 'UGX 30,000',
    avatarColor: const Color(0xFFAD1457),
    tagColor: const Color(0xFFAD1457),
    initials: 'FN',
    phone: '+256777678901',
    latitude: 0.3548,
    longitude: 32.7526,
  ),
];

final List<ExtensionWorker> extensionWorkers = [
  ExtensionWorker(
    name: 'Samuel Kato',
    specialty: 'Crop-Livestock Integration',
    location: 'Wakiso, Nansana',
    rating: 4.7,
    isVerified: true,
    isNearby: true,
    isAvailableNow: true,
    bio: 'Senior extension worker with 10+ years promoting integrated crop-livestock farming systems. Certified by the Ministry of Agriculture, Animal Industry and Fisheries. Expert in helping farmers maximize productivity through sustainable practices.',
    availability: 'Mon-Fri: 8AM-5PM',
    serviceArea: 'Wakiso, Mpigi, Luwero',
    languages: 'English, Luganda',
    avatarColor: const Color(0xFF2E7D32),
    tagColor: const Color(0xFF2E7D32),
    initials: 'SK',
    phone: '+256778789012',
    latitude: 0.3730,
    longitude: 32.4780,
  ),
  ExtensionWorker(
    name: 'Prossy Nakamya',
    specialty: 'Poultry Extension Services',
    location: 'Mukono, Seeta',
    rating: 4.8,
    isVerified: true,
    isNearby: true,
    isAvailableNow: true,
    bio: 'Poultry extension specialist with expertise in modern poultry management, biosecurity, and flock health. Trained by FAO on smallholder poultry value chains. Has helped over 500 farmers improve their poultry enterprises.',
    availability: 'Mon-Sat: 8AM-4PM',
    serviceArea: 'Mukono, Buikwe, Kayunga',
    languages: 'English, Luganda',
    avatarColor: const Color(0xFF1565C0),
    tagColor: const Color(0xFF1565C0),
    initials: 'PN',
    phone: '+256779890123',
    latitude: 0.3670,
    longitude: 32.7500,
  ),
  ExtensionWorker(
    name: 'John Bosco Tumwesigye',
    specialty: 'Dairy Farming Support',
    location: 'Mbarara, Kakoba',
    rating: 4.6,
    isVerified: true,
    isNearby: false,
    isAvailableNow: false,
    bio: 'Dairy farming specialist supporting farmers in western Uganda with herd management, feed formulation, and milk quality improvement. Holds a diploma in Animal Husbandry from Bukalasa College.',
    availability: 'Mon-Fri: 9AM-5PM',
    serviceArea: 'Mbarara, Kiruhura, Ibanda',
    languages: 'English, Runyankole',
    avatarColor: const Color(0xFFE65100),
    tagColor: const Color(0xFFE65100),
    initials: 'JT',
    phone: '+256770901234',
    latitude: -0.5980,
    longitude: 30.6600,
  ),
  ExtensionWorker(
    name: 'Hellen Achieng',
    specialty: 'Goat & Sheep Management',
    location: 'Jinja, Budondo',
    rating: 4.5,
    isVerified: true,
    isNearby: false,
    isAvailableNow: true,
    bio: 'Small ruminant specialist focused on goat and sheep breeding, health, and nutrition. Certified community animal health worker with hands-on experience in eastern Uganda.',
    availability: 'Mon-Fri: 8AM-4PM',
    serviceArea: 'Jinja, Kamuli, Iganga',
    languages: 'English, Lusoga, Luganda',
    avatarColor: const Color(0xFF6A1B9A),
    tagColor: const Color(0xFF6A1B9A),
    initials: 'HA',
    phone: '+256771012345',
    latitude: 0.4350,
    longitude: 33.1900,
  ),
  ExtensionWorker(
    name: 'David Mwesigwa',
    specialty: 'Pig Farming Extension',
    location: 'Wakiso, Entebbe Road',
    rating: 4.4,
    isVerified: false,
    isNearby: true,
    isAvailableNow: true,
    bio: 'Pig production advisor helping farmers with breed selection, housing, feeding programs, and disease prevention. Works closely with local pig cooperatives in central Uganda.',
    availability: 'Mon-Sat: 7AM-3PM',
    serviceArea: 'Wakiso, Kampala, Mukono',
    languages: 'English, Luganda',
    avatarColor: const Color(0xFF00838F),
    tagColor: const Color(0xFF00838F),
    initials: 'DM',
    phone: '+256772123457',
    latitude: 0.3500,
    longitude: 32.5200,
  ),
  ExtensionWorker(
    name: 'Margaret Babirye',
    specialty: 'Rabbit & Poultry Care',
    location: 'Kampala, Kireka',
    rating: 4.3,
    isVerified: false,
    isNearby: true,
    isAvailableNow: false,
    bio: 'Extension worker specializing in small livestock including rabbits and poultry. Provides training on housing, feeding, breeding, and marketing for urban and peri-urban farmers.',
    availability: 'Tue-Sat: 9AM-4PM',
    serviceArea: 'Kampala, Wakiso',
    languages: 'English, Luganda',
    avatarColor: const Color(0xFFAD1457),
    tagColor: const Color(0xFFAD1457),
    initials: 'MB',
    phone: '+256773234568',
    latitude: 0.3580,
    longitude: 32.6500,
  ),
];

// ═══════════════════════════════════════════════════════════════
//  HELPERS (unchanged)
// ═══════════════════════════════════════════════════════════════

Future<void> _makePhoneCall(String phone) async {
  final uri = Uri.parse('tel:$phone');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

Future<void> _sendSMS(String phone, {String body = ''}) async {
  final uri = Uri.parse('sms:$phone${body.isNotEmpty ? '?body=${Uri.encodeComponent(body)}' : ''}');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

Future<void> _openGoogleMaps(double lat, double lng, {String label = ''}) async {
  final query = Uri.encodeComponent(label.isNotEmpty ? label : '$lat,$lng');
  final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    final browserUri = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
    if (await canLaunchUrl(browserUri)) {
      await launchUrl(browserUri);
    }
  }
}

Future<void> _openGoogleMapsDirections(double lat, double lng) async {
  final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    final browserUri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    if (await canLaunchUrl(browserUri)) {
      await launchUrl(browserUri);
    }
  }
}

String _getGoogleMapsStaticUrl(double lat, double lng) {
  return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=15&size=800x400&maptype=roadmap&markers=color:red%7C$lat,$lng';
}

// ═══════════════════════════════════════════════════════════════
//  PROFILE SCREEN WRAPPER (unchanged)
// ═══════════════════════════════════════════════════════════════
class ProfileScreenWrapper extends StatelessWidget {
  const ProfileScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: const ProfileTab(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  DOCTOR INFO SCREEN (unchanged)
// ═══════════════════════════════════════════════════════════════
class DoctorInfoScreen extends StatelessWidget {
  final VetDoctor doctor;
  const DoctorInfoScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1F36),
        elevation: 0,
        title: const Text('About Doctor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(
              initials: doctor.initials,
              avatarColor: doctor.avatarColor,
              name: doctor.name,
              isVerified: doctor.isVerified,
              tagText: doctor.specialty,
              tagColor: doctor.tagColor,
              rating: doctor.rating,
              isNearby: doctor.isNearby,
              isAvailableNow: doctor.isAvailableNow,
            ),
            const SizedBox(height: 12),
            _buildBioCard(bio: doctor.bio),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildInfoCard(Icons.schedule_rounded, 'Availability', doctor.availability)),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoCard(Icons.monetization_on_rounded, 'Consult Fee', doctor.consultFee)),
              ],
            ),
            const SizedBox(height: 24),
            _buildActionButtons(
              context: context,
              name: doctor.name,
              location: doctor.location,
              phone: doctor.phone,
              specialty: doctor.specialty,
              avatarColor: doctor.avatarColor,
              initials: doctor.initials,
              latitude: doctor.latitude,
              longitude: doctor.longitude,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  WORKER INFO SCREEN (unchanged)
// ═══════════════════════════════════════════════════════════════
class WorkerInfoScreen extends StatelessWidget {
  final ExtensionWorker worker;
  const WorkerInfoScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1F36),
        elevation: 0,
        title: const Text('About Worker', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(
              initials: worker.initials,
              avatarColor: worker.avatarColor,
              name: worker.name,
              isVerified: worker.isVerified,
              tagText: worker.specialty,
              tagColor: worker.tagColor,
              rating: worker.rating,
              isNearby: worker.isNearby,
              isAvailableNow: worker.isAvailableNow,
            ),
            const SizedBox(height: 12),
            _buildBioCard(bio: worker.bio),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildInfoCard(Icons.schedule_rounded, 'Availability', worker.availability)),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoCard(Icons.map_rounded, 'Service Area', worker.serviceArea)),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoCardFull(Icons.language_rounded, 'Languages', worker.languages),
            const SizedBox(height: 24),
            _buildActionButtons(
              context: context,
              name: worker.name,
              location: worker.location,
              phone: worker.phone,
              specialty: worker.specialty,
              avatarColor: worker.avatarColor,
              initials: worker.initials,
              latitude: worker.latitude,
              longitude: worker.longitude,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHARED WIDGETS for Info Screens (unchanged)
// ═══════════════════════════════════════════════════════════════

Widget _buildProfileHeader({
  required String initials,
  required Color avatarColor,
  required String name,
  required bool isVerified,
  required String tagText,
  required Color tagColor,
  required double rating,
  required bool isNearby,
  required bool isAvailableNow,
}) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: avatarColor.withOpacity(0.12),
          child: Text(initials, style: TextStyle(color: avatarColor, fontSize: 28, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
            if (isVerified) ...[
              const SizedBox(width: 6),
              const Icon(Icons.verified_rounded, color: Color(0xFF2E7D32), size: 20),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
          child: Text(tagText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tagColor)),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: rating >= 4.5 ? const Color(0xFFFFF8E1) : Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, color: rating >= 4.5 ? Colors.amber[600] : Colors.grey[400], size: 14),
                  const SizedBox(width: 3),
                  Text(rating.toString(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: rating >= 4.5 ? Colors.amber[800] : Colors.grey[600])),
                ],
              ),
            ),
            if (isNearby) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_rounded, color: Color(0xFF2E7D32), size: 13),
                    SizedBox(width: 3),
                    Text('Nearby', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32)),
                )],
                ),
              ),
            ],
            if (isAvailableNow) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle_rounded, color: Colors.green, size: 8),
                    SizedBox(width: 3),
                    Text('Available', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    ),
  );
}

Widget _buildBioCard({required String bio}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
        const SizedBox(height: 8),
        Text(bio, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.6)),
      ],
    ),
  );
}

Widget _buildInfoCard(IconData icon, String label, String value) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(
      children: [
        Icon(icon, size: 22, color: Colors.grey[500]),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36)), textAlign: TextAlign.center),
      ],
    ),
  );
}

Widget _buildInfoCardFull(IconData icon, String label, String value) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[500]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36))),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildActionButtons({
  required BuildContext context,
  required String name,
  required String location,
  required String phone,
  required String specialty,
  required Color avatarColor,
  required String initials,
  required double latitude,
  required double longitude,
}) {
  return Row(
    children: [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LocationScreen(name: name, location: location, latitude: latitude, longitude: longitude)));
          },
          icon: const Icon(Icons.location_on_rounded, size: 18),
          label: const Text('Location'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1E88E5),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: Color(0xFF1E88E5)),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: ElevatedButton.icon(
          onPressed: () => _makePhoneCall(phone),
          icon: const Icon(Icons.phone_rounded, size: 18),
          label: const Text('Call Now'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    ],
  );
}

// ═══════════════════════════════════════════════════════════════
//  LOCATION SCREEN (unchanged)
// ═══════════════════════════════════════════════════════════════
class LocationScreen extends StatelessWidget {
  final String name;
  final String location;
  final double latitude;
  final double longitude;

  const LocationScreen({super.key, required this.name, required this.location, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1F36),
        elevation: 0,
        title: const Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFC8E6C9))),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Image.network(
                    _getGoogleMapsStaticUrl(latitude, longitude),
                    width: double.infinity, height: 300, fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(height: 300, color: const Color(0xFFE8F5E9), child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)))));
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300, color: const Color(0xFFE8F5E9),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Icon(Icons.map_rounded, size: 56, color: Color(0xFF2E7D32)),
                          const SizedBox(height: 10),
                          Text('Tap below to open in Google Maps', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                        ]),
                      );
                    },
                  ),
                  Positioned(
                    top: 0, left: 0, right: 0, bottom: 0,
                    child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))]),
                          child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4)]),
                          child: Text(name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36))),
                        ),
                      ]),
                    ),
                  ),
                  Positioned(
                    bottom: 12, left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(6)),
                      child: Text('${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))]),
              child: Row(
                children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFF1E88E5).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.location_on_rounded, color: Color(0xFF1E88E5), size: 22)),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36))),
                    SizedBox(height: 3),
                    Text(location, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                  ])),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _openGoogleMaps(latitude, longitude, label: '$name, $location'),
                icon: const Icon(Icons.map_rounded), label: const Text('Open in Google Maps'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E88E5), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _openGoogleMapsDirections(latitude, longitude),
                icon: const Icon(Icons.directions_rounded, size: 20), label: const Text('Get Directions'),
                style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF2E7D32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: const BorderSide(color: Color(0xFF2E7D32))),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  DOCTOR CARD (unchanged)
// ═══════════════════════════════════════════════════════════════
class _DoctorCard extends StatelessWidget {
  final VetDoctor doctor;
  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    final doc = doctor;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                _buildAvatar(doc.avatarColor, doc.initials),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(child: Text(doc.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36)), overflow: TextOverflow.ellipsis)),
                        if (doc.isVerified) ...[const SizedBox(width: 4), const Icon(Icons.verified_rounded, color: Color(0xFF2E7D32), size: 14)],
                      ]),
                      const SizedBox(height: 2),
                      Row(children: [
                        Icon(Icons.location_on_rounded, color: Colors.grey[400], size: 13),
                        const SizedBox(width: 2),
                        Text(doc.location, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                        if (doc.isNearby) ...[
                          const SizedBox(width: 4),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: const Text('Nearby', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
                          ),
                        ],
                      ]),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: doc.tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(doc.specialty, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: doc.tagColor)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: doc.rating >= 4.5 ? const Color(0xFFFFF8E1) : Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Icon(Icons.star_rounded, color: doc.rating >= 4.5 ? Colors.amber[600] : Colors.grey[400], size: 14),
                    const SizedBox(width: 2),
                    Text(doc.rating.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: doc.rating >= 4.5 ? Colors.amber[800] : Colors.grey[600])),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _actionButton(Icons.info_outline_rounded, 'About', const Color(0xFF2E7D32), () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorInfoScreen(doctor: doc)));
                })),
                const SizedBox(width: 8),
                Expanded(child: _actionButton(Icons.location_on_rounded, 'Location', const Color(0xFF1E88E5), () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LocationScreen(name: doc.name, location: doc.location, latitude: doc.latitude, longitude: doc.longitude)));
                })),
                const SizedBox(width: 8),
                Expanded(child: _actionButton(Icons.phone_rounded, 'Call', const Color(0xFF43A047), () => _makePhoneCall(doc.phone))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  WORKER CARD (unchanged)
// ═══════════════════════════════════════════════════════════════
class _WorkerCard extends StatelessWidget {
  final ExtensionWorker worker;
  const _WorkerCard({required this.worker});

  @override
  Widget build(BuildContext context) {
    final w = worker;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                _buildAvatar(w.avatarColor, w.initials),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(child: Text(w.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36)), overflow: TextOverflow.ellipsis)),
                        if (w.isVerified) ...[const SizedBox(width: 4), const Icon(Icons.verified_rounded, color: Color(0xFF2E7D32), size: 14)],
                      ]),
                      const SizedBox(height: 2),
                      Row(children: [
                        Icon(Icons.location_on_rounded, color: Colors.grey[400], size: 13),
                        const SizedBox(width: 2),
                        Text(w.location, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                        if (w.isNearby) ...[
                          const SizedBox(width: 4),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: const Text('Nearby', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
                          ),
                        ],
                      ]),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: w.tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(w.specialty, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: w.tagColor)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: w.rating >= 4.5 ? const Color(0xFFFFF8E1) : Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Icon(Icons.star_rounded, color: w.rating >= 4.5 ? Colors.amber[600] : Colors.grey[400], size: 14),
                    const SizedBox(width: 2),
                    Text(w.rating.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: w.rating >= 4.5 ? Colors.amber[800] : Colors.grey[600])),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _actionButton(Icons.info_outline_rounded, 'About', const Color(0xFF2E7D32), () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WorkerInfoScreen(worker: w)));
                })),
                const SizedBox(width: 8),
                Expanded(child: _actionButton(Icons.location_on_rounded, 'Location', const Color(0xFF1E88E5), () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LocationScreen(name: w.name, location: w.location, latitude: w.latitude, longitude: w.longitude)));
                })),
                const SizedBox(width: 8),
                Expanded(child: _actionButton(Icons.phone_rounded, 'Call', const Color(0xFF43A047), () => _makePhoneCall(w.phone))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHARED CARD WIDGETS (unchanged)
// ═══════════════════════════════════════════════════════════════

Widget _buildAvatar(Color color, String initials) {
  return Container(
    width: 50, height: 50,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
    child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
  );
}

Widget _actionButton(IconData icon, String label, Color color, VoidCallback onTap) {
  return Material(
    color: color.withOpacity(0.08),
    borderRadius: BorderRadius.circular(10),
    child: InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ]),
      ),
    ),
  );
}