import 'package:flutter/material.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease%20details/Nagana.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease%20details/Peste%20des%20Petits%20Ruminants.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease%20details/brucellosis.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease%20details/coccidiosis.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease%20details/displaced_abomusam.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease%20details/foot_and_mouth.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease%20details/mastitis.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease%20details/new_castle.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease%20details/swine_fever.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease%20details/vibrosis.dart';
import 'package:jaguza_app/screens/home_details/Disease%20Information/disease%20details/white_muscle_disease.dart';
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
      screen: const FootAndMouthDetail(),
    ),
    DiseaseItem(
      title: 'Displaced Abomasum in Cattle',
      animal: 'Cattle',
      severity: 'Medium',
      severityColor: const Color(0xFFFFA000),
      icon: Icons.tab_unselected_sharp,
      category: 'Cattle',
      description: 'Abomasum displaces from its normal position, common post-calving.',
      screen: const DisplacedAbomasumDetail(),
    ),
    DiseaseItem(
      title: 'White Muscle Disease',
      animal: 'Cattle, Sheep',
      severity: 'Medium',
      severityColor: const Color(0xFFFFA000),
      icon: Icons.fitness_center_rounded,
      category: 'Small Ruminants',
      description: 'Nutritional muscular dystrophy caused by selenium/vitamin E deficiency.',
      screen: const WhiteMuscleDiseaseDetail(),
    ),
    DiseaseItem(
      title: 'Newcastle Disease',
      animal: 'Poultry',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.coronavirus_rounded,
      category: 'Poultry',
      description: 'Contagious viral disease causing respiratory and nervous symptoms in birds.',
      screen: const NewcastleDiseaseDetail(),
    ),
    DiseaseItem(
      title: 'Mastitis',
      animal: 'Cattle, Goats',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.water_drop_rounded,
      category: 'Cattle',
      description: 'Inflammation of the mammary gland, impacting milk production.',
      screen: const MastitisDetail(),
    ),
    DiseaseItem(
      title: 'African Swine Fever',
      animal: 'Swine',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.warning_rounded,
      category: 'Swine',
      description: 'Highly contagious viral hemorrhagic fever with high mortality rates.',
      screen: const AfricanSwineFeverDetail(),
    ),
    DiseaseItem(
      title: 'Coccidiosis',
      animal: 'Poultry, Cattle',
      severity: 'Medium',
      severityColor: const Color(0xFFFFA000),
      icon: Icons.bug_report_rounded,
      category: 'Poultry',
      description: 'Parasitic disease affecting the intestinal tract of animals.',
      screen: const CoccidiosisDetail(),
    ),
    DiseaseItem(
      title: 'Brucellosis',
      animal: 'Cattle, Goats, Pigs',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.coronavirus_rounded,
      category: 'Cattle',
      description: 'Zoonotic bacterial disease causing reproductive failure in livestock.',
      screen: const BrucellosisDetail(),
    ),
    DiseaseItem(
      title: 'Peste des Petits Ruminants',
      animal: 'Sheep, Goats,Rabbits',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.coronavirus_rounded,
      category: 'Small Ruminants',
      description: 'Viral disease causing fever, sores, and high mortality in small ruminants.',
      screen: const PPRDetail(),
    ),
      DiseaseItem(
    title: 'Vibriosis (Campylobacter)',
    animal: 'Cattle',
    severity: 'High',
    severityColor: const Color(0xFFE53935),
    icon: Icons.bug_report_rounded,
    category: 'Reproductive',
    description: 'A bacterial venereal disease causing infertility, early embryonic death, and prolonged calving intervals in cows.',
    screen: const VibriosisDetail(),
  ),
  DiseaseItem(
    title: 'Acetonaemia (Ketosis)',
    animal: 'Cattle',
    severity: 'Medium',
    severityColor: const Color(0xFFFFA000),
    icon: Icons.bloodtype_rounded,
    category: 'Metabolic',
    description: 'A metabolic disorder in high-producing dairy cows occurring after calving due to a negative energy balance and high ketone levels.',
    screen: const _PlaceholderDetailScreen(title: 'Acetonaemia'),
  ),
  DiseaseItem(
    title: 'Acon Poisoning',
    animal: 'Cattle',
    severity: 'High',
    severityColor: const Color(0xFFE53935),
    icon: Icons.local_florist_rounded,
    category: 'Toxicology',
    description: 'Toxicosis caused by ingesting poisonous plants containing alkaloids, leading to severe gastrointestinal and neurological distress.',
    screen: const _PlaceholderDetailScreen(title: 'Acon Poisoning'),
  ),
  DiseaseItem(
    title: 'Anaplasmosis',
    animal: 'Cattle',
    severity: 'High',
    severityColor: const Color(0xFFE53935),
    icon: Icons.bug_report_rounded,
    category: 'Blood',
    description: 'An infectious blood disease transmitted by ticks that destroys red blood cells, causing severe anemia, fever, and jaundice.',
    screen: const _PlaceholderDetailScreen(title: 'Anaplasmosis'),
  ),
  DiseaseItem(
    title: 'Anthrax',
    animal: 'Cattle',
    severity: 'High',
    severityColor: const Color(0xFFE53935),
    icon: Icons.warning_amber_rounded,
    category: 'Bacterial',
    description: 'A highly fatal zoonotic bacterial disease that often causes sudden death without prior symptoms, characterized by bleeding from body orifices.',
    screen: const _PlaceholderDetailScreen(title: 'Anthrax'),
  ),
  DiseaseItem(
    title: 'Bloat in Cattle',
    animal: 'Cattle',
    severity: 'High',
    severityColor: const Color(0xFFE53935),
    icon: Icons.circle_outlined,
    category: 'Digestive',
    description: 'A deadly digestive disorder where excess gas builds up in the rumen, causing severe left-sided abdominal distension and breathing difficulty.',
    screen: const _PlaceholderDetailScreen(title: 'Bloat in Cattle'),
  ),
      DiseaseItem(
      title: 'Nagana (Sleeping Sickness)',
      animal: 'Cattle',
      severity: 'High',
      severityColor: const Color(0xFFE53935),
      icon: Icons.pest_control_rounded,
      category: 'Parasitic',
      description: 'A parasitic disease transmitted by tsetse flies causing severe anemia, fever, weight loss, and extreme lethargy in livestock.',
      screen: const NaganaDetail(),
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
      backgroundColor: const Color(0xFFF5F5F5),
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
      color: const Color(0xFF2E7D32),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _iconCircle(icon: Icons.arrow_back_rounded, onTap: () => Navigator.pop(context)),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Animal Diseases',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Comprehensive disease database',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildPromoBanners() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _promoCard(
              icon: Icons.biotech_rounded,
              title: 'Know Diseases',
              subtitle: 'Learn & prevent',
              color: const Color(0xFF2E7D32),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            hintText: 'Search diseases, symptoms, animals...',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9CA3AF), size: 20),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isActive = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
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
                cat,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiseaseList() {
    final diseases = _filteredDiseases;
    if (diseases.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No diseases found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try a different search or category',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: diseases.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => DiseaseCard(item: diseases[index]),
    );
  }
}

// ═══════════════════════════════════════
//  DISEASE CARD - Clean, flat, professional
// ═══════════════════════════════════════
class DiseaseCard extends StatelessWidget {
  final DiseaseItem item;
  const DiseaseCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item.screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.severityColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                color: item.severityColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.pets_rounded, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        item.animal,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.severityColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.severity,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: item.severityColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
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
  final Widget screen;

  const DiseaseItem({
    required this.title,
    required this.animal,
    required this.severity,
    required this.severityColor,
    required this.icon,
    required this.category,
    required this.description,
    required this.screen,
  });
}

// ═══════════════════════════════════════
//  PLACEHOLDER SCREEN
// ═══════════════════════════════════════
class _PlaceholderDetailScreen extends StatelessWidget {
  final String title;
  const _PlaceholderDetailScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_information_rounded, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Disease details coming soon',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}