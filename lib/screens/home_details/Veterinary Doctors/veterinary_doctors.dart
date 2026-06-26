import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
        ),
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
  late AnimationController _listController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Nearby', 'Top Rated', 'Surgery', 'Preventive'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _listController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _listController.dispose();
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
          (_selectedFilter == 'Surgery' && doc.specialty.toLowerCase().contains('surgery')) ||
          (_selectedFilter == 'Preventive' && doc.specialty.toLowerCase().contains('preventive'));
      return matchesSearch && matchesFilter;
    }).toList();
  }

  List<ExtensionWorker> get _filteredWorkers {
    final query = _searchQuery.toLowerCase();
    return extensionWorkers.where((w) {
      return w.name.toLowerCase().contains(query) ||
          w.location.toLowerCase().contains(query) ||
          w.specialty.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildQuickActions(),
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

  // ═══════════════════════════════════════
  //  HEADER
  // ═══════════════════════════════════════
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1B5E20),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        children: [
          // Top row
          Row(
            children: [
              _headerIcon(Icons.arrow_back_rounded, onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12),
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
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Veterinary Doctors',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              _headerIcon(Icons.filter_list_rounded, onTap: () {}),
              const SizedBox(width: 8),
              _headerIcon(Icons.tune_rounded, onTap: () {}),
            ],
          ),
          const SizedBox(height: 16),
          // Stats row
          Row(
            children: [
              _statChip(Icons.verified_rounded, '24 Verified', Colors.white.withOpacity(0.15)),
              const SizedBox(width: 10),
              _statChip(Icons.star_rounded, '4.6 Avg Rating', Colors.amber.withOpacity(0.2)),
              const SizedBox(width: 10),
              _statChip(Icons.location_on_rounded, '12 Nearby', Colors.white.withOpacity(0.15)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 21),
      ),
    );
  }

  Widget _statChip(IconData icon, String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  SEARCH BAR
  // ═══════════════════════════════════════
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search by name, location, or specialty...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13.5),
            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.search_rounded, color: Color(0xFF2E7D32), size: 20),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.close_rounded, color: Colors.red[400], size: 18),
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  QUICK ACTION BANNERS
  // ═══════════════════════════════════════
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: _quickBanner(
              icon: Icons.storefront_rounded,
              title: 'Sell Products',
              subtitle: 'in Market Place',
              gradient: const [Color(0xFFF57C00), Color(0xFFFF9800)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _quickBanner(
              icon: Icons.biotech_rounded,
              title: 'Diseases Info',
              subtitle: 'Know more',
              gradient: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickBanner({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: gradient[0].withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.6), size: 20),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  FILTER CHIPS
  // ═══════════════════════════════════════
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 38,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF2E7D32) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? const Color(0xFF2E7D32) : Colors.grey[300]!,
                  ),
                  boxShadow: [
                    if (isActive)
                      BoxShadow(color: const Color(0xFF2E7D32).withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3)),
                  ],
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey[600],
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  TAB BAR
  // ═══════════════════════════════════════
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        indicatorPadding: const EdgeInsets.all(3),
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFF1B5E20),
        unselectedLabelColor: Colors.grey[500],
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: '  Veterinary Doctors  '),
          Tab(text: '  Extension Workers  '),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  DOCTORS LIST
  // ═══════════════════════════════════════
  Widget _buildDoctorsList() {
    final doctors = _filteredDoctors;
    if (doctors.isEmpty) {
      return _emptyState('No doctors found', 'Try adjusting your search or filters');
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          index: index,
          controller: _listController,
          child: _DoctorCard(doctor: doctors[index]),
        );
      },
    );
  }

  // ═══════════════════════════════════════
  //  WORKERS LIST
  // ═══════════════════════════════════════
  Widget _buildWorkersList() {
    final workers = _filteredWorkers;
    if (workers.isEmpty) {
      return _emptyState('No workers found', 'Try adjusting your search');
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          index: index,
          controller: _listController,
          child: _WorkerCard(worker: workers[index]),
        );
      },
    );
  }

  Widget _emptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded, size: 36, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
            const SizedBox(height: 8),
            Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[500]), textAlign: TextAlign.center),
          ],
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.grid_view_rounded, 'Explore', false),
              _navItem(Icons.pets_rounded, 'My Farm', false),
              _navItem(Icons.medical_services_rounded, 'Doctors', true),
              _navItem(Icons.language_rounded, 'Web', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    final color = active ? const Color(0xFF2E7D32) : const Color(0xFFBDBDBD);
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: active
                ? BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), borderRadius: BorderRadius.circular(12))
                : null,
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10.5, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════
//  DOCTOR CARD
// ═══════════════════════════════════════
class _DoctorCard extends StatefulWidget {
  final VetDoctor doctor;
  const _DoctorCard({required this.doctor});

