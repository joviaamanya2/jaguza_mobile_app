import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jaguza_app/screens/home_details/Profile/profile_screen.dart';
import 'package:jaguza_app/services/api_service.dart';

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

  final List<String> _filters = ['All', 'Nearby', 'Top Rated', 'Available Now'];
  final ApiService _apiService = ApiService();
  List<VetDoctor> _doctors = List<VetDoctor>.from(vetDoctors);
  List<ExtensionWorker> _workers = List<ExtensionWorker>.from(extensionWorkers);
  bool _isLoadingProfessionals = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfessionals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<VetDoctor> get _filteredDoctors {
    final query = _searchQuery.toLowerCase();
    return _doctors.where((doc) {
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
    return _workers.where((w) {
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

  Future<void> _loadProfessionals() async {
    setState(() => _isLoadingProfessionals = true);
    Object? doctorsError;
    Object? workersError;

    try {
      final doctors = await _apiService.getDoctors();
      if (mounted) {
        setState(() {
          _doctors = doctors
              .whereType<Map>()
              .map((item) => VetDoctor.fromApi(Map<String, dynamic>.from(item)))
              .toList();
        });
      }
    } catch (error) {
      doctorsError = error;
    }

    try {
      final workers = await _apiService.getExtensionWorkers();
      if (mounted) {
        setState(() {
          _workers = workers
              .whereType<Map>()
              .map((item) => ExtensionWorker.fromApi(Map<String, dynamic>.from(item)))
              .toList();
        });
      }
    } catch (error) {
      workersError = error;
    }

    if (!mounted) return;
    setState(() => _isLoadingProfessionals = false);
    if (doctorsError != null || workersError != null) {
      final failed = doctorsError != null && workersError != null
          ? 'doctors and extension workers'
          : doctorsError != null
              ? 'doctors'
              : 'extension workers';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not load $failed. Check the deployed API and login session.'),
          action: SnackBarAction(label: 'Retry', onPressed: _loadProfessionals),
        ),
      );
    }
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 6),
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
    );
  }
  Widget _buildSearchBar() {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
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
            hintStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
            prefixIcon: Icon(Icons.search_rounded, color: scheme.primary, size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: Icon(Icons.close_rounded, color: scheme.onSurfaceVariant, size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          ),
        ),
      ),
    );
  }

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
            final scheme = Theme.of(context).colorScheme;
            final filter = _filters[index];
            final isActive = _selectedFilter == filter;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? scheme.primary : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive ? scheme.primary : scheme.outlineVariant,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isActive ? Colors.white : scheme.onSurfaceVariant,
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
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6),
          ],
        ),
        indicatorPadding: const EdgeInsets.all(3),
        dividerColor: Colors.transparent,
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
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
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: scheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: scheme.onSurface)),
            const SizedBox(height: 6),
            Text(subtitle, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  DATA MODELS
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

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

  factory VetDoctor.fromApi(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : <String, dynamic>{};
    final name = (user['name'] ?? json['name'] ?? 'Veterinary Doctor').toString();
    final rating = double.tryParse('${json['rating'] ?? 0}') ?? 0;
    final fee = double.tryParse('${json['consultation_fee'] ?? 0}') ?? 0;
    return VetDoctor(
      name: name,
      specialty: (json['specialization'] ?? 'Veterinary Medicine').toString(),
      location: (json['location'] ?? 'Location unavailable').toString(),
      rating: rating,
      isVerified: true,
      isNearby: false,
      isAvailableNow: json['is_available'] == true,
      bio: (json['bio'] ?? 'Veterinary professional available through Jaguza.').toString(),
      availability: json['is_available'] == true ? 'Available now' : 'Currently unavailable',
      consultFee: fee > 0 ? 'UGX ${fee.toStringAsFixed(0)}' : 'Contact for fee',
      avatarColor: const Color(0xFF2E7D32),
      tagColor: const Color(0xFF2E7D32),
      initials: _initials(name),
      phone: (json['phone_number'] ?? '').toString(),
      latitude: double.tryParse('${json['latitude'] ?? 0}') ?? 0,
      longitude: double.tryParse('${json['longitude'] ?? 0}') ?? 0,
    );
  }
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

  factory ExtensionWorker.fromApi(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : <String, dynamic>{};
    final name = (user['name'] ?? json['name'] ?? 'Extension Worker').toString();
    return ExtensionWorker(
      name: name,
      specialty: (json['expertise_area'] ?? 'Livestock Extension').toString(),
      location: (json['assigned_region'] ?? 'Location unavailable').toString(),
      rating: double.tryParse('${json['rating'] ?? 0}') ?? 0,
      isVerified: true,
      isNearby: false,
      isAvailableNow: json['is_available'] == true,
      bio: (json['bio'] ?? 'Extension worker available through Jaguza.').toString(),
      availability: json['is_available'] == true ? 'Available now' : 'Currently unavailable',
      serviceArea: (json['assigned_region'] ?? 'Contact for service area').toString(),
      languages: (json['languages_spoken'] ?? 'English').toString(),
      avatarColor: const Color(0xFF2E7D32),
      tagColor: const Color(0xFF2E7D32),
      initials: _initials(name),
      phone: (json['phone_number'] ?? '').toString(),
      latitude: double.tryParse('${json['latitude'] ?? 0}') ?? 0,
      longitude: double.tryParse('${json['longitude'] ?? 0}') ?? 0,
    );
  }
}

