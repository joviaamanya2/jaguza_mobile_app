import 'package:flutter_test/flutter_test.dart';
import 'package:jaguza_app/services/legacy_farm_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('starts empty', () async {
    expect(await LegacyFarmStore.list(), isEmpty);
  });

  test('add stores a farm and list returns it', () async {
    await LegacyFarmStore.add({'id': '4010', 'name': 'Sunrise Farm'});
    final farms = await LegacyFarmStore.list();
    expect(farms, hasLength(1));
    expect(farms.first['name'], 'Sunrise Farm');
  });

  test('add with the same id replaces rather than duplicates', () async {
    await LegacyFarmStore.add({'id': '4010', 'name': 'Old Name'});
    await LegacyFarmStore.add({'id': '4010', 'name': 'New Name'});
    final farms = await LegacyFarmStore.list();
    expect(farms, hasLength(1));
    expect(farms.first['name'], 'New Name');
  });

  test('remove drops only the matching farm', () async {
    await LegacyFarmStore.add({'id': '1', 'name': 'A'});
    await LegacyFarmStore.add({'id': '2', 'name': 'B'});
    await LegacyFarmStore.remove('1');
    final farms = await LegacyFarmStore.list();
    expect(farms, hasLength(1));
    expect(farms.first['id'], '2');
  });
}
