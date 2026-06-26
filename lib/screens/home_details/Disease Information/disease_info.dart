import 'package:flutter/material.dart';

// TODO: Replace these placeholder imports with your real files as you create them
// import 'disease_details/foot_mouth_detail_screen.dart';
// import 'disease_details/abomasum_detail_screen.dart';

class AnimalDiseasesScreen extends StatefulWidget {
  const AnimalDiseasesScreen({super.key});

  @override
  State<AnimalDiseasesScreen> createState() => _AnimalDiseasesScreenState();
}

class _AnimalDiseasesScreenState extends State<AnimalDiseasesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All', 'Cattle', 'Poultry', 'Small Ruminants', 'Swine',
  ];

  final List<DiseaseItem> _allDiseases = [
    DiseaseItem(
      title: 'Foot-and-Mouth Disease',
      animal: 'Cattle, Sheep, Pigs',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.pets_rounded,
      category: 'Cattle',
      description: 'Highly contagious viral disease affecting cloven-hoofed animals.',
      screen: const _PlaceholderDetailScreen(title: 'Foot-and-Mouth Disease'), // Replace with: const FootMouthDetailScreen()
    ),
    DiseaseItem(
      title: 'Displaced Abomasum in Cattle',
      animal: 'Cattle',
      severity: 'Medium',
      severityColor: const Color(0xFFFFA000),
      icon: Icons.tab_unselected_sharp,
      category: 'Cattle',
      description: 'Abomasum displaces from its normal position, common post-calving.',
      screen: const _PlaceholderDetailScreen(title: 'Displaced Abomasum'),
    ),
    DiseaseItem(
      title: 'White Muscle Disease',
      animal: 'Cattle, Sheep',
      severity: 'Medium',
      severityColor: const Color(0xFFFFA000),
      icon: Icons.fitness_center_rounded,
      category: 'Small Ruminants',
      description: 'Nutritional muscular dystrophy caused by selenium/vitamin E deficiency.',
      screen: const _PlaceholderDetailScreen(title: 'White Muscle Disease'),
    ),
    DiseaseItem(
      title: 'Newcastle Disease',
      animal: 'Poultry',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.coronavirus_rounded,
      category: 'Poultry',
      description: 'Contagious viral disease causing respiratory and nervous symptoms in birds.',
      screen: const _PlaceholderDetailScreen(title: 'Newcastle Disease'),
    ),
    DiseaseItem(
      title: 'Mastitis',
      animal: 'Cattle, Goats',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.water_drop_rounded,
      category: 'Cattle',
      description: 'Inflammation of the mammary gland, impacting milk production.',
      screen: const _PlaceholderDetailScreen(title: 'Mastitis'),
    ),
    DiseaseItem(
      title: 'African Swine Fever',
      animal: 'Swine',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.warning_rounded,
      category: 'Swine',
      description: 'Highly contagious viral hemorrhagic fever with high mortality rates.',
      screen: const _PlaceholderDetailScreen(title: 'African Swine Fever'),
    ),
    DiseaseItem(
      title: 'Coccidiosis',
      animal: 'Poultry, Cattle',
      severity: 'Medium',
      severityColor: const Color(0xFFFFA000),
      icon: Icons.bug_report_rounded,
      category: 'Poultry',
      description: 'Parasitic disease affecting the intestinal tract of animals.',
      screen: const _PlaceholderDetailScreen(title: 'Coccidiosis'),
    ),
    DiseaseItem(
      title: 'Brucellosis',
      animal: 'Cattle, Goats, Pigs',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.coronavirus_rounded,
      category: 'Cattle',
      description: 'Zoonotic bacterial disease causing reproductive failure in livestock.',
      screen: const _PlaceholderDetailScreen(title: 'Brucellosis'),
    ),
    DiseaseItem(
      title: 'Peste des Petits Ruminants',
      animal: 'Sheep, Goats',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.coronavirus_rounded,
      category: 'Small Ruminants',
      description: 'Viral disease causing fever, sores, and high mortality in small ruminants.',
      screen: const _PlaceholderDetailScreen(title: 'Peste des Petits Ruminants'),
    ),
    DiseaseItem(
      title: 'Avian Influenza',
      animal: 'Poultry',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.air_rounded,
      category: 'Poultry',
      description: 'Highly contagious viral respiratory disease in birds, zoonotic potential.',
      screen: const _PlaceholderDetailScreen(title: 'Avian Influenza'),
    ),
  ];

  List<DiseaseItem> get _filteredDiseases {
    return _allDiseases.where((d) {
      final matchesSearch = d.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.animal.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || d.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildPromoBanners(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildCategoryFilters(),
            const SizedBox(height: 12),
            Expanded(child: _buildDiseaseList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Color(0xFF2E7D32), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _iconCircle(icon: Icons.arrow_back_rounded, onTap: () => Navigator.pop(context)),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Animal Diseases', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                SizedBox(height: 2),
                Text('Comprehensive disease database', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          _iconCircle(icon: Icons.filter_list_rounded, onTap: () {}),
        ],
      ),
    );
  }

  Widget _iconCircle({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildPromoBanners() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Expanded(child: _promoCard(icon: Icons.biotech_rounded, title: 'Know Diseases', subtitle: 'Learn & prevent', gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]), onTap: () {})),
        ],
      ),
    );
  }

  Widget _promoCard({required IconData icon, required String title, required String subtitle, required Gradient gradient, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: gradient.colors.first.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: Colors.white, size: 20)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10, offset: const Offset(0, 2))]),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search diseases, symptoms, animals...',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13.5),
            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9CA3AF), size: 22),
            suffixIcon: _searchQuery.isNotEmpty ? GestureDetector(onTap: () { _searchController.clear(); setState(() => _searchQuery = ''); }, child: const Icon(Icons.close_rounded, color: Color(0xFF9CA3AF), size: 20)) : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5)),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isActive = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF2E7D32) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: isActive ? null : Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: isActive ? [BoxShadow(color: const Color(0xFF2E7D32), blurRadius: 8, offset: const Offset(0, 3))] : null,
              ),
              child: Text(cat, style: TextStyle(color: isActive ? Colors.white : const Color(0xFF6B7280), fontSize: 12.5, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiseaseList() {
    final diseases = _filteredDiseases;
    if (diseases.isEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.search_off_rounded, size: 60, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text('No diseases found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Text('Try a different search or category', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
      ]));
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      itemCount: diseases.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => DiseaseCard(item: diseases[index]),
    );
  }
}

