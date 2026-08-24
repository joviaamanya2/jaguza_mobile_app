import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaguza_app/models/user.dart';
import 'package:jaguza_app/models/farm_model.dart';
import 'package:jaguza_app/services/api_service.dart';

class MyFarmScreen extends StatefulWidget {
  const MyFarmScreen({super.key});

  @override
  State<MyFarmScreen> createState() => _MyFarmScreenState();
}

class _MyFarmScreenState extends State<MyFarmScreen> {
  final List<Farm> _farms = [];
  int _selectedFarmIndex = 0;
  bool _isLoading = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser().then((_) => _loadFarms());
  }

  Future<void> _loadFarms() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.getFarms();
      final loadedFarms = <Farm>[];

      if (response is List) {
        for (final item in response) {
          if (item is Map) {
            final farmData = Map<String, dynamic>.from(item);
            final farm = Farm.fromJson(farmData);
            final farmOwnerId = farmData['user_id'] ?? farmData['owner_id'];
            final currentUserId = _currentUser?.id;

            if (currentUserId != null && farmOwnerId != null) {
              if (farmOwnerId.toString() == currentUserId.toString()) {
                loadedFarms.add(farm);
              }
            } else if (farm.owner.isNotEmpty || loadedFarms.isEmpty) {
              loadedFarms.add(farm);
            }
          }
        }
      }

      // Fetch workers for each farm directly from ApiService().getWorkers
      for (final farm in loadedFarms) {
        final farmId = int.tryParse(farm.id);
        if (farmId != null) {
          try {
            final workersData = await apiService.getWorkers(farmId: farmId);
            if (workersData.isNotEmpty) {
              final fetchedWorkers = workersData
                  .whereType<Map>()
                  .map((w) => Worker(
                        id: w['id']?.toString(),
                        name: w['name'] ?? '',
                        role: w['role'] ?? '',
                        phone: w['phone'] ?? w['phone_number'] ?? '',
                      ))
                  .toList();
              if (fetchedWorkers.isNotEmpty) {
                farm.workers = fetchedWorkers;
              }
            }
          } catch (e) {
            print('Workers fetch note for farm $farmId: $e');
          }
        }
      }

      if (!mounted) return;

      setState(() {
        _farms
          ..clear()
          ..addAll(loadedFarms);
        _isLoading = false;
        if (_farms.isNotEmpty && _selectedFarmIndex >= _farms.length) {
          _selectedFarmIndex = 0;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to load farms from the server: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final response = await ApiService().get('user');
      if (response is Map) {
        setState(() {
          _currentUser = User.fromJson(Map<String, dynamic>.from(response));
        });
      }
    } catch (_) {
      setState(() {
        _currentUser = null;
      });
    }
  }

  Future<void> _saveFarms() async {
    if (_farms.isEmpty) return;

    final farm = _farms[_selectedFarmIndex];

    try {
      final farmId = int.tryParse(farm.id);
      if (farmId != null) {
        await ApiService().updateFarm(farmId, farm.toApiPayload());
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Farm synced locally, but the server update failed: $e',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'My Farm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Add farm',
            onPressed: () => _navigateToCreateFarm(context),
            icon: Icon(Icons.add_rounded, color: scheme.onPrimary),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _farms.isEmpty
          ? _buildEmptyState()
          : _buildFarmContent(),
    );
  }

  Widget _buildEmptyState() {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.agriculture_rounded,
                size: 64,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Farm Registered',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Get started by creating your first farm',
              style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToCreateFarm(context),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Create Farm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateFarm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateFarmScreen()),
    ).then((result) async {
      if (result != null && result is Farm) {
        if (!mounted) return;
        setState(() {
          _farms.add(result);
          _selectedFarmIndex = _farms.length - 1;
        });
        await _saveFarms();
      }
    });
  }

  Widget _buildFarmContent() {
    final farm = _farms[_selectedFarmIndex];

    return Column(
      children: [
        // Farm Selector
        _buildFarmSelector(),

        // Farm Overview Card
        _buildFarmOverviewCard(farm),

        const SizedBox(height: 16),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            child: Column(
              children: [
                // Animal Categories
                _buildAnimalSection(farm),

                const SizedBox(height: 16),

                // Workers Section
                _buildWorkersSection(farm),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFarmSelector() {
    if (_farms.length <= 1) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _farms.asMap().entries.map((entry) {
            final index = entry.key;
            final farm = entry.value;
            final isSelected = _selectedFarmIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFarmIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? scheme.primary : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? scheme.primary
                        : scheme.outlineVariant,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.storefront_rounded,
                      size: 16,
                      color: isSelected ? Colors.white : scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      farm.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : scheme.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFarmOverviewCard(Farm farm) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (farm.imagePath != null && farm.imagePath!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(farm.imagePath!),
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 140,
                  color: Colors.white24,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farm.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            farm.location,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (farm.coordinates != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.gps_fixed_rounded,
                            color: Colors.white70,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            farm.coordinates!,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  farm.size,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit') _editFarm(farm);
                  if (value == 'delete') _deleteFarm(farm);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit farm')),
                  PopupMenuItem(value: 'delete', child: Text('Delete farm')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(
                'Total Animals',
                _getTotalAnimals(farm).toString(),
                Icons.pets_rounded,
              ),
              _statItem(
                'Workers',
                farm.workers.length.toString(),
                Icons.people_rounded,
              ),
              _statItem(
                'Categories',
                farm.animals.length.toString(),
                Icons.category_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 14),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildAnimalSection(Farm farm) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.pets_rounded,
                    size: 16,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Animal Inventory',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddAnimalDialog(context),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add Animal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: scheme.outlineVariant),

          // Animal List
          farm.animals.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No animals registered yet',
                      style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: farm.animals.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: scheme.outlineVariant),
                  itemBuilder: (context, index) {
                    final animal = farm.animals[index];
                    return _buildAnimalTile(animal);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildAnimalTile(AnimalCategory animal) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getAnimalIcon(animal.name),
              size: 22,
              color: scheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              animal.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${animal.count}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: scheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: scheme.onSurfaceVariant, size: 20),
            onSelected: (value) {
              if (value == 'edit') _editAnimal(animal);
              if (value == 'delete') _deleteAnimal(animal);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit animals')),
              PopupMenuItem(value: 'delete', child: Text('Delete animals')),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getAnimalIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cattle':
      case 'cow':
        return Icons.pets_rounded;
      case 'goats':
      case 'goat':
        return Icons.grass_rounded;
      case 'poultry':
      case 'chicken':
        return Icons.egg_rounded;
      case 'pigs':
      case 'pig':
        return Icons.set_meal_rounded;
      case 'sheep':
        return Icons.agriculture_rounded;
      case 'rabbits':
      case 'rabbit':
        return Icons.cruelty_free_rounded;
      case 'fish':
        return Icons.water_drop_rounded;
      case 'horses':
      case 'horse':
        return Icons.bedroom_baby_rounded;
      default:
        return Icons.pets_rounded;
    }
  }

  Widget _buildWorkersSection(Farm farm) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.people_rounded,
                    size: 16,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Farm Workers',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddWorkerDialog(context),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add Worker'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: scheme.outlineVariant),

          // Worker List
          farm.workers.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No workers registered yet',
                      style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: farm.workers.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: scheme.outlineVariant),
                  itemBuilder: (context, index) {
                    final worker = farm.workers[index];
                    return _buildWorkerTile(worker);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildWorkerTile(Worker worker) {
    final scheme = Theme.of(context).colorScheme;
    final initials = worker.name.trim().isNotEmpty
        ? worker.name.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase()
        : 'W';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.work_rounded, color: scheme.onSurfaceVariant, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      worker.role,
                      style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.phone_rounded,
                      color: scheme.onSurfaceVariant,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      worker.phone,
                      style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: scheme.onSurfaceVariant, size: 20),
            onSelected: (value) {
              if (value == 'edit') _editWorker(worker);
              if (value == 'delete') _deleteWorker(worker);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit worker')),
              PopupMenuItem(value: 'delete', child: Text('Delete worker')),
            ],
          ),
        ],
      ),
    );
  }

  int _getTotalAnimals(Farm farm) {
    int total = 0;
    for (var animal in farm.animals) {
      total += animal.count;
    }
    return total;
  }

  Future<bool> _confirm(String title, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: FilledButton.styleFrom(backgroundColor: Theme.of(dialogContext).colorScheme.error),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _editFarm(Farm farm) async {
    final name = TextEditingController(text: farm.name);
    final location = TextEditingController(text: farm.location);
    final size = TextEditingController(text: farm.size);
    final changed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit farm'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Farm name')),
            TextField(controller: location, decoration: const InputDecoration(labelText: 'Location')),
            TextField(controller: size, decoration: const InputDecoration(labelText: 'Size')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Save')),
        ],
      ),
    ) ?? false;
    if (!changed || !mounted) return;
    try {
      final id = int.tryParse(farm.id);
      if (id == null) throw Exception('This farm has no valid server ID.');
      await ApiService().updateFarm(id, {
        'name': name.text.trim(),
        'location': location.text.trim(),
        'size': size.text.trim(),
      });
      await _loadFarms();
    } catch (e) {
      if (mounted) _showMessage('Failed to edit farm: $e', error: true);
    }
  }

  Future<void> _deleteFarm(Farm farm) async {
    if (!await _confirm('Delete farm?', 'This will also remove its farm records.')) return;
    try {
      final id = int.tryParse(farm.id);
      if (id == null) throw Exception('This farm has no valid server ID.');
      await ApiService().deleteFarm(id);
      await _loadFarms();
    } catch (e) {
      if (mounted) _showMessage('Failed to delete farm: $e', error: true);
    }
  }

  String _apiAnimalType(String type) {
    const values = {
      'cattle': 'cattle', 'goats': 'goat', 'goat': 'goat',
      'sheep': 'sheep', 'pigs': 'pig', 'pig': 'pig',
      'poultry': 'poultry', 'rabbits': 'rabbit', 'rabbit': 'rabbit',
      'horse': 'horse', 'fish': 'other', 'other': 'other',
    };
    return values[type.toLowerCase()] ?? 'other';
  }

  Future<void> _editAnimal(AnimalCategory animal) async {
    final count = TextEditingController(text: animal.count.toString());
    String selectedType = animal.name;
    final changed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit animals'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<String>(
            initialValue: ['Cattle', 'Goats', 'Sheep', 'Pigs', 'Poultry', 'Rabbits', 'Other'].contains(selectedType) ? selectedType : 'Other',
            items: const ['Cattle', 'Goats', 'Sheep', 'Pigs', 'Poultry', 'Rabbits', 'Other']
                .map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
            onChanged: (value) => selectedType = value ?? selectedType,
            decoration: const InputDecoration(labelText: 'Animal type'),
          ),
          TextField(controller: count, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Number')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Save')),
        ],
      ),
    ) ?? false;
    if (!changed || !mounted) return;
    final newCount = int.tryParse(count.text) ?? 0;
    if (newCount < 1) {
      _showMessage('Enter a valid animal count.', error: true);
      return;
    }
    try {
      final farm = _farms[_selectedFarmIndex];
      final farmId = int.tryParse(farm.id);
      if (farmId == null || animal.ids.isEmpty) throw Exception('Animal records have no server IDs. Refresh the farm and try again.');
      final type = _apiAnimalType(selectedType);
      final ids = [...animal.ids];
      for (final id in ids.take(newCount)) {
        await ApiService().updateAnimal(int.parse(id), {'type': type, 'farm_id': farmId});
      }
      if (newCount > ids.length) {
        for (var i = ids.length; i < newCount; i++) {
          final created = await ApiService().createAnimal({
            'identification_number': '${type}_${DateTime.now().millisecondsSinceEpoch}_$i',
            'type': type, 'breed': 'Unknown', 'gender': 'male', 'age': 0,
            'health_status': 'healthy', 'farm_id': farmId,
          });
          if (created is Map && created['id'] != null) ids.add(created['id'].toString());
        }
      } else if (newCount < ids.length) {
        for (final id in ids.skip(newCount)) {
          await ApiService().deleteAnimal(int.parse(id));
        }
        ids.removeRange(newCount, ids.length);
      }
      await _loadFarms();
    } catch (e) {
      if (mounted) _showMessage('Failed to edit animals: $e', error: true);
    }
  }

  Future<void> _deleteAnimal(AnimalCategory animal) async {
    if (!await _confirm('Delete animals?', 'Delete all ${animal.count} ${animal.name} records?')) return;
    try {
      if (animal.ids.isNotEmpty) {
        for (final id in animal.ids) {
          final intId = int.tryParse(id);
          if (intId != null) await ApiService().deleteAnimal(intId);
        }
      }
      if (mounted) {
        setState(() {
          _farms[_selectedFarmIndex].animals.removeWhere((a) => a.name.toLowerCase() == animal.name.toLowerCase());
        });
        _showMessage('Animals deleted successfully!');
      }
    } catch (e) {
      if (mounted) _showMessage('Failed to delete animals: $e', error: true);
    }
  }

  Future<void> _editWorker(Worker worker) async {
    final name = TextEditingController(text: worker.name);
    final role = TextEditingController(text: worker.role);
    final phone = TextEditingController(text: worker.phone);
    bool isSubmitting = false;

    final changed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit worker'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: name, enabled: !isSubmitting, decoration: const InputDecoration(labelText: 'Full name')),
            TextField(controller: role, enabled: !isSubmitting, decoration: const InputDecoration(labelText: 'Role')),
            TextField(controller: phone, enabled: !isSubmitting, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone')),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    ) ?? false;

    if (!changed || !mounted) return;
    try {
      final id = int.tryParse(worker.id ?? '');
      if (id != null) {
        await ApiService().updateWorker(id, {
          'name': name.text.trim(),
          'role': role.text.trim(),
          'phone': phone.text.trim(),
        });
      }
      await _loadFarms();
    } catch (e) {
      if (mounted) _showMessage('Failed to edit worker: $e', error: true);
    }
  }

  Future<void> _deleteWorker(Worker worker) async {
    if (!await _confirm('Delete worker?', 'Remove ${worker.name} from this farm?')) return;
    try {
      final id = int.tryParse(worker.id ?? '');
      if (id != null) {
        await ApiService().deleteWorker(id);
      }
      if (mounted) {
        setState(() {
          _farms[_selectedFarmIndex].workers.removeWhere((w) => w.id == worker.id || w.name == worker.name);
        });
        _showMessage('Worker removed successfully!');
      }
    } catch (e) {
      if (mounted) _showMessage('Failed to delete worker: $e', error: true);
    }
  }

  void _showMessage(String message, {bool error = false}) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? scheme.error : scheme.primary,
    ));
  }

  void _showAddAnimalDialog(BuildContext context) {
    if (_farms.isEmpty) {
      _showMessage('Please create or select a farm first.', error: true);
      return;
    }

    final countController = TextEditingController(text: '1');
    final tagController = TextEditingController();
    final breedController = TextEditingController();
    final ageController = TextEditingController();

    String selectedType = 'Cattle';
    String selectedGender = 'male';
    String selectedHealth = 'healthy';
    bool isBatchMode = true;
    bool isSubmitting = false;
    String? errorMessage;

    final scheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: !isSubmitting,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pets_rounded,
                    color: scheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Add Animal Record',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: scheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: scheme.onErrorContainer, fontSize: 12),
                      ),
                    ),
                  ],

                  // Mode Chips
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Batch Count'),
                          selected: isBatchMode,
                          onSelected: isSubmitting
                              ? null
                              : (selected) {
                                  if (selected) {
                                    setDialogState(() {
                                      isBatchMode = true;
                                      errorMessage = null;
                                    });
                                  }
                                },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Single Animal'),
                          selected: !isBatchMode,
                          onSelected: isSubmitting
                              ? null
                              : (selected) {
                                  if (selected) {
                                    setDialogState(() {
                                      isBatchMode = false;
                                      errorMessage = null;
                                    });
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Animal Type *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category_rounded, size: 20),
                    ),
                    items: const [
                      'Cattle',
                      'Goats',
                      'Sheep',
                      'Pigs',
                      'Poultry',
                      'Rabbits',
                      'Fish',
                      'Horses',
                      'Other',
                    ].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                    onChanged: isSubmitting
                        ? null
                        : (value) {
                            if (value != null) {
                              setDialogState(() {
                                selectedType = value;
                              });
                            }
                          },
                  ),
                  const SizedBox(height: 12),

                  if (isBatchMode) ...[
                    TextFormField(
                      controller: countController,
                      enabled: !isSubmitting,
                      decoration: const InputDecoration(
                        labelText: 'Number of Animals *',
                        hintText: 'e.g. 5',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers_rounded, size: 20),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ] else ...[
                    TextFormField(
                      controller: tagController,
                      enabled: !isSubmitting,
                      decoration: const InputDecoration(
                        labelText: 'Tag / ID (Optional)',
                        hintText: 'e.g., COW-102',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.qr_code_rounded, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: breedController,
                      enabled: !isSubmitting,
                      decoration: const InputDecoration(
                        labelText: 'Breed (Optional)',
                        hintText: 'e.g., Friesian, Ankole',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.pets_rounded, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedGender,
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'male', child: Text('Male')),
                              DropdownMenuItem(value: 'female', child: Text('Female')),
                            ],
                            onChanged: isSubmitting
                                ? null
                                : (val) {
                                    if (val != null) setDialogState(() => selectedGender = val);
                                  },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: ageController,
                            enabled: !isSubmitting,
                            decoration: const InputDecoration(
                              labelText: 'Age (Years)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedHealth,
                      decoration: const InputDecoration(
                        labelText: 'Health Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'healthy', child: Text('Healthy')),
                        DropdownMenuItem(value: 'sick', child: Text('Sick')),
                        DropdownMenuItem(value: 'treatment', child: Text('Under Treatment')),
                        DropdownMenuItem(value: 'quarantine', child: Text('Quarantine')),
                        DropdownMenuItem(value: 'recovering', child: Text('Recovering')),
                      ],
                      onChanged: isSubmitting
                          ? null
                          : (val) {
                              if (val != null) setDialogState(() => selectedHealth = val);
                            },
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(dialogContext),
                child: Text('Cancel', style: TextStyle(color: scheme.onSurfaceVariant)),
              ),
              ElevatedButton(
                onPressed: isSubmitting ? null : () async {
                  final count = isBatchMode ? (int.tryParse(countController.text.trim()) ?? 0) : 1;
                  if (count < 1) {
                    setDialogState(() {
                      errorMessage = 'Please enter a valid count (at least 1).';
                    });
                    return;
                  }

                  setDialogState(() {
                    isSubmitting = true;
                    errorMessage = null;
                  });

                  try {
                    final farm = _farms[_selectedFarmIndex];
                    final farmId = int.tryParse(farm.id);
                    final createdIds = <String>[];
                    final apiType = _apiAnimalType(selectedType);

                    if (farmId != null) {
                      if (isBatchMode) {
                        for (int i = 0; i < count; i++) {
                          final created = await ApiService().createAnimal({
                            'identification_number': '${apiType}_${DateTime.now().millisecondsSinceEpoch}_$i',
                            'type': apiType,
                            'breed': 'Unknown',
                            'gender': 'male',
                            'age': 0,
                            'health_status': 'healthy',
                            'farm_id': farmId,
                          });
                          if (created is Map) {
                            final id = created['id'] ?? (created['data'] is Map ? created['data']['id'] : null);
                            if (id != null) createdIds.add(id.toString());
                          }
                        }
                      } else {
                        final tag = tagController.text.trim().isNotEmpty
                            ? tagController.text.trim()
                            : '${apiType}_${DateTime.now().millisecondsSinceEpoch}';
                        final created = await ApiService().createAnimal({
                          'identification_number': tag,
                          'type': apiType,
                          'breed': breedController.text.trim().isNotEmpty ? breedController.text.trim() : 'Unknown',
                          'gender': selectedGender,
                          'age': int.tryParse(ageController.text.trim()) ?? 0,
                          'health_status': selectedHealth,
                          'farm_id': farmId,
                        });
                        if (created is Map) {
                          final id = created['id'] ?? (created['data'] is Map ? created['data']['id'] : null);
                          if (id != null) createdIds.add(id.toString());
                        }
                      }
                    }

                    final normalizedCatName = Farm.normalizeCategoryName(selectedType);
                    if (mounted) {
                      setState(() {
                        final currentFarm = _farms[_selectedFarmIndex];
                        final existingIndex = currentFarm.animals.indexWhere(
                          (a) => a.name.toLowerCase() == normalizedCatName.toLowerCase(),
                        );

                        if (existingIndex != -1) {
                          currentFarm.animals[existingIndex].count += count;
                          currentFarm.animals[existingIndex].ids.addAll(createdIds);
                        } else {
                          currentFarm.animals.add(
                            AnimalCategory(normalizedCatName, count, '', ids: createdIds),
                          );
                        }
                      });
                    }

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }

                    if (mounted) {
                      _showMessage('$selectedType added successfully!');
                    }
                  } catch (e) {
                    setDialogState(() {
                      isSubmitting = false;
                      errorMessage = 'Failed to add animal: $e';
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(isBatchMode ? 'Add Animals' : 'Add Single Animal'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddWorkerDialog(BuildContext context) {
    if (_farms.isEmpty) {
      _showMessage('Please create or select a farm first.', error: true);
      return;
    }

    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    bool isSubmitting = false;
    String? errorMessage;

    final presetRoles = [
      'Farm Manager',
      'Herdsman',
      'Veterinary Tech',
      'Feeder',
      'Milker',
      'General Worker',
    ];

    final scheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: !isSubmitting,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_add_rounded,
                    color: scheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Add Worker',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: scheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: scheme.onErrorContainer, fontSize: 12),
                      ),
                    ),
                  ],

                  TextFormField(
                    controller: nameController,
                    enabled: !isSubmitting,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      hintText: 'e.g. John Okello',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: roleController,
                    enabled: !isSubmitting,
                    decoration: const InputDecoration(
                      labelText: 'Role / Position *',
                      hintText: 'e.g. Farm Manager',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: presetRoles.map((role) {
                      final isSelected = roleController.text == role;
                      return ChoiceChip(
                        label: Text(role, style: const TextStyle(fontSize: 11)),
                        selected: isSelected,
                        onSelected: isSubmitting
                            ? null
                            : (_) {
                                setDialogState(() {
                                  roleController.text = role;
                                });
                              },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: phoneController,
                    enabled: !isSubmitting,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number *',
                      hintText: 'e.g., +256 772 123 456',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_rounded, size: 20),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: emailController,
                    enabled: !isSubmitting,
                    decoration: const InputDecoration(
                      labelText: 'Email Address (Optional)',
                      hintText: 'e.g., john@example.com',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_rounded, size: 20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(dialogContext),
                child: Text('Cancel', style: TextStyle(color: scheme.onSurfaceVariant)),
              ),
              ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        final name = nameController.text.trim();
                        final role = roleController.text.trim();
                        final phone = phoneController.text.trim();
                        final email = emailController.text.trim();

                        if (name.isEmpty || role.isEmpty || phone.isEmpty) {
                          setDialogState(() {
                            errorMessage = 'Please fill in Name, Role, and Phone Number.';
                          });
                          return;
                        }

                        setDialogState(() {
                          isSubmitting = true;
                          errorMessage = null;
                        });

                        try {
                          final farm = _farms[_selectedFarmIndex];
                          final farmId = int.tryParse(farm.id);
                          String? newWorkerId;

                          if (farmId != null) {
                            final created = await ApiService().createWorker({
                              'farm_id': farmId,
                              'name': name,
                              'role': role,
                              'phone': phone,
                              if (email.isNotEmpty) 'email': email,
                            });

                            if (created is Map) {
                              final directId = created['id'];
                              final nested = created['data'];
                              final nestedId = nested is Map ? nested['id'] : null;
                              newWorkerId = (directId ?? nestedId)?.toString();
                            }
                          }

                          if (mounted) {
                            setState(() {
                              _farms[_selectedFarmIndex].workers.add(
                                    Worker(
                                      id: newWorkerId,
                                      name: name,
                                      role: role,
                                      phone: phone,
                                    ),
                                  );
                            });
                          }

                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          }

                          if (mounted) {
                            _showMessage('Worker added successfully!');
                          }
                        } catch (e) {
                          setDialogState(() {
                            isSubmitting = false;
                            errorMessage = 'Failed to add worker: $e';
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Add Worker'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// CREATE FARM FULL SCREEN FORM
class CreateFarmScreen extends StatefulWidget {
  const CreateFarmScreen({super.key});

  @override
  State<CreateFarmScreen> createState() => _CreateFarmScreenState();
}

class _CreateFarmScreenState extends State<CreateFarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _sizeController = TextEditingController();
  final _ownerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coordinatesController = TextEditingController();

  final List<String> _selectedFacilities = [];
  File? _farmImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _availableFacilities = [
    'Barn',
    'Milking Parlor',
    'Poultry House',
    'Store',
    'Silo',
    'Greenhouse',
    'Irrigation System',
    'Fencing',
    'Water Tanks',
    'Solar Panels',
    'Processing Unit',
    'Office',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Create New Farm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveFarm,
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Farm Image
              _buildImageSection(),

              const SizedBox(height: 20),

              // Basic Information
              _buildSectionHeader(
                Icons.info_outline_rounded,
                'Basic Information',
              ),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _nameController,
                label: 'Farm Name *',
                hint: 'Enter farm name',
                icon: Icons.storefront_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter farm name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _ownerController,
                label: 'Owner Name *',
                hint: 'Enter owner name',
                icon: Icons.person_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter owner name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Location Section
              _buildSectionHeader(
                Icons.location_on_rounded,
                'Location Details',
              ),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _locationController,
                label: 'Physical Location *',
                hint: 'e.g., Wakiso, Uganda',
                icon: Icons.location_city_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _coordinatesController,
                label: 'GPS Coordinates',
                hint: 'e.g., 0.3136° N, 32.5811° E',
                icon: Icons.gps_fixed_rounded,
              ),

              const SizedBox(height: 16),

              // Farm Details
              _buildSectionHeader(Icons.agriculture_rounded, 'Farm Details'),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _sizeController,
                label: 'Farm Size *',
                hint: 'e.g., 50 acres',
                icon: Icons.square_foot_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter farm size';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe your farm...',
                icon: Icons.description_rounded,
                maxLines: 4,
              ),

              const SizedBox(height: 24),

              // Facilities
              _buildSectionHeader(
                Icons.business_center_rounded,
                'Farm Facilities',
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableFacilities.map((facility) {
                    final scheme = Theme.of(context).colorScheme;
                    final isSelected = _selectedFacilities.contains(facility);
                    return FilterChip(
                      label: Text(
                        facility,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : scheme.onSurfaceVariant,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedFacilities.add(facility);
                          } else {
                            _selectedFacilities.remove(facility);
                          }
                        });
                      },
                      backgroundColor: Theme.of(context).cardColor,
                      selectedColor: scheme.primary,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected
                              ? scheme.primary
                              : scheme.outlineVariant,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveFarm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Create Farm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.image_rounded,
                color: scheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Farm Image',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                'Optional',
                style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: _farmImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _farmImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 40,
                          color: scheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to add farm image',
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: scheme.primary),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: scheme.onSurface,
          ),
          prefixIcon: Icon(icon, size: 20, color: scheme.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: scheme.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _farmImage = File(image.path);
        });
      }
    } catch (_) {}
  }

  Future<void> _saveFarm() async {
    if (!_formKey.currentState!.validate()) return;

    final newFarm = Farm(
      id: DateTime.now().toString(),
      name: _nameController.text,
      location: _locationController.text,
      established: DateTime.now().year.toString(),
      size: _sizeController.text,
      owner: _ownerController.text,
      animals: [],
      workers: [],
      coordinates: _coordinatesController.text.isNotEmpty
          ? _coordinatesController.text
          : null,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
      facilities: _selectedFacilities.isNotEmpty ? _selectedFacilities : null,
      imagePath: _farmImage?.path,
    );

    try {
      final response = await ApiService().createFarm(
        newFarm.toApiPayload(),
        imageFile: _farmImage,
      );
      final createdFarm = response is Map
          ? Farm.fromJson(Map<String, dynamic>.from(response))
          : newFarm;

      if (!mounted) return;

      final scheme = Theme.of(context).colorScheme;
      Navigator.pop(context, createdFarm);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Farm created successfully and registered in dashboard!',
          ),
          backgroundColor: scheme.primary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Farm could not be saved: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _sizeController.dispose();
    _ownerController.dispose();
    _descriptionController.dispose();
    _coordinatesController.dispose();
    super.dispose();
  }
}
