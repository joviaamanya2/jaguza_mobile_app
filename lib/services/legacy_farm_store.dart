import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local cache of farms created through the legacy CMD API's `AddFarm`.
///
/// The CMD API (§15 of Jaguza-API-Documentation.md) has `AddFarm`,
/// `getFarmDetails` (one farm, by id) and `SetMainFarm` — but **no command
/// that lists a user's farms**. Unlike the Laravel backend, there is no way
/// to ask the legacy server "what farms does this user own?" after the fact.
/// So a farm created here only exists to the app if this device remembers
/// its id. Reinstalling the app, or switching devices, loses that memory —
/// a real limitation of the documented API, not a bug in this class.
///
/// If a `getFarmsList`-style command turns up in a live capture later, it
/// should replace this cache as the source of truth; keep the cache as a
/// fallback for `getFarmDetails` failures either way.
class LegacyFarmStore {
  LegacyFarmStore._();

  static const _key = 'legacy_farms';

  static Future<List<Map<String, dynamic>>> list() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const [];
    return raw
        .map((entry) {
          try {
            final decoded = json.decode(entry);
            return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
          } catch (_) {
            return null;
          }
        })
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  static Future<void> add(Map<String, dynamic> farm) async {
    final farms = await list();
    final id = '${farm['id']}';
    farms.removeWhere((f) => '${f['id']}' == id);
    farms.add(farm);
    await _save(farms);
  }

  static Future<void> remove(String id) async {
    final farms = await list();
    farms.removeWhere((f) => '${f['id']}' == id);
    await _save(farms);
  }

  static Future<void> _save(List<Map<String, dynamic>> farms) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, farms.map(json.encode).toList());
  }
}
