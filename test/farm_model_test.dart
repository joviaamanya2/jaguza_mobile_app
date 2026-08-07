import 'package:flutter_test/flutter_test.dart';
import 'package:jaguza_app/screens/home_details/My%20farm/my_farm.dart';

void main() {
  group('Farm.fromJson', () {
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
      expect(farm.workers.single.role, 'Manager');
    });
  });
}