String _initials(String name) {
  final initials = name
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .map((part) => part[0])
      .take(2)
      .join()
      .toUpperCase();
  return initials.isEmpty ? 'NA' : initials;
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

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  HELPERS
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

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

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  PROFILE SCREEN WRAPPER
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class ProfileScreenWrapper extends StatelessWidget {
  const ProfileScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ProfileTab(),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  DOCTOR INFO SCREEN
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class DoctorInfoScreen extends StatelessWidget {
  final VetDoctor doctor;
  const DoctorInfoScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('About Doctor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
              context: context,
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
            _buildBioCard(context: context, bio: doctor.bio),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildInfoCard(context, Icons.schedule_rounded, 'Availability', doctor.availability)),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoCard(context, Icons.monetization_on_rounded, 'Consult Fee', doctor.consultFee)),
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

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  WORKER INFO SCREEN
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class WorkerInfoScreen extends StatelessWidget {
  final ExtensionWorker worker;
  const WorkerInfoScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('About Worker', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
              context: context,
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
            _buildBioCard(context: context, bio: worker.bio),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildInfoCard(context, Icons.schedule_rounded, 'Availability', worker.availability)),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoCard(context, Icons.map_rounded, 'Service Area', worker.serviceArea)),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoCardFull(context, Icons.language_rounded, 'Languages', worker.languages),
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

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  SHARED WIDGETS for Info Screens
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

Widget _buildProfileHeader({
  required BuildContext context,
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
  final scheme = Theme.of(context).colorScheme;
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: avatarColor.withValues(alpha: 0.12),
          child: Text(initials, style: TextStyle(color: avatarColor, fontSize: 28, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: scheme.onSurface),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (isVerified) ...[
              const SizedBox(width: 6),
              Icon(Icons.verified_rounded, color: scheme.primary, size: 20),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: tagColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
          child: Text(
            tagText,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tagColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: rating >= 4.5 ? const Color(0xFFFFF8E1) : scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, color: rating >= 4.5 ? Colors.amber[600] : scheme.onSurfaceVariant, size: 14),
                  const SizedBox(width: 3),
                  Text(rating.toString(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: rating >= 4.5 ? Colors.amber[800] : scheme.onSurfaceVariant)),
                ],
              ),
            ),
            if (isNearby) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: scheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_rounded, color: scheme.primary, size: 13),
                    const SizedBox(width: 3),
                    Text('Nearby', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.primary)),
                  ],
                ),
              ),
            ],
            if (isAvailableNow) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
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

Widget _buildBioCard({required BuildContext context, required String bio}) {
  final scheme = Theme.of(context).colorScheme;
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: scheme.onSurface)),
        const SizedBox(height: 8),
        Text(bio, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, height: 1.6)),
      ],
    ),
  );
}

