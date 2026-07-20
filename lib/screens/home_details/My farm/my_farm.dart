import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyFarmScreen extends StatefulWidget {
  const MyFarmScreen({super.key});

  @override
  State<MyFarmScreen> createState() => _MyFarmScreenState();
}

class _MyFarmScreenState extends State<MyFarmScreen> {
  // Sample farm data - In real app, this would come from a database
  final List<Farm> _farms = [
    Farm(
      id: '1',
      name: 'Green Valley Farm',
      location: 'Wakiso, Uganda',
      established: '2018',
      size: '50 acres',
      owner: 'John Mukasa',
      animals: [
        AnimalCategory('Cattle', 45, 'assets/cattle.png'),
        AnimalCategory('Goats', 30, 'assets/goat.png'),
        AnimalCategory('Poultry', 200, 'assets/poultry.png'),
        AnimalCategory('Pigs', 15, 'assets/pig.png'),
      ],
      workers: [
        Worker('Peter Okello', 'Farm Manager', '+256 772 123 456'),
        Worker('Sarah Namukasa', 'Animal Health Specialist', '+256 775 234 567'),
        Worker('James Muwonge', 'Farm Attendant', '+256 782 345 678'),
      ],
      coordinates: '0.3136° N, 32.5811° E',
      description: 'A modern mixed farm specializing in dairy and poultry production.',
      facilities: ['Barn', 'Milking Parlor', 'Poultry House', 'Store'],
    ),
  ];