  @override
  State<_DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<_DoctorCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top row: avatar + info
                Row(
                  children: [
                    // Avatar
                    _buildAvatar(doc),
                    const SizedBox(width: 14),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  doc.name,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (doc.isVerified) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.verified_rounded, color: Color(0xFF2E7D32), size: 16),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: Colors.grey[400], size: 14),
                              const SizedBox(width: 3),
                              Text(doc.location, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                              if (doc.isNearby) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('Nearby', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Specialty tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: doc.tagColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              doc.specialty,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: doc.tagColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Rating
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: doc.rating >= 4.5
                                ? const Color(0xFFFFF8E1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_rounded, color: doc.rating >= 4.5 ? Colors.amber[600] : Colors.grey, size: 16),
                              const SizedBox(width: 3),
                              Text(doc.rating.toString(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: doc.rating >= 4.5 ? Colors.amber[800] : Colors.grey[600])),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('rating', style: TextStyle(fontSize: 10, color: Colors.grey[400])),
                      ],
                    ),
                  ],
                ),

                // Expanded detail section
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity, height: 0),
                  secondChild: _buildExpandedInfo(doc),
                  crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                  sizeCurve: Curves.easeInOut,
                ),

                // Action buttons
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: _actionButton(Icons.info_outline_rounded, 'About', const Color(0xFF2E7D32), () {})),
                    const SizedBox(width: 10),
                    Expanded(child: _actionButton(Icons.location_on_rounded, 'Location', const Color(0xFF1E88E5), () {})),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _actionButton(Icons.phone_rounded, 'Call', const Color(0xFF43A047), () {
                        _showCallSheet(context, doc);
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(VetDoctor doc) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [doc.avatarColor, doc.avatarColor.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: doc.avatarColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Center(
        child: Text(
          doc.initials,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
      ),
    );
  }

  Widget _buildExpandedInfo(VetDoctor doc) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
          const SizedBox(height: 4),
          Text(doc.bio, style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5)),
          const SizedBox(height: 10),
          Row(
            children: [
              _infoChip(Icons.schedule_rounded, doc.availability),
              const SizedBox(width: 8),
              _infoChip(Icons.monetization_on_rounded, doc.consultFee),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.grey[500]),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  void _showCallSheet(BuildContext context, VetDoctor doc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            CircleAvatar(radius: 32, backgroundColor: doc.avatarColor.withOpacity(0.15), child: Text(doc.initials, style: TextStyle(color: doc.avatarColor, fontSize: 20, fontWeight: FontWeight.w800))),
            const SizedBox(height: 12),
            Text(doc.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Text(doc.specialty, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.phone_rounded),
                label: const Text('Call Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.message_rounded, size: 18),
                label: const Text('Send Message'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════
//  WORKER CARD
// ═══════════════════════════════════════
class _WorkerCard extends StatelessWidget {
  final ExtensionWorker worker;
  const _WorkerCard({required this.worker});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [worker.color, worker.color.withOpacity(0.7)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: worker.color.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: Center(
                child: Text(worker.initials, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(worker.name, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: Colors.grey[400], size: 13),
                      const SizedBox(width: 3),
                      Text(worker.location, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: worker.color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(worker.specialty, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: worker.color)),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                _smallAction(Icons.location_on_rounded, const Color(0xFF1E88E5), () {}),
                const SizedBox(height: 8),
                _smallAction(Icons.phone_rounded, const Color(0xFF43A047), () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallAction(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

// ═══════════════════════════════════════
//  STAGGERED LIST ANIMATION HELPER
// ═══════════════════════════════════════
class AnimatedBuilder extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final Widget child;

  const AnimatedBuilder({
    required this.index,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final startDelay = (index * 0.06).clamp(0.0, 0.6);
    final slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(parent: controller, curve: Interval(startDelay, (startDelay + 0.4).clamp(0.0, 1.0), curve: Curves.easeOutCubic)),
    );
    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Interval(startDelay, (startDelay + 0.4).clamp(0.0, 1.0), curve: Curves.easeOut)),
    );

    return SlideTransition(
      position: slideAnim,
      child: FadeTransition(
        opacity: fadeAnim,
        child: child,
      ),
    );
  }
}

// ═══════════════════════════════════════
//  DATA MODELS
// ═══════════════════════════════════════
class VetDoctor {
  final String name;
  final String location;
  final String specialty;
  final String bio;
  final double rating;
  final bool isVerified;
  final bool isNearby;
  final String availability;
  final String consultFee;
  final Color avatarColor;
  final Color tagColor;

  String get initials => name.replaceAll('Dr. ', '').split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();

  const VetDoctor({
    required this.name,
    required this.location,
    required this.specialty,
    required this.bio,
    required this.rating,
    this.isVerified = true,
    this.isNearby = false,
    required this.availability,
    required this.consultFee,
    required this.avatarColor,
    required this.tagColor,
  });
}

class ExtensionWorker {
  final String name;
  final String location;
  final String specialty;
  final Color color;

  String get initials => name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();

  const ExtensionWorker({
    required this.name,
    required this.location,
    required this.specialty,
    required this.color,
  });
}

// ═══════════════════════════════════════
//  SAMPLE DATA
// ═══════════════════════════════════════
const List<VetDoctor> vetDoctors = [
  VetDoctor(
    name: 'Dr. Alex Mwangi',
    location: 'Wandegeya, Kampala',
    specialty: 'Swine Health & Treatment',
    bio: 'Specialized in pig disease diagnosis, treatment, and herd health management with over 12 years of experience.',
    rating: 4.8,
    isVerified: true,
    isNearby: true,
    availability: 'Mon - Sat, 8AM - 6PM',
    consultFee: 'UGX 50,000',
    avatarColor: Color(0xFFE53935),
    tagColor: Color(0xFFE53935),
  ),
  VetDoctor(
    name: 'Dr. Atim Nancy',
    location: 'Jinja, Eastern Uganda',
    specialty: 'Preventive Medicine & Surgery',
    bio: 'Expert in preventive veterinary care and surgical interventions for cattle, goats, and sheep.',
    rating: 4.9,
    isVerified: true,
    isNearby: false,
    availability: 'Mon - Fri, 9AM - 5PM',
    consultFee: 'UGX 60,000',
    avatarColor: Color(0xFF8E24AA),
    tagColor: Color(0xFF8E24AA),
  ),
  VetDoctor(
    name: 'Dr. Ochieng Peter',
    location: 'Mbale, Eastern Uganda',
    specialty: 'Poultry Disease Specialist',
    bio: 'Focused on poultry health, vaccination programs, and biosecurity for commercial and local poultry farms.',
    rating: 4.6,
    isVerified: true,
    isNearby: false,
    availability: 'Tue - Sat, 7AM - 4PM',
    consultFee: 'UGX 40,000',
    avatarColor: Color(0xFFFB8C00),
    tagColor: Color(0xFFFB8C00),
  ),
  VetDoctor(
    name: 'Dr. Nakamya Grace',
    location: 'Mukono, Central Uganda',
    specialty: 'Large Animal Surgery',
    bio: 'Skilled in large animal surgical procedures including cesarean sections, tumor removals, and orthopedic repairs.',
    rating: 4.7,
    isVerified: true,
    isNearby: true,
    availability: 'Mon - Sun, 24/7 Emergency',
    consultFee: 'UGX 80,000',
    avatarColor: Color(0xFF1E88E5),
    tagColor: Color(0xFF1E88E5),
  ),
  VetDoctor(
    name: 'Dr. Bbosa Samuel',
    location: 'Entebbe, Wakiso',
    specialty: 'Ruminant Nutrition & Health',
    bio: 'Specializes in cattle and goat nutrition, metabolic disorders, and reproductive health management.',
    rating: 4.4,
    isVerified: false,
    isNearby: true,
    availability: 'Mon - Fri, 8AM - 5PM',
    consultFee: 'UGX 45,000',
    avatarColor: Color(0xFF43A047),
    tagColor: Color(0xFF43A047),
  ),
  VetDoctor(
    name: 'Dr. Achieng Florence',
    location: 'Gulu, Northern Uganda',
    specialty: 'Epidemiology & Disease Control',
    bio: 'Veterinary epidemiologist focusing on disease surveillance, outbreak investigation, and control strategies.',
    rating: 4.8,
    isVerified: true,
    isNearby: false,
    availability: 'Mon - Sat, 9AM - 6PM',
    consultFee: 'UGX 55,000',
    avatarColor: Color(0xFFEC407A),
    tagColor: Color(0xFFEC407A),
  ),
  VetDoctor(
    name: 'Dr. Tumusiime Robert',
    location: 'Mbarara, Western Uganda',
    specialty: 'Artificial Insemination & Reproduction',
    bio: 'Expert in AI services, pregnancy diagnosis, fertility management, and breeding program optimization.',
    rating: 4.5,
    isVerified: true,
    isNearby: false,
    availability: 'Mon - Fri, 7AM - 5PM',
    consultFee: 'UGX 70,000',
    avatarColor: Color(0xFF039BE5),
    tagColor: Color(0xFF039BE5),
  ),
  VetDoctor(
    name: 'Dr. Nalubega Prossy',
    location: 'Kampala, Kawempe',
    specialty: 'Small Animal Practice',
    bio: 'Caring for dogs, cats, and other companion animals with expertise in internal medicine and dermatology.',
    rating: 4.3,
    isVerified: true,
    isNearby: true,
    availability: 'Mon - Sat, 9AM - 7PM',
    consultFee: 'UGX 35,000',
    avatarColor: Color(0xFF6D4C41),
    tagColor: Color(0xFF6D4C41),
  ),
];

const List<ExtensionWorker> extensionWorkers = [
  ExtensionWorker(name: 'Okello James', location: 'Lira, Northern Uganda', specialty: 'Crop-Livestock Integration', color: Color(0xFF2E7D32)),
  ExtensionWorker(name: 'Nabukenya Sarah', location: 'Wakiso, Central Uganda', specialty: 'Dairy Farming Advisor', color: Color(0xFF1E88E5)),
  ExtensionWorker(name: 'Mugisha David', location: 'Kabale, Western Uganda', specialty: 'Pig Farming Extension', color: Color(0xFFFB8C00)),
  ExtensionWorker(name: 'Aol Betty', location: 'Gulu, Northern Uganda', specialty: 'Poultry Production', color: Color(0xFFEC407A)),
  ExtensionWorker(name: 'Ssebaggala Joseph', location: 'Masaka, Central Uganda', specialty: 'Beekeeping & Apiculture', color: Color(0xFFFFA000)),
  ExtensionWorker(name: 'Kemigisha Alice', location: 'Fort Portal, Western Uganda', specialty: 'Goat & Sheep Farming', color: Color(0xFF8E24AA)),
];