// ═══════════════════════════════════════
//  DISEASE CARD
// ═══════════════════════════════════════
class DiseaseCard extends StatefulWidget {
  final DiseaseItem item;
  const DiseaseCard({super.key, required this.item});

  @override
  State<DiseaseCard> createState() => _DiseaseCardState();
}

class _DiseaseCardState extends State<DiseaseCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        // NAVIGATES TO THE SPECIFIC SCREEN ASSIGNED IN THE LIST
        Navigator.push(context, MaterialPageRoute(builder: (context) => widget.item.screen));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: _pressed ? (Matrix4.identity()) : Matrix4.identity(),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black, blurRadius: _pressed ? 4 : 10, offset: Offset(0, _pressed ? 1 : 4))]),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(width: 50, height: 50, decoration: BoxDecoration(color: widget.item.severityColor.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: Icon(widget.item.icon, color: widget.item.severityColor, size: 24)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.item.title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36), height: 1.3)),
              const SizedBox(height: 4),
              Text(widget.item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF), height: 1.4)),
              const SizedBox(height: 8),
              Row(children: [Icon(Icons.pets_rounded, size: 13, color: Colors.grey[400]), const SizedBox(width: 4), Text(widget.item.animal, style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500))]),
            ])),
            const SizedBox(width: 10),
            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: widget.item.severityColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(widget.item.severity, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: widget.item.severityColor))),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFFD1D5DB), size: 22),
            ]),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════
//  DATA MODEL
// ═══════════════════════════════════════
class DiseaseItem {
  final String title;
  final String animal;
  final String severity;
  final Color severityColor;
  final IconData icon;
  final String category;
  final String description;
  final Widget screen; // NEW PROPERTY

  const DiseaseItem({
    required this.title,
    required this.animal,
    required this.severity,
    required this.severityColor,
    required this.icon,
    required this.category,
    required this.description,
    required this.screen, // NEW PROPERTY
  });
}

// ═══════════════════════════════════════
//  PLACEHOLDER SCREEN (Delete this class once you create all real files)
// ═══════════════════════════════════════
class _PlaceholderDetailScreen extends StatelessWidget {
  final String title;
  const _PlaceholderDetailScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Design your $title screen here', style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }
}