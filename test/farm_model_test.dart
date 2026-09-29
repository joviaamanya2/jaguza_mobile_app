import 'package:flutter_test/flutter_test.dart';
import 'package:jaguza_app/models/farm_model.dart';

void main() {
  test('parses backend farm payload fields', () {
    final farm = Farm.fromJson({
      'id': 12,
      'name': 'Green Acres',
      'location': 'Wakiso',
      'owner_name': 'Moses',
      'size': '20 acres',
      'description': 'A productive hatchery',
      'established_year': '2022',
      'coordinates': '0.1,32.1',
      'facilities': ['Barn', 'Water Tanks'],
      'image_url': 'https://example.com/farm.jpg',
      'animals': [
        {'name': 'Cattle', 'count': 5},
      ],
      'workers': [
        {'name': 'John', 'role': 'Manager', 'phone': '0772000000'},
      ],
    });

    expect(farm.id, '12');
    expect(farm.name, 'Green Acres');
    expect(farm.location, 'Wakiso');
    expect(farm.owner, 'Moses');
    expect(farm.established, '2022');
    expect(farm.imagePath, 'https://example.com/farm.jpg');
    expect(farm.facilities, ['Barn', 'Water Tanks']);
    expect(farm.animals.single.name, 'Cattle');
    expect(farm.animals.single.count, 5);
    expect(farm.workers.single.role, 'Manager');
  });

  test('parses documented legacy V2 farm fields', () {
    final farm = Farm.fromJson({
      'farm_id': 27,
      'name': 'Hill Farm',
      'district': 'Wakiso',
      'country': 'Uganda',
      'farm_owner': 5,
      'farm_size': '12 acres',
      'gps_lat': '0.31',
      'gps_lon': '32.58',
    });

    expect(farm.id, '27');
    expect(farm.location, 'Wakiso, Uganda');
    expect(farm.owner, '5');
    expect(farm.size, '12 acres');
    expect(farm.coordinates, '0.31, 32.58');
  });
}