Widget _buildInfoCard(BuildContext context, IconData icon, String label, String value) {
  final scheme = Theme.of(context).colorScheme;
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(
      children: [
        Icon(icon, size: 22, color: scheme.onSurfaceVariant),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.onSurface),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    ),
  );
}

Widget _buildInfoCardFull(BuildContext context, IconData icon, String label, String value) {
  final scheme = Theme.of(context).colorScheme;
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Row(
      children: [
        Icon(icon, size: 20, color: scheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: scheme.onSurface),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
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
  final scheme = Theme.of(context).colorScheme;
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
            backgroundColor: scheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    ],
  );
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  LOCATION SCREEN
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class LocationScreen extends StatelessWidget {
  final String name;
  final String location;
  final double latitude;
  final double longitude;

  const LocationScreen({super.key, required this.name, required this.location, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
              decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(16), border: Border.all(color: scheme.primary.withValues(alpha: 0.3))),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Image.network(
                    _getGoogleMapsStaticUrl(latitude, longitude),
                    width: double.infinity, height: 300, fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(height: 300, color: scheme.primaryContainer, child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(scheme.primary))));
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300, color: scheme.primaryContainer,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.map_rounded, size: 56, color: scheme.primary),
                          const SizedBox(height: 10),
                          Text('Tap below to open in Google Maps', style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
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
                          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))]),
                          child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4)]),
                          child: Text(
                            name,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: scheme.onSurface),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Positioned(
                    bottom: 12, left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(6)),
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
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))]),
              child: Row(
                children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFF1E88E5).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.location_on_rounded, color: Color(0xFF1E88E5), size: 22)),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: scheme.onSurface),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      location,
                      style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
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
                style: OutlinedButton.styleFrom(foregroundColor: scheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: BorderSide(color: scheme.primary)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  DOCTOR CARD (FIXED - No Overflow)
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class _DoctorCard extends StatelessWidget {
  final VetDoctor doctor;
  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    final doc = doctor;
    return _ProfessionalCard(
      name: doc.name,
      subtitle: doc.location,
      bio: doc.bio,
      onAbout: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorInfoScreen(doctor: doc)),
      ),
      onLocation: () => _openGoogleMaps(
        doc.latitude,
        doc.longitude,
        label: (doc.latitude == 0 && doc.longitude == 0) ? doc.location : '',
      ),
      onCall: () => _makePhoneCall(doc.phone),
    );
  }
}

// WORKER CARD
class _WorkerCard extends StatelessWidget {
  final ExtensionWorker worker;
  const _WorkerCard({required this.worker});

  @override
  Widget build(BuildContext context) {
    final w = worker;
    return _ProfessionalCard(
      name: w.name,
      subtitle: w.location,
      bio: w.bio,
      onAbout: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkerInfoScreen(worker: w)),
      ),
      onLocation: () => _openGoogleMaps(
        w.latitude,
        w.longitude,
        label: (w.latitude == 0 && w.longitude == 0) ? w.location : '',
      ),
      onCall: () => _makePhoneCall(w.phone),
    );
  }
}

// SHARED PROFESSIONAL CARD (matches the doctors screen design)
class _ProfessionalCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String bio;
  final VoidCallback onAbout;
  final VoidCallback onLocation;
  final VoidCallback onCall;

  const _ProfessionalCard({
    required this.name,
    required this.subtitle,
    required this.bio,
    required this.onAbout,
    required this.onLocation,
    required this.onCall,
  });

  static const _red = Color(0xFFC62828);
  static const _orange = Color(0xFFEF6C00);
  static const _green = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cardBg = Color.alphaBlend(
      scheme.primary.withValues(alpha: 0.06),
      Theme.of(context).cardColor,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              size: 30,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: scheme.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  bio,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: scheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Row(
                    children: [
                      _circleAction(Icons.question_mark_rounded, _red, onAbout),
                      const SizedBox(width: 16),
                      _circleAction(Icons.location_on_rounded, _orange, onLocation),
                      const SizedBox(width: 16),
                      _circleAction(Icons.phone_rounded, _green, onCall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleAction(IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  SHARED CARD WIDGETS
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
