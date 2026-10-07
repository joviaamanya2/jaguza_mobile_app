import 'package:flutter/material.dart';
import 'package:jaguza_app/services/api_service.dart';
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

  List<DiseaseItem> _allDiseases = [];
  bool _isLoading = true;
  String? _loadError;


  @override
  void initState() {
    super.initState();
    _loadBackendDiseases();
  }

  Future<void> _loadBackendDiseases() async {
    try {
      final records = await ApiService().getDiseases();
      final diseases = records.whereType<Map>().map((raw) {
        final disease = Map<String, dynamic>.from(raw);
        final severity = '${disease['severity'] ?? 'medium'}'.toLowerCase();
        final species = '${disease['species_affected'] ?? 'Livestock'}';
        final category = _diseaseCategory(species);
        return DiseaseItem(
          title: '${disease['name'] ?? 'Disease'}',
          animal: species,
          severity: _titleCase(severity),
          severityColor: _severityColor(severity),
          icon: Icons.medical_information_rounded,
          category: category,
          description: '${disease['description'] ?? disease['symptoms'] ?? ''}',
            imageUrl: '${disease['thumbnail'] ?? ''}'.trim().isEmpty
              ? null
              : '${disease['thumbnail']}',
          screen: _ApiDiseaseDetailScreen(disease: disease),
        );
      }).toList();
      if (mounted) {
        setState(() {
          _allDiseases
            ..clear()
            ..addAll(diseases);
          _isLoading = false;
          _loadError = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = 'Could not load diseases from the dashboard. Please try again.';
        });
      }
    }
  }

  String _diseaseCategory(String species) {
    final value = species.toLowerCase();
    if (value.contains('poultry') || value.contains('chicken') || value.contains('bird')) {
      return 'Poultry';
    }
    if (value.contains('pig') || value.contains('swine')) return 'Swine';
    if (value.contains('sheep') || value.contains('goat')) return 'Small Ruminants';
    return 'Cattle';
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'critical':
      case 'high':
        return const Color(0xFFE53935);
      case 'medium':
        return const Color(0xFFFFA000);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  String _titleCase(String value) => value.isEmpty
      ? value
      : '${value[0].toUpperCase()}${value.substring(1)}';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 8),
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

  Widget _buildSearchBar() {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
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
            hintText: 'Search diseases, symptoms, animals...',
            hintStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
            prefixIcon: Icon(Icons.search_rounded, color: scheme.onSurfaceVariant, size: 20),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final scheme = Theme.of(context).colorScheme;
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
                color: isActive ? scheme.primary : scheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isActive ? scheme.primary : scheme.outlineVariant,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isActive ? scheme.onPrimary : scheme.onSurfaceVariant,
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_loadError!, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: () {
            setState(() {
              _isLoading = true;
              _loadError = null;
            });
            _loadBackendDiseases();
          }, child: const Text('Retry')),
        ]),
      );
    }
    final diseases = _filteredDiseases;
    if (diseases.isEmpty) {
      final scheme = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: scheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              'No diseases found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try a different search or category',
              style: TextStyle(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
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
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item.screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outlineVariant),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.severityColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: item.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.imageUrl!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          item.icon,
                          color: item.severityColor,
                          size: 22,
                        ),
                      ),
                    )
                  : Icon(item.icon, color: item.severityColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.pets_rounded, size: 12, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        item.animal,
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurfaceVariant,
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
                    color: item.severityColor.withValues(alpha: 0.08),
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
                  color: scheme.onSurfaceVariant,
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
  final String? imageUrl;
  final Widget screen;

  const DiseaseItem({
    required this.title,
    required this.animal,
    required this.severity,
    required this.severityColor,
    required this.icon,
    required this.category,
    required this.description,
    this.imageUrl,
    required this.screen,
  });
}

// ═══════════════════════════════════════
//  PLACEHOLDER SCREEN
// ═══════════════════════════════════════
/// Detail view for catalog entries returned by the API. The fields mirror the
/// disease information shown in the admin dashboard.
class _ApiDiseaseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> disease;
  const _ApiDiseaseDetailScreen({required this.disease});

  @override
  Widget build(BuildContext context) {
    final name = '${disease['name'] ?? 'Disease'}';
    final fields = <(String, String)>[
      ('Description', '${disease['description'] ?? ''}'),
      ('Species affected', '${disease['species_affected'] ?? ''}'),
      ('Symptoms', '${disease['symptoms'] ?? ''}'),
      ('Treatment', '${disease['treatment'] ?? ''}'),
      ('Prevention', '${disease['prevention'] ?? ''}'),
      ('Severity', '${disease['severity'] ?? ''}'),
      ('Outbreak risk', '${disease['outbreak_risk'] ?? ''}'),
    ].where((field) => field.$2.trim().isNotEmpty && field.$2 != 'null').toList();
    final image = '${disease['thumbnail'] ?? ''}'.trim();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (image.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(image, height: 210, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            ),
            const SizedBox(height: 16),
          ],
          for (final field in fields)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(field.$1, style: TextStyle(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    )),
                    const SizedBox(height: 7),
                    Text(field.$2, style: TextStyle(
                      color: scheme.onSurface,
                      height: 1.45,
                    )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
