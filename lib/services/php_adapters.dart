import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'php_api_service.dart';

/// Translates PHP-backend responses into the JSON shapes the screens already
/// consume (they were written against the REST backend), so screens don't need
/// to know which server they are talking to.
class PhpAdapters {
  PhpAdapters._();
  static final PhpApiService _php = PhpApiService.instance;

  /// Category ids in the PHP database, keyed by the app's animal type.
  static const Map<String, int> categoryIds = {
    'cattle': 2,
    'cow': 2,
    'goat': 3,
    'goats': 3,
    'pig': 4,
    'pigs': 4,
    'sheep': 5,
    'rabbit': 6,
    'rabbits': 6,
    'poultry': 7,
    'chicken': 7,
  };

  static const Map<int, String> categoryTypes = {
    2: 'cattle',
    3: 'goat',
    4: 'pig',
    5: 'sheep',
    6: 'rabbit',
    7: 'poultry',
  };

  static const _kampala = [0.3476, 32.5825];

  static Future<List<double>> _position() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return _kampala;
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return _kampala;
      }
      final p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 8),
      );
      return [p.latitude, p.longitude];
    } catch (_) {
      return _kampala;
    }
  }

  static double _d(dynamic v, [double fallback = 0]) =>
      double.tryParse('$v') ?? fallback;

  // ───────────────────────── user ─────────────────────────

  static Map<String, dynamic> currentUser() {
    final p = _php.profile ?? const {};
    return {
      'id': _php.userId ?? 0,
      'name': p['name'] ?? '',
      'email': p['email'] ?? '',
      'role': p['role'] ?? 'farmer',
      'phone_number': p['phone'] ?? '',
      'is_verified': '${p['email_verified']}' == '1' || p['status'] == 'ok',
      'is_active': true,
    };
  }

  // ───────────────────────── farms & animals ─────────────────────────

  static Map<String, dynamic> animalToJson(Map<String, dynamic> a, int farmId) {
    final catId = int.tryParse('${a['animal_category_id']}') ?? 0;
    final type = categoryTypes[catId] ?? 'other';
    final status = '${a['status'] ?? 'alive'}';
    return {
      'id': a['id'],
      'identification_number': '${a['tag_id'] ?? a['id']}',
      'name': a['name'],
      'type': type,
      'type_display': type,
      'breed': '${a['breed'] ?? 'Unknown'}',
      'gender': '${a['gender'] ?? ''}',
      'age': _ageYears('${a['date_of_birth'] ?? ''}'),
      'health_status': status == 'alive' ? 'healthy' : status,
      'health_status_display': status,
      'farm': farmId,
      'farm_id': farmId,
      'owner': _php.userId,
      'photo': a['photo'],
      'latitude': a['latitude'],
      'longitude': a['longitude'],
    };
  }

  static int _ageYears(String dob) {
    // PHP returns e.g. "Aug 2 2019".
    final parsed = _parseLooseDate(dob);
    if (parsed == null) return 0;
    return (DateTime.now().difference(parsed).inDays / 365).floor().clamp(0, 99);
  }

  static DateTime? _parseLooseDate(String s) {
    final direct = DateTime.tryParse(s);
    if (direct != null) return direct;
    const months = {
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
      'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
    };
    final m = RegExp(r'^([A-Za-z]{3})\w*\s+(\d{1,2})\s+(\d{4})$').firstMatch(s.trim());
    if (m == null) return null;
    final month = months[m.group(1)!.toLowerCase()];
    if (month == null) return null;
    return DateTime(int.parse(m.group(3)!), month, int.parse(m.group(2)!));
  }

  static Future<List<Map<String, dynamic>>> _rawFarms() async {
    final r = await _php.farmSummary();
    // The doc lists `farmslist`; `farms` is used by getAnimalList-style replies.
    return PhpApiService.listOf(r['farmslist'] ?? r['farms']);
  }

  static int? _farmId(Map<String, dynamic> f) =>
      int.tryParse('${f['id'] ?? f['farm_id']}');

  static Future<List<Map<String, dynamic>>> farms() async {
    final result = <Map<String, dynamic>>[];
    for (final f in await _rawFarms()) {
      final id = _farmId(f);
      if (id == null) continue;
      final animals = <Map<String, dynamic>>[];
      try {
        final r = await _php.animals(id);
        animals.addAll(PhpApiService.listOf(r['listing']).map((a) => animalToJson(a, id)));
      } catch (_) {}
      result.add({
        'id': id,
        'name': f['farm_name'] ?? f['name'] ?? '',
        'location': f['actual_location'] ?? f['location'] ?? f['district'] ?? '',
        'owner_name': _php.profile?['name'] ?? '',
        'user_id': _php.userId,
        'size': '',
        'coordinates': (f['latitude'] != null && f['longitude'] != null)
            ? '${f['latitude']}, ${f['longitude']}'
            : null,
        'image': f['photo'] ?? f['image'],
        'animals': animals,
        'workers': const [],
      });
    }
    return result;
  }

  static Future<List<Map<String, dynamic>>> animals() async {
    final out = <Map<String, dynamic>>[];
    for (final f in await _rawFarms()) {
      final id = _farmId(f);
      if (id == null) continue;
      final r = await _php.animals(id);
      out.addAll(PhpApiService.listOf(r['listing']).map((a) => animalToJson(a, id)));
    }
    return out;
  }

  static Future<Map<String, dynamic>> createFarm(
    Map<String, dynamic> data,
    File? image,
  ) async {
    final coords = '${data['coordinates'] ?? ''}'.split(',');
    final r = await _php.addFarm(
      name: '${data['name'] ?? ''}',
      location: data['location'] as String?,
      latitude: coords.length == 2 ? double.tryParse(coords[0].trim()) : null,
      longitude: coords.length == 2 ? double.tryParse(coords[1].trim()) : null,
      image: image,
    );
    if (!PhpApiService.isOk(r)) {
      throw PhpApiException(PhpApiService.messageOf(r, 'Could not create farm'));
    }
    return {
      'id': r['farm_id'],
      'name': data['name'],
      'location': data['location'] ?? '',
      'owner_name': data['owner_name'] ?? '',
      'user_id': _php.userId,
      'animals': const [],
      'workers': const [],
    };
  }

  static Future<Map<String, dynamic>> createAnimal(Map<String, dynamic> d) async {
    final type = '${d['type'] ?? ''}'.toLowerCase();
    final catId = categoryIds[type];
    if (catId == null) {
      throw PhpApiException('Unsupported animal type: $type');
    }
    final years = int.tryParse('${d['age'] ?? 0}') ?? 0;
    final dob = DateTime.now().subtract(Duration(days: 365 * years));
    final r = await _php.addAnimal({
      'name': '${d['name'] ?? d['identification_number'] ?? type}',
      'category_id': catId,
      'farm_id': d['farm_id'],
      'gender': d['gender'],
      'breedval': d['breed'],
      'tag_id': d['identification_number'],
      'dob': '${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}',
    });
    if (!PhpApiService.isOk(r)) {
      throw PhpApiException(PhpApiService.messageOf(r, 'Could not add animal'));
    }
    return {'id': r['animal_id']};
  }

  static Future<void> deleteAnimal(int id) async {
    final r = await _php.deleteAnimal(id);
    if (!PhpApiService.isOk(r)) {
      throw PhpApiException(PhpApiService.messageOf(r, 'Could not delete animal'));
    }
  }

  // ───────────────────────── doctors ─────────────────────────

  static Future<List<Map<String, dynamic>>> doctors() async {
    final pos = await _position();
    final r = await _php.doctors(pos[0], pos[1]);
    return PhpApiService.listOf(r['listing']).map((d) {
      return {
        'id': d['id'],
        'user': {'name': d['name']},
        'name': d['name'],
        'specialization': d['cat_name'] ?? 'Veterinary Medicine',
        'location': d['physical_address'] ?? '',
        'rating': d['rating'] ?? 0,
        'consultation_fee': 0,
        'is_available': true,
        'bio': _stripHtml('${d['description'] ?? ''}'),
        'phone_number': '${d['telephone'] ?? ''}'.replaceAll('/', '').trim(),
        'latitude': d['lat'],
        'longitude': d['lon'],
        'photo': d['photo'],
        'email': d['email'],
        'education': _stripHtml('${d['education'] ?? ''}'),
        'distance_km': d['distance'],
      };
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> extensionWorkers() async {
    final pos = await _position();
    final r = await _php.extensionWorkers(pos[0], pos[1]);
    return PhpApiService.listOf(r['listing']).map((d) {
      return {
        'id': d['id'],
        'user': {'name': d['name']},
        'name': d['name'],
        'expertise_area': d['cat_name'] ?? 'Livestock Extension',
        'assigned_region': d['physical_address'] ?? '',
        'languages_spoken': 'English',
        'rating': d['rating'] ?? 0,
        'is_available': true,
        'bio': _stripHtml('${d['description'] ?? ''}'),
        'phone_number': '${d['telephone'] ?? ''}'.replaceAll('/', '').trim(),
        'latitude': d['lat'],
        'longitude': d['lon'],
        'photo': d['photo'],
        'email': d['email'],
      };
    }).toList();
  }

  static String _stripHtml(String s) => PhpApiService.cleanHtml(s);

  // ───────────────────────── diseases ─────────────────────────

  /// The server stores the literal word "category" for some diseases.
  static String _species(String raw) {
    final v = raw.trim();
    return (v.isEmpty || v.toLowerCase() == 'category') ? 'Livestock' : v;
  }

  static Map<String, dynamic> _disease(Map<String, dynamic> d) {
    final signs = d['signs_list'] is Map
        ? PhpApiService.listOf((d['signs_list'] as Map)['signs'])
        : const <Map<String, dynamic>>[];
    final symptoms = signs.map((s) => '${s['symptom_name']}').join(', ');
    final doctors = d['doctors_list'] is Map
        ? PhpApiService.listOf((d['doctors_list'] as Map)['doctors'])
        : const <Map<String, dynamic>>[];
    return {
      'id': d['id'],
      'name': '${d['name'] ?? ''}'.trim(),
      'species_affected': _species('${d['category'] ?? ''}'),
      'description': _stripHtml('${d['description'] ?? ''}'),
      'symptoms': symptoms.isEmpty ? _stripHtml('${d['description'] ?? ''}') : symptoms,
      'prevention': _stripHtml('${d['prevention'] ?? ''}'),
      'treatment': _stripHtml('${d['treatment'] ?? ''}'),
      'severity': 'medium',
      'thumbnail': d['photo'],
      'doctors': doctors,
    };
  }

  static Future<List<Map<String, dynamic>>> diseases() async {
    final r = await _php.diseases();
    return PhpApiService.listOf(r['listing']).map(_disease).toList();
  }

  /// Keywords that identify each in-app symptom label inside the server's sign names.
  static const Map<String, List<String>> _symptomKeywords = {
    'fever': ['temperature', 'fever'],
    'loss of appetite': ['appetite', 'not eating'],
    'diarrhea': ['diarrh'],
    'coughing': ['cough'],
    'lethargy': ['lethargy', 'weak', 'dull', 'depress'],
    'weight loss': ['weight', 'thin', 'emaciat', 'unthrift'],
    'skin lesions': ['skin', 'lesion', 'blister', 'sore', 'wart'],
    'difficulty breathing': ['breath', 'respirat'],
    'swelling': ['swell', 'swollen'],
    'discharge': ['discharge'],
    'vomiting': ['vomit'],
    'lameness': ['lame', 'limp', 'recumb', 'stiff'],
    'nasal discharge': ['nasal', 'nose'],
    'reduced milk production': ['milk'],
    'dehydration': ['dehydrat'],
    'abnormal behavior': ['behavio', 'aggress', 'restless'],
  };

  /// The UI sends symptom *names*; the PHP API wants sign ids, so resolve them
  /// against the server's sign list first.
  static Future<Map<String, dynamic>> diagnose(List<String> symptoms) async {
    final signs = PhpApiService.listOf((await _php.signs())['signs']);
    final wanted = symptoms.map((s) => s.toLowerCase().trim()).toList();
    // sign ids matched per selected symptom, so the score reflects how many
    // of the user's symptoms a disease explains.
    final idsPerSymptom = <String, Set<int>>{for (final w in wanted) w: <int>{}};
    for (final s in signs) {
      final name = '${s['symptom_name']}'.toLowerCase().trim();
      final id = int.tryParse('${s['id']}');
      if (id == null || name.isEmpty) continue;
      for (final w in wanted) {
        final keys = _symptomKeywords[w] ?? [w];
        if (name == w || keys.any(name.contains)) idsPerSymptom[w]!.add(id);
      }
    }
    final ids = idsPerSymptom.values.expand((e) => e).toSet();
    if (ids.isEmpty) {
      return {
        'diseases': const [],
        'matches': 0,
        'message': 'None of the selected symptoms matched the server symptom list.',
      };
    }
    final r = await _php.diagnose(0, ids.toList());
    final results = PhpApiService.listOf(r['diseases']).map((d) {
      final m = _disease(d);
      final diseaseIds = (d['signs_list'] is Map
              ? PhpApiService.listOf((d['signs_list'] as Map)['signs'])
              : const <Map<String, dynamic>>[])
          .map((s) => int.tryParse('${s['id']}'))
          .whereType<int>()
          .toSet();
      final explained = idsPerSymptom.values
          .where((set) => set.isNotEmpty && set.any(diseaseIds.contains))
          .length;
      m['match'] = ((explained / wanted.length) * 100).round().clamp(0, 100);
      m['severity'] = 'Medium';
      return m;
    }).toList()
      ..sort((a, b) => (b['match'] as int).compareTo(a['match'] as int));
    return {'diseases': results, 'matches': results.length};
  }

  // ───────────────────────── marketplace ─────────────────────────

  static String _categoryName(dynamic id) {
    final t = categoryTypes[int.tryParse('$id')];
    return t ?? 'other';
  }

  static Future<List<Map<String, dynamic>>> marketplaceListings() async {
    final r = await _php.marketProducts();
    return PhpApiService.listOf(r['mkt_posts']).map((p) {
      return {
        'id': p['id'],
        'title': p['title'],
        'description': _stripHtml('${p['content'] ?? ''}'),
        'price': p['price'],
        'location': p['location'],
        'category': _categoryName(p['animal_category_id']),
        'status': p['status'] ?? 'available',
        'seller_id': p['user_id'],
        'seller': {'name': p['author'] ?? 'Seller'},
        'images': (p['photo'] is String && '${p['photo']}'.isNotEmpty) ? [p['photo']] : const [],
        'phone_number': p['telephone'],
        'likes_count': p['likes_count'],
        'comment_count': p['comment_count'],
      };
    }).toList();
  }

  static Future<Map<String, dynamic>> createListing(
    Map<String, dynamic> d,
    File? image,
  ) async {
    final cat = categoryIds['${d['category'] ?? ''}'.toLowerCase()];
    final r = await _php.addMarketListing(
      title: '${d['title'] ?? ''}',
      content: '${d['description'] ?? ''}',
      price: double.tryParse('${d['price'] ?? ''}'),
      location: d['location'] as String?,
      animalCategoryId: cat,
      image: image,
    );
    if (!PhpApiService.isOk(r)) {
      throw PhpApiException(PhpApiService.messageOf(r, 'Could not create listing'));
    }
    return {'id': r['mkt_post_id']};
  }

  // ───────────────────────── markets & prices ─────────────────────────

  static Future<List<Map<String, dynamic>>> markets({double? lat, double? lng}) async {
    final r = await _php.marketPricesHome();
    return PhpApiService.listOf(r['markets'])
        .where((m) => '${m['status']}' == '1')
        .map((m) => {
              'id': m['id'],
              'name': m['name'],
              'location': m['location'],
              'latitude': m['latitude'],
              'longitude': m['longitude'],
              'contact': m['contact'],
              'country_id': m['country_id'],
            })
        .toList();
  }

  /// Prices of the market nearest to [lat]/[lng] (or the first Ugandan market).
  static Future<List<Map<String, dynamic>>> marketPrices({double? lat, double? lng}) async {
    final list = await markets();
    if (list.isEmpty) return const [];
    var chosen = list.first;
    if (lat != null && lng != null) {
      double best = double.infinity;
      for (final m in list) {
        final mlat = double.tryParse('${m['latitude']}');
        final mlng = double.tryParse('${m['longitude']}');
        if (mlat == null || mlng == null) continue;
        final dist = Geolocator.distanceBetween(lat, lng, mlat, mlng);
        if (dist < best) {
          best = dist;
          chosen = m;
        }
      }
    }
    final r = await _php.marketPricesFor('${chosen['id']}');
    return PhpApiService.listOf(r['market_products'])
        .where((p) => p['price'] != null)
        .map((p) {
      final price = _d(p['price']);
      return {
        'item': '${p['product_name']}'.trim(),
        'category': 'Other',
        'low': price.round(),
        'high': price.round(),
        'unit': 'per unit',
      };
    }).toList();
  }

  // ───────────────────────── gestation ─────────────────────────

  static Future<List<Map<String, dynamic>>> gestations() async {
    final out = <Map<String, dynamic>>[];
    for (final f in await _rawFarms()) {
      final id = _farmId(f);
      if (id == null) continue;
      final r = await _php.gestations(farmId: id);
      out.addAll(PhpApiService.listOf(r['listing']));
    }
    return out;
  }

  static Future<Map<String, dynamic>> createGestation(Map<String, dynamic> d) async {
    final r = await _php.addGestation({
      'animal_id': d['animal_id'] ?? d['animal'],
      'farm_id': d['farm_id'] ?? d['farm'],
      'insemination_date': d['insemination_date'] ?? d['breeding_date'],
      'method': d['method'],
      'notes': d['notes'],
    });
    if (!PhpApiService.isOk(r)) {
      throw PhpApiException(PhpApiService.messageOf(r, 'Could not record gestation'));
    }
    return {'id': r['animal_id']};
  }
}
