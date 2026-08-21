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
    return Farm(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['farm_name'] ?? '',
      location: json['location'] ?? json['farm_location'] ?? '',
      established: json['established_year']?.toString() ?? json['established']?.toString() ?? '',
      size: json['size'] ?? '',
      owner: json['owner_name'] ?? json['farm_owner'] ?? json['owner'] ?? '',
      animals: Farm._groupAnimalsByType(json['animals'] as List<dynamic>? ?? []),
      workers: (json['workers'] as List<dynamic>? ?? [])
          .map((worker) => Worker(
                worker['name'] ?? '',
                worker['role'] ?? '',
                worker['phone'] ?? '',
              ))
          .toList(),
      coordinates: json['coordinates'],
      description: json['description'],
      facilities: (json['facilities'] as List<dynamic>? ?? [])
          .map((f) => f.toString())
          .toList(),
      imagePath: json['imagePath'] ?? json['image'] ?? json['image_url'] ?? json['image_path'],
    );
  }

  static List<AnimalCategory> _groupAnimalsByType(List<dynamic> animals) {
    final Map<String, int> groupedAnimals = {};

    for (final animal in animals) {
      if (animal is Map) {
        if (animal['count'] != null) {
          final name = animal['name'] ?? animal['type'] ?? 'Unknown';
          final count = int.tryParse(animal['count'].toString()) ?? 0;
          groupedAnimals[name] = (groupedAnimals[name] ?? 0) + count;
        } else if (animal['type'] != null) {
          final type = animal['type'] as String;
          groupedAnimals[type] = (groupedAnimals[type] ?? 0) + 1;
        }
      }
    }

    return groupedAnimals.entries
        .map((entry) => AnimalCategory(entry.key, entry.value, ''))
        .toList();
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

  AnimalCategory(this.name, this.count, this.imagePath);
}

class Worker {
  final String name;
  final String role;
  final String phone;

  Worker(this.name, this.role, this.phone);
}