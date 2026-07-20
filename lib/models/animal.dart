class Animal {
  final int id;
  final String identificationNumber;
  final String? name;
  final String type;
  final String typeDisplay;
  final String breed;
  final String gender;
  final int age;
  final double? weight;
  final String healthStatus;
  final String healthStatusDisplay;
  final int farm;
  final Map<String, dynamic>? farmDetails;
  final int owner;
  final Map<String, dynamic>? ownerDetails;
  final String? photo;
  final DateTime? dateBought;
  final double? purchasePrice;
  final String? notes;
  
  Animal({
    required this.id,
    required this.identificationNumber,
    this.name,
    required this.type,
    required this.typeDisplay,
    required this.breed,
    required this.gender,
    required this.age,
    this.weight,
    required this.healthStatus,
    required this.healthStatusDisplay,
    required this.farm,
    this.farmDetails,
    required this.owner,
    this.ownerDetails,
    this.photo,
    this.dateBought,
    this.purchasePrice,
    this.notes,
  });
  
  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'],
      identificationNumber: json['identification_number'],
      name: json['name'],
      type: json['type'],
      typeDisplay: json['type_display'],
      breed: json['breed'],
      gender: json['gender'],
      age: json['age'],
      weight: json['weight'] != null ? double.parse(json['weight'].toString()) : null,
      healthStatus: json['health_status'],
      healthStatusDisplay: json['health_status_display'],
      farm: json['farm'],
      farmDetails: json['farm_details'],
      owner: json['owner'],
      ownerDetails: json['owner_details'],
      photo: json['photo'],
      dateBought: json['date_bought'] != null ? DateTime.parse(json['date_bought']) : null,
      purchasePrice: json['purchase_price'] != null ? double.parse(json['purchase_price'].toString()) : null,
      notes: json['notes'],
    );
  }
}