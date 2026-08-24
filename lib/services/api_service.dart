import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Defaults to the deployed production server. NOTE: production is
  // currently out of sync with several fixes made against the local server
  // (POST /workers route, marketplace schema, video categories, ad
  // approval, animal/worker creation) - those won't work until production
  // is redeployed. Pass --dart-define=USE_LOCAL_API=true to point at a
  // local dev server instead.
  static const bool _forceLocalApi = bool.fromEnvironment(
    'USE_LOCAL_API',
    defaultValue: false,
  );

  // Production URLs
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://188.166.8.72:9044/api/v1/',
  );
  static const String tokenUrl = String.fromEnvironment(
    'TOKEN_URL',
    defaultValue: 'http://188.166.8.72:9044/api/token/',
  );

  // Local development URLs
  // Physical phones must use the computer's LAN IP, not 127.0.0.1.
  // Override LOCAL_API_BASE_URL when the phone/network IP changes.
  static const String _localApi = String.fromEnvironment(
    'LOCAL_API_BASE_URL',
    defaultValue: 'http://192.168.2.160:8000/api/v1/',
  );
  static const String _localToken = String.fromEnvironment(
    'LOCAL_TOKEN_URL',
    defaultValue: 'http://192.168.2.160:8000/api/token/',
  );

  // For an Android emulator use:
  // --dart-define=LOCAL_API_BASE_URL=http://10.0.2.2:8000/api/v1/

  // Separate tokens for local and production
  String? _productionToken;
  String? _localTokenValue;
  String? _refreshToken;

  // Mode tracking
  bool _isLocalMode = false;

  // Singleton
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Get the current token based on mode
  String? get _currentToken =>
      _isLocalMode ? _localTokenValue : _productionToken;

  // Load tokens from storage
  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _productionToken = prefs.getString('production_token');
    _localTokenValue = prefs.getString('local_token');
    _refreshToken = prefs.getString('refresh_token');
    // The selected API is controlled by USE_LOCAL_API, so debug and release
    // builds use the same server configuration.
    _isLocalMode = _forceLocalApi;

    print('🔑 Mode: ${_isLocalMode ? "LOCAL" : "PRODUCTION"}');
    print('🔑 Production Token: ${_tokenPreview(_productionToken)}');
    print('🔑 Local Token: ${_tokenPreview(_localTokenValue)}');
  }

  String _tokenPreview(String? token) {
    if (token == null || token.isEmpty) return 'none';
    return '${token.substring(0, token.length < 20 ? token.length : 20)}...';
  }

  // Save production tokens
  Future<void> saveProductionTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('production_token', access);
    await prefs.setString('refresh_token', refresh);
    await prefs.setBool('is_local_mode', false);
    _productionToken = access;
    _refreshToken = refresh;
    _isLocalMode = false;
    print('💾 Production token saved');
  }

  // Save local tokens
  Future<void> saveLocalTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('local_token', access);
    await prefs.setString('refresh_token', refresh);
    await prefs.setBool('is_local_mode', true);
    _localTokenValue = access;
    _refreshToken = refresh;
    _isLocalMode = true;
    print('💾 Local token saved');
  }

  // Clear all tokens
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('production_token');
    await prefs.remove('local_token');
    await prefs.remove('refresh_token');
    await prefs.remove('is_local_mode');
    _productionToken = null;
    _localTokenValue = null;
    _refreshToken = null;
    _isLocalMode = false;
    print('🗑️ All tokens cleared');
  }

  // Switch to production mode
  Future<void> switchToProduction() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_local_mode', false);
    _isLocalMode = false;
    print('🔄 Switched to PRODUCTION mode');
  }

  // Switch to local mode
  Future<void> switchToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_local_mode', true);
    _isLocalMode = true;
    print('🔄 Switched to LOCAL mode');
  }

  // Check if authenticated in current mode
  bool get isAuthenticated => _currentToken != null;

  // ========== AUTHENTICATION ==========

  // Login to production server
  Future<Map<String, dynamic>> login(String email, String password) async {
    if (_forceLocalApi) {
      return loginLocal(email, password);
    }

    try {
      print('🌐 Logging in to PRODUCTION server');

      final response = await http.post(
        Uri.parse('${baseUrl}login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print('📥 Login Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          String token = data['data']['token'] ?? data['token'];
          await saveProductionTokens(
            token,
            data['data']['refresh_token'] ?? 'refresh_token_placeholder',
          );
          return {'success': true, 'data': data['data']};
        }
        return {'success': false, 'error': data['message'] ?? 'Login failed'};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['message'] ?? 'Invalid credentials',
        };
      }
    } catch (e) {
      print('❌ Login Error: $e');
      return {'success': false, 'error': 'Cannot reach the server at $baseUrl'};
    }
  }

  // Login to local server
  Future<Map<String, dynamic>> loginLocal(String email, String password) async {
    try {
      print('🔧 Logging in to LOCAL server: ${_localApi}login');

      final response = await http.post(
        Uri.parse('${_localApi}login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print('📥 Local Login Response Status: ${response.statusCode}');
      print('📥 Local Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          String token =
              data['data']['token'] ??
              data['data']['access_token'] ??
              data['token'] ??
              '';

          if (token.isEmpty) {
            return {'success': false, 'error': 'No token received from server'};
          }

          await saveLocalTokens(
            token,
            data['data']['refresh_token'] ??
                data['refresh_token'] ??
                'refresh_token_placeholder',
          );

          print('✅ Successfully logged in to LOCAL server');
          return {'success': true, 'data': data['data']};
        }
        return {'success': false, 'error': data['message'] ?? 'Login failed'};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['message'] ?? 'Invalid credentials',
        };
      }
    } catch (e) {
      print('❌ Local Login Error: $e');
      return {
        'success': false,
        'error':
            'Cannot reach the local server at $_localApi. Make sure your Laravel server is running.',
      };
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      await loadTokens();
      final registrationBaseUrl = _getBaseUrl();
      final response = await http.post(
        Uri.parse('${registrationBaseUrl}register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final token = data['data']['token'];
          if (_isLocalMode) {
            await saveLocalTokens(token, 'refresh_token_placeholder');
          } else {
            await saveProductionTokens(token, 'refresh_token_placeholder');
          }
          return {'success': true, 'data': data['data']};
        }
        return {
          'success': false,
          'error': data['message'] ?? 'Registration failed',
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['errors'] ?? error['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<void> logout() async {
    await clearTokens();
  }

  // ========== GENERIC HTTP METHODS ==========

  // Get the base URL based on mode
  String _getBaseUrl() {
    return _isLocalMode ? _localApi : baseUrl;
  }

  // Get the current token
  String? _getToken() {
    return _isLocalMode ? _localTokenValue : _productionToken;
  }

  Future<dynamic> get(String endpoint) async {
    await loadTokens();

    String token = _getToken() ?? '';
    String baseUrlToUse = _getBaseUrl();
    String fullUrl = '$baseUrlToUse$endpoint';

    print('📡 GET Request: $fullUrl');
    print('📍 Mode: ${_isLocalMode ? "LOCAL" : "PRODUCTION"}');
    print('🔑 Token exists: ${token.isNotEmpty}');

    if (token.isEmpty) {
      throw Exception(
        'Not authenticated. Please login to ${_isLocalMode ? "local" : "production"} server first.',
      );
    }

    try {
      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('📥 GET Response Status: ${response.statusCode}');

      if (response.statusCode == 401) {
        if (_isLocalMode) {
          await clearTokens();
          throw Exception(
            'Local session expired. Please login to local server again.',
          );
        } else {
          await clearTokens();
          throw Exception('Production session expired. Please login again.');
        }
      }

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded['data'] ?? decoded;
        }
        return decoded;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Request failed');
      }
    } catch (e) {
      print('❌ GET Error: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    await loadTokens();

    String token = _getToken() ?? '';
    String baseUrlToUse = _getBaseUrl();
    String fullUrl = '$baseUrlToUse$endpoint';

    print('📡 POST Request: $fullUrl');
    print('📍 Mode: ${_isLocalMode ? "LOCAL" : "PRODUCTION"}');
    print('🔑 Token exists: ${token.isNotEmpty}');
    print('📦 POST Data: $data');

    if (token.isEmpty) {
      throw Exception(
        'Not authenticated. Please login to ${_isLocalMode ? "local" : "production"} server first.',
      );
    }

    try {
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      );

      print('📥 POST Response Status: ${response.statusCode}');
      print('📥 POST Response Body: ${response.body}');

      if (response.statusCode == 401) {
        if (_isLocalMode) {
          await clearTokens();
          throw Exception(
            'Local session expired. Please login to local server again.',
          );
        } else {
          await clearTokens();
          throw Exception('Production session expired. Please login again.');
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = _decodeJsonResponse(response.body);
        return result['data'] ?? result;
      } else {
        final error = _decodeJsonResponse(response.body);
        if (response.statusCode == 422) {
          String errorMessage = 'Validation failed: ';
          if (error['errors'] != null) {
            final errors = error['errors'] as Map<String, dynamic>;
            errorMessage += errors.values.map((e) => e.join(', ')).join('; ');
          } else if (error['message'] != null) {
            errorMessage = error['message'];
          }
          throw Exception(errorMessage);
        }
        throw Exception(
          error['message'] ??
              error['error'] ??
              'Request failed (${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      print('❌ POST Error: $e');
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    await loadTokens();

    String token = _getToken() ?? '';
    String baseUrlToUse = _getBaseUrl();
    String fullUrl = '$baseUrlToUse$endpoint';

    if (token.isEmpty) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.put(
        Uri.parse(fullUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 401) {
        await clearTokens();
        throw Exception('Session expired. Please login again.');
      }

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['data'] ?? result;
      } else {
        final error = json.decode(response.body);
        if (response.statusCode == 422) {
          String errorMessage = 'Validation failed: ';
          if (error['errors'] != null) {
            final errors = error['errors'] as Map<String, dynamic>;
            errorMessage += errors.values.map((e) => e.join(', ')).join('; ');
          } else if (error['message'] != null) {
            errorMessage = error['message'];
          }
          throw Exception(errorMessage);
        }
        throw Exception(error['message'] ?? 'Request failed');
      }
    } catch (e) {
      print('❌ PUT Error: $e');
      rethrow;
    }
  }

  Future<void> delete(String endpoint) async {
    await loadTokens();

    String token = _getToken() ?? '';
    String baseUrlToUse = _getBaseUrl();
    String fullUrl = '$baseUrlToUse$endpoint';

    if (token.isEmpty) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.delete(
        Uri.parse(fullUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 401) {
        await clearTokens();
        throw Exception('Session expired. Please login again.');
      }

      if (response.statusCode != 200 && response.statusCode != 204) {
        final error = json.decode(response.body);
        if (response.statusCode == 422) {
          String errorMessage = 'Validation failed: ';
          if (error['errors'] != null) {
            final errors = error['errors'] as Map<String, dynamic>;
            errorMessage += errors.values.map((e) => e.join(', ')).join('; ');
          } else if (error['message'] != null) {
            errorMessage = error['message'];
          }
          throw Exception(errorMessage);
        }
        throw Exception(error['message'] ?? 'Delete failed');
      }
    } catch (e) {
      print('❌ DELETE Error: $e');
      rethrow;
    }
  }

  // ========== MULTIPART FILE UPLOAD ==========

  Future<Map<String, dynamic>> postMultipartFiles(
    String endpoint,
    Map<String, dynamic> data,
    Map<String, List<File>> files,
  ) async {
    await loadTokens();

    final token = _getToken() ?? '';
    if (token.isEmpty) {
      throw Exception(
        'Not authenticated. Please login to ${_isLocalMode ? "local" : "production"} server first.',
      );
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${_getBaseUrl()}$endpoint'),
    )
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    data.forEach((key, value) {
      if (value == null) return;
      request.fields[key] = value is List ? json.encode(value) : value.toString();
    });

    for (final entry in files.entries) {
      for (final file in entry.value) {
        if (await file.exists()) {
          request.files.add(await http.MultipartFile.fromPath(entry.key, file.path));
        }
      }
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();
    dynamic decoded;
    try {
      decoded = json.decode(body);
    } catch (_) {
      decoded = null;
    }

    if (response.statusCode == 401) {
      await clearTokens();
      throw Exception('Session expired. Please login again.');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final message = decoded is Map<String, dynamic>
          ? (decoded['message'] ?? decoded['errors'] ?? 'Upload failed')
          : 'Upload failed (${response.statusCode})';
      throw Exception(message.toString());
    }

    if (decoded is Map<String, dynamic>) {
      final result = decoded['data'] ?? decoded;
      return result is Map<String, dynamic>
          ? result
          : <String, dynamic>{'data': result};
    }
    throw Exception('The server returned an invalid upload response.');
  }

  Map<String, dynamic> _decodeJsonResponse(String body) {
    try {
      final decoded = json.decode(body);
      return decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{'data': decoded};
    } catch (_) {
      return <String, dynamic>{'message': body.trim()};
    }
  }

  Future<dynamic> postMultipart(
    String endpoint,
    Map<String, dynamic> data,
    File? file,
  ) async {
    await loadTokens();

    String token = _getToken() ?? '';
    String baseUrlToUse = _getBaseUrl();
    String fullUrl = '$baseUrlToUse$endpoint';

    print('📡 POST (Multipart) Request: $fullUrl');
    print('📍 Mode: ${_isLocalMode ? "LOCAL" : "PRODUCTION"}');
    print('🔑 Token exists: ${token.isNotEmpty}');
    print('📦 Data: $data');
    print('📁 File: ${file?.path}');

    if (token.isEmpty) {
      throw Exception(
        'Not authenticated. Please login to ${_isLocalMode ? "local" : "production"} server first.',
      );
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(fullUrl));

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add all form fields
      data.forEach((key, value) {
        if (value != null) {
          if (value is List) {
            for (int i = 0; i < value.length; i++) {
              request.fields['$key[$i]'] = value[i].toString();
            }
          } else {
            request.fields[key] = value.toString();
          }
        }
      });

      // Add file if provided
      if (file != null && file.existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath('image', file.path),
        );
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('📥 POST (Multipart) Response Status: ${response.statusCode}');
      print('📥 POST (Multipart) Response Body: $responseBody');

      if (response.statusCode == 401) {
        if (_isLocalMode) {
          await clearTokens();
          throw Exception(
            'Local session expired. Please login to local server again.',
          );
        } else {
          await clearTokens();
          throw Exception('Production session expired. Please login again.');
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(responseBody);
        return result['data'] ?? result;
      } else {
        try {
          final error = json.decode(responseBody);
          if (response.statusCode == 422) {
            String errorMessage = 'Validation failed: ';
            if (error['errors'] != null) {
              final errors = error['errors'] as Map<String, dynamic>;
              errorMessage += errors.values.map((e) => e.join(', ')).join('; ');
            } else if (error['message'] != null) {
              errorMessage = error['message'];
            }
            throw Exception(errorMessage);
          }
          throw Exception(error['message'] ?? 'Request failed');
        } catch (e) {
          throw Exception(
            'Upload failed: ${response.statusCode} - $responseBody',
          );
        }
      }
    } catch (e) {
      print('❌ POST (Multipart) Error: $e');
      rethrow;
    }
  }

  Future<dynamic> postWithFile(
    String endpoint,
    Map<String, dynamic> data,
    String? fileFieldName,
    File? file,
  ) async {
    await loadTokens();

    String token = _getToken() ?? '';
    String baseUrlToUse = _getBaseUrl();
    String fullUrl = '$baseUrlToUse$endpoint';

    print('📡 POST (Multipart) Request: $fullUrl');
    print('📍 Mode: ${_isLocalMode ? "LOCAL" : "PRODUCTION"}');
    print('🔑 Token exists: ${token.isNotEmpty}');
    print('📦 Data: $data');
    print('📁 File: ${file?.path}');

    if (token.isEmpty) {
      throw Exception(
        'Not authenticated. Please login to ${_isLocalMode ? "local" : "production"} server first.',
      );
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(fullUrl));

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add all form fields
      data.forEach((key, value) {
        if (value != null) {
          if (value is List) {
            for (int i = 0; i < value.length; i++) {
              request.fields['$key[$i]'] = value[i].toString();
            }
          } else {
            request.fields[key] = value.toString();
          }
        }
      });

      // Add file if provided
      if (file != null && fileFieldName != null && file.existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath(fileFieldName, file.path),
        );
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('📥 POST (Multipart) Response Status: ${response.statusCode}');
      print('📥 POST (Multipart) Response Body: $responseBody');

      if (response.statusCode == 401) {
        if (_isLocalMode) {
          await clearTokens();
          throw Exception(
            'Local session expired. Please login to local server again.',
          );
        } else {
          await clearTokens();
          throw Exception('Production session expired. Please login again.');
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(responseBody);
        return result['data'] ?? result;
      } else {
        try {
          final error = json.decode(responseBody);
          if (response.statusCode == 422) {
            String errorMessage = 'Validation failed: ';
            if (error['errors'] != null) {
              final errors = error['errors'] as Map<String, dynamic>;
              errorMessage += errors.values.map((e) => e.join(', ')).join('; ');
            } else if (error['message'] != null) {
              errorMessage = error['message'];
            }
            throw Exception(errorMessage);
          }
          throw Exception(error['message'] ?? 'Request failed');
        } catch (e) {
          throw Exception(
            'Upload failed: ${response.statusCode} - $responseBody',
          );
        }
      }
    } catch (e) {
      print('❌ POST (Multipart) Error: $e');
      rethrow;
    }
  }

  // ========== DASHBOARD API ==========

  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await get('dashboard/stats');
    return response;
  }

  Future<Map<String, dynamic>> getChartData() async {
    final response = await get('dashboard/chart-data');
    return response;
  }

  // ========== ANIMALS API ==========

  Future<List<dynamic>> getAnimals() async {
    return _extractList(await get('animals'));
  }

  Future<dynamic> createAnimal(Map<String, dynamic> data) async {
    if (data.containsKey('type')) {
      data['type'] = data['type'].toString().toLowerCase();
    }

    return await post('animals', data);
  }

  Future<Map<String, dynamic>> updateAnimal(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await put('animals/$id', data);
  }

  Future<void> deleteAnimal(int id) async {
    await delete('animals/$id');
  }

  Future<Map<String, dynamic>> updateAnimalHealth(int id, String status) async {
    return await post('animals/$id/update-health', {'health_status': status});
  }

  Future<List<dynamic>> getAnimalHealthHistory(int id) async {
    return _extractList(await get('animals/$id/health-history'));
  }

  Future<Map<String, dynamic>> getAnimalStats() async {
    final response = await get('animals/stats/by-type');
    return response;
  }

  // ========== REPORTS API ==========

  Future<List<dynamic>> getReports() async {
    final response = await get('reports');
    if (response is List) return response;
    if (response is Map<String, dynamic>) {
      final reports = response['data'];
      return reports is List ? reports : [];
    }
    return [];
  }

  Future<Map<String, dynamic>> createReport(Map<String, dynamic> data) async {
    return await post('reports', data);
  }

  Future<Map<String, dynamic>> createReportWithMedia(
    Map<String, dynamic> data, {
    List<File> images = const [],
    List<File> videos = const [],
    File? audio,
  }) async {
    final files = <String, List<File>>{
      'images[]': images,
      'videos[]': videos,
      'audio': audio == null ? const [] : [audio],
    };
    return await postMultipartFiles('reports', data, files);
  }

  Future<Map<String, dynamic>> updateReport(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await put('reports/$id', data);
  }

  Future<void> deleteReport(int id) async {
    await delete('reports/$id');
  }

  Future<Map<String, dynamic>> assignDoctor(int reportId, int doctorId) async {
    return await post('reports/$reportId/assign-doctor', {
      'doctor_id': doctorId,
    });
  }

  Future<Map<String, dynamic>> resolveReport(int reportId) async {
    return await post('reports/$reportId/resolve', {});
  }

  Future<Map<String, dynamic>> getReportStats() async {
    final response = await get('reports/stats');
    return response;
  }

  Future<Map<String, dynamic>> getReport(int id) async {
    final response = await get('reports/$id');
    return response is Map<String, dynamic> ? response : <String, dynamic>{};
  }

  // ========== FARMS API ==========

  Future<List<dynamic>> getFarms() async {
    return _extractList(await get('farms'));
  }

  Future<dynamic> createFarm(
    Map<String, dynamic> data, {
    File? imageFile,
  }) async {
    try {
      if (imageFile != null && imageFile.existsSync()) {
        return await postWithFile('farms', data, 'image', imageFile);
      } else {
        return await post('farms', data);
      }
    } catch (e) {
      print('❌ Failed to create farm: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateFarm(
    int id,
    Map<String, dynamic> data, {
    File? imageFile,
  }) async {
    if (imageFile != null && imageFile.existsSync()) {
      return await postWithFile(
        'farms/$id?_method=PUT',
        data,
        'image',
        imageFile,
      );
    } else {
      return await put('farms/$id', data);
    }
  }

  Future<void> deleteFarm(int id) async {
    await delete('farms/$id');
  }

  // ========== WORKERS API ==========

  Future<List<dynamic>> getWorkers({int? farmId}) async {
    final endpoint = farmId != null ? 'workers?farm_id=$farmId' : 'workers';
    return _extractList(await get(endpoint));
  }

  Future<dynamic> createWorker(Map<String, dynamic> data) async {
    return await post('workers', data);
  }

  Future<Map<String, dynamic>> updateWorker(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await put('workers/$id', data);
  }

  Future<void> deleteWorker(int id) async {
    await delete('workers/$id');
  }

  // ========== DOCTORS API ==========

  Future<List<dynamic>> getDoctors() async {
    final response = await get('doctors');
    return _extractList(response);
  }

  Future<List<dynamic>> getExtensionWorkers() async {
    final response = await get('extension-workers');
    return _extractList(response);
  }

  List<dynamic> _extractList(dynamic response) {
    if (response is List) return response;
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is List) return data;
      if (data is Map<String, dynamic> && data['data'] is List) {
        return data['data'] as List<dynamic>;
      }
    }
    return [];
  }

  Future<Map<String, dynamic>> createDoctor(Map<String, dynamic> data) async {
    return await post('doctors', data);
  }

  Future<Map<String, dynamic>> updateDoctorAvailability(
    int id,
    bool isAvailable,
  ) async {
    return await post('doctors/$id/availability', {
      'is_available': isAvailable,
    });
  }

  // ========== DISEASES API ==========

  Future<List<dynamic>> getDiseases() async {
    return _extractList(await get('diseases'));
  }

  Future<Map<String, dynamic>> diagnoseSymptoms({
    required String animalType,
    required List<String> symptoms,
  }) async {
    try {
      final response = await post('diagnosis', {
        'animal_type': animalType,
        'symptoms': symptoms,
      });
      return response is Map<String, dynamic> ? response : <String, dynamic>{};
    } catch (error) {
      // Older deployments may not have the new /diagnosis route yet. The
      // disease catalog is still backend data, so use it as a compatible
      // fallback instead of showing a blank diagnosis screen.
      final diseases = await getDiseases();
      if (diseases.isEmpty) rethrow;
      return _matchDiseaseCatalog(diseases, animalType, symptoms);
    }
  }

  Map<String, dynamic> _matchDiseaseCatalog(
    List<dynamic> diseases,
    String animalType,
    List<String> symptoms,
  ) {
    final animal = animalType.toLowerCase();
    final normalizedSymptoms = symptoms.map((s) => s.toLowerCase()).toList();
    final results = diseases.whereType<Map>().map((raw) {
      final disease = Map<String, dynamic>.from(raw);
      final text = '${disease['name'] ?? ''} ${disease['species_affected'] ?? ''} '
          '${disease['symptoms'] ?? ''}'.toLowerCase();
      final symptomMatches = normalizedSymptoms.where((symptom) {
        return text.contains(symptom) ||
            symptom.split(' ').where((word) => word.length > 3).any((word) => text.contains(word));
      }).length;
      final species = '${disease['species_affected'] ?? ''}'.toLowerCase();
      final speciesMatches = species.contains(animal) ||
          (animal == 'poultry' && (species.contains('chicken') || species.contains('bird')));
      final score = normalizedSymptoms.isEmpty
          ? 0
          : ((symptomMatches / normalizedSymptoms.length) * 80).round() +
              (speciesMatches ? 20 : 0);
      return <String, dynamic>{
        ...disease,
        'match': score.clamp(0, 100).toInt(),
        'severity': '${disease['severity'] ?? 'medium'}'.replaceFirstMapped(
          RegExp(r'^.'),
          (match) => match.group(0)!.toUpperCase(),
        ),
        'description': disease['symptoms'] ?? '',
      };
    }).where((disease) => (disease['match'] as int) > 0).toList()
      ..sort((a, b) => (b['match'] as int).compareTo(a['match'] as int));

    return {
      'diseases': results.take(5).toList(),
      'matches': results.length,
      'message': 'Matches are based on symptoms from the backend disease catalog.',
    };
  }

  Future<Map<String, dynamic>> createDisease(Map<String, dynamic> data) async {
    return await post('diseases', data);
  }

  // ========== VIDEOS API ==========

  Future<List<dynamic>> getVideos() async {
    final response = await get('videos');
    if (response is List) return response;
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      return data is List ? data : [];
    }
    return [];
  }

  Future<Map<String, dynamic>> getVideoCategories() async {
    final response = await get('videos/categories');
    return response is Map<String, dynamic>
        ? response
        : <String, dynamic>{'data': response};
  }

  Future<void> incrementVideoViews(int id) async {
    await post('videos/$id/view', {});
  }

  // ========== ADVERTISEMENTS API ==========

  Future<List<dynamic>> getAdvertisements() async {
    final response = await get('advertisements');
    if (response is List) return response;
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      return data is List ? data : [];
    }
    return [];
  }

  Future<Map<String, dynamic>> createAdvertisement(
    Map<String, dynamic> data, {
    File? imageFile,
    File? videoFile,
  }) async {
    dynamic response;
    if (imageFile != null && imageFile.existsSync()) {
      response = await postWithFile('advertisements', data, 'image_file', imageFile);
    } else if (videoFile != null && videoFile.existsSync()) {
      response = await postWithFile('advertisements', data, 'video_file', videoFile);
    } else {
      response = await post('advertisements', data);
    }
    return response is Map<String, dynamic> ? response : <String, dynamic>{};
  }

  Future<void> trackAdClick(int id) async {
    await post('advertisements/$id/click', {});
  }

  // ========== AI CHAT API ==========

  Future<List<dynamic>> getChatHistory() async {
    final response = await get('ai-chat/history');
    if (response is List) return response;
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      return data is List ? data : [];
    }
    return [];
  }

  Future<Map<String, dynamic>> sendChatMessage(
    String message, {
    String? language,
  }) async {
    return await post('ai-chat/send', {
      'message': message,
      if (language != null) 'language': language,
    });
  }

  Future<void> clearChatHistory() async {
    await delete('ai-chat/clear');
  }

  Future<void> sendChatFeedback(int messageId, String feedback) async {
    await post('ai-chat/$messageId/feedback', {'feedback': feedback});
  }

  // ========== DECISION SUPPORT API ==========

  Future<List<dynamic>> getDecisionSupport({String? category}) async {
    String url = 'decision-support/resources';
    if (category != null) {
      url += '?category=$category';
    }
    final response = await get(url);
    if (response is List) return response;
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      return data is List ? data : [];
    }
    return [];
  }

  Future<Map<String, dynamic>> getDecisionCategories() async {
    final response = await get('decision-support/categories');
    return response is Map<String, dynamic>
        ? response
        : <String, dynamic>{'data': response};
  }

  Future<void> markDecisionHelpful(int id) async {
    await post('decision-support/$id/helpful', {});
  }

  // ========== WEATHER API ==========

  Future<Map<String, dynamic>> getWeather(String location) async {
    final response = await get('weather/$location');
    return response;
  }

  Future<List<dynamic>> getWeatherAdvisories() async {
    return _extractList(await get('weather/advisories'));
  }

  // ========== SETTINGS API ==========

  Future<Map<String, dynamic>> getSettings() async {
    final response = await get('settings');
    return response;
  }

  Future<Map<String, dynamic>> updateSetting(String key, dynamic value) async {
    return await put('settings/$key', {'value': value});
  }

  Future<Map<String, dynamic>> getPublicSettings() async {
    final response = await get('settings/public');
    return response;
  }

  // ========== MARKETPLACE API ==========

  Future<List<dynamic>> getMarketplaceListings() async {
    return _extractList(await get('marketplace'));
  }

  Future<Map<String, dynamic>> createMarketplaceListing(
    Map<String, dynamic> data,
    {File? imageFile}
  ) async {
    final response = imageFile != null && imageFile.existsSync()
        ? await postWithFile('marketplace', data, 'image', imageFile)
        : await post('marketplace', data);
    return response is Map<String, dynamic> ? response : <String, dynamic>{};
  }

  Future<Map<String, dynamic>> updateMarketplaceListing(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await put('marketplace/$id', data);
  }

  Future<void> deleteMarketplaceListing(int id) async {
    await delete('marketplace/$id');
  }

  // ========== GESTATION AND VACCINATION API ==========

  Future<List<dynamic>> getGestationRecords() async {
    return _extractList(await get('gestation'));
  }

  Future<Map<String, dynamic>> createGestationRecord(
    Map<String, dynamic> data,
  ) async {
    final response = await post('gestation', data);
    return response is Map<String, dynamic> ? response : <String, dynamic>{};
  }

  Future<Map<String, dynamic>> updateGestationRecord(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await put('gestation/$id', data);
  }

  Future<void> deleteGestationRecord(int id) async {
    await delete('gestation/$id');
  }

  Future<List<dynamic>> getVaccinationRecords() async {
    return _extractList(await get('vaccinations'));
  }

  Future<Map<String, dynamic>> createVaccinationRecord(
    Map<String, dynamic> data,
  ) async {
    final response = await post('vaccinations', data);
    return response is Map<String, dynamic> ? response : <String, dynamic>{};
  }

  Future<Map<String, dynamic>> updateVaccinationRecord(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await put('vaccinations/$id', data);
  }

  Future<void> deleteVaccinationRecord(int id) async {
    await delete('vaccinations/$id');
  }

  // ========== LANGUAGES API ==========

  Future<List<dynamic>> getLanguages() async {
    return _extractList(await get('languages'));
  }

  Future<List<dynamic>> getActiveLanguages() async {
    return _extractList(await get('languages/active'));
  }

  Future<void> setDefaultLanguage(int id) async {
    await post('languages/$id/default', {});
  }
}
