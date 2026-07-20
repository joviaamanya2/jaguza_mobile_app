import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api/v1/';
  static const String tokenUrl = 'http://localhost:8000/api/token/';
  
  String? _accessToken;
  String? _refreshToken;
  
  // Singleton
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();
  
  // Get tokens from storage
  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
  }
  
  // Save tokens
  Future<void> saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
    _accessToken = access;
    _refreshToken = refresh;
  }
  
  // Clear tokens (logout)
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    _accessToken = null;
    _refreshToken = null;
  }
  
  // ========== AUTHENTICATION ==========
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          await saveTokens(
            data['data']['token'],
            'refresh_token_placeholder'
          );
          return {'success': true, 'data': data['data']};
        }
        return {'success': false, 'error': data['message'] ?? 'Login failed'};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['message'] ?? 'Invalid credentials'};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
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
          // Auto login after registration
          await saveTokens(
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
    await get('logout');
    await clearTokens();
  }
  
  // ========== GENERIC HTTP METHODS ==========
  
  Future<dynamic> get(String endpoint) async {
    await loadTokens();
    if (_accessToken == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 401) {
        throw Exception('Session expired');
      }
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? data;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Request failed');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    await loadTokens();
    if (_accessToken == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      );
      
      if (response.statusCode == 401) {
        throw Exception('Session expired');
      }
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);
        return result['data'] ?? result;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Request failed');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    await loadTokens();
    if (_accessToken == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      );
      
      if (response.statusCode == 401) {
        throw Exception('Session expired');
      }
      
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['data'] ?? result;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Request failed');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> delete(String endpoint) async {
    await loadTokens();
    if (_accessToken == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 401) {
        throw Exception('Session expired');
      }
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Delete failed');
      }
    } catch (e) {
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