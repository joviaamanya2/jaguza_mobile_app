import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Client for the JaguzaLivestockUg PHP backend (`index.php?cmd=...`).
///
/// The backend has no tokens: every call carries the `userId` returned by
/// `login`, which is persisted here. Responses are not consistent (some have
/// PHP warnings printed before the JSON body), so everything goes through
/// [_decode].
class PhpApiService {
  PhpApiService._();
  static final PhpApiService instance = PhpApiService._();
  factory PhpApiService() => instance;

  static const String host = String.fromEnvironment(
    'PHP_API_HOST',
    defaultValue: 'http://143.198.174.35:9060',
  );
  static String get indexUrl => '$host/api/index.php';

  static const _kUserId = 'php_user_id';
  static const _kProfile = 'php_user_profile';

  int? _userId;
  Map<String, dynamic>? _profile;

  int? get userId => _userId;
  Map<String, dynamic>? get profile => _profile;
  bool get isLoggedIn => _userId != null;

  Future<void> load() async {
    if (_userId != null) return;
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt(_kUserId);
    final raw = prefs.getString(_kProfile);
    if (raw != null) {
      try {
        _profile = Map<String, dynamic>.from(json.decode(raw) as Map);
      } catch (_) {}
    }
  }

  Future<void> _saveSession(int id, Map<String, dynamic> profile) async {
    _userId = id;
    _profile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kUserId, id);
    await prefs.setString(_kProfile, json.encode(profile));
  }

  Future<void> logout() async {
    _userId = null;
    _profile = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserId);
    await prefs.remove(_kProfile);
  }

  // ───────────────────────── transport ─────────────────────────

  /// Strips PHP notices/warnings emitted before the JSON payload.
  static dynamic _decode(String body) {
    for (final m in RegExp(r'[\{\[]').allMatches(body)) {
      try {
        return json.decode(body.substring(m.start));
      } on FormatException {
        continue;
      }
    }
    throw PhpApiException('Unexpected server response');
  }

  Future<Map<String, dynamic>> call(
    String cmd, [
    Map<String, dynamic> params = const {},
  ]) async {
    final body = <String, String>{
      'cmd': cmd,
      for (final e in params.entries)
        if (e.value != null) e.key: '${e.value}',
    };
    try {
      final res = await http
          .post(Uri.parse(indexUrl), body: body)
          .timeout(const Duration(seconds: 30));
      if (res.statusCode >= 500) {
        throw PhpApiException('Server error (${res.statusCode})');
      }
      final decoded = _decode(res.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'results': decoded};
    } on SocketException {
      throw PhpApiException('Cannot reach the server. Check your connection.');
    } on FormatException {
      throw PhpApiException('Unexpected server response');
    }
  }

  /// `status` is inconsistent across commands ("ok", "1", 1, ...).
  static bool isOk(Map<String, dynamic> r) {
    final s = '${r['status']}'.toLowerCase();
    return s == 'ok' || s == '1' || s == 'true' || s == 'success';
  }

  static String messageOf(Map<String, dynamic> r, [String fallback = 'Request failed']) {
    final m = r['message'];
    return (m is String && m.isNotEmpty) ? m : fallback;
  }

  /// Strips tags and decodes the HTML entities the PHP backend stores in text.
  static String cleanHtml(String input) {
    const named = {
      'nbsp': ' ', 'amp': '&', 'lt': '<', 'gt': '>', 'quot': '"',
      'apos': "'", 'rsquo': '\u2019', 'lsquo': '\u2018', 'rdquo': '\u201D',
      'ldquo': '\u201C', 'ndash': '\u2013', 'mdash': '\u2014',
      'hellip': '\u2026', 'deg': '\u00B0',
    };
    var s = input.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    s = s.replaceAll(RegExp(r'<[^>]*>'), ' ');
    s = s.replaceAllMapped(RegExp(r'&#(x?)([0-9a-fA-F]+);'), (m) {
      final code = int.tryParse(m.group(2)!, radix: m.group(1) == 'x' ? 16 : 10);
      return code == null ? m.group(0)! : String.fromCharCode(code);
    });
    s = s.replaceAllMapped(RegExp(r'&([a-zA-Z]+);'), (m) => named[m.group(1)] ?? m.group(0)!);
    return s.replaceAll('\r\n', '\n').replaceAll(RegExp(r'[ \t]+'), ' ').trim();
  }

  static List<Map<String, dynamic>> listOf(dynamic v) {
    if (v is! List) return const [];
    return v
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  int get _uid {
    final id = _userId;
    if (id == null) {
      throw PhpApiException('Not signed in. Please login again.');
    }
    return id;
  }

  // ───────────────────────── auth ─────────────────────────

  /// Returns `{success, error?, data?}`. Accounts that still need the SMS PIN
  /// come back with `needsVerification: true` and the `user_id`.
  Future<Map<String, dynamic>> login(String username, String password) async {
    // The server matches phones by suffix (`telephone LIKE '%input'`), so send
    // the 9 national digits regardless of how the user typed the number.
    var login = username.trim();
    if (!login.contains('@')) {
      final digits = login.replaceAll(RegExp(r'\D'), '');
      if (digits.length >= 9) login = digits.substring(digits.length - 9);
    }
    final r = await call('login', {
      'username': login,
      'password': password,
      'country': 'Uganda',
      'gcm': '',
    });
    if (isOk(r)) {
      final id = int.tryParse('${r['user_id']}');
      if (id == null) return {'success': false, 'error': 'Invalid server response'};
      await _saveSession(id, r);
      return {'success': true, 'data': r};
    }
    final status = '${r['status']}';
    return {
      'success': false,
      'needsVerification': status == 'notactivated',
      'user_id': r['user_id'],
      'phone': r['phone'],
      'error': messageOf(r, 'Login failed, wrong user name or password'),
    };
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String phone,
    required String password,
    String email = '',
    String gender = '',
  }) async {
    final r = await call('addUsers', {
      'username': username,
      'phone': phone,
      'email': email,
      'password': password,
      'gender': gender,
      'country': 'Uganda',
      'gcm': '',
    });
    if (isOk(r)) {
      return {'success': true, 'data': r, 'user_id': r['user_id']};
    }
    return {'success': false, 'error': messageOf(r, 'Registration failed')};
  }

  Future<Map<String, dynamic>> verifyPin({
    required String userId,
    required String phone,
    required String pin,
  }) async {
    final r = await call('logincode', {'userId': userId, 'phone': phone, 'pin': pin});
    if (isOk(r)) {
      final id = int.tryParse('${r['user_id'] ?? userId}');
      if (id != null) await _saveSession(id, r);
      return {'success': true, 'data': r};
    }
    return {'success': false, 'error': messageOf(r, 'Invalid code')};
  }

  Future<Map<String, dynamic>> resendCode(String phone) async {
    final r = await call('resendcode', {'phone': phone});
    return isOk(r)
        ? {'success': true, 'data': r}
        : {'success': false, 'error': messageOf(r)};
  }

  /// Emails a reset link (completed in the browser by `/api/applogin/`).
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final r = await call('forgotPassword', {'email': email});
    return isOk(r)
        ? {'success': true, 'message': messageOf(r, 'Reset link sent')}
        : {'success': false, 'error': messageOf(r, 'Email not found')};
  }

  Future<Map<String, dynamic>> updateProfile({
    required String username,
    String? email,
    String? phone,
  }) async {
    final r = await call('editUsers', {
      'user_id': _uid,
      'username': username,
      'email': email,
      'phone': phone,
    });
    if (isOk(r)) {
      _profile = {...?_profile, 'name': username, 'email': email, 'phone': phone};
      await _saveSession(_uid, _profile!);
      return {'success': true};
    }
    return {'success': false, 'error': messageOf(r)};
  }

  // ───────────────────────── farms ─────────────────────────

  Future<Map<String, dynamic>> farmSummary() =>
      call('getUserFarmDetails', {'userId': _uid});

  Future<Map<String, dynamic>> addFarm({
    required String name,
    String? location,
    String? district,
    double? latitude,
    double? longitude,
    File? image,
  }) =>
      call('AddFarm', {
        'userId': _uid,
        'farm_name': name,
        'actual_location': location,
        'district': district,
        'latitude': latitude,
        'longitude': longitude,
        if (image != null) 'image': base64Encode(image.readAsBytesSync()),
      });

  Future<Map<String, dynamic>> setMainFarm(int farmId) =>
      call('SetMainFarm', {'userId': _uid, 'farm_id': farmId});

  // ───────────────────────── animals ─────────────────────────

  Future<Map<String, dynamic>> animals(int farmId) =>
      call('getAnimalList', {'userId': _uid, 'farm_id': farmId});

  Future<Map<String, dynamic>> animalDetails(int farmId, int animalId) =>
      call('getAnimalDetails', {
        'userId': _uid,
        'farm_id': farmId,
        'animal_id': animalId,
      });

  Future<Map<String, dynamic>> addAnimal(Map<String, dynamic> p) =>
      call('AddAnimal', {'userId': _uid, ...p});

  Future<Map<String, dynamic>> deleteAnimal(int animalId, {int? farmId}) =>
      call('deleteAnimal', {
        'userId': _uid,
        'animal_id': animalId,
        'farm_id': farmId,
      });

  // ───────────────────────── health ─────────────────────────

  Future<Map<String, dynamic>> doctors(double lat, double lng) =>
      call('getDoctors', {'userId': _uid, 'latitude': lat, 'longitude': lng});

  Future<Map<String, dynamic>> extensionWorkers(double lat, double lng) =>
      call('getExtensionWorkers', {
        'userId': _uid,
        'latitude': lat,
        'longitude': lng,
      });

  Future<Map<String, dynamic>> diseases() =>
      call('getDiseasesList', {'userId': _uid});

  Future<Map<String, dynamic>> signs() =>
      call('getAllSignsList', {'userId': _uid});

  Future<Map<String, dynamic>> diagnose(int farmId, List<int> signIds) =>
      call('diagnosis', {
        'userId': _uid,
        'farm_id': farmId,
        'signs_list': json.encode(signIds.map((e) => {'sign_id': e}).toList()),
      });

  // ───────────────────────── community / sickness ─────────────────────────

  Future<Map<String, dynamic>> sicknessPosts(
    double lat,
    double lng, {
    int page = 1,
    bool mine = false,
  }) =>
      call('getSicknessPosts', {
        'userId': _uid,
        'latitude': lat,
        'longitude': lng,
        'page': page,
        if (mine) 'self': 'yes',
      });

  Future<Map<String, dynamic>> addSicknessPost({
    required String title,
    required String content,
    String? animalCategory,
    String? location,
    double? latitude,
    double? longitude,
    String? telephone,
    File? image,
  }) =>
      call('AddSicknessPost', {
        'userId': _uid,
        'title': title,
        'content': content,
        'animalCategory': animalCategory,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'telephone': telephone,
        'post_type': image != null ? 'image' : 'text',
        if (image != null) 'image': base64Encode(image.readAsBytesSync()),
      });

  // ───────────────────────── marketplace ─────────────────────────

  Future<Map<String, dynamic>> marketProducts({int farmId = 0}) =>
      call('getMarketProducts', {'userId': _uid, 'farm_id': farmId});

  Future<Map<String, dynamic>> addMarketListing({
    required String title,
    required String content,
    double? price,
    bool negotiable = false,
    String? location,
    double? latitude,
    double? longitude,
    String? telephone,
    int? animalCategoryId,
    int? farmId,
    File? image,
  }) =>
      call('addMarket', {
        'userId': _uid,
        'title': title,
        'content': content,
        'price': price,
        'negotiable': negotiable ? 1 : 0,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'telephone': telephone,
        'animal_category_id': animalCategoryId,
        'farm_id': farmId,
        if (image != null) 'image': base64Encode(image.readAsBytesSync()),
      });

  /// Public, unauthenticated market-prices endpoints.
  Future<Map<String, dynamic>> marketPricesHome() async {
    final res = await http
        .get(Uri.parse('$host/api/v1/fetch_market_prices_home.php'))
        .timeout(const Duration(seconds: 30));
    final d = _decode(res.body);
    return d is Map<String, dynamic> ? d : {};
  }

  Future<Map<String, dynamic>> marketPricesFor(String marketId) async {
    final res = await http
        .post(
          Uri.parse('$host/api/v1/fetch_market_prices_products.php'),
          body: {'market_id': marketId},
        )
        .timeout(const Duration(seconds: 30));
    final d = _decode(res.body);
    return d is Map<String, dynamic> ? d : {'results': d};
  }

  // ───────────────────────── gestation ─────────────────────────

  Future<Map<String, dynamic>> gestations({int? farmId}) =>
      call('getGestationList', {'userId': _uid, 'farm_id': farmId});

  Future<Map<String, dynamic>> addGestation(Map<String, dynamic> p) =>
      call('AddGestation', {'userId': _uid, ...p});

  // ───────────────────────── milk & expenses ─────────────────────────

  Future<Map<String, dynamic>> addMilk(Map<String, dynamic> p) =>
      call('AddMilk', {'userId': _uid, ...p});

  Future<Map<String, dynamic>> milkList(int farmId, String start, String end) =>
      call('getMilkList', {
        'user_id': _uid,
        'farm_id': farmId,
        'start_date': start,
        'end_date': end,
      });

  Future<Map<String, dynamic>> addExpense(Map<String, dynamic> p) =>
      call('AddFarmExpense', {'userId': _uid, ...p});

  Future<Map<String, dynamic>> expenses(int farmId, String start, String end) =>
      call('getExpensesList', {
        'user_id': _uid,
        'farm_id': farmId,
        'start_date': start,
        'end_date': end,
      });

  // ───────────────────────── doctor chat ─────────────────────────

  Future<Map<String, dynamic>> chatList(int doctorId, {int page = 1}) =>
      call('getDoctorChatList', {'userId': _uid, 'post_id': doctorId, 'page': page});

  Future<Map<String, dynamic>> sendChat(int doctorId, String content) =>
      call('AddDoctorChat', {
        'userId': _uid,
        'post_id': doctorId,
        'content': content,
        'type': 'text',
      });

  Future<Map<String, dynamic>> lastContacted({int page = 1}) =>
      call('getDoctorLastContacted', {'userId': _uid, 'page': page});

  // ───────────────────────── reference data ─────────────────────────

  Future<Map<String, dynamic>> districts({int countryId = 1}) =>
      call('getCountryDistricts', {'country_id': countryId});
}

class PhpApiException implements Exception {
  final String message;
  PhpApiException(this.message);
  @override
  String toString() => message;
}