  int _selectedFarmIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'My Farm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F36),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _navigateToCreateFarm(context),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Farm'),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: _farms.isEmpty
          ? _buildEmptyState()
          : _buildFarmContent(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.agriculture_rounded,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Farm Registered',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Get started by creating your first farm',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToCreateFarm(context),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Create Farm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      MaterialPageRoute(
        builder: (context) => const CreateFarmScreen(),
      ),
    ).then((result) {
      if (result != null && result is Farm) {
        setState(() {
          _farms.add(result);
          _selectedFarmIndex = _farms.length - 1;
        });
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.storefront_rounded,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      farm.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF2E7D32), const Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
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
                        Icon(Icons.location_on_rounded, color: Colors.white70, size: 14),
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
                          Icon(Icons.gps_fixed_rounded, color: Colors.white70, size: 12),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
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
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('Total Animals', _getTotalAnimals(farm).toString(), Icons.pets_rounded),
              _statItem('Workers', farm.workers.length.toString(), Icons.people_rounded),
              _statItem('Categories', farm.animals.length.toString(), Icons.category_rounded),
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
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimalSection(Farm farm) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
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
                    color: const Color(0xFF2E7D32).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.pets_rounded,
                    size: 16,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Animal Inventory',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddAnimalDialog(context),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add Animal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFE8E8E8)),
          
          // Animal List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: farm.animals.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE8E8E8)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getAnimalIcon(animal.name),
              size: 22,
              color: const Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              animal.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1F36),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${animal.count}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey[400],
            size: 20,
          ),
        ],
      ),
    );
  }

  IconData _getAnimalIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cattle':
        return Icons.pets_rounded;
      case 'goats':
        return Icons.grass_rounded;
      case 'poultry':
        return Icons.egg_rounded;
      case 'pigs':
        return Icons.set_meal_rounded;
      case 'sheep':
        return Icons.agriculture_rounded;
      case 'fish':
        return Icons.water_drop_rounded;
      default:
        return Icons.pets_rounded;
    }
  }

  Widget _buildWorkersSection(Farm farm) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
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
                    color: const Color(0xFF2E7D32).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.people_rounded,
                    size: 16,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Farm Workers',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddWorkerDialog(context),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add Worker'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFE8E8E8)),
          
          // Worker List
          farm.workers.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No workers registered yet',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: farm.workers.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE8E8E8)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                worker.name.split(' ').map((w) => w[0]).take(2).join(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.work_rounded, color: Colors.grey[400], size: 12),
                    const SizedBox(width: 4),
                    Text(
                      worker.role,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.phone_rounded, color: Colors.grey[400], size: 12),
                    const SizedBox(width: 4),
                    Text(
                      worker.phone,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.more_vert_rounded,
            color: Colors.grey[400],
            size: 20,
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

  void _showAddAnimalDialog(BuildContext context) {
    final countController = TextEditingController();
    String selectedType = 'Cattle';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets_rounded,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Add Animals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: const InputDecoration(
                labelText: 'Animal Type *',
                border: OutlineInputBorder(),
              ),
              items: const [
                'Cattle',
                'Goats',
                'Sheep',
                'Pigs',
                'Poultry',
                'Fish',
                'Rabbits',
                'Other'
              ].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                selectedType = value ?? 'Cattle';
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: countController,
              decoration: const InputDecoration(
                labelText: 'Number of Animals *',
                hintText: 'Enter count',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (countController.text.isNotEmpty) {
                final count = int.tryParse(countController.text) ?? 0;
                if (count > 0) {
                  setState(() {
                    final farm = _farms[_selectedFarmIndex];
                    final existing = farm.animals
                        .firstWhere((a) => a.name == selectedType,
                            orElse: () => AnimalCategory(selectedType, 0, ''));
                    
                    if (existing.name.isNotEmpty) {
                      // Update existing category
                      existing.count += count;
                    } else {
                      // Add new category
                      farm.animals.add(
                        AnimalCategory(selectedType, count, ''),
                      );
                    }
                  });
                  
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Animals added successfully'),
                      backgroundColor: Color(0xFF2E7D32),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Animals'),
          ),
        ],
      ),
    );
  }

  void _showAddWorkerDialog(BuildContext context) {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_add_rounded,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Add Worker',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                hintText: 'Enter worker name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: 'Role *',
                hintText: 'e.g., Farm Manager',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number *',
                hintText: 'e.g., +256 772 123 456',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  roleController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                setState(() {
                  _farms[_selectedFarmIndex].workers.add(
                    Worker(
                      nameController.text,
                      roleController.text,
                      phoneController.text,
                    ),
                  );
                });
                
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Worker added successfully'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Worker'),
          ),
        ],
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Create New Farm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F36),
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
                color: Color(0xFF2E7D32),
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
              _buildSectionHeader(Icons.info_outline_rounded, 'Basic Information'),
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
              _buildSectionHeader(Icons.location_on_rounded, 'Location Details'),
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
              _buildSectionHeader(Icons.business_center_rounded, 'Farm Facilities'),
              const SizedBox(height: 12),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableFacilities.map((facility) {
                    final isSelected = _selectedFacilities.contains(facility);
                    return FilterChip(
                      label: Text(
                        facility,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey[700],
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
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF2E7D32),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
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
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Create Farm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.image_rounded,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Farm Image',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1F36),
                ),
              ),
              const Spacer(),
              Text(
                'Optional',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
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
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
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
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to add farm image',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F36),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey[400],
          ),
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1F36),
          ),
          prefixIcon: Icon(
            icon,
            size: 20,
            color: const Color(0xFF2E7D32),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    } catch (e) {
      // Handle error
    }
  }

  void _saveFarm() {
    if (_formKey.currentState!.validate()) {
      final newFarm = Farm(
        id: DateTime.now().toString(),
        name: _nameController.text,
        location: _locationController.text,
        established: DateTime.now().year.toString(),
        size: _sizeController.text,
        owner: _ownerController.text,
        animals: [],
        workers: [],
        coordinates: _coordinatesController.text.isNotEmpty ? _coordinatesController.text : null,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        facilities: _selectedFacilities.isNotEmpty ? _selectedFacilities : null,
      );
      
      Navigator.pop(context, newFarm);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Farm created successfully!'),
          backgroundColor: Color(0xFF2E7D32),
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

// Updated Farm Model with new fields
class Farm {
  final String id;
  final String name;
  final String location;
  final String established;
  final String size;
  final String owner;
  List<AnimalCategory> animals;
  List<Worker> workers;
  final String? coordinates;
  final String? description;
  final List<String>? facilities;

  Farm({
    required this.id,
    required this.name,
    required this.location,
    required this.established,
    required this.size,
    required this.owner,
    required this.animals,
    required this.workers,
    this.coordinates,
    this.description,
    this.facilities,
  });
}

class AnimalCategory {
  final String name;
  int count;
  final String imagePath;

  AnimalCategory(this.name, this.count, this.imagePath);
}

class Worker {
  final String name;
  final String role;
  final String phone;

  Worker(this.name, this.role, this.phone);
}