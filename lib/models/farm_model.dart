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
  final String? imagePath;

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
    this.imagePath,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    final location = json['location'] ?? json['farm_location'];
    final district = json['district']?.toString() ?? '';
    final country = json['country']?.toString() ?? '';
    final gpsLat = json['gps_lat']?.toString() ?? '';
    final gpsLon = json['gps_lon']?.toString() ?? '';

    return Farm(
      id: (json['id'] ?? json['farm_id'])?.toString() ?? '',
      name: json['name'] ?? json['farm_name'] ?? '',
      location: location?.toString() ??
          [district, country].where((part) => part.isNotEmpty).join(', '),
      established: json['established_year']?.toString() ?? json['established']?.toString() ?? '',
      size: json['size'] ?? json['farm_size'] ?? '',
        owner: (json['owner_name'] ?? json['farm_owner'] ?? json['owner'] ?? '')
          .toString(),
      animals: Farm._groupAnimalsByType(json['animals'] as List<dynamic>? ?? []),
      workers: (json['workers'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((worker) => Worker(
                id: worker['id']?.toString(),
                name: worker['name'] ??
                  '${worker['first_name'] ?? ''} ${worker['surname'] ?? ''}'.trim(),
                role: worker['role'] ?? '',
                phone: worker['telephone'] ??
                  worker['phone'] ??
                  worker['phone_number'] ??
                  '',
                email: worker['email'] ?? '',
              ))
          .toList(),
        coordinates: json['coordinates'] ??
          (gpsLat.isNotEmpty || gpsLon.isNotEmpty ? '$gpsLat, $gpsLon' : null),
      description: json['description'],
      facilities: (json['facilities'] as List<dynamic>? ?? [])
          .map((f) => f.toString())
          .toList(),
      imagePath: json['imagePath'] ?? json['image'] ?? json['image_url'] ?? json['image_path'],
    );
  }

  static String normalizeCategoryName(String raw) {
    final lower = raw.trim().toLowerCase();
    switch (lower) {
      case 'cattle':
      case 'cow':
        return 'Cattle';
      case 'goat':
      case 'goats':
        return 'Goats';
      case 'sheep':
        return 'Sheep';
      case 'pig':
      case 'pigs':
        return 'Pigs';
      case 'poultry':
      case 'chicken':
        return 'Poultry';
      case 'rabbit':
      case 'rabbits':
        return 'Rabbits';
      case 'fish':
        return 'Fish';
      case 'horse':
      case 'horses':
        return 'Horses';
      default:
        if (raw.isEmpty) return 'Other';
        return raw[0].toUpperCase() + raw.substring(1);
    }
  }

  static List<AnimalCategory> _groupAnimalsByType(List<dynamic> animals) {
    final Map<String, AnimalCategory> groupedAnimals = {};

    for (final animal in animals) {
      if (animal is Map) {
        if (animal['count'] != null) {
          final name = normalizeCategoryName(animal['name'] ?? animal['type'] ?? 'Unknown');
          final count = int.tryParse(animal['count'].toString()) ?? 0;
          final category = groupedAnimals.putIfAbsent(
            name,
            () => AnimalCategory(name, 0, '', ids: <String>[]),
          );
          category.count += count;
        } else if (animal['type'] != null) {
          final type = normalizeCategoryName(animal['type'].toString());
          final category = groupedAnimals.putIfAbsent(
            type,
            () => AnimalCategory(type, 0, '', ids: <String>[]),
          );
          category.count++;
          if (animal['id'] != null) category.ids.add(animal['id'].toString());
        }
      }
    }

    return groupedAnimals.values.toList();
  }

  Map<String, dynamic> toApiPayload() {
    return {
      'name': name,
      'location': location,
      'owner_name': owner,
      'size': size,
      'description': description,
      'established_year': established,
      'coordinates': coordinates,
      'facilities': facilities ?? [],
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'established': established,
      'size': size,
      'owner': owner,
      'animals': animals.map((animal) => {
            'name': animal.name,
            'count': animal.count,
            'imagePath': animal.imagePath,
          }).toList(),
      'workers': workers.map((worker) => {
            'name': worker.name,
            'role': worker.role,
            'phone': worker.phone,
          }).toList(),
      'coordinates': coordinates,
      'description': description,
      'facilities': facilities,
      'imagePath': imagePath,
    };
  }
}

class AnimalCategory {
  final String name;
  int count;
  final String imagePath;
  final List<String> ids;
  final String categoryId;

  AnimalCategory(
    this.name,
    this.count,
    this.imagePath, {
    List<String>? ids,
    this.categoryId = '',
  }) : ids = ids ?? <String>[];
}

class Worker {
  final String? id;
  final String name;
  final String role;
  final String phone;
  final String email;

  Worker({
    this.id,
    required this.name,
    required this.role,
    required this.phone,
    this.email = '',
  });
}
