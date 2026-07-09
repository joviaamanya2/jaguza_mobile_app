import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use http://10.0.2.2:8000 for Android Emulator, http://127.0.0.1:8000 for iOS or Web.
  static String baseUrl = 'http://127.0.0.1:8000/api';

  static String? _token;
  static Map<String, dynamic>? _currentUser;

  static String? get token => _token;
  static Map<String, dynamic>? get currentUser => _currentUser;

  static bool get isAuthenticated => _token != null;

  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Token $_token';
    }
    return headers;
  }

  // --- Authentication ---

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _currentUser = data['user'];
        return {'success': true, 'user': _currentUser};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'error': error['error'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    String role = 'farmer',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phone,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _currentUser = data['user'];
        return {'success': true, 'user': _currentUser};
      } else {
        final errors = jsonDecode(response.body);
        // Compile errors
        String errorMsg = 'Registration failed';
        if (errors is Map) {
          errorMsg = errors.values.map((v) => v.toString()).join('\n');
        }
        return {'success': false, 'error': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'error': 'Connection error: $e'};
    }
  }

  static void logout() {
    _token = null;
    _currentUser = null;
  }

  // --- Farms ---

  static Future<List<dynamic>> getFarms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/farms/'), headers: _headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to load farms');
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createFarm(Map<String, dynamic> farmData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/farms/'),
        headers: _headers,
        body: jsonEncode(farmData),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      final err = jsonDecode(response.body);
      throw Exception(err.toString());
    } catch (e) {
      rethrow;
    }
  }

  // --- Sickness Reports ---

  static Future<Map<String, dynamic>> submitSicknessReport(Map<String, dynamic> reportData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sickness/'),
        headers: _headers,
        body: jsonEncode(reportData),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      final err = jsonDecode(response.body);
      throw Exception(err.toString());
    } catch (e) {
      rethrow;
    }
  }

  // --- Gestation ---

  static Future<List<dynamic>> getGestationRecords() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/gestation/'), headers: _headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to load gestation records');
    } catch (e) {
      rethrow;
    }
  }

  // --- Marketplace ---

  static Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/'), headers: _headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to load marketplace products');
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/'),
        headers: _headers,
        body: jsonEncode(productData),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      final err = jsonDecode(response.body);
      throw Exception(err.toString());
    } catch (e) {
      rethrow;
    }
  }
}
