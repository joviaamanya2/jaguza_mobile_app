import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
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
  static const String _localApi =
      'http://127.0.0.1:8000/api/v1/';
  static const String _localToken =
      'http://127.0.0.1:8000/api/token/';
  
  // For Android emulator:
  // static const String _localApi = 'http://10.0.2.2:8000/api/v1/';
  
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
  String? get _currentToken => _isLocalMode ? _localTokenValue : _productionToken;
  
  // Load tokens from storage
  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _productionToken = prefs.getString('production_token');
    _localTokenValue = prefs.getString('local_token');
    _refreshToken = prefs.getString('refresh_token');
    _isLocalMode = prefs.getBool('is_local_mode') ?? false;
    
    print('🔑 Mode: ${_isLocalMode ? "LOCAL" : "PRODUCTION"}');
    print('🔑 Production Token: ${_productionToken?.substring(0, 20)}...');
    print('🔑 Local Token: ${_localTokenValue?.substring(0, 20)}...');
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
    try {
      print('🌐 Logging in to PRODUCTION server');
      
      final response = await http.post(
        Uri.parse('${baseUrl}login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      print('📥 Login Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          String token = data['data']['token'] ?? data['token'];
          await saveProductionTokens(
            token,
            data['data']['refresh_token'] ?? 'refresh_token_placeholder'
          );
          return {'success': true, 'data': data['data']};
        }
        return {'success': false, 'error': data['message'] ?? 'Login failed'};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['message'] ?? 'Invalid credentials'};
      }
    } catch (e) {
      print('❌ Login Error: $e');
      return {
        'success': false,
        'error': 'Cannot reach the server at $baseUrl',
      };
    }
  }
  
  // Login to local server - THIS IS WHAT YOU NEED TO USE
  Future<Map<String, dynamic>> loginLocal(String email, String password) async {
    try {
      print('🔧 Logging in to LOCAL server: ${_localApi}login');
      
      final response = await http.post(
        Uri.parse('${_localApi}login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      print('📥 Local Login Response Status: ${response.statusCode}');
      print('📥 Local Login Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Extract token - handle different response formats
          String token = data['data']['token'] ?? 
                        data['data']['access_token'] ?? 
                        data['token'] ?? 
                        '';
          
          if (token.isEmpty) {
            return {'success': false, 'error': 'No token received from server'};
          }
          
          // Save token with local mode flag
          await saveLocalTokens(
            token,
            data['data']['refresh_token'] ?? data['refresh_token'] ?? 'refresh_token_placeholder'
          );
          
          print('✅ Successfully logged in to LOCAL server');
          return {'success': true, 'data': data['data']};
        }
        return {'success': false, 'error': data['message'] ?? 'Login failed'};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['message'] ?? 'Invalid credentials'};
      }
    } catch (e) {
      print('❌ Local Login Error: $e');
      return {
        'success': false,
        'error': 'Cannot reach the local server at $_localApi. Make sure your Laravel server is running.',
      };
    }
  }
  
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          await saveProductionTokens(
            data['data']['token'],
            'refresh_token_placeholder'
          );
          return {'success': true, 'data': data['data']};
        }
        return {'success': false, 'error': data['message'] ?? 'Registration failed'};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['errors'] ?? error['message'] ?? 'Registration failed'};
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
      throw Exception('Not authenticated. Please login to ${_isLocalMode ? "local" : "production"} server first.');
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
        // Token is invalid for this server
        if (_isLocalMode) {
          await clearTokens();
          throw Exception('Local session expired. Please login to local server again.');
        } else {
          await clearTokens();
          throw Exception('Production session expired. Please login again.');
        }
      }
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? data;
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
      throw Exception('Not authenticated. Please login to ${_isLocalMode ? "local" : "production"} server first.');
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
          throw Exception('Local session expired. Please login to local server again.');
        } else {
          await clearTokens();
          throw Exception('Production session expired. Please login again.');
        }
      }
      
      if (response.statusCode == 200 || response.statusCode == 201) {
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
    final response = await get('animals');
    return response['data'] ?? [];
  }
  
  Future<Map<String, dynamic>> createAnimal(Map<String, dynamic> data) async {
    return await post('animals', data);
  }
  
  Future<Map<String, dynamic>> updateAnimal(int id, Map<String, dynamic> data) async {
    return await put('animals/$id', data);
  }
  
  Future<void> deleteAnimal(int id) async {
    await delete('animals/$id');
  }
  
  Future<Map<String, dynamic>> updateAnimalHealth(int id, String status) async {
    return await post('animals/$id/update-health', {'health_status': status});
  }
  
  Future<List<dynamic>> getAnimalHealthHistory(int id) async {
    final response = await get('animals/$id/health-history');
    return response['data'] ?? [];
  }
  
  Future<Map<String, dynamic>> getAnimalStats() async {
    final response = await get('animals/stats/by-type');
    return response;
  }
  
  // ========== REPORTS API ==========
  
  Future<List<dynamic>> getReports() async {
    final response = await get('reports');
    return response['data'] ?? [];
  }
  
  Future<Map<String, dynamic>> createReport(Map<String, dynamic> data) async {
    return await post('reports', data);
  }
  
  Future<Map<String, dynamic>> updateReport(int id, Map<String, dynamic> data) async {
    return await put('reports/$id', data);
  }
  
  Future<void> deleteReport(int id) async {
    await delete('reports/$id');
  }
  
  Future<Map<String, dynamic>> assignDoctor(int reportId, int doctorId) async {
    return await post('reports/$reportId/assign-doctor', {'doctor_id': doctorId});
  }
  
  Future<Map<String, dynamic>> resolveReport(int reportId) async {
    return await post('reports/$reportId/resolve', {});
  }
  
  Future<Map<String, dynamic>> getReportStats() async {
    final response = await get('reports/stats');
    return response;
  }
  
  // ========== FARMS API ==========
  
  Future<List<dynamic>> getFarms() async {
    final response = await get('farms');
    return response['data'] ?? [];
  }
  
  Future<Map<String, dynamic>> createFarm(Map<String, dynamic> data) async {
    return await post('farms', data);
  }
  
  Future<Map<String, dynamic>> updateFarm(int id, Map<String, dynamic> data) async {
    return await put('farms/$id', data);
  }
  
  Future<void> deleteFarm(int id) async {
    await delete('farms/$id');
  }
  
  // ========== DOCTORS API ==========
  
  Future<List<dynamic>> getDoctors() async {
    final response = await get('doctors');
    return response['data'] ?? [];
  }
  
  Future<Map<String, dynamic>> createDoctor(Map<String, dynamic> data) async {
    return await post('doctors', data);
  }
  
  Future<Map<String, dynamic>> updateDoctorAvailability(int id, bool isAvailable) async {
    return await post('doctors/$id/availability', {'is_available': isAvailable});
  }
  
  // ========== DISEASES API ==========
  
  Future<List<dynamic>> getDiseases() async {
    final response = await get('diseases');
    return response['data'] ?? [];
  }
  
  Future<Map<String, dynamic>> createDisease(Map<String, dynamic> data) async {
    return await post('diseases', data);
  }
  
  // ========== VIDEOS API ==========
  
  Future<List<dynamic>> getVideos() async {
    final response = await get('videos');
    return response['data'] ?? [];
  }
  
  Future<Map<String, dynamic>> getVideoCategories() async {
    final response = await get('videos/categories');
    return response;
  }
  
  Future<void> incrementVideoViews(int id) async {
    await post('videos/$id/view', {});
  }
  
  // ========== ADVERTISEMENTS API ==========
  
  Future<List<dynamic>> getAdvertisements() async {
    final response = await get('advertisements');
    return response['data'] ?? [];
  }
  
  Future<Map<String, dynamic>> createAdvertisement(Map<String, dynamic> data) async {
    return await post('advertisements', data);
  }
  
  Future<void> trackAdClick(int id) async {
    await post('advertisements/$id/click', {});
  }
  
  // ========== AI CHAT API ==========
  
  Future<List<dynamic>> getChatHistory() async {
    final response = await get('ai-chat/history');
    return response['data'] ?? [];
  }
  
  Future<Map<String, dynamic>> sendChatMessage(String message) async {
    return await post('ai-chat/send', {'message': message});
  }
  
  Future<void> clearChatHistory() async {
    await delete('ai-chat/clear');
  }
  
  Future<void> sendChatFeedback(int messageId, String feedback) async {
    await post('ai-chat/$messageId/feedback', {'feedback': feedback});
  }
  
  // ========== DECISION SUPPORT API ==========
  
  Future<List<dynamic>> getDecisionSupport({String? category}) async {
    String url = 'decision-support';
    if (category != null) {
      url += '?category=$category';
    }
    final response = await get(url);
    return response['data'] ?? [];
  }
  
  Future<Map<String, dynamic>> getDecisionCategories() async {
    final response = await get('decision-support/categories');
    return response;
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
    final response = await get('weather/advisories');
    return response['data'] ?? [];
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
  
  // ========== LANGUAGES API ==========
  
  Future<List<dynamic>> getLanguages() async {
    final response = await get('languages');
    return response['data'] ?? [];
  }
  
  Future<List<dynamic>> getActiveLanguages() async {
    final response = await get('languages/active');
    return response['data'] ?? [];
  }
  
  Future<void> setDefaultLanguage(int id) async {
    await post('languages/$id/default', {});
  }
